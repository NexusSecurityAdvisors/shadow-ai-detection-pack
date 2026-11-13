#!/usr/bin/env bash
# Regenerate KQL (Microsoft Defender XDR) and SPL (Splunk) from the Sigma sources.
# Requires: pip install sigma-cli pysigma-backend-kusto pysigma-backend-splunk
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p rules/kql rules/spl
for rule in rules/sigma/*.yml; do
  name="$(basename "$rule" .yml)"
  sigma convert -t kusto -p microsoft_xdr "$rule" > "rules/kql/${name}.kql" 2> "rules/kql/${name}.err" \
    || echo "KQL: no Defender XDR mapping for ${name} (see rules/kql/${name}.err)"
  sigma convert -t splunk -p splunk_windows "$rule" > "rules/spl/${name}.spl" 2> "rules/spl/${name}.err" \
    || sigma convert -t splunk "$rule" --without-pipeline > "rules/spl/${name}.spl" 2> "rules/spl/${name}.err" \
    || echo "SPL: conversion failed for ${name} (see rules/spl/${name}.err)"
  # Drop progress noise; keep error files only when conversion failed
  for f in "rules/kql/${name}.err" "rules/spl/${name}.err"; do
    grep -qv '^Parsing Sigma rules' "$f" 2>/dev/null || rm -f "$f"
  done
done
echo "DNS and proxy rules have no Defender XDR table mapping; hand-written KQL for them lives in rules/kql/manual_*.kql."
echo "Done. Review every translation before deploying; field names vary by data connector."
