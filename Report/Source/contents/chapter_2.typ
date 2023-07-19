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

=== Chọn mode thích hợp
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
// ==== Single-channel, single conversion mode
// Mode này là mode đơn giản nhất, bộ ADC chỉ thực hiện chuyển đổi một lần duy nhất sau khi chuyển đổi xong  bộ ADC sẽ dừng.

// #figure(
//     image("../images/adc_single_single_conv.png", width: 20%),
//     caption: [Single-channel, single conversion mode.],
// )

// ==== Multichannel (scan), single conversion mode
// Trong mode này, bộ ADC sẽ thực hiện chuyển đổi các channel liên tiếp, chuyển đổi tiếp theo sẽ được thực hiện ngay khi chuyển đổi trước kết thúc, thứ tự channel được chuynể đổi có thể tuỳ chỉnh. Các channel có thể được thiết lập thời gian lấy mẫu khác nhau.
// #figure(
//     image("../images/adc_scan_single_mode.png", width: 20%),
//     caption: [Multichannel, single conversion mode.],
// )

// ==== Single-channel, continuous conversion mode
// Với mode này, ADC sẽ thực hiện chuyển đổi 1 channel liên tục và vô hạn. Đồng nghĩa với việc ADC sẽ chuyển đổi liên tục mà không cần sự can thiệp của CPU.


// #figure(
//     image("../images/adc_continuous_conv.png", width: 30%),
//     caption: [Single-channel, continuous conversion mode.],
// )

// ==== Multichannel (scan) continuous conversion mode
// Mode này được dùng khi cần chuyển đổi nhiều channel liên tiếp và không cần sự can thiệp của CPU. Có thể thiết lập thứ tự chuyển đổi và thời gian lấy mẫu từng channel. Khi chuyển đổi đến channel cuối cùng, bộ ADC sẽ quay lại channel đầu tiên và lặp đi lặp lại.

// #figure(
//     image("../images/adc_scan_continuous.png", width: 30%),
//     caption: [Multichannel, continuous conversion mode.],
// )

// ==== Injected conversion mode
// Ta dùng mode này khi cần kích sự chuyển đổi bằng sự kiền nào đó (bên ngoài hoặc bằng phần mềm).

Với các mode kể trên, mode thích hợp nhất để đọc đồng thời tín hiệu điện áp tức thời và dòng điện tức thời là mode *Dual regular simultaneous* với ADC1 channel 6 đọc tín hiệu dòng diện, ADC2 channel 7 đọc tín hiệu điện áp.

Trong mode này, ADC1 và ADC2 sẽ lấy mẫu và chuyển đổi đồng thời. Sau khi chuyển đổi xong, kết quả sẽ được lưu vào thanh ghi data 32-bit ADC1. Nếu dùng scan mode, thứ tự chuyển đổi các channel của 2 ADC có chút khác biệt, với ADC1: từ channel 15 đến channel 0 và ADC2 là từ channel 0 đến channel 15.

#figure(
    image("../images/dual_regular.png", width: 60%),
    caption: [Dual regular simultaneous mode],
)

// ==== Dual fast interleaved mode


// ==== Dual slow interleaved mode


// ==== Dual alternate trigger mode


// ==== Dual combined regular/injected simultaneous mode


// ==== Dual combined: injected simultaneous + interleaved mode



=== Thời gian lấy mẫu (Sampling time)
Mỗi kênh trong bộ ADC có thể lập trình từng giá trị sampling time riêng biệt. Tối thiểu là 1.5 cycles và tối đa là 239.5 cycles.

Như vậy, total conversion time (T#sub[CONV]) của STM32F103C8T6 sẽ được tính như sau:
$
T#sub[CONV] = #[Sampling time] + 12.5 #[cycles].
$ <conversion-time>

== Nguồn cấp cho mạch
#figure(
    image("../images/power_diagram.png", width: 100%),
    caption: [Sơ đồ khối nguồn cấp],
) <power-diagram>
Ta sẽ sử dụng adapter chuyển từ 220VAC thành 9VDC sao đó dùng LDO hạ áp xuống 5v và 3.3V

Theo @power-diagram về LDO, ta sẽ chọn IC AMS1117 - 5V và IC AMS1117 - 3.3V là đủ công suất cung cấp cho mạch.

#figure(
    image("../images/LDO_3.3.png", width: 100%),
    caption: [LDO 3.3V],
)

#figure(
    image("../images/LDO_5.png", width: 100%),
    caption: [LDO 5V],
)

== Thiết kế bộ đo công suất AC
=== Ý tưởng thực hiện
Scale dòng điện và điện áp của điện lưới về phạm vi điện áp đọc được của bộ ADC (0 - 3.3V với V#sub[DDA] = 3.3V), sau đó dùng MCU tính toán công suất bằng phương pháp tích phân dòng điện và điện áp tức thời và hiển thị kết quả lên LCD.

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

Theo datasheet, ZMPT101B là biến áp dòng, tức là ta phải mắc tải hạn dòng ở cuộn sơ cấp để tạo dòng qua biến áp và mắc trở lấy mẫu tại cuộn thứ cấp. Biến áp có tỷ số 2mA:2mA, nếu ta chọn trở hạn dòng $R_L = 820k Omega$ và trở lấy mẫu $R_S = 100 Omega$, giả sử điện áp lưới là $230V_#[rms]$ thì điện áp trên trở $R_S$ có biên độ là 
$
V_R_S = frac(230 dot root(,2) dot 2, R_L) dot R_S = frac(230 dot root(,2) dot 2, 820k) dot 100 = 0.079V#sub[pp]
$
Với $V#sub[pp]$ khá nhỏ như vậy, ảnh hưởng của nhiễu đối với tín hiệu là rất lớn, ta cần 1 tầng khuếch đại vi sai để loại bỏ nhiễu từ biến áp. Tuy nhiên, điện áp lưới có dạng sóng sin, có bán kỳ âm và bán kỳ dương. ADC của STM32F103C8T6 chỉ có thể đọc giá trị điện áp dương từ 0 - V#sub[DDA], vậy nên ta cần có 1 tầng cộng điện áp DC $V#sub[offset] = frac(V#sub[DDA], 2)$ để nâng toàn bộ điện áp $U_R$ lên phần dương.

Mạch khuếch đại này sẽ dùng IC TL072 tham khảo datasheet #link("https://pdf1.alldatasheet.com/datasheet-pdf/view/28775/TI/TL072.html")[*tại đây*]. TL072 có lợi thế hơn so với LM358 ở các module trên thị trường:
- Có thể cấp nguồn 3.3V tiện lợi cho việc dùng STM32F103C8T6.
- Độ nhiễu thấp (low-noise).
- Dùng JFET nên trở kháng đầu vào cao.

Ta sẽ thiết kế từng tầng, đầu tiên là tầng khuếch đại vi sai dùng OPAMP.
@opamp-differ là sơ đồ cơ bản của tầng khuếch đại vi sai:

#figure(
    image("../images/opamp_differ.png", width: 55%),
    caption: [Sơ đồ nguyên lý khuếch đại vi sai dùng OPAMP],
) <opamp-differ>

Theo lý thuyết, độ lợi vi sai của mạch @opamp-differ: 

$
V#sub[out] = V_2 dot (frac(R_5, R_4 + R_5))(1 + frac(R_2, R_1)) - V_1 dot (frac(R_2, R_1))
$
Với $R_1 = R_2$ và $R_4 = R_5$, ta được $V#sub[out] = V_2 - V_1 = V_R$, nguồn cấp $V#sub[CC] = 3.3V$ và $V#sub[EE] = -3.3V $ thì dạng sóng $V#sub[out]$ thu được như @form-wave-opamp-dual:

#figure(
    image("../images/form_wave_opamp_dual.png", width: 100%),
    caption: [Dạng sóng $V#sub[out]$ của OPAMP cấp nguồn đôi],
) <form-wave-opamp-dual>

Tuy nhiên, việc chưa đủ kiến thức để thiết kế nguồn đôi $plus.minus 3.3V$ nên ta sẽ chuyển sang cấp nguồn đơn $3.3V$ và cộng thêm $V#sub[offset] = frac(V#sub[CC],  2)$ và dạng sóng $V#sub[out]$ thu được   . 

#figure(
    image("../images/opamp_diff_single.png", width: 100%),
    caption: [Dạng sóng $V#sub[out]$ của OPAMP cấp nguồn đơn],
) <form-wave-opamp-single>

