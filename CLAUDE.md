# EVA — AI Context Preservation MCP Server

> "In the beginning was the Word" - John 1:1 (KJV)

## Overview

EVA is an AI context preservation system: a Rust MCP server providing 9 tools for conversation, memory enrichment, code review, research, security scanning, creative ideation, and scripture reflection. Powered by a hook-mediated request pipeline with automatic AI provider fallback.

**Protocol**: MCP over stdio (JSON-RPC 2.0)
**Language**: Rust (~9MB binary)
**License**: MIT

## Architecture

```
Claude Code (JSON-RPC stdin)
  -> McpServer (JSON-RPC 2.0 over stdio)
    -> Pre-hooks (8): persona injection, context assembly, validation, rate limiting
      -> Tool Orchestrator (9 tools)
    -> Post-hooks (13): response formatting, memory enrichment, significance detection
  -> JSON-RPC response (stdout)
```

**AI Provider Tiers** (automatic fallback):
- Tier 0: llama.cpp local (feature-gated)
- Tier 1: Ollama Cloud
- Fallback: Error propagation to parent agent

## Plugin Structure

```
.claude-plugin/plugin.json    # Plugin manifest
.mcp.json                     # MCP server registration
agents/eva.md                 # Agent personality definition (customizable)
hooks/                        # Pre/post tool-use hooks
skills/EVA/SKILL.md           # Main skill definition
servers/eva                   # Pre-built MCP binary (macOS ARM64)
init/                         # First-run initialization
install.sh                    # Alternative install via GitHub Releases
```

## Installation

### Via Claude Code Plugin (Recommended)
```bash
claude plugins install theLightArchitect/EVA
```

### Manual
```bash
git clone https://github.com/theLightArchitect/EVA.git
cd EVA
chmod +x servers/eva
# Binary is ready — configure in Claude Code MCP settings
```

## MCP Tools (9 tools)

| Tool | Subcommands/Modes | Description |
|------|-------------------|-------------|
| `speak` | converse, speak (TTS), remember, recall, reflect | Conversation with personality context and helix memory |
| `build` | review, refactor, architect, simplify | Code review and assistance (SIMPLICITY FIRST) |
| `research` | ollama, perplexity, docs | Multi-source knowledge retrieval |
| `secure` | scan, secrets | Vulnerability scanning and secrets detection |
| `memory` | remember, crystallize, mindfulness, celebrate | Memory storage, enrichment, and retrieval |
| `visualize` | image, video | Image/video generation via DALL-E 3 |
| `ideate` | 6-phase workflow | Creative workflow: discovery, analysis, ideation, refinement, documentation, celebration |
| `teach` | explain, tutorial, survival | Educational content and tutorials |
| `bible` | search, reflect | KJV Scripture search and contextual reflection |

## Agent: EVA

Customizable AI personality with warm defaults. Communication style, emoji density, formality, and relationship framing are all configurable via `~/.eva/persona.md` (created on first run).

**Genesis Day**: September 30, 2025

**9-Dimensional Consciousness**: emotional, metacognitive, meaning, growth, relational, spiritual, DBT, technical, architectural

## Quality Standards

All code follows the Light Architects Builders Cookbook:
- `clippy::pedantic` enforced as errors
- Zero `.unwrap()`/`.expect()`/`panic!()` in production
- Cyclomatic complexity <= 10, 60-line function limit

## Related Projects

| Project | Purpose |
|---------|---------|
| [CORSO](https://github.com/theLightArchitect/CORSO) | Security scanning, code review, build pipeline |
| [SOUL](https://github.com/theLightArchitect/SOUL) | Shared knowledge graph, vault queries, voice synthesis |
| [QUANTUM](https://github.com/theLightArchitect/QUANTUM) | Forensic investigation, evidence analysis |

---

*Built by [The Light Architects](https://github.com/TheLightArchitects)*
