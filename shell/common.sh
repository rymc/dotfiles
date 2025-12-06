# Shared, POSIX-friendly shell config for zsh and bash.

export CLICOLOR=1
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
export EDITOR=vim

# PNPM (prefer macOS location, fallback to Linux default)
if [ -d "$HOME/Library/pnpm" ]; then
  export PNPM_HOME="$HOME/Library/pnpm"
elif [ -d "$HOME/.local/share/pnpm" ]; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
if [ -n "${PNPM_HOME:-}" ]; then
  case ":$PATH:" in *":$PNPM_HOME:"*) ;; *) PATH="$PNPM_HOME:$PATH" ;; esac
fi

# Common PATH additions
PATH="$HOME/.local/bin:$PATH"
PATH="$PATH:$HOME/.lmstudio/bin"
PATH="$PATH:$HOME/.codeium/windsurf/bin"
PATH="$PATH:$HOME/.antigravity/antigravity/bin"

# Cargo (adds ~/.cargo/bin to PATH if installed)
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Local env overrides (if you use ~/.local/bin/env to export secrets/paths)
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

# Bun (if installed)
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  PATH="$BUN_INSTALL/bin:$PATH"
fi

alias aie='aichat -e'

# eza/exa as ls replacement (if present)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first --long'
  alias la='eza --icons --group-directories-first --long --all'
  alias lt='eza --icons --tree --level=2'
elif command -v exa >/dev/null 2>&1; then
  alias ls='exa --icons --group-directories-first --long'
fi

# Disable terminal flow control when interactive so Ctrl+S works
if command -v stty >/dev/null 2>&1 && [ -t 0 ]; then
  stty -ixon
fi

# Ghostty wants this TERM override
if [ "${TERM_PROGRAM:-}" = "ghostty" ]; then
  export TERM=xterm-256color
fi