Lúc này, ngõ ra sẽ có phương trình
$
V#sub[out] = V_2 dot (frac(R_4 parallel R_6, R_7 + R_4 parallel R_6))(1 + frac(R_2, R_1)) - V_1 dot (frac(R_2, R_1)) + V#sub[CC] dot frac(R_6, R_6 + R_7)
$ <eq-vout-single>
chọn tất cả $R = 10 k Omega$, ta có 
$
V#sub[out] = frac(2, 3) dot V_2 - V_1 +  frac(V#sub[CC], 2)
$
và dạng sóng thu được như @form-wave-opamp-single có $V#sub[pp] = 36.2 $ mV. Được biết, độ lợi áp của mạch phụ thuộc bởi tỷ số $frac(R_2, R_1)$ để dễ dàng cho việc đọc ADC, ta chọn $R_2 = 200 k Omega, R_1 = 10 k Omega$. Như vậy, thay vào @eq-vout-single ta được:

$
V#sub[out] = frac(20, 3) dot V_2 - 20 dot V_1 +  frac(V#sub[CC], 2)
$
và có $V#sub[pp] = 102$ mV dạng sóng như @form-wave-opamp-single-g20
#figure(
    image("../images/opamp_diff_g20.png", width: 90%),
    caption: [Dạng sóng $V#sub[out]$ của OPAMP cấp nguồn đơn và khuếch đại vi sai],
) <form-wave-opamp-single-g20>

Tiếp theo, ta sẽ thêm tụ decupling và tụ bypass vào mạch như @first-stage-opamp
#figure(
    image("../images/first_stage_opamp.png", width: 80%),
    caption: [Khuếch đại vi sai dùng OPAMP cấp nguồn đơn],
) <first-stage-opamp>

Vậy là ta đã thiết kế xong tầng khuếch đại vi sai, với ý tưởng ban đầu ta sẽ làm tầng cộng điện áp, tuy nhiên do ở tầng 1 ta đã cộng được $V#sub[offset] = frac(V#sub[CC], 2)$ mà tín hiệu vần còn khá nhỏ để đọc nên tầng tiếp theo sẽ có tác dụng khuếch đại tín hiệu một lần nữa.

Để lọc nhiễu tín hiệu, ta sẽ gắn thêm bộ lọc thông thấp RC với $R = 1 k Omega, C = 1 mu F$ có tần số cắt $f_C = frac(1, 2 pi R C) = frac(1, 2 pi dot 1000 dot 10^(-6)) = 160$ Hz, ta được mạch hoàn chỉnh như @final-opamp.

#figure(
    image("../images/final_opamp.png", width: 100%),
    caption: [Mạch đo điện áp AC],
) <final-opamp>

==== Đo dòng điện AC

Để đo dòng điện AC, ta sẽ dùng cảm biến dòng dựa trên hiệu ứng Hall #link("https://pdf1.alldatasheet.com/datasheet-pdf/view/168326/ALLEGRO/ACS712.html")[ACS712] với tầm đo đến 30A. Với nhu cầu đo chỉ dưới 8A nên ta sẽ dùng loại ACS712-20 có độ nhạy 100mV/A.
$V#sub[out]$ tại chân số 7 của IC là tín hiệu analog 0 - V#sub[CC] và có $V#sub[offset] = frac(V#sub[CC], 2)$ vậy nên chỉ cần gắn thêm bộ lọc thông thấp và diode zener tránh trường hợp V#sub[out] quá 3.3V.

#figure(
    image("../images/current_meas.png", width: 100%),
    caption: [Mạch đo dòng diện AC dùng ACS712],
) <current-measure>

ACS712 trả về kết quả khá đúng ở dòng điện cao, nhưng ở dòng diện nhỏ (< 1A) thì cho kết quả không đúng và khá dao động.

== Thiết kế giao tiếp MCU và hiển thị LCD

Về MCU, ta sẽ sử dụng STM32F103C8T6 có 64KB FLASH và 64 pins phù hợp với đề tài. MCU khi cấp nguồn cần gắn thêm một số tụ lọc theo datasheet (@power-sup-cap). Sử dụng thạch anh ngoại để cấp xung clock ổn định cho hệ thống cũng như bộ ADC (@xtal), debug và nạp code qua serial wire và nút reset MCU (@nrst) và 7 chân GPIO để giao tiếp với LCD 1602 (@).
#figure(
    image("../images/mcu_perip.png", width: 60%),
    caption: [Kết nối MCU và các ngoại vi],
) <mcu-perip>
#figure(
    image("../images/power_sup_cap.png", width: 60%),
    caption: [Các tụ lọc cho MCU],
) <power-sup-cap>
#figure(
    image("../images/xtal.png", width: 35%),
    caption: [Thạch anh ngoại 8MHz],
) <xtal>
#figure(
    image("../images/nrst.png", width: 35%),
    caption: [Giao tiếp Serial Wire và nút nhấn reset MCU],
) <nrst>
#figure(
    image("../images/lcd.png", width: 80%),
    caption: [LCD 1602 giao tiếp 4-bit],
) <lcd>

== Thiết kế phần mềm đọc tín hiệu ADC và tính toán công suất



#figure(
    image("../images/flowchart.png", width: 100%),
    caption: [Lưu đồ giải thuật đo công suất AC],
) <flowchart-software>

=== Cấu hình Clock cho hệ thống

Hệ thống sẽ sử dụng xung clock từ thạch anh 8MHz (HSE), qua các bộ prescaler để cấp cho ADC1 & ADC2 clock 500kHz và timer clock 8MHz (@clock-tree).

#figure(
    image("../images/clock_tree.png", width: 100%),
    caption: [Clock tree cho MCU],
) <clock-tree>

=== Cấu hình ADC

Theo  @conversion-time, ta sẽ chọn Sampling time tối đa là 239.5 cycles, $f_#[ADC] = 500 #[kHz]$ suy ra thời gian chuyển đổi của bộ ADC là
$
T_#[CONV] = frac(239.5 + 12.5, 500000) = 0.5 #[ms]
$

Cho điện lưới có chu kỳ 50Hz thì trong 1 chu kỳ bộ ADC sẽ lấy mẫu 40 lần. Với dữ liệu lớn như vậy, ta sẽ sử dụng DMA để tránh chiếm tài nguyên của CPU.

#figure(
    image("../images/config_adc.png", width: 80%),
    caption: [ADC1 channel 6 và ADC2 channel 7],
) <config-adc>

=== Công thức tính công suất

Ta sẽ tính công suất trung bình theo công thức:
$
P = 1/T integral_(0)^(T) u(t) dot i(t) #[dt]
$ <eq-power>
@eq-power có thể tính như sau:
$
    P = 1/(T) dot sum u(t) dot i(t) dot T_s
$ <eq-power-sum>

với T là chu kỳ của điện lưới 20ms,$T_s$ là thời gian lấy mẫu $T_s = frac(239.5, 500000) = 0.48 #[ms]$, u(t) chính là giá trị tức thời của ADC2_IN7, i(t) là giá trị tức thời của ADC1_IN6.

Thay vào @eq-power-sum
$
    P = frac(T_s, T) dot sum u(t) dot i(t) = 0.024 dot sum u(t) dot i(t)
$ <eq-power-cal>

Ta sẽ dùng @eq-power-cal để tính toán trong MCU.

ADC1 & ADC2 đều là ADC 12-bit, $V_#[ref] = V_#[DDA] = 3.3V$ suy ra u và i tức thời.
$
    u = frac(#[ADC2_IN7], 4096) dot 3.3 dot #[V_GAIN] 
$
$
    i = frac(#[ADC1_IN6], 4096) dot 3.3 dot #[I_GAIN]
$

Suy ra
$
    p = u dot i = #[ADC1_IN6] dot #[ADC_IN7] dot (frac(3.3,4096))^2 dot #[V_GAIN] dot #[I_GAIN]
$

để giảm tải tài nguyên CPU, ta sẽ nhân hằng số ở bước cuối cùng
$
    P = 0.024 dot (frac(3.3,4096))^2 dot #[V_GAIN] dot #[I_GAIN] dot sum u dot i
$ <final-eq-power>

@final-eq-power là phương trình được dùng trong giải thuật tính công suất. Với V_GAIN và I_GAIN là 2 hệ số nhân tỷ lệ.

== Các vấn đề gặp phải khi đo công suất dùng vi điều khiển

Việc dùng ADC để đọc tín hiệu liên tục trả về kết quả không chính xác do nhiều yếu tố như nguồn không ổn định, nhiễu, nhiệt độ ảnh hưởng đấn giá trị điện trở,.... Mặc dù đã cài đặt sampling time lớn nhất của STM32F103C8T6 (239.5 cycles), điều chỉnh các hệ số tỷ lệ để tăng độ chính xác, nhưng vẫn không thể đo chính xác được giá trị điện áp và dòng điện.