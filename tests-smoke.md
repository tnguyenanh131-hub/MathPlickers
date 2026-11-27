# Kiểm thử khói đã thực hiện khi đóng gói

- `node --check` trên hai khối JavaScript inline: đạt.
- Thử bộ biên dịch đồ thị với `x^3 - 3*x + 1`, `sin(x)`, `sqrt(x)+e`: đạt.
- Thử biểu thức chứa mã ngoài danh sách cho phép: bị từ chối.
- Kiểm tra bảng chữ ký của 60 thẻ × 4 hướng: 240 chữ ký duy nhất, không trùng.

Các kiểm thử trên là kiểm thử cú pháp/logic tĩnh. Chưa có kiểm thử phần cứng camera trên điện thoại hoặc xác minh độ chính xác nhận diện trong lớp học thực tế.

## Kiểm thử bổ sung – camera đa thẻ
1. Mở `index.html` trên máy tính, chọn đúng lớp có ít nhất 4 học sinh với số thẻ khác nhau; mở phòng quét.
2. Mở `mobile-scanner.html` trên điện thoại bằng HTTPS, cấp quyền camera sau và kết nối mã phòng.
3. Đặt 2, 4 rồi 6 thẻ khác nhau trong khung hình, mỗi thẻ đủ lớn, phẳng, không che mã; thử các hướng A/B/C/D.
4. Xác nhận mỗi thẻ được gán đúng tên theo số thẻ; một thẻ xuất hiện trong nhiều cửa sổ ảnh không bị ghi nhận hai lần.
5. Đổi đáp án của riêng một thẻ; chỉ học sinh đó được cập nhật. Đưa thẻ không thuộc lớp vào khung; máy tính không ghi nhận thẻ đó.
6. Thử ánh sáng yếu, lóa, nghiêng thẻ, camera đang bị ứng dụng khác chiếm, từ chối quyền camera; giao diện phải báo lỗi và cho phép thử lại.
7. Kiểm tra iOS Safari và Android Chrome trên thiết bị thật; không kết luận độ chính xác chỉ từ kiểm tra cú pháp.
