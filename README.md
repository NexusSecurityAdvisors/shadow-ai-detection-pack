# Shadow AI Detection Pack

Find shadow AI with the logs you already collect. Vendor-neutral detection content for security teams: Sigma rules with KQL and SPL translations, a starter list of AI service domains, hunting queries for OAuth grants and SaaS audit logs, and a one-page triage rubric.

Companion material for the talk *"You Already Have Shadow AI: Finding It With the Logs You Already Own."*

> **Status: v0.1 draft (November 2026). Not yet tested against production telemetry.** Rules are written to Sigma's standard taxonomy and converted with sigma-cli. Expect to tune field names and thresholds for your environment.

## What's inside

| Path | What it is |
|---|---|
| `domains/ai-services.csv` | Starter list of AI service domains, tagged by category (chat, API, coding assistant, note-taker, model hub) |
| `rules/sigma/` | Sigma rules: DNS, proxy, process creation, network connection, file events |
| `rules/kql/` | Microsoft Defender XDR / Sentinel translations, plus hand-written Entra ID consent hunts |
| `rules/spl/` | Splunk translations |
| `hunts/` | Hunting queries that don't fit Sigma well: OAuth consent grants, SaaS AI feature settings, expense data, browser extensions |
| `secrets/` | Gitleaks-style patterns for AI provider API keys in repos and scripts |
| `rubric/triage-rubric.md` | One-page rubric: data sensitivity × access × autonomy |
| `scripts/convert.sh` | Regenerates KQL and SPL from the Sigma sources |

## Coverage map

| Data source | Detects | Rule |
|---|---|---|
| DNS (Sysmon EID 22, resolver logs) | Lookups of AI chat, API and note-taker services | `rules/sigma/dns_ai_service_lookup.yml` |
| Web proxy / SWG | Large uploads to AI services | `rules/sigma/proxy_ai_large_upload.yml` |
| Web proxy / SWG | Direct API calls to AI providers | `rules/sigma/proxy_ai_api_call.yml` |
| EDR process creation | Local model runtimes (Ollama, LM Studio, llama.cpp, KoboldCpp, Jan) | `rules/sigma/proc_local_llm_runtime.yml` |
| EDR network connection | Non-browser processes calling AI APIs (scripts, unsanctioned apps, agents) | `rules/sigma/net_ai_api_non_browser.yml` |
| EDR file events | Model weight files written to disk | `rules/sigma/file_model_weights_written.yml` |
| Entra ID / Google Workspace | OAuth consent grants to AI apps and agents | `hunts/oauth_ai_consent.md` |
| SaaS admin audit logs | Embedded AI features switched on | `hunts/saas_ai_features.md` |
| Browser management | AI extensions and risky permissions | `hunts/browser_extensions.md` |
| Code repos | AI provider API keys | `secrets/ai-provider-keys.toml` |
| Expense / procurement | Paid AI seats on personal or corporate cards | `hunts/expense_data.md` |

## Framework mapping

- **OWASP Top 10 for LLM Applications 2025:** LLM02 Sensitive Information Disclosure, LLM06 Excessive Agency
- **MITRE ATLAS:** exfiltration via ML inference API; LLM data leakage
- **NIST AI RMF:** GOVERN 1.6 (inventory of AI systems), MAP 1.1 and MAP 4.1
- **ISO/IEC 42001:** A.4 (resources for AI systems), A.6 inventory and lifecycle controls
- **NIST CSF 2.0:** ID.AM-02 (software and services inventory), DE.CM (continuous monitoring)

Verify control numbers against the current versions of each framework before citing them in audit material.

## How to use it

1. Start with the DNS rule. It has the widest coverage and the fewest dependencies.
2. Run the hunts for 30 days of history before alerting on anything. Shadow AI is a baseline problem first, an alerting problem second.
3. Score what you find with the triage rubric. Most findings are low risk; spend your time on the few that combine sensitive data, broad access and autonomy.
4. Offer a sanctioned alternative before blocking. Blocking without one moves usage to phones and personal accounts.

## Regenerating translations

```bash
pip install sigma-cli pysigma-backend-kusto pysigma-backend-splunk
./scripts/convert.sh
```

## Contributing

Pull requests welcome, especially new domains (with a source), false-positive notes, and translations for other SIEMs.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE). Use, modify and redistribute freely, including commercially; keep the NOTICE file and credit in redistributions.

Maintained by Dan Sorensen, [Nexus Security Advisors](https://nexussecurityadvisors.com).
