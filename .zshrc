
# This file only contains my differences from the default .zshrc.

# Ensure tmux (and by extension, Cloud9), works ok with colours.
export TERM="xterm-256color"

# Set name of the theme to load.
# @ee https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

# Use oh-my-zsh, of course.
source $ZSH/oh-my-zsh.sh

# Use common alias and environment variable definitions in each shell.
# For a full list of active aliases, run `alias`.
source ~/.aliases
source ~/.env

# Initialize Z (https://github.com/rupa/z).
source ~/z.sh
