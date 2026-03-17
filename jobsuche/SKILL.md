---
name: Jobsuche
description: >
  Search and retrieve German job listings via the Arbeitsagentur Jobsuche API (rest.arbeitsagentur.de).
  The largest job database in Germany. Use when: (1) searching for jobs in Germany by keyword, location,
  or filters, (2) retrieving details of a specific job listing by reference number, (3) user asks to
  find jobs, Stellen, or Stellenangebote in Germany. Triggers: "Jobsuche", "Stellenangebote",
  "Arbeitsagentur", "jobs in Germany", "Stellen suchen", "find jobs". NOT for: international job boards,
  LinkedIn, Indeed, or non-German job markets.
---

# Jobsuche (Arbeitsagentur API)

Search the Arbeitsagentur job database, the largest job database in Germany, via their public REST API.

## Quick Search Profiles

Predefined search profiles for common job searches. Use these as shortcuts when the user says something like "Suche Berlin" or "Jobs München".

### Default Filters (always apply unless overridden)

- `arbeitszeit=vz` (Vollzeit)
- `befristung=2` (Unbefristet)
- `zeitarbeit=false` (keine Zeitarbeit)
- `veroeffentlichtseit=28` (letzte 4 Wochen)
- `size=50` (50 Ergebnisse)
- `angebotsart=1` (Arbeit, keine Ausbildung/Praktikum)

### Search Keywords (rotate through these per city)

Run multiple searches per city to cover different angles of the profile:

1. `was=Softwareentwickler` (broad software dev)
2. `was=Backend Engineer` (backend focus)
3. `was=Full Stack Developer` (full-stack)
4. `was=Python Developer` (Python focus)
5. `was=TypeScript Developer` (TypeScript focus)
6. `was=DevOps Engineer` (infrastructure)
7. `was=Machine Learning Engineer` (AI/ML)
8. `was=Data Engineer` (data pipelines)

### City Profiles

| City | `wo` | `umkreis` | Notes |
|------|------|-----------|-------|
| Berlin | Berlin | 25 | Home base, highest priority |
| Hamburg | Hamburg | 25 | Strong tech scene |
| München | München | 25 | High salaries, many enterprise roles |
| Remote | (any city) | 0 | Use `arbeitszeit=ho` additionally |

### Filtering Results (post-search)

After fetching results, always filter out:
- Zeitarbeitsfirmen (FERCHAU, DIS AG, Bertrandt, Akkodis, Hays, Randstad, Adecco, ManpowerGroup, Robert Half)
- C++, Embedded, COBOL, ABAP, SAP roles (unless user asks)
- Junior positions (unless user asks)
- Roles requiring niche stacks unrelated to profile (e.g., pure Java/Spring without AI component)

Prioritize roles that match:
- TypeScript, Python, Node.js, Go
- AI, ML, NLP, RAG, LLM, Vector Databases
- Full-Stack or Backend
- Cloud-native (AWS, GCP, Azure)
- Remote or hybrid options
- Startups and product companies over consulting

### Quick Command Examples

User says: "Suche Berlin" →
Search Berlin with all default filters and keywords 1-5.

User says: "Suche Remote ML" →
Search with `was=Machine Learning Engineer`, `arbeitszeit=ho;vz`, all cities.

User says: "Suche Hamburg Backend letzte Woche" →
Search Hamburg with `was=Backend Engineer`, `veroeffentlichtseit=7`.

## Authentication

All requests require the header `X-API-Key`. The default public key is `jobboerse-jobsuche`.

```bash
-H "X-API-Key: jobboerse-jobsuche"
```

## Endpoints

Base URL: `https://rest.arbeitsagentur.de/jobboerse/jobsuche-service`

### Search Jobs

`GET /pc/v4/jobs`

```bash
curl -s "https://rest.arbeitsagentur.de/jobboerse/jobsuche-service/pc/v4/jobs?was=Softwareentwickler&wo=Berlin&arbeitszeit=vz&befristung=2&zeitarbeit=false&veroeffentlichtseit=28&size=50" \
  -H "X-API-Key: jobboerse-jobsuche" \
  -H "Accept: application/json"
```

#### Query Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `was` | string | | Keyword search (job title) |
| `wo` | string | | Location search |
| `page` | number | 1 | Result page (starts at 1) |
| `size` | number | 25 | Results per page (1 to 100) |
| `umkreis` | number | 25 | Search radius in km |
| `angebotsart` | number | 1 | 1=Arbeit, 4=Ausbildung, 34=Praktikum, 2=Selbständigkeit |
| `befristung` | string | | "1"=Befristet, "2"=Unbefristet (semicolon-separated) |
| `arbeitszeit` | string | | "vz"=Vollzeit, "tz"=Teilzeit, "ho"=Remote, "mj"=Minijob, "snw"=Schicht (semicolon-separated) |
| `arbeitgeber` | string | | Employer name filter |
| `berufsfeld` | string | | Occupational field |
| `veroeffentlichtseit` | number | 30 | Published within last N days (0 to 100) |
| `zeitarbeit` | boolean | true | Include temp agency jobs |
| `behinderung` | boolean | false | Only disability-suitable positions |

### Get Job Details

`GET /pc/v3/jobdetails/{base64_refnr}`

The reference number from search results must be base64-encoded.

```bash
REFNR="10000-1184867112-S"
ENCODED=$(echo -n "$REFNR" | base64)
curl -s "https://rest.arbeitsagentur.de/jobboerse/jobsuche-service/pc/v3/jobdetails/$ENCODED" \
  -H "X-API-Key: jobboerse-jobsuche" \
  -H "Accept: application/json"
```

## Workflow

1. Search with default filters and relevant keywords for the requested city.
2. Parse results and filter out Zeitarbeit, irrelevant stacks, and junior roles.
3. Get details for promising matches via the Get endpoint.
4. Rank by profile fit and present top matches to the user.
5. If user wants Anschreiben: use the bewerbungsanschreiben skill.

## API Documentation

Full API docs: https://jobsuche.api.bund.dev/
