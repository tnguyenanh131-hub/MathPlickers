# MathPlickers - Hệ thống Trắc nghiệm Toán học Tương tác & Quét thẻ trực tiếp

Ứng dụng web tĩnh (Static Web App) chạy trực tiếp trên **GitHub Pages**, tích hợp trình chiếu câu hỏi Toán học chuẩn LaTeX/KaTeX, đồ thị hàm số, nhập đề Word (`.docx`) bằng Gemini AI và quét thẻ Plickers bằng camera điện thoại theo thời gian thực.

## Cấu trúc thư mục
- `index.html`: Màn hình giáo viên (Trình chiếu máy chiếu, Ngân hàng câu hỏi, Quản lý đa lớp & In thẻ 5×5, Báo cáo điểm CSV).
- `mobile-scanner.html`: Ứng dụng quét thẻ trên điện thoại (kết nối với màn hình máy chiếu qua mã phòng `MP-xxxx` hoặc mã QR).

## Cách triển khai nhanh lên GitHub Pages
1. Tạo repository mới trên GitHub và tải toàn bộ các file (`index.html`, `mobile-scanner.html`, `README.md`) lên nhánh `main`.
2. Vào **Settings → Pages → Build and deployment**, chọn **Deploy from a branch**, nhánh `main` (`/root`) rồi nhấn **Save**.
3. Mở link GitHub Pages trên máy tính trình chiếu (`index.html`), sau đó dùng điện thoại quét mã QR góc phải trên màn hình để mở `mobile-scanner.html` và bắt đầu quét thẻ.
