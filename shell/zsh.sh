# zsh-specific configuration (sourced from ~/.zshrc)

setopt extendedglob

autoload -Uz compinit
# Only regenerate completion dump once per day
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Syntax highlighting
_zsh_highlighting_candidates=(
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)
for _zsh_highlight in "${_zsh_highlighting_candidates[@]}"; do
  if [ -f "$_zsh_highlight" ]; then
    source "$_zsh_highlight"
    break
  fi
done
unset _zsh_highlighting_candidates _zsh_highlight

# Autosuggestions (optional)
_zsh_autosuggest_candidates=(
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
)
for _zsh_autosuggest in "${_zsh_autosuggest_candidates[@]}"; do
  if [ -f "$_zsh_autosuggest" ]; then
    source "$_zsh_autosuggest"
    break
  fi
done
unset _zsh_autosuggest_candidates _zsh_autosuggest

# VCS info (git branch)
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%b%u%c'
zstyle ':vcs_info:git*' actionformats '%F{14}⏱ %*%f'
zstyle ':vcs_info:git*' unstagedstr '*'
zstyle ':vcs_info:git*' stagedstr '+'
zstyle ':vcs_info:*:*' check-for-changes true
add-zsh-hook precmd vcs_info

# Prompt
PROMPT=$'%F{blue}[%D{%f/%m/%y} %D{%H:%M:%S}]%f [%(?.%F{10}✔︎.%F{9}✘)%f] %~ %F{yellow}${vcs_info_msg_0_}%f\n '
RPROMPT=""

# History
HISTFILE=$HOME/.zhistory
HISTSIZE=50000
SAVEHIST=50000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt appendhistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# Misc options
setopt autocd
setopt autopushd
setopt pushdignoredups
setopt no_beep

if [[ -o interactive && -t 0 ]]; then
  # Keybindings (need an interactive terminal for zle)
  bindkey '^A' beginning-of-line
  bindkey '^E' end-of-line
  bindkey '^B' backward-char
  bindkey '^F' forward-char
  bindkey '^H' backward-delete-char
  bindkey '^D' delete-char
  bindkey '^K' kill-line
  bindkey '^U' backward-kill-line
  bindkey '^W' backward-kill-word
  bindkey '^Y' yank

  # FZF integration
  if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
  fi
fi

# Google Cloud SDK
_gcloud_path_candidates=(
  "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
  "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
  /usr/lib/google-cloud-sdk/path.zsh.inc
  /usr/lib/google-cloud-sdk/completion.zsh.inc
  /snap/google-cloud-sdk/current/path.zsh.inc
  /snap/google-cloud-sdk/current/completion.zsh.inc
)
for _gcloud_file in "${_gcloud_path_candidates[@]}"; do
  case "$_gcloud_file" in
    *path.zsh.inc) [ -f "$_gcloud_file" ] && . "$_gcloud_file" ;;
    *completion.zsh.inc) [ -f "$_gcloud_file" ] && . "$_gcloud_file" ;;
  esac
done
unset _gcloud_path_candidates _gcloud_file

# Nebius CLI
if [ -f "$HOME/.nebius/path.zsh.inc" ]; then
  source "$HOME/.nebius/path.zsh.inc"
fi

# Bun completions
if [ -n "${BUN_INSTALL:-}" ] && [ -s "$BUN_INSTALL/_bun" ]; then
  source "$BUN_INSTALL/_bun"
fi

# Mark SSH sessions in the prompt
if [[ -n "$SSH_CONNECTION" ]]; then
  PROMPT='(SSH) '$PROMPT
fi

# Lazy-load NVM for performance
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    . "/opt/homebrew/opt/nvm/nvm.sh"
  elif [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
  fi
  if [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]; then
    . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  elif [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"
  fi
  nvm "$@"
}
node() { nvm --version >/dev/null 2>&1; unset -f node; node "$@"; }
npm() { nvm --version >/dev/null 2>&1; unset -f npm; npm "$@"; }
npx() { nvm --version >/dev/null 2>&1; unset -f npx; npx "$@"; }
