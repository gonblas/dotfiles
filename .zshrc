# Define the plugins directory
ZSH_PLUGINS_DIR=/usr/share/zsh/plugins/
ZDOTDIR=$HOME/.zsh

# Default programs
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export READER="zathura"
export VIDEO_PLAYER="vlc"

# History settings
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Load aliases from an external file
[[ -f $HOME/.config/.aliasrc ]] && source $HOME/.config/.aliasrc

# Function to clone repositories if they don't exist and source plugins
ensure_plugins() {
  typeset -a plugins
  plugins=(
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh-history-substring-search"
    "zsh-you-should-use"
  )

  # Iterate over the plugins array and source the appropriate file if it exists
  for plugin in "${plugins[@]}"; do
    if [[ -f "$ZSH_PLUGINS_DIR/$plugin/${plugin}.zsh" ]]; then
      source "$ZSH_PLUGINS_DIR/$plugin/${plugin}.zsh"
    elif [[ -f "$ZSH_PLUGINS_DIR/$plugin/${plugin}.plugin.zsh" ]]; then
      source "$ZSH_PLUGINS_DIR/$plugin/${plugin}.plugin.zsh"
    else
      # Attempt to source a file with 'zsh-' removed from the plugin name
      alternative_file="${plugin#zsh-}.zsh"
      if [[ -f "$ZSH_PLUGINS_DIR/$plugin/$alternative_file" ]]; then
        source "$ZSH_PLUGINS_DIR/$plugin/$alternative_file"
      fi
    fi
  done
}

ensure_plugins


# Hystory substring search options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# Disable the default prompt and load Starship and Zoxide
# prompt off
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

unsetopt PROMPT_SP


# Entr settings
echo ~/.zshrc | entr -r source ~/.zshrc &



# Colors for man pages

export LESS_TERMCAP_mb=$'\e[01;31m'   # Red (Flamingo)
export LESS_TERMCAP_md=$'\e[01;34m'   # Blue (Sapphire)
export LESS_TERMCAP_me=$'\e[0m'        # Reset
export LESS_TERMCAP_so=$'\e[01;33m'   # Yellow (Peach)
export LESS_TERMCAP_se=$'\e[0m'        # Reset
export LESS_TERMCAP_us=$'\e[04;36m'   # Cyan (Teal)
export LESS_TERMCAP_ue=$'\e[0m'        # Reset

