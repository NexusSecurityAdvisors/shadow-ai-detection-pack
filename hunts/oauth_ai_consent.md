# Hunt: OAuth consent grants to AI apps and agents

**Why:** Personal AI assistants, note-takers and agents ask users to "Sign in with Microsoft/Google" and grant access to mail, calendar and files. One consent gives a third party ongoing access with no browser traffic to see. This is the shadow AI with the most reach (OWASP LLM06 Excessive Agency).

## Microsoft Entra ID (Sentinel / Log Analytics)

```kql
let ai_keywords = dynamic(["gpt","openai","claude","anthropic","gemini","copilot","otter","fireflies",
  "fathom","read.ai","tldv","perplexity","assistant","agent","notetaker","note taker","ai "]);
AuditLogs
| where TimeGenerated > ago(90d)
| where OperationName == "Consent to application"
| extend AppName = tostring(TargetResources[0].displayName),
         User = tostring(InitiatedBy.user.userPrincipalName),
         Permissions = tostring(TargetResources[0].modifiedProperties)
| where AppName has_any (ai_keywords)
| summarize Consents = count(), Users = make_set(User, 50), FirstSeen = min(TimeGenerated)
    by AppName, Permissions
| order by Consents desc
```

High-risk scopes to look for in `Permissions`: `Mail.Read`, `Mail.ReadWrite`, `Mail.Send`, `Files.Read.All`, `Calendars.ReadWrite`, `OnlineMeetings.Read`, `offline_access` (long-lived refresh tokens).

To list what is already granted, regardless of when, review **Entra ID > Enterprise applications > User consent** or export `oauth2PermissionGrants` from Microsoft Graph.

## Google Workspace

Admin console > **Security > API controls > Manage third-party app access** lists every app users have authorized, with scopes. For log-based hunting, the OAuth token audit events (`authorize`) carry the app name and scopes.

```spl
index=gworkspace sourcetype="gws:reports:token" event.name=authorize
| search app_name IN ("*GPT*","*OpenAI*","*Claude*","*Gemini*","*Otter*","*Fireflies*","*Fathom*","*Read AI*","*tl;dv*","*Perplexity*")
| stats count dc(actor.email) as users values(scope) as scopes by app_name
| sort - users
```

Index and field names depend on your Google Workspace add-on; adjust to match.

## Response

- Revoke grants to unsanctioned apps holding mail or file scopes.
- Turn on admin consent workflow (Entra) or restrict third-party access to trusted apps (Workspace) so the next grant comes to you first.
