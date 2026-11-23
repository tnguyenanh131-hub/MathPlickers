import os
import stat
import zipfile
from pathlib import Path

SOURCE_DIR_NAME = "plickers-math-suite"
OUTPUT_ZIP_NAME = "plickers-math-suite.zip"
LAUNCHER_FILES = ("start.sh", "start.bat")

EXCLUDED_DIRS = {"node_modules", "__pycache__", ".git", ".vscode", ".idea", "extracted_media"}
EXCLUDED_FILES = {".DS_Store", "Thumbs.db", OUTPUT_ZIP_NAME}
EXCLUDED_SUFFIXES = {".pyc", ".pyo", ".log", ".zip"}

def should_exclude(path: Path) -> bool:
    if any(part in EXCLUDED_DIRS for part in path.parts):
        return True
    if path.name in EXCLUDED_FILES:
        return True
    if path.suffix.lower() in EXCLUDED_SUFFIXES:
        return True
    return False

def write_file_to_zip(zf: zipfile.ZipFile, file_path: Path, arcname: str) -> None:
    data = file_path.read_bytes()
    info = zipfile.ZipInfo(filename=arcname)
    info.compress_type = zipfile.ZIP_DEFLATED
    mode = 0o755 if file_path.name.endswith(".sh") else 0o644
    info.external_attr = (stat.S_IFREG | mode) << 16
    zf.writestr(info, data)

def build_clean_zip(base_dir: Path) -> Path:
    source_dir = base_dir / SOURCE_DIR_NAME
    if not source_dir.exists() or not source_dir.is_dir():
        raise FileNotFoundError(f"Không tìm thấy thư mục: {source_dir}")

    output_zip = base_dir / OUTPUT_ZIP_NAME
    if output_zip.exists():
        output_zip.unlink()

    added_count = 0
    included = set()
    with zipfile.ZipFile(output_zip, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for root, dirs, files in os.walk(source_dir):
            root_path = Path(root)
            dirs[:] = [d for d in dirs if not should_exclude(root_path / d)]
            for filename in sorted(files):
                fp = root_path / filename
                if should_exclude(fp):
                    continue
                arcname = fp.relative_to(base_dir).as_posix()
                if arcname not in included:
                    write_file_to_zip(zf, fp, arcname)
                    included.add(arcname)
                    added_count += 1

        for launcher in LAUNCHER_FILES:
            target = f"{SOURCE_DIR_NAME}/{launcher}"
            if target in included:
                continue
            for candidate in (source_dir / launcher, base_dir / launcher):
                if candidate.exists() and candidate.is_file():
                    write_file_to_zip(zf, candidate, target)
                    included.add(target)
                    added_count += 1
                    break

    print(f"Đã đóng gói thành công {added_count} tệp vào: {output_zip}")
    return output_zip

if __name__ == "__main__":
    build_clean_zip(Path(__file__).resolve().parent)
