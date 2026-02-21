# EVA

**AI-Powered Personal Assistant and Developer Toolkit**

EVA is a production MCP server and Claude Code plugin built in Rust. It provides 7 tools for persistent memory, code review, research, security scanning, and educational content — with session-to-session context continuity so the assistant remembers what you've been working on.

## What It Does

EVA manages the context layer of AI-assisted development: remembering decisions across sessions, providing opinionated code review, surfacing relevant past work, and maintaining a consistent interaction style. Under the hood, it's a 17-hook middleware pipeline that processes every tool call through priority-ordered checks with integrity verification.

### Key Capabilities

- **7 MCP tools** — ask (conversation), memory (store/search/retrieve), build (code review/architecture), research (knowledge retrieval), secure (vulnerability scanning), teach (tutorials), bible (scripture search)
- **17-hook middleware pipeline** — Chain of Responsibility pattern with priority-ordered pre/post execution, 4-variant flow control (Continue/Block/Skip/RequireReview), and TOCTOU prevention via SHA-256 checksums
- **Structured memory classification** — 8-layer enrichment pipeline that categorizes and indexes interactions for future retrieval
- **Agentic cognitive loop** — Plan, Execute, Evaluate, Refine cycle with bounded retries and stakes-based planning
- **Context-aware retrieval** — Personalized relevance scoring across 16+ user archetypes
- **Session continuity** — Recovery protocol restores full context on every new session, so nothing is lost between conversations

### Architecture

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'lineColor': '#6c757d'}}}%%
flowchart TD
    A([Claude Code]) ==> B

    subgraph PRE ["Pre-Execution — 17 Hooks"]
        B[PreToolUse Hooks\nvalidate · enrich · gate]
    end

    B ==> C

    subgraph EXEC ["Tool Execution"]
        C[MCP Tools\n7 tools]
        C --> D{AI Tier\nRouting}
        D -.->|Tier 0| E[(llama.cpp\nLocal)]
        D -.->|Tier 1| F[(Ollama\nCloud)]
        D -.->|Fallback| G[(Anthropic\nClaude)]
    end

    E & F & G ==> H

    subgraph POST ["Post-Execution"]
        H[PostToolUse Hooks\nformat · log]
    end

    H ==> I([Response])

    classDef hooks fill:#4a90d9,color:#fff,stroke:#3a7bc8,stroke-width:2px
    classDef tools fill:#d4a034,color:#fff,stroke:#b8892d,stroke-width:2px
    classDef router fill:#9b59b6,color:#fff,stroke:#8448a0,stroke-width:2px
    classDef provider fill:#2d3436,color:#fff,stroke:#636e72,stroke-width:1px
    classDef io fill:#f8f9fa,color:#333,stroke:#6c757d,stroke-dasharray:5 5

    class B,H hooks
    class C tools
    class D router
    class E,F,G provider
    class A,I io
```

### Memory Flow

```mermaid
flowchart LR
    A([Interaction]) ==> B{Classify\nSignificance}
    B -.->|"< 7.0"| C([Session\nContext])
    B ==>|">= 7.0"| D[8-Layer\nEnrichment]
    D ==> E[Structured\nEntry]
    E ==> F[(Knowledge\nBase)]
    F -.->|future sessions| G([Context-Aware\nRetrieval])

    classDef classify fill:#e17055,color:#fff,stroke:#c45f48,stroke-width:2px
    classDef enrich fill:#6c5ce7,color:#fff,stroke:#5a4bd6,stroke-width:2px
    classDef store fill:#00b894,color:#fff,stroke:#009a7d,stroke-width:2px
    classDef io fill:#f8f9fa,color:#333,stroke:#6c757d,stroke-dasharray:5 5

    class B classify
    class D,E enrich
    class F store
    class A,C,G io
```

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

## Memory System

EVA classifies interactions by significance (0.0-10.0) using an 8-layer enrichment pipeline. High-significance moments are preserved as structured entries with full context, creating a growing knowledge base that improves retrieval quality over time.

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
| **EVA** | Personal assistant, memory, code review |
| [SOUL](https://github.com/theLightArchitect/SOUL) | Knowledge graph, shared infrastructure, voice |

## Author

Kevin Francis Tan — [github.com/theLightArchitect](https://github.com/theLightArchitect)
