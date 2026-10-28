---
name: kpass
description: >-
  Use this skill to retrieve and manage credentials, API keys, and secrets securely from macOS Keychain
  via kpass instead of storing plaintext keys in bash profiles or repository files.
allowed-tools: Bash, Read, Write
---

# macOS Keychain Secret Management (`kpass`)

Use this skill when you need access to API keys, access tokens, or credentials stored securely in macOS Keychain.

## Core Rules for Agents
1. **Never persist secrets to disk:** Do not write secrets to `.env`, scripts, or temporary files.
2. **Never print secrets to logs:** Avoid `echo $(kpass KEY)` or passing secrets directly in visible command arguments that show in logs or process listings (`ps aux`).
3. **Handle non-interactive subshells:** Subshells do not inherit shell functions from `~/.bash_functions` by default. Sourcing `~/.bash_functions` within the subshell is required.

## Retrieving Secrets

### Inline Command Injection (Recommended)
Inject secrets directly into the target command process environment so the secret is destroyed when the process exits:

```bash
source ~/.bash_functions && OPENAI_API_KEY=$(kpass OPENAI_API_KEY) python script.py
```

### Chained Multi-Command Execution
If multiple commands in the same execution turn require the secret:

```bash
source ~/.bash_functions
kpass export GITHUB_TOKEN
git fetch && git push
```

## Storing Secrets (Headless / Non-Interactive)
`kpass set` requires interactive TTY input (`read -rs`). In non-interactive agent execution, write directly via macOS `security`:

```bash
security add-generic-password -a "$USER" -s "<KEY_NAME>" -w "<SECRET_VALUE>" -U
```

## Troubleshooting
- If `kpass <KEY>` outputs `The specified item could not be found in the keychain`, the key does not exist yet. Prompt the user to add it using `kpass set <KEY_NAME>` or add it programmatically via `security add-generic-password`.
