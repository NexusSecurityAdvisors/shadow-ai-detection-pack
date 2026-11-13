# Hunt: AI browser extensions

**Why:** AI sidebar, writing and summarizer extensions often request "read and change all your data on all websites." That permission lets them read every page a user opens, including internal apps.

## Collect the inventory

| Source | How |
|---|---|
| Chrome Enterprise (Google Admin) | Devices > Chrome > Apps & extensions > Usage: every installed extension, user count and permissions |
| Microsoft Intune / Edge management | Edge extension inventory report |
| Microsoft Defender Vulnerability Management | Browser extensions inventory (Defender portal > Vulnerability management > Inventories > Browser extensions) |
| osquery | `SELECT name, identifier, version, permissions FROM chrome_extensions;` |

## Flag

1. Name or description contains: `AI`, `GPT`, `ChatGPT`, `Claude`, `Gemini`, `Copilot`, `assistant`, `summar`, `writer`, `transcri`.
2. Permissions include `<all_urls>`, `*://*/*`, `tabs`, `scripting`, `webRequest`, `clipboardRead`, or `cookies`.
3. Extensions matching both are first in line for review.

```sql
-- osquery: AI-looking extensions with broad host access
SELECT u.username, e.name, e.identifier, e.version, e.permissions
FROM users u CROSS JOIN chrome_extensions e USING (uid)
WHERE (lower(e.name) LIKE '%ai%' OR lower(e.name) LIKE '%gpt%' OR lower(e.name) LIKE '%copilot%'
       OR lower(e.name) LIKE '%summar%' OR lower(e.name) LIKE '%assistant%')
  AND (e.permissions LIKE '%<all_urls>%' OR e.permissions LIKE '%*://*/*%');
```

The `%ai%` match is noisy (it also hits "mail", "detail"); review by hand.

## Extension ID list

Not included yet: extension IDs change as vendors republish, and an unverified list causes false confidence. Build your own from the inventory above, then enforce with an allow-list (`ExtensionInstallAllowlist`) rather than a block-list.

## Response

Move to an extension allow-list. Approve one AI assistant extension per need, so people have a sanctioned option.
