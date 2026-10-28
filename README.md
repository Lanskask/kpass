# kpass

A small shell function that wraps the macOS Keychain `security` tool with a
[`pass`](https://www.passwordstore.org/)-like interface. Keep API keys and tokens in the Keychain instead of plaintext
in your shell profile or `.env` files.

macOS only (it uses `security` and `pbcopy`). Works in zsh and bash.

## Install

Source `kpass.sh` from your shell startup file, or copy it into `~/.bash_functions` (which the agent skill below
expects):

```bash
echo 'source /path/to/kpass/kpass.sh' >> ~/.zshrc
```

## Usage

| Command                 | What it does                                                                     |
|-------------------------|----------------------------------------------------------------------------------|
| `kpass set KEY_NAME`    | Prompt for a value (hidden input) and save it to the Keychain; updates if exists |
| `kpass KEY_NAME`        | Print the value                                                                  |
| `kpass copy KEY_NAME`   | Copy the value to the clipboard without a trailing newline                       |
| `kpass export KEY_NAME` | Export the value as the environment variable `KEY_NAME` in the current shell     |
| `kpass`                 | Print the short help                                                             |

Secrets are stored as generic passwords with the account set to `$USER` and the service set to `KEY_NAME`.

Pass a secret to a single command without leaving it in your shell environment:

```bash
OPENAI_API_KEY=$(kpass OPENAI_API_KEY) python script.py
```

## Agent skill

`SKILL.md` is a Claude Code skill that tells an agent to read secrets through `kpass` and never write them to disk or
logs. Copy or symlink this directory into `~/.claude/skills/kpass` to use it.
