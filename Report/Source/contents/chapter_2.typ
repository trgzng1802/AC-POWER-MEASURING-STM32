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
Theo datasheet, STM32F103C8T6 có tất cả 2 ADC: ADC1 và ADC2 nên được chia thành 2 nhóm mode hoạt động chính, bao gồm nhóm Independent mode và Dual mode.
    - Nhóm Independent mode gồm:
        + Single-channel, single conversion mode, 
        + Multichannel (scan), single conversion mode, 
        + Single-channel, continuous conversion mode, 
        + Multichannel (scan), single conversion mode,
        + Injected conversion mode.
    - Nhóm Dual mode gồm:
        + Dual regular simultaneous mode,
        + Dual fast interleaved mode,
        + Dual slow interleaved mode,
        + Dual alternate trigger mode,
        + Dual combined regular/injected simultaneous mode,
        + Dual combined: injected simultaneous + interleaved mode.
==== Single-channel, single conversion mode
Mode này là mode đơn giản nhất, bộ ADC chỉ thực hiện chuyển đổi một lần duy nhất sau khi chuyển đổi xong  bộ ADC sẽ dừng.

#figure(
    image("../images/adc_single_single_conv.png", width: 20%),
    caption: [Single-channel, single conversion mode.],
)

==== Multichannel (scan), single conversion mode
Trong mode này, bộ ADC sẽ thực hiện chuyển đổi các channel liên tiếp, chuyển đổi tiếp theo sẽ được thực hiện ngay khi chuyển đổi trước kết thúc, thứ tự channel được chuynể đổi có thể tuỳ chỉnh. Các channel có thể được thiết lập thời gian lấy mẫu khác nhau.
#figure(
    image("../images/adc_scan_single_mode.png", width: 20%),
    caption: [Multichannel, single conversion mode.],
)

==== Single-channel, continuous conversion mode
Với mode này, ADC sẽ thực hiện chuyển đổi 1 channel liên tục và vô hạn. Đồng nghĩa với việc ADC sẽ chuyển đổi liên tục mà không cần sự can thiệp của CPU.


#figure(
    image("../images/adc_continuous_conv.png", width: 30%),
    caption: [Single-channel, continuous conversion mode.],
)

==== Multichannel (scan) continuous conversion mode
Mode này được dùng khi cần chuyển đổi nhiều channel liên tiếp và không cần sự can thiệp của CPU. Có thể thiết lập thứ tự chuyển đổi và thời gian lấy mẫu từng channel. Khi chuyển đổi đến channel cuối cùng, bộ ADC sẽ quay lại channel đầu tiên và lặp đi lặp lại.

#figure(
    image("../images/adc_scan_continuous.png", width: 30%),
    caption: [Multichannel, continuous conversion mode.],
)

==== Injected conversion mode
Ta dùng mode này khi cần kích sự chuyển đổi bằng sự kiền nào đó (bên ngoài hoặc bằng phần mềm).

==== Dual regular simultaneous mode
Trong mode này, ADC1 và ADC2 sẽ lấy mẫu và chuyển đổi đồng thời. Sau khi chuyển đổi xong, kết quả sẽ được lưu vào thanh ghi data 32-bit ADC1. Nếu dùng scan mode, thứ tự chuyển đổi các channel của 2 ADC có chút khác biệt, với ADC1: từ channel 15 đến channel 0 và ADC2 là từ channel 0 đến channel 15.

#figure(
    image("../images/dual_regular.png", width: 60%),
    caption: [Dual regular simultaneous mode.],
)

==== Dual fast interleaved mode


==== Dual slow interleaved mode


==== Dual alternate trigger mode


==== Dual combined regular/injected simultaneous mode


==== Dual combined: injected simultaneous + interleaved mode



=== Thời gian lấy mẫu (Sampling time)
Mỗi kênh trong bộ ADC có thể lập trình từng giá trị sampling time riêng biệt. Tối thiểu là 1.5 cycles và tối đa là 239.5 cycles.

