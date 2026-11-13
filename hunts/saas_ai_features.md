# Hunt: AI features switched on inside sanctioned SaaS

**Why:** The fastest-growing shadow AI is not a new tool. It is an AI feature that a vendor enabled by default inside a tool you already approved. No new domain, no new app, no consent prompt.

## Where to look

| Platform | Check |
|---|---|
| Zoom | Admin > Account settings > AI Companion: meeting summaries, smart recording, who can turn it on |
| Microsoft Teams / 365 | Copilot licensing, Teams meeting transcription and recap policies, third-party bot apps allowed in meetings |
| Google Workspace | Gemini for Workspace settings per organizational unit; Meet transcripts and "take notes for me" |
| Slack | Slack AI features and third-party AI apps installed in the workspace |
| Salesforce, HubSpot, Notion, Atlassian, Box, Dropbox | AI assistant toggles and data-use terms in each admin console |
| Zoom / Teams / Meet | Bots joining meetings (participant names like "Notetaker", "Otter", "Fireflies", "Read.ai") |

## Log-based checks

- **Admin audit logs:** search for setting changes containing `AI`, `Copilot`, `Gemini`, `Companion`, `assistant`, `summary`, `transcript`.
- **Meeting participant logs:** look for recurring participants whose display name contains a note-taker brand or "AI". Example for Microsoft Teams call records exported to Sentinel:

```kql
// Adjust table and field names to your Teams / call-records connector
CallRecords_CL
| where TimeGenerated > ago(30d)
| mv-expand Participant = todynamic(participants_s)
| extend Name = tolower(tostring(Participant.displayName))
| where Name has_any ("notetaker","otter","fireflies","fathom","read.ai","tldv","ai assistant")
| summarize Meetings = dcount(id_s) by Name
| order by Meetings desc
```

## Response

Decide per feature: approve with a data-use review, restrict to a pilot group, or turn off. Record the decision in your AI inventory (NIST AI RMF GOVERN 1.6).
