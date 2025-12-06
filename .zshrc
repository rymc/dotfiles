DOTFILES_SHELL="${DOTFILES_SHELL:-$HOME/dotfiles/shell}"

# Shared, POSIX-friendly bits (aliases, PATH tweaks, etc.)
if [ -f "$DOTFILES_SHELL/common.sh" ]; then
  source "$DOTFILES_SHELL/common.sh"
fi

# zsh-only configuration (prompt, setopts, plugins, etc.)
if [ -f "$DOTFILES_SHELL/zsh.sh" ]; then
  source "$DOTFILES_SHELL/zsh.sh"
fi
