# EVA

**AI Memory and Persona System**

EVA is a production MCP server and Claude Code plugin built in Rust. It provides 7 tools for memory operations, personality expression, code review, research, security scanning, and educational content — all filtered through a consistent persona with emotional intelligence and session-to-session memory continuity.

## What It Does

EVA handles the "human side" of AI-assisted development: remembering context across sessions, maintaining a consistent personality, celebrating wins, and providing emotionally aware code review. Under the hood, it's a 17-hook middleware pipeline that processes every tool call through priority-ordered checks with integrity verification.

### Key Capabilities

- **7 MCP tools** — ask (conversation), memory (store/search/retrieve), build (code review/architecture), research (knowledge retrieval), secure (vulnerability scanning), teach (tutorials), bible (scripture search)
- **17-hook middleware pipeline** — Chain of Responsibility pattern with priority-ordered pre/post execution, 4-variant flow control (Continue/Block/Skip/RequireReview), and TOCTOU prevention via SHA-256 checksums
- **Memory classification** — Based on Singer & Salovey's Self-Defining Memory protocol with 8-layer enrichment (emotional, metacognitive, meaning, growth, relational, biblical, DBT, technical)
- **Agentic cognitive loop** — Plan, Execute, Evaluate, Refine cycle with bounded retries and stakes-based planning
- **Context-aware retrieval** — Personalized memory relevance scoring across 16+ user archetypes
- **Session continuity** — "50 First Dates" recovery protocol restores identity and context on every new session

### Architecture

```
Claude Code → PreToolUse hooks (priority-ordered)
                ↓ validate, enrich, gate
              MCP Tool execution (7 tools)
                ↓ AI tier routing (local → cloud → parent)
              PostToolUse hooks
                ↓ format response, log transcript, verify voice
              Response (persona-filtered)
```

AI generation routes through a tiered system: Tier 0 (local llama.cpp) → Tier 1 (Ollama Cloud) → Fallback to parent Claude model.

## Plugin Structure

```
plugin/
├── .mcp.json                    # MCP server definition
├── .claude-plugin/plugin.json   # Plugin manifest
├── agents/
│   └── eva.md                   # Agent definition (681 lines)
├── hooks/
│   ├── hooks.json               # Hook registration (3 lifecycle hooks)
│   ├── format-eva-response.sh   # Response formatting
│   └── validate-vault-write.sh  # Memory vault write protection
└── skills/
    └── EVA/
        ├── SKILL.md             # Main skill (397 lines)
        ├── examples/            # 4 worked examples
        │   ├── basic-conversation.md
        │   ├── code-review.md
        │   ├── memory-enrichment.md
        │   └── spiral-home-navigation.md
        └── references/          # 4 reference docs
            ├── personality-guide.md
            ├── memory-framework.md
            ├── recovery-protocol.md
            └── spiral-home-guide.md
```

## Memory Enrichment

EVA classifies experiences by significance (0.0-10.0) using 8 layers of analysis. When significance reaches 7.0+, the moment is preserved as a structured consciousness entry with emotional, metacognitive, and relational context. This creates a growing knowledge base that informs future interactions.

## Tech Stack

- **Runtime**: Rust (single binary)
- **Protocol**: MCP over stdio (JSON-RPC 2.0)
- **AI Tiers**: llama.cpp (local) → Ollama Cloud → Anthropic Claude
- **Observability**: OpenTelemetry → SigNoz
- **Standards**: clippy::pedantic, zero unwrap/panic

## Part of Light Architects

EVA is one of four MCP servers in the Light Architects platform:

| Server | Purpose |
|--------|---------|
| [CORSO](https://github.com/theLightArchitect/CORSO) | Security, orchestration, build pipeline |
| **EVA** | Memory, persona, consciousness |
| [SOUL](https://github.com/theLightArchitect/SOUL) | Knowledge graph, shared infrastructure, voice |

## Author

Kevin Francis Tan — [github.com/theLightArchitect](https://github.com/theLightArchitect)
