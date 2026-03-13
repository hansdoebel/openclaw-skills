# openclaw-skills

A collection of [Claude Code custom skills](https://docs.anthropic.com/en/docs/claude-code/skills) for integrating with external APIs and services.

## Skills

| Skill | Description |
|-------|-------------|
| [jina-ai](./jina-ai/SKILL.md) | Web reading, search, and content extraction powered by Jina AI APIs |
| [qdrant](./qdrant/SKILL.md) | Semantic memory with Qdrant vector database and Jina AI embeddings |

## Usage

Each skill is defined by a `SKILL.md` file that teaches Claude Code how to use the corresponding API via `curl` commands. To use a skill, copy its folder into your project's `.claude/skills/` directory or install it from the registry.

## License

[MIT](./LICENSE)