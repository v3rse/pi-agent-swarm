---
name: deep-research
description: "Run a disciplined multi-step deep research workflow — search from multiple angles, fetch full content from top sources, and synthesize a structured report with cited sources and permalinks. Use when the user says 'research X', 'deep dive on Y', 'comprehensive overview of Z', 'investigate W', or asks for a report on any topic. NOT for quick factual lookups — use a single web_search for those."
---

# Deep Research

Synthesize across many sources to produce evidence-backed, well-cited research reports. Every claim gets a permalink. No shortcut steps.

## Execution Model

Pi executes tool calls sequentially, even when you emit multiple calls in one turn. Batch independent calls in a single turn to save LLM round-trips (~5-10s each). Use these patterns:

| Pattern | When | Actually parallel? |
|---------|------|-------------------|
| Batch `web_search` with `queries: [...]` | Multiple search angles | Yes (provider-level) |
| `fetch_content({ urls: [...] })` | Multiple URLs to fetch | Yes (3 concurrent) |

## Step 1: Plan the Search

Before any tool call, define your search angles. A good deep research uses 3-4 varied queries — different phrasing, different scopes, different question types:

| Angle type | Example |
|------------|---------|
| **Overview** | "current state of X technology 2025" |
| **Comparison** | "X vs Y tradeoffs performance" |
| **Deep-dive** | "X internals architecture design decisions" |
| **Ecosystem/context** | "X community adoption packages alternatives" |
| **Recent/critical** | "X latest release breaking changes" (add recencyFilter) |

Cover at least 3 of these. Never run the same query with slightly different words — that wastes tokens for redundant results.

## Step 2: Broad Search

Batch all angles in one turn:

```
web_search({
  queries: ["angle 1", "angle 2", "angle 3", "angle 4"],
  includeContent: true,
  recencyFilter: "year"  // unless the topic requires fresher
})
```

The response is a synthesized summary with source citations. Do NOT call this Step 2 "complete" — the summary is a starting point, not the deliverable. You haven't read the sources yet.

For technical/code topics, also run in the same turn:

```
code_search({ query: "X library API usage examples" })
```

## Step 3: Deep-Dive Sources

From the search results, identify the 3-5 most authoritative, in-depth sources. Prioritize:

1. **Official docs / release notes** — primary sources
2. **In-depth technical articles** — comprehensive analysis
3. **GitHub repos / RFCs / proposals** — raw implementation detail
4. **Recent benchmarks / research papers** — data-backed claims
5. **Community consensus threads** — collective wisdom, but verify

Fetch them in one batch:

```
fetch_content({ urls: [bestSource1, bestSource2, bestSource3] })
```

## Step 4: Synthesize the Report

Now produce the final report. Structure:

```
## [Topic] — Research Report

### Key Findings
- 3-5 bullet points with the most important discoveries
- Each backed by a source linked below

### Detailed Analysis
[Organized by theme or angle. Every claim gets an inline citation.]

### Caveats & Limitations
- What the research didn't cover
- Conflicting information between sources
- Recency concerns (e.g., "Source X is from 2024, pre-dates Y change")

### Sources
- [Title](URL) — brief note on why this source matters
```

## Quality Rules

- **Every factual claim** gets a citation. No "it is believed" or "many say" without a source link.
- **Mark conflicts** explicitly: "Source A says X, but Source B argues Y" — don't silently pick a winner.
- **Note recency**: "As of June 2025..."
- **Acknowledge gaps**: "I did not find authoritative sources on Z; the claims above are from community threads and should be verified."
- **No lazy synthesis**: If 2 of your 4 search queries returned weak results, say so. Don't pad.
- **Permalinks only**: Use commit-SHA GitHub links, not branch links. For non-GitHub sources, use the most stable URL available.

## When NOT to Use This

- **Quick fact lookup** — use a single `web_search` instead
- **Code implementation question** — use `code_search` + `fetch_content` to read the repo
- **"What's new in X"** — single `web_search` with `recencyFilter: "week"` is usually enough
- **The user already gave you sources** — just `fetch_content` them, don't re-search

## Cost Awareness

- `includeContent: true` costs more but is essential for deep research — you can't cite what you haven't read
- `recencyFilter` reduces cost by limiting scope
- 4 queries × 5 results with content ≈ $0.02-$0.05 on Exa. Worth it for a proper report.
- Don't run deep research speculatively — the user must explicitly ask for it
