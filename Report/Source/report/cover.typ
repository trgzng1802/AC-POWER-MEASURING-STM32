#import "font.typ": *
#import "../contents/info.typ": *

#set page(footer: none)

#counter(page).update(0)

#show: block.with(stroke: 3pt, 
                width: 100%, 
                height: 100%, 
                inset: 4pt)
#show: block.with(stroke: 0.5pt, 
                width: 100%, 
                height: 100%, 
                inset: 10pt)

#set text(
        font: arial,
        size: font_size.small,
        )

#align(center)[
    #table(
        columns: (auto),
        align: horizon,
        stroke: none,
        text(
        font: arial,
        size: font_size.small,
        weight: "bold",
        )[ĐẠI HỌC QUỐC GIA THÀNH PHỐ HỒ CHÍ MINH],
        text(
        font: arial,
        size: font_size.small,
        weight: "bold",
        )[TRƯỜNG ĐẠI HỌC BÁCH KHOA],
    )
    #v(-10pt)
    #line(
        length: 70%,
        stroke: 1pt,
    )
    #v(-20pt)

    #table(
        columns: (auto),
        align: horizon,
        stroke: none,
        [#image("../images/01_logobachkhoasang.png", width: 50%)],
        [],[],
        [],[],
        text(
        font: arial,
        size: font_size.small,
        weight: "bold",
        )[BÁO CÁO],

        // text(
        // font: arial,
        // size: font_size.small,
        // weight: "bold",
        // )[#vn_subject],
        [],[],
        text(
        font: arial,
        size: font_size.Large,
        weight: "bold",
        )[ĐỀ TÀI:],
        text(
        font: arial,
        size: font_size.Large,
        weight: "bold",
        )[#vn_title],

        // text(
        // font: arial,
        // size: font_size.small,
        // weight: "bold",
        // )[Lớp #btl_class - Nhóm #btl_gr - #semester],
        [],[],
        text(
        font: arial,
        size: font_size.small,
        weight: "bold",
        )[GVHD: #advisor],
    )
    


    #table(
        columns: (auto, auto),
        inset: 5pt,
        align: horizon,
        text(
        font: arial,
        size: font_size.small,
        weight: "bold",
        )[Sinh viên thực hiện], text(
        font: arial,
        size: font_size.small,
        weight: "bold",
        )[Mã số sinh viên],
        [#st_name], [#st_id]
    )
]

#v(230pt)
#align(
    center,
    block(
        text(
            weight: "bold",
            size: font_size.large,
            [_Hồ Chí Minh, #date _]
        )
    ))







