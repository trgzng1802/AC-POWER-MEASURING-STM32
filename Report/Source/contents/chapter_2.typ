#import "../report/tablex.typ": *

= ĐO CÔNG SUẤT LƯỚI DÙNG VI ĐIỀU KHIỂN STM32F103C8T6
== Tổng quan về bộ ADC của STM32F103C8T6

Bộ ADC đóng vai trò quan trọng, là bộ phận thu thập giá trị điện áp và dòng điện theo thời gian, cũng là bộ phận quyết định độ chính xác của hệ thống. Theo datasheet, bộ ADC của STM32F103C8T6 là bộ ADC 12-bit, có các mode: Single mode, Continuous mode, Scan mode và Discontinuous mode. Dưới dây là các thông số cơ bản được ghi trong datasheet.

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