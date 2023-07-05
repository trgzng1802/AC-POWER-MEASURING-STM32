#import "font.typ": *


#show heading: it => {
    set align(center)
    set text(font: arial, size: font_size.large)
    it
    par(leading: 1.5em)[#text(size:0.0em)[#h(0.0em)]]
}

#set page(footer: [
    #set align(center)
    #set text(size: 10pt, baseline: -3pt)
    #counter(page).display(
        "I",
    )
] )
// List of Figures
#v(2em)
/*
#show outline: it => {
    set heading(numbering: "1.1")
    set text(font: arial, size: font_size.footnotesize)
    set par(leading: 1em )
    it
}
#outline(
    title: none,
    target: figure.where(kind: image),
    indent : true,
)
*/
#heading(level: 1, outlined: false)[DANH SÁCH HÌNH ẢNH]
#show outline: it => {
    set heading(numbering: "1.1.1")
    set text(font: arial, size: font_size.footnotesize)
    set par(leading: 1em )
    it
}
#outline(
    depth: 3,
    title: none,
    target: figure.where(kind: image),
    indent: true,
)

#pagebreak()

// List of Tables
#v(2em)
#heading(level: 1, outlined: false)[DANH SÁCH BẢNG BIỂU]
#show outline: it => {
    set heading(numbering: "1.1.1")
    set text(font: arial, size: font_size.footnotesize)
    set par(leading: 1em )
    it
}
#outline(
    depth: 3,
    title: none,
    target: figure.where(kind: table),
    indent: true,
)
#pagebreak()

// Table of Contents
#heading(level: 1, outlined: false)[MỤC LỤC]
#v(2em)
#{
    set align(left)
    set text(font: arial, size: font_size.footnotesize)
    set par(first-line-indent: 0pt)

  [TÓM TẮT ] + [.] * 135 + [ I]
    set par(leading: 1em) 
  [DANH SÁCH HÌNH ẢNH ] + [.] * 107 + [ II]
    set par(leading: 1em)
  [DANH SÁCH BẢNG BIỂU ] + [.] * 104 + [ III]
    set par(leading: 1em)
  [MỤC LỤC ] + [.] * 131 + [ IV]
}
#show outline: it => {
    set text(font: arial, size: font_size.footnotesize)
    set par(leading: 1em )
    it
}
#outline(
    title: none,
    indent: true,
)