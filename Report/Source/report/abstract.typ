#import "font.typ": *
#import "../contents/info.typ": *
#import "../contents/abstract.typ": *


#show heading : it => {
  set align(center)
  set text(font: arial, size: font_size.large)
  it
  par(leading: 1.5em)[#text(size:0.0em)[#h(0.0em)]]
}

// format footer
#set page(footer: [
    #set align(center)
    #set text(size: 10pt, baseline: -3pt)
    #counter(page).display(
      "I",
    )
] )

#pagebreak()
// Abstract written by Vietnamese
  #heading(level: 1, outlined: false)[TÓM TẮT]
  #v(2em)

  #par(
    justify: true,
    leading: 1.5em, 
    first-line-indent: 2em)[#text(font: arial, size: font_size.footnotesize)[#abstract_vn]]

Bài báo cáo có tham khảo một số tài liệu.

@an3322 @ac_design