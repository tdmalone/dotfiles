# shellcheck shell=bash
# shellcheck disable=SC1090 disable=SC1091 disable=SC2034

# Disabled directives:
# https://github.com/koalaman/shellcheck/wiki/SC1090 - we source scripts not in this repo
# https://github.com/koalaman/shellcheck/wiki/SC1091 - we source scripts not in this repo
# https://github.com/koalaman/shellcheck/wiki/SC2034 - not all these settings need exporting

# Ensure tmux (and by extension, Cloud9), works ok with colours.
export TERM="xterm-256color"

# Path to oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set theme.
# @see https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Enables command auto-correction.
ENABLE_CORRECTION="true"

# Displays red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins to load. Add wisely; too many plugins slow down startup.
# @see ~/.oh-my-zsh/plugins
# @see ~/.oh-my-zsh/custom/plugins
plugins=(
  git
)

# Load oh-my-zsh.
source "${ZSH}/oh-my-zsh.sh"

# Load custom aliases and specific environment settings.
source "${HOME}/.env"
source "${HOME}/.aliases"

# Settings added by other packages follow. Usually for shell completion.

# Initialise bash completions.
# @see https://stackoverflow.com/a/27853970/1982136
autoload -U +X bashcompinit && bashcompinit

# iTerm2.
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Travis CI CLI.
[ -f /home/tim/.travis/travis.sh ] && source /home/tim/.travis/travis.sh
[ -f /Users/tim/.travis/travis.sh ] && source /Users/tim/.travis/travis.sh

# Vault.
complete -o nospace -C /usr/local/bin/vault vault
