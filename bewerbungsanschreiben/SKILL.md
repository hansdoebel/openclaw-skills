---
name: Bewerbungsanschreiben
description: >
  Erstelle professionelle deutsche Bewerbungsanschreiben nach DIN 5008 als PDF via Typst.
  Use when: (1) user shares a job posting URL and wants an Anschreiben/cover letter,
  (2) user asks to write a Bewerbung or Bewerbungsanschreiben,
  (3) user wants to apply for a job and needs a German-language application letter.
  Triggers: "Bewerbung", "Anschreiben", "Bewerbungsanschreiben", "cover letter", "bewerben",
  "Stellenanzeige", "Job bewerbung". NOT for: English cover letters, CV/Lebenslauf creation,
  or non-German application formats.
---

# Bewerbungsanschreiben

Erstelle professionelle deutsche Bewerbungsanschreiben im DIN-5008-Format, kompiliert als PDF mit Typst.

## Workflow

### 1. Stellenanzeige erfassen

- URL der Stellenanzeige abrufen (web_fetch oder Browser)
- Alle relevanten Infos extrahieren: Titel, Firma, Anforderungen, Nice-to-haves, Benefits
- Stellenanzeige als `stellenanzeige.md` im Firmenordner speichern

### 2. Persönliche Daten laden

- `constants.md` aus dem Bewerbungs-Repo lesen (Pfad: `bewerbungen/constants.md`)
- Enthält: Name, Adresse, Telefon, E-Mail, Profil, Kompetenzen
- Falls Daten fehlen, den Benutzer fragen

### 3. Anschreiben erstellen

- Richtlinien lesen: `references/richtlinien.md`
- Typst-Vorlage nutzen: `assets/anschreiben-vorlage.typ`
- Neuen Ordner unter `bewerbungen/firmen/<firma-jobtitel>/` anlegen
- `anschreiben.typ` erstellen, das die Vorlage importiert:
  ```typst
  #import "../../vorlagen/anschreiben.typ": anschreiben
  #show: anschreiben.with(
    absender-name: "...",
    firma-name: "...",
    betreff: "Bewerbung als ...",
    // weitere Parameter
  )
  // Fließtext
  ```

### 4. Regeln (strikt einhalten)

- Max. 1 Seite, niemals länger
- Kein "Hiermit bewerbe ich mich", kreativer Einstieg
- Nur vollständige Sätze im Fließtext, keine Gedankenstriche oder Stichpunkte im Prosa
- Schriftart: Helvetica, Arial oder Liberation Sans
- Aktive Sprache, konkrete Beispiele, Bezug zu Anforderungen
- Jedes Anschreiben individuell auf die Stelle zugeschnitten
- Selbstbewusst, aber authentisch

### 5. PDF generieren

```bash
# Typst installieren falls nötig
mkdir -p /tmp/typst-bin
curl -fsSL https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz \
  | tar xJ --strip-components=1 -C /tmp/typst-bin/

# Liberation Sans installieren (metrisch identisch mit Arial/Helvetica)
mkdir -p ~/.fonts
curl -fsSL "https://github.com/liberationfonts/liberation-fonts/files/7261482/liberation-fonts-ttf-2.1.5.tar.gz" \
  | tar xz -C /tmp && cp /tmp/liberation-fonts-ttf-2.1.5/LiberationSans-*.ttf ~/.fonts/

# Kompilieren (--root zeigt auf bewerbungen/, --font-path für Liberation Sans)
cd bewerbungen/
/tmp/typst-bin/typst compile --root . --font-path ~/.fonts firmen/<ordner>/anschreiben.typ firmen/<ordner>/anschreiben.pdf
```

### 6. Ergebnis liefern

- PDF an den Benutzer senden
- Alles ins Git-Repo committen und pushen

## Dateistruktur

```
bewerbungen/
├── constants.md                    ← Persönliche Daten (vom Benutzer gepflegt)
├── vorlagen/
│   └── anschreiben.typ             ← Zentrale Typst-Vorlage
└── firmen/
    └── <firma-jobtitel>/
        ├── stellenanzeige.md       ← Extrahierte Stellenanzeige
        ├── anschreiben.typ         ← Individuelles Anschreiben
        └── anschreiben.pdf         ← Generiertes PDF
```

## Vorlage aktualisieren

Die Vorlage unter `vorlagen/anschreiben.typ` und die Kopie in diesem Skill (`assets/anschreiben-vorlage.typ`) synchron halten. Änderungen an der Vorlage wirken sich auf alle zukünftigen Anschreiben aus.
