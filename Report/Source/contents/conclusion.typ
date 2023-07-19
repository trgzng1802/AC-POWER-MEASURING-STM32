= KẾT LUẬN
Hiện đề tài còn nhiểu vấn đề phẩn cứng chưa giải quyết được cũng như chưa tối ưu được phần mềm. Vấn đề cảm biến ACS712 không cho ra kết quả đúng khi dòng dòng điện quá nhỏ (< 1A) có lẽ sẽ được cải thiện bằng phương án dùng điện trở shunt. Để tối ưu phần mềm, sẽ không phụ thuộc vào generate code của STM32CubeIDE mà dùng code thanh ghi (Bare metal) thay thế cho thư viện HAL.
