# Nhật ký cập nhật

## Bản nâng cấp hiện tại
- Mở rộng hiển thị công thức KaTeX và macro tập hợp số.
- Bổ sung loại minh họa bảng JSON và ảnh HTTPS.
- Lọc SVG trước khi đưa vào DOM.
- Giới hạn cú pháp biểu thức đồ thị theo danh sách hàm toán học cho phép.
- Cải thiện xử lý lỗi và vòng đời camera trên điện thoại.
- Bổ sung hướng dẫn triển khai GitHub Pages.

## Bản vá camera đa thẻ
- Khắc phục giới hạn chỉ dò một vùng ROI giữa màn hình: chia khung hình thành 16 cửa sổ vuông chồng lấp và dò từng cửa sổ độc lập.
- Xác nhận ổn định theo từng số thẻ, gộp kết quả trùng do cửa sổ chồng lấp, chống quét lặp theo cặp số thẻ/đáp án.
- Gửi nhiều kết quả cùng lúc bằng `PLICKERS_SCAN_BATCH`; máy tính ánh xạ từng số thẻ sang học sinh trong danh sách lớp.
- Chỉ chấp nhận số thẻ đã được giáo viên cấp khi điện thoại đã nhận danh sách học sinh.
- Cải thiện mở camera bằng cấu hình dự phòng, ưu tiên camera sau, tự lấy nét/phơi sáng liên tục khi thiết bị hỗ trợ và giải phóng luồng camera nếu khởi tạo thất bại.
- Đã kiểm tra cú pháp JavaScript; cần kiểm thử camera/thẻ in thực tế trước khi dùng chấm điểm.