Như vậy, total conversion time (T#sub[CONV]) của STM32F103C8T6 sẽ được tính như sau:

T#sub[CONV] = Sampling time + 12.5 cycles.


== Thiết kế bộ đo công suất AC
=== Ý tưởng thực hiện
Scale dòng điện và điện áp của điện lưới về phạm vi điện áp đọc được của bộ ADC (0 - 3.3V với V#sub[DDA] = 3.3V), tích hợp vào ổ cắm có hiển thị LCD.

#figure(
    image("../images/hardware_diagram.png", width: 100%),
    caption: [Sơ khối mô tả thiết kế phần cứng bộ đo công suất AC.],
) <hardware-diagram>

==== Đo điện áp AC
Với ý tưởng ban đầu dùng biến áp để hạ áp từ điện áp lưới, tuy nhiên với loại biến áp thường như @bien-ap-thuong có kích thước khá lớn (thường 6.5 x 3.5 x 3.5 cm) làm cho bộ đo bị cồng kềnh.

#figure(
    image("../images/bien_ap_thuong.jpg", width: 25%),
    caption: [Biến áp thường.],
) <bien-ap-thuong>

Sau khi tìm hiểu các loại biến áp, vấn đề đã được giải quyết bằng biến áp ZMPT101B có kích thước nhỏ gọn chỉ 1.7 x 2 cm (@zmpt101b).

#figure(
    image("../images/ZMPT101B.jpg", width: 30%),
    caption: [Biến áp ZMPT101B.],
) <zmpt101b>

Theo datasheet, ZMPT101B là biến áp dòng, tức là ta phải mắc tải hạn dòng ở cuộn sơ cấp để tạo dòng qua biến áp và mắc trở lấy mẫu tại cuộn thứ cấp. Biến áp có tỷ số 2mA:2mA, nếu ta chọn trở hạn dòng $R_L = 820k Omega$ và trở lấy mẫu $R_S = 100 Omega$, giả sử điện áp lưới là $230V#sub[rms]$ thì điện áp trên trở $R_S$ có biên độ là $V_R_S = frac(230 dot root(,2) dot 2, R_L) dot R_S = frac(230 dot root(,2) dot 2, 820k) dot 100 = 0.079V#sub[pp]$. Với $V#sub[pp]$ khá nhỏ như vậy, ảnh hưởng của nhiễu đối với tín hiệu là rất lớn, ta cần 1 tầng khuếch đại vi sai để loại bỏ nhiễu từ biến áp. Tuy nhiên, điện áp lưới có dạng sóng sin, có bán kỳ âm và bán kỳ dương. ADC của STM32F103C8T6 chỉ có thể đọc giá trị điện áp dương từ 0 - V#sub[DDA], vậy nên ta cần có 1 tầng cộng điện áp DC $V#sub[offset] = frac(V#sub[DDA], 2)$ để nâng toàn bộ điện áp $U_R$ lên phần dương.

Ta sẽ thiết kế từng tầng, đầu tiên là tầng khuếch đại vi sai dùng OPAMP.
+ @opamp-differ là cấu trúc cơ bản của tầng khuếch đại vi sai:

#figure(
    image("../images/opamp_differ.png", width: 55%),
    caption: [Sơ đồ nguyên lý khuếch đại vi sai dùng OPAMP],
) <opamp-differ>

Theo lý thuyết, độ lợi vi sai của mạch @opamp-differ: 

$V#sub[out] = V_2 dot (frac(R_5, R_4 + R_5))(1 + frac(R_2, R_1)) - V_1 dot (frac(R_2, R_1))$. Với $R_1 = R_2$ và $R_4 = R_5$, ta được $V#sub[out] = V_2 - V_1 = V_R$, nguồn cấp $V#sub[CC] = 3.3V$ và $V#sub[EE] = -3.3V $ thì dạng sóng $V#sub[out]$ thu được như @form-wave-opamp-dual:

#figure(
    image("../images/form_wave_opamp_dual.png", width: 100%),
    caption: [Dạng sóng $V#sub[out]$],
) <form-wave-opamp-dual>

Tuy nhiên, việc chưa đủ kiến thức để thiết kế nguồn đôi $plus.minus 3.3V$ nên ta sẽ chuyển sang cấp nguồn đơn và cấp thêm $V#sub[offset] = frac(V#sub[CC], 2)$ vào $V#sub[+]$ 
