---
slug: qdrant
name: Qdrant
description: Semantic memory with Qdrant vector database — store and search text using Jina AI embeddings
license: MIT-0
---

# Qdrant

Semantic memory using Qdrant Cloud for vector storage and Jina AI for embeddings. Store text by meaning and find it later with natural language queries.

Requires environment variables:
- `QDRANT_URL` — Qdrant Cloud REST endpoint
- `QDRANT_API_KEY` — Qdrant Cloud API key
- `JINA_API_KEY` — Jina AI API key (for embeddings)

Default collection name: `openclaw`. Default embedding model: `jina-embeddings-v3` (1024 dimensions).

## Store Text

Two-step process: embed with Jina, then upsert to Qdrant.

**Step 1 — Generate embedding:**

```bash
curl -s https://api.jina.ai/v1/embeddings \
  -H "Authorization: Bearer $JINA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "jina-embeddings-v3",
    "input": ["TEXT_TO_STORE"]
  }'
```

Extract the vector with `jq '.data[0].embedding'`.

**Step 2 — Upsert to Qdrant:**

```bash
curl -s "$QDRANT_URL/collections/openclaw/points" \
  -H "api-key: $QDRANT_API_KEY" \
  -H "Content-Type: application/json" \
  -X PUT \
  -d "{
    \"points\": [{
      \"id\": \"$(uuidgen | tr '[:upper:]' '[:lower:]')\",
      \"vector\": EMBEDDING_ARRAY,
      \"payload\": {
        \"text\": \"THE_ORIGINAL_TEXT\",
        \"source\": \"where-this-came-from\",
        \"created_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"
      }
    }]
  }"
```

## Find Similar Text

Two-step process: embed the query with Jina, then search Qdrant.

**Step 1 — Embed the query** (same as above, with your search query as input).

**Step 2 — Search Qdrant:**

```bash
curl -s "$QDRANT_URL/collections/openclaw/points/search" \
  -H "api-key: $QDRANT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "vector": QUERY_EMBEDDING,
    "limit": 5,
    "with_payload": true
  }'
```

Results include `score` (similarity, 0-1) and `payload.text`.

## List Collections

```bash
curl -s "$QDRANT_URL/collections" \
  -H "api-key: $QDRANT_API_KEY"
```

## Create Collection

Create before first use. Vector size must match the embedding model (1024 for jina-embeddings-v3).

```bash
curl -s "$QDRANT_URL/collections/openclaw" \
  -H "api-key: $QDRANT_API_KEY" \
  -H "Content-Type: application/json" \
  -X PUT \
  -d '{
    "vectors": {
      "size": 1024,
      "distance": "Cosine"
    }
  }'
```

## Get Collection Info

```bash
curl -s "$QDRANT_URL/collections/openclaw" \
  -H "api-key: $QDRANT_API_KEY"
```

## Count Points

```bash
curl -s "$QDRANT_URL/collections/openclaw/points/count" \
  -H "api-key: $QDRANT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"exact": true}'
```

## Delete Points

```bash
curl -s "$QDRANT_URL/collections/openclaw/points/delete" \
  -H "api-key: $QDRANT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"points": ["point-id-1", "point-id-2"]}'
```

## Delete Collection

```bash
curl -s "$QDRANT_URL/collections/COLLECTION_NAME" \
  -H "api-key: $QDRANT_API_KEY" \
  -X DELETE
```

## Usage Notes

- Always create the collection before storing points. Check with list collections first.
- Use `jq` to extract embeddings: `curl ... | jq '.data[0].embedding'`.
- For filtered search, add `"filter"` to the search body. Example: `"filter": {"must": [{"key": "source", "match": {"value": "notes"}}]}`.
- Payload fields can store any JSON — use them for metadata like tags, source, type.
