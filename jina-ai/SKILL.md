---
slug: jina-ai
name: Jina AI
description: Web reading, search, and content extraction powered by Jina AI APIs
license: MIT-0
---

# Jina AI

Use Jina AI APIs for web reading, search, and content extraction. All requests require the `JINA_API_KEY` environment variable.

## Tools

### Read a URL

Extract clean markdown content from any web page.

```bash
curl -s https://r.jina.ai/ \
  -H "Authorization: Bearer $JINA_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "X-Return-Format: markdown" \
  -d '{"url": "URL_HERE"}'
```

Optional headers:
- `X-Return-Format`: `markdown` (default), `html`, `text`, `screenshot`
- `X-Timeout`: timeout in seconds (default 30)

### Search the Web

Search for current information.

```bash
curl -s https://s.jina.ai/ \
  -H "Authorization: Bearer $JINA_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"q": "QUERY_HERE"}'
```

Optional parameters:
- `num`: number of results (default 5)
- `gl`: country code (e.g. `de`, `us`)
- `hl`: language code (e.g. `de`, `en`)
- `page`: pagination

### Rerank Documents

Rerank a list of documents by relevance to a query.

```bash
curl -s https://api.jina.ai/v1/rerank \
  -H "Authorization: Bearer $JINA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "jina-reranker-v3",
    "query": "QUERY_HERE",
    "documents": ["doc1", "doc2", "doc3"],
    "top_n": 3
  }'
```

### Generate Embeddings

Generate text embeddings for semantic search or similarity.

```bash
curl -s https://api.jina.ai/v1/embeddings \
  -H "Authorization: Bearer $JINA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "jina-embeddings-v5-text-nano",
    "input": ["text to embed"]
  }'
```

Models: `jina-embeddings-v5-text-nano`, `jina-embeddings-v5-text-small`, `jina-embeddings-v4`, `jina-embeddings-v3`.

## Usage Notes

- The read and search tools are the most commonly useful. Prefer them for general web lookups.
- All endpoints return JSON. Parse the response to extract the relevant content.
- Some endpoints work without an API key but with strict rate limits.
- For academic papers, use the search tool with site-specific queries (e.g. `site:arxiv.org`).
