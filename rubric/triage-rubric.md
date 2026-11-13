# Shadow AI Triage Rubric

Score each finding on three questions. Multiply. Act on the highest scores first.

## 1. Data sensitivity: what could reach the tool?

| Score | Meaning | Examples |
|---|---|---|
| 1 | Public or low | Marketing copy, public docs, generic questions |
| 2 | Internal | Internal processes, non-sensitive code, meeting notes without client detail |
| 3 | Regulated or secret | Customer PII, PHI, CUI / export-controlled data, credentials, source code with secrets, M&A, legal matters |

## 2. Access: what can the tool reach on its own?

| Score | Meaning | Examples |
|---|---|---|
| 1 | Only what a user pastes | Web chat with no integrations |
| 2 | One app or data store | An extension on specific sites, a single-repo coding assistant, a Slack app in one channel |
| 3 | Broad, persistent access | OAuth grant to mail and files, extension on all sites, API key with org-wide scope, meeting bot on every call |

## 3. Autonomy: can it act without a human?

| Score | Meaning | Examples |
|---|---|---|
| 1 | Answers only | Chat, summarization on request |
| 2 | Acts with approval | Drafts emails or code a human sends or merges |
| 3 | Acts on its own | Agents that send, delete, purchase, commit or change settings; scheduled automations |

## Score and response

| Score (1–27) | Tier | Response | Target time |
|---|---|---|---|
| 1–4 | Low | Record in the AI inventory. Offer the sanctioned alternative. | 30 days |
| 6–9 | Medium | Talk to the user and their manager. Review the tool's data-use terms. Approve with conditions or migrate. | 2 weeks |
| 12–18 | High | Restrict now: revoke the OAuth grant, block the extension, rotate exposed keys. Then find the business need. | 48 hours |
| 27 | Critical | Treat as a potential incident. Scope what data left, preserve logs, follow the IR plan. | Same day |

Any finding that scores 3 on data sensitivity **and** shows evidence data was actually sent (large upload, secret detected) moves up one tier.

## Rules of thumb

- Most findings land in Low. That is the point: it frees time for the few High ones.
- Never block without a sanctioned option ready. Blocking alone moves use to phones and personal accounts.
- Record every decision. The inventory is your evidence for NIST AI RMF GOVERN 1.6 and ISO/IEC 42001.

## Leadership metrics (monthly)

1. **Coverage:** share of users and devices covered by at least one detection source.
2. **Findings by tier:** count of High and Critical, and the trend.
3. **Time to resolve High findings.**
4. **Sanctioned adoption:** share of AI use going to approved tools.
