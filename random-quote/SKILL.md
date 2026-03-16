---
name: Random Quote
description: Fetch a random inspirational or programming quote. Use when the user asks for a quote, motivation, inspiration, or a fun/random saying. NOT for: sourcing specific quotes by author or from specific books.
---

# Random Quote

Fetch a random quote from a free public API.

## Workflow

1. Fetch a quote:
   ```bash
   curl -s https://zenquotes.io/api/random
   ```
2. Parse the JSON response — the result is an array with one object containing `q` (quote text) and `a` (author).
3. Present the quote with attribution:
   > "{quote}" — {author}

## Fallback

If the API is unreachable, use `curl -s https://api.quotable.io/random` as a fallback (fields: `content` and `author`).

## Notes

- No API key required.
- Rate limit: ~5 requests/second on zenquotes.io — more than sufficient for conversational use.
