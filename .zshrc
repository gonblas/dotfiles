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
    "you-should-use"
  )

  # Iterate over the plugins array and source the appropriate file if it exists
  for plugin in "${plugins[@]}"; do
    if [[ -f "$ZSH_PLUGINS_DIR/$plugin/${plugin}.zsh" ]]; then
      source "$ZSH_PLUGINS_DIR/$plugin/${plugin}.zsh"
    elif [[ -f "$ZSH_PLUGINS_DIR/$plugin/${plugin}.plugin.zsh" ]]; then
      source "$ZSH_PLUGINS_DIR/$plugin/${plugin}.plugin.zsh"
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

