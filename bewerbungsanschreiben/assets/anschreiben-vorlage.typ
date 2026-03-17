// ============================================================
// Bewerbungsanschreiben – Wiederverwendbare Typst-Vorlage
// Version: 1.0 | Letzte Aktualisierung: 2026-03-17
// ============================================================
// Verwendung: In firmen/<firma>/anschreiben.typ importieren:
//   #import "../../vorlagen/anschreiben.typ": anschreiben
//   #show: anschreiben.with(
//     absender-name: "Max Mustermann",
//     ...
//   )
// ============================================================

#let anschreiben(
  // --- Absender ---
  absender-name: "Vorname Nachname",
  absender-strasse: "Musterstraße 1",
  absender-ort: "12345 Berlin",
  absender-telefon: "+49 123 4567890",
  absender-email: "vorname@example.com",
  // --- Empfänger ---
  firma-name: "Firma GmbH",
  firma-abteilung: none,
  firma-ansprechpartner: none,
  firma-strasse: none,
  firma-ort: none,
  // --- Meta ---
  datum: datetime.today().display("[day].[month].[year]"),
  ort: "Berlin",
  betreff: "Bewerbung als …",
  anrede: "Sehr geehrte Damen und Herren,",
  gruss: "Mit freundlichen Grüßen",
  // --- Inhalt ---
  body,
) = {
  // ----- Seiteneinstellungen (DIN 5008 angelehnt, max. 1 Seite) -----
  set page(
    paper: "a4",
    margin: (top: 27mm, bottom: 25mm, left: 25mm, right: 20mm),
  )
  set text(font: "New Computer Modern", size: 11pt, lang: "de")
  set par(justify: true, leading: 0.65em)

  // Warnung bei >1 Seite (Anschreiben muss immer auf eine Seite passen)
  context {
    let pages = counter(page).final().at(0)
    if pages > 1 {
      place(top + right, dx: 5mm, dy: -15mm,
        text(fill: red, weight: "bold", size: 9pt)[⚠ ACHTUNG: #pages Seiten! Kürzen!]
      )
    }
  }

  // ----- Absenderzeile (klein, einzeilig) -----
  text(size: 8pt, fill: luma(100))[
    #absender-name · #absender-strasse · #absender-ort
  ]
  v(2mm)
  line(length: 100%, stroke: 0.4pt + luma(180))
  v(6mm)

  // ----- Empfänger-Anschriftenfeld -----
  {
    set text(size: 11pt)
    firma-name
    linebreak()
    if firma-abteilung != none { firma-abteilung; linebreak() }
    if firma-ansprechpartner != none { firma-ansprechpartner; linebreak() }
    if firma-strasse != none { firma-strasse; linebreak() }
    if firma-ort != none { firma-ort }
  }

  v(12mm)

  // ----- Datum rechtsbündig -----
  align(right)[#ort, den #datum]

  v(8mm)

  // ----- Betreffzeile -----
  text(weight: "bold", size: 11.5pt)[#betreff]

  v(6mm)

  // ----- Anrede -----
  anrede

  v(2mm)

  // ----- Fließtext (body) -----
  body

  v(6mm)

  // ----- Grußformel & Unterschrift -----
  gruss
  v(10mm)
  absender-name

  // ----- Kontaktdaten Fußzeile -----
  place(bottom + center, dy: 10mm,
    text(size: 8pt, fill: luma(120))[
      #absender-telefon #h(1em) · #h(1em) #absender-email
    ]
  )
}
