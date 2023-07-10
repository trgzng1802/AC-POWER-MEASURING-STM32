#import "../report/tablex.typ": *

= ĐO CÔNG SUẤT LƯỚI DÙNG VI ĐIỀU KHIỂN STM32F103C8T6
== Tổng quan về bộ ADC của STM32F103C8T6
=== Các thông số cơ bản

Bộ ADC đóng vai trò quan trọng, là bộ phận thu thập giá trị điện áp và dòng điện theo thời gian, cũng là bộ phận quyết định độ chính xác của hệ thống. Theo datasheet, bộ ADC của STM32F103C8T6 là bộ ADC 12-bit, có các mode: Single conversion mode, Continuous conversion mode, Scan mode và Discontinuous mode. Dưới dây là các thông số cơ bản được ghi trong datasheet.

#figure(
    kind: table,
    tablex(
        columns: 7,
        inset: 8pt,
        align: center,
        [*Symbol*], [*Parameter*], [*Conditions*], [*Min.*], [*Typ.*], [*Max.*], [*Đơn vị*],
        [V#sub[DDA]], [ADC power supply], [], [2.4], [], [3.6], [V],
        [V#sub[REF+]], [Positive reference voltage], [], [2.0], [], [V#sub[DDA]], [V],
        [f#sub[ADC]], [ADC clock frequency], [], [0.6], [], [14], [MHz],
        [f#sub[S]], [Sampling rate], [], [0.05], [], [1], [MHz],
        [t#sub[CAL]], [Calibration time], [f#sub[ADC] = 14MHz], colspanx(3)[5.9], (), (), [$mu S$],
        [t#sub[STAB]], [Power-up time], [], [0], [0], [1], [$mu S$],
        [t#sub[CONV]], [Total conversion time], [f#sub[ADC] = 14MHz], colspanx(3)[14], (), (), [1/f#sub[ADC]]
    ),
    caption: [Thông số ADC]
) <tb-adc-char>

Vấn đề tiếp theo ta cần quan tâm là các sai số của bộ ADC.
#figure(
    kind: table,
    tablex(
        columns: 6,
        align: center + horizon,
        [*Symbol*], [*Parameter*], [*Conditions*], [*Typ.*], [*Max.*], [*Unit*],
        [|E#sub[T]|], [Total unadjusted error], rowspanx(5)[f#sub[ADC] = 14MHz, V#sub[DDA] = 3.3V], [3], [to be determined], rowspanx(5)[LSB],
        [|E#sub[O]|], [Offset error], (), [1], [to be determined], (),
        [|E#sub[G]|], [Gain error], (), [2], [to be determined], (),
        [|E#sub[D]|], [Differential linearity error], (), [3], [to be determined], (),
        [|E#sub[L]|], [Integral linearity error], (), [2], [to be determined], ()
    ),
    caption: [Bảng sai số của ADC]
) <tb-adc-accuracy>

=== Các mode hoạt động
Bộ ADC của STM32F103c6t8 có tất cả 4 mode hoạt động, bao gồm Single conversion mode, Continuous conversion mode, Scan mode và Discontinuous mode.

==== Single conversion mode
Trong Single conversion mode, bộ ADC chỉ thực hiện chuyển đổi một lần duy nhất khi bit ADON trong thanh ghi ADC_CR2 được set lên 1 và bit CONT bằng 0. Sau khi chuyển đổi, data sẽ được lưu vào thanh ghi 16-bit ADC_DR (left-aligned hay right-aligned sẽ phụ thuộc vào bit ALIGN) và cờ EOC được bật, đồng thời sẽ sinh ra  ngắt và gọi hàm
```c
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
```
nếu bit EOCIE được set lên 1. Sau đó bộ ADC sẽ dừng.

#figure(
    image("../images/adc_single_conv.png", width: 20%),
    caption: [Lưu đồ của ADC Single conversion mode],
)

==== Continuous conversion mode
Trong mode này, bộ ADC sẽ thực hiện chuyển đổi liên tục, chuyển đổi tiếp theo sẽ được thực hiện ngay khi chuyển đổi trước kết thúc. Để mode này hoạt động chỉ cần set bit ADON và CONT trong thanh ghi ADC_CR2 lên 1 một lần duy nhất. Sau khi mỗi chuyển đổi, data sẽ được lưu vào thanh ghi 16-bit ADC_DR (left-aligned hay right-aligned sẽ phụ thuộc vào bit ALIGN) và cờ EOC được bật, đồng thời sẽ sinh ra  ngắt và gọi hàm
```c
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
```
nếu bit EOCIE được set lên 1.

#figure(
    image("../images/adc_continuous_conv.png", width: 30%),
    caption: [Lưu đồ của ADC Continuous conversion mode],
)

==== Scan mode
Scan mode được dùng khi cần đọc nhiều kênh analog trong 1 bộ ADC. Khi bộ thực hiện xong chuyển đổi ở kênh này sẽ tự động chuyển đổi ở kênh tiếp theo. Nếu bit CONT được set lên 1, bộ ADC sẽ thực hiện chuyển đổi hết tất cả các kênh được chọn sau đó quay về kênh đầu tiên để thực hiện chu kỳ chuyển đổi tiếp theo.

Khi dùng mode này, cần chú ý bit DMA phải được set lên 1 để data sau khi chuyển đổi sẽ được truyền từ thanh ghi ADC_DR sang SRAM.

(*Chỗ này cần verify*)

#figure(
    image("../images/adc_scan_mode.png", width: 40%),
    caption: [Lưu đồ của ADC Scan mode],
)

==== Discontinuous mode
mode này kh hiểu


=== Thời gian lấy mẫu (Sampling time)
Mỗi kênh trong bộ ADC có thể lập trình từng giá trị sampling time riêng biệt. Tối thiểu là 1.5 cycles và tối đa là 239.5 cycles.
