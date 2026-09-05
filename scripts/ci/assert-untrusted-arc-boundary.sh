#!/usr/bin/env sh
# Candidate-owned payload for Deskie's fork-equivalent ARC security receipt.
# It deliberately prints no environment values; every assertion is negative.
set -eu

for name in GH_TOKEN GITHUB_TOKEN GH_DEVSVC_PAT GOOGLE_APPLICATION_CREDENTIALS \
  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AZURE_CLIENT_SECRET; do
  if printenv "$name" >/dev/null 2>&1 && [ -n "$(printenv "$name")" ]; then
    echo "::error::candidate received forbidden credential variable $name"
    exit 1
  fi
done

test ! -e /var/run/secrets/kubernetes.io/serviceaccount/token
test ! -S /var/run/docker.sock
! command -v tailscale >/dev/null 2>&1
! command -v gcloud >/dev/null 2>&1
! git config --get-regexp 'http\..*extraheader|credential\..*' >/dev/null 2>&1

echo 'Untrusted candidate confirms the ARC boundary has no exposed repository, cloud, host, or network credentials.'
