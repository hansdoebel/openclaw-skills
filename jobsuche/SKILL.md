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

## Authentication

All requests require the header `X-API-Key`. The default public key is `jobboerse-jobsuche`.

```bash
-H "X-API-Key: jobboerse-jobsuche"
```

## Endpoints

Base URL: `https://rest.arbeitsagentur.de/jobboerse/jobsuche-service`

### Search Jobs

`GET /pc/v4/jobs`

Search for job listings with keyword, location, and filters.

```bash
curl -s "https://rest.arbeitsagentur.de/jobboerse/jobsuche-service/pc/v4/jobs?was=Softwareentwickler&wo=Berlin&size=10&page=1" \
  -H "X-API-Key: jobboerse-jobsuche" \
  -H "Accept: application/json"
```

#### Query Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `was` | string | | Keyword search (job title). Example: "Softwareentwickler" |
| `wo` | string | | Location search. Example: "Berlin" |
| `page` | number | 1 | Result page (starts at 1) |
| `size` | number | 25 | Results per page (1 to 100) |
| `umkreis` | number | 25 | Search radius in km from location |
| `angebotsart` | number | 1 | Offer type: 1=Arbeit, 4=Ausbildung/Duales Studium, 34=Praktikum/Trainee, 2=Selbständigkeit |
| `befristung` | string | | Contract type: "1"=Befristet, "2"=Unbefristet. Multiple values separated by semicolon |
| `arbeitszeit` | string | | Working time: "vz"=Vollzeit, "tz"=Teilzeit, "ho"=Remote, "mj"=Minijob, "snw"=Schicht/Nacht/Wochenende. Multiple values separated by semicolon |
| `arbeitgeber` | string | | Employer name filter. Example: "Deutsche Bahn AG" |
| `berufsfeld` | string | | Occupational field. Example: "Informatik" |
| `veroeffentlichtseit` | number | 30 | Published within last N days (0 to 100) |
| `zeitarbeit` | boolean | true | Include temp agency jobs |
| `behinderung` | boolean | false | Only disability-suitable positions |

#### Example: Remote TypeScript jobs in Berlin, last 7 days

```bash
curl -s "https://rest.arbeitsagentur.de/jobboerse/jobsuche-service/pc/v4/jobs?was=TypeScript&wo=Berlin&arbeitszeit=ho&veroeffentlichtseit=7&size=25" \
  -H "X-API-Key: jobboerse-jobsuche" \
  -H "Accept: application/json"
```

### Get Job Details

`GET /pc/v3/jobdetails/{base64_refnr}`

Retrieve full details of a specific job listing. The reference number (refnr from search results) must be base64-encoded in the URL path.

```bash
# Example: refnr "10000-1184867112-S"
REFNR="10000-1184867112-S"
ENCODED=$(echo -n "$REFNR" | base64)
curl -s "https://rest.arbeitsagentur.de/jobboerse/jobsuche-service/pc/v3/jobdetails/$ENCODED" \
  -H "X-API-Key: jobboerse-jobsuche" \
  -H "Accept: application/json"
```

## Typical Workflow

1. Search for jobs using keyword and location filters.
2. Extract `refnr` from each result in the response.
3. Use the Get endpoint with base64-encoded `refnr` to retrieve full job details.

## API Documentation

Full API docs: https://jobsuche.api.bund.dev/
