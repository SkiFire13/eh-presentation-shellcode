#import "@preview/polylux:0.3.1": logic, utils

#let unipd-palette = (
  main: rgb(155, 0, 20),
  gray: rgb(72, 79, 89),
  light-gray: rgb(237, 237, 238),
  header-logo: "logo_text_white.png",
  title-background: "bg.svg",
  background-logo: "logo_text.png",
  footer-wave: "bg_wave.svg",
)

#let palette-state = state("unipd-theme-palette", unipd-palette)
#let with-palette = f => locate(loc => f(palette-state.at(loc)))

#let title-background = with-palette(palette => {
  place(image(palette.title-background, width: 100%, fit: "stretch"))
  place(
    bottom + right, dx: -5%, dy: -5%,
    image(palette.background-logo, height: 18%)
  )
})

#let unipd-theme(aspect-ratio: "4-3", palette: unipd-palette, body) = {
  set page(margin: 0pt)
  set page(paper: "presentation-" + aspect-ratio) if aspect-ratio != "16-9-extended"
  set page(width: 1058.27pt, height: 595.28pt) if aspect-ratio == "16-9-extended"
  
  set text(font: "New Computer Modern Sans", size: 24pt)
  show heading.where(level: 2): set text(fill: palette.main)
  show heading.where(level: 2): it => it + v(1em)
  set list(marker: text("•", fill: palette.main.darken(20%)))

  palette-state.update(palette)
  body
}

#let title-slide(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
) = logic.polylux-slide({
  // Background
  title-background

  // Normalize data
  if type(subtitle) == none {
    subtitle = ""
  }
  if type(authors) != array {
    authors = (authors,)
  }
  if type(date) == none {
    date = ""
  }

  // Title, subtitle, author and date
  v(20%)
  align(
    center,
    box(inset: (x: 2em), text(size: 46pt, fill: white, title))
  )
  align(
    center,
    box(inset: (x: 2em), text(size: 30pt, fill: white, subtitle))
  )
  v(5%)
  // TODO: Max 2 columns, last in a single column
  block(width: 100%, inset: (x: 2em), grid(
    rows: (auto,),
    columns: (1fr,) * authors.len(),
    column-gutter: 2em,
    ..authors.map(author => align(center, text(size: 24pt, fill: white, author)))
  ))
  place(bottom, dx: 7.5%, dy: -30%, text(size: 24pt, fill: white, date))
})

#let header = with-palette(palette => {
  place(rect(width: 100%, height: 12%, fill: palette.main))
  place(right, dx: -2%, dy: 1%, image(palette.header-logo, height: 10%))
  // Section name in header
  place(dx: 2%, dy: 4.5%, text(size: 34pt, fill: white, utils.current-section))
})

#let footer = with-palette(palette => {
  place(bottom, image(palette.footer-wave, width: 100%))
  // Slide number in the footer
  place(
    bottom + right, dx: -2.5%, dy: -2.5%,
    text(
      size: 18pt,
      fill: palette.main.lighten(50%),
      logic.logical-slide.display("1 of 1", both: true)
    )
  )
})

#let slide(title: none, body) = logic.polylux-slide({
  header
  v(15%) // Space for header
  footer

  if title != none {
    v(7%)
    let title-text = with-palette(palette => text(palette.main, title))
    block(
      width: 100%, inset: (x: 4.5%, y: -.5em), breakable: false,
      outset: 0em,
      heading(level: 1, title-text)
    )
    v(.7em)
  }

  v(1fr)
  block(width: 100%, inset: (x: 2em), body)
  v(2fr)
})

#let new-section(title) = utils.register-section(title)

#let new-section-slide(title) = logic.polylux-slide({
  header
  footer

  new-section(title)
  set align(center + horizon)
  let titletext = with-palette(palette => text(palette.main, title))
  heading(level: 2, titletext)
})

#let filled-slide(content) = logic.polylux-slide(with-palette(palette => {
  set text(size: 44pt, fill: white)
  show: it => box(width: 100%, height: 100%, fill: palette.main, it)
  show: it => align(center + horizon, it)
  content
}))

/*

  let default(slide-info, bodies) = {

    // Header
    place(rect(width: 100%, height: 12%, fill: unipd-red))
    place(right, dx: -2%, dy: 1%, image("logo_text_white.png", height: 10%))
    // Section name in header
    place(dx: 2%, dy: 4.5%, text(size: 34pt, fill: white, section.display()))
    // Skip header
    v(15%)

    // Footer
    place(bottom, image("bg_wave.svg", width: 100%))
    // Slide number in the footer
    place(
      bottom + right, dx: -2.5%, dy: -2.5%,
      text(size: 18pt, fill: unipd-red.lighten(50%), logical-slide.display("1 of 1", both: true))
    )

    if bodies.len() == 0 {
      if "title" in slide-info {
        v(-7%)
        align(
          center + horizon,
          heading(level: 1, text(unipd-red)[#slide-info.title])
        )
      }
      return
    }

    if "title" in slide-info {
      v(7%)
      block(
        width: 100%, inset: (x: 4.5%, y: -.5em), breakable: false,
        outset: 0em,
        heading(level: 1, text(unipd-red)[#slide-info.title])
      )
	    v(.7em)
    }

    block(width: 100%, inset: (x: 2em), grid(
      columns: (1fr,) * bodies.len(),
      column-gutter: 2em,
      ..bodies.map(body => v(1fr) + body + v(2fr))
    ))
  }

  let wake-up(slide-info, bodies) = {
    if bodies.len() != 1 {
      panic("unipd theme only supports one body per slide")
    }

    // Background
    place(block(
      width: 100%, height: 100%, fill: unipd-red, breakable: false,
      outset: 0pt, inset: 0pt,
    ))

    align(center + horizon, text(size: 1.5em, fill: white, bodies.first()))
  }

  (
    "default": default,

    "title slide": title-slide,
    "title": title-slide,

    "wake up": wake-up,
    "full": wake-up,
    "end": wake-up,
  )
}

#let (normal-block, alert-block, example-block) = {
  let make_block_fn(header-color) = (title, body) => {
    align(center, box(width: 85%, stack(dir: ttb,
      box(
        width: 100%, inset: 0.5em, outset: 0em,
        fill: header-color, stroke: black,
        align(left, heading(level: 2, text(fill: white)[#title]))
      ),
      box(
        width: 100%, inset: 1em, outset: 0em, fill: unipd-light-gray,
        stroke: black,
        align(left, body)
      )
    )))
  }

  (
    make_block_fn(unipd-gray),
    make_block_fn(unipd-red),
    make_block_fn(rgb(0, 128, 0)),
  )
}
*/