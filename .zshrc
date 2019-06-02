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
# NOTE: This will need to be disabled if you want to make custom changes to PS1.
# @see https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#POWERLEVEL9K_MODE="awesome-fontconfig" # TODO: These 'bonus' fonts don't appear to work :(
ZSH_THEME="powerlevel9k/powerlevel9k"

# Customise powerlevel9k prompt - if powerlevel9k theme is activated above.
# @see https://github.com/bhilburn/powerlevel9k#prompt-customization
#POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# if [ $(tput cols) -gt 100 ]; then
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vcs         custom_aws kubecontext newline dir custom_dollarsign)
# else
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vcs newline custom_aws kubecontext newline dir custom_dollarsign)
# fi
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time history time)
POWERLEVEL9K_CUSTOM_AWS="tdm_aws_context"
POWERLEVEL9K_CUSTOM_AWS_BACKGROUND="150"
POWERLEVEL9K_CUSTOM_DOLLARSIGN="echo \$"
#POWERLEVEL9K_CUSTOM_DOLLARSIGN_BACKGROUND="yellow"
POWERLEVEL9K_SHOW_CHANGESET="true"
#POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

tdm_aws_context() {

  cache_file="${HOME}/.zshrc_tdm_aws_context.$$"
  cache_toleration="$(( 5 * 60 ))" # How long can the cache be out of date for?
  now="$( date +%s )"

  if [ -f "${cache_file}" ]; then
    cache_modified="$( date -r "${cache_file}" +%s)"
    if grep --extended-regexp '(min|sec)' "${cache_file}" > /dev/null; then
      cache_toleration="60" # Refresh the cache every minute if we're below an hour.
    fi
    if [ "${cache_modified}" -gt "$(( now - cache_toleration ))" ]; then
      cat "${cache_file}"
      return
    fi
  fi

  # No AWS profile in use?
  if [ "${AWS_PROFILE:-}" = "" ]; then

    if [ "${AWS_ACCESS_KEY_ID:-}" != "" ]; then
      # We have a raw AWS access key; print that out.
      result="${AWS_ACCESS_KEY_ID}"
    else
      default_access_key_id="$( aws configure get default.aws_access_key_id )"
      if [ "${default_access_key_id}" != "" ]; then
        # The default profile has an access key, so print the default profile name.
        result="default"
      fi
    fi

  else

    # Looks like we have an AWS profile set, so we'll attempt to show any MFA expiry details (as per
    # the place aws-mfa stores them in), along with the profile name.

    mfa_expiry_date="$( aws configure get "${AWS_PROFILE}.expiration" )"
    mfa_expiry_warning_threshold="$(( 30 * 60 ))" # Make the prompt a bit noisy.

    if [ "${mfa_expiry_date:-}" != "" ]; then
      mfa_expiry_timestamp="$( date -ujf "%Y-%m-%d %H:%M:%S" "${mfa_expiry_date}" +%s )"
      mfa_expiry_from_now="$(( mfa_expiry_timestamp - $( date +%s ) ))"
      mfa_expiry_seconds="${mfa_expiry_from_now}"
      mfa_suffix="sec"

      # This is some funky stuff here. Bash doesn't do math on decimals, so we're pretending we have
      # whole numbers by multiplying by ten... working out if we're half way or not (-ge 5 on the
      # last digit), before adding 10 if we are, and dividing by 10 to remove the 'fake decimal'.
      # This allows us to effectively 'round up' and be a bit more 'friendly' with our output.
      if [ "${mfa_expiry_from_now}" -ge 60 ]; then
        mfa_expiry_from_now="$(( 10 * mfa_expiry_from_now / 60 ))"
        if [ "${mfa_expiry_from_now: -1}" -ge 5 ]; then
          mfa_expiry_from_now="$(( mfa_expiry_from_now + 10 ))"
        fi
        mfa_expiry_from_now="$(( mfa_expiry_from_now / 10 ))"
        mfa_suffix="min"
        if [ "${mfa_expiry_from_now}" -ge 60 ]; then
          mfa_expiry_from_now="$(( 10 * mfa_expiry_from_now / 60 ))"
          if [ "${mfa_expiry_from_now: -1}" -ge 5 ]; then
            mfa_expiry_from_now="$(( mfa_expiry_from_now + 10 ))"
          fi
          mfa_expiry_from_now="$(( mfa_expiry_from_now / 10 ))"
          mfa_suffix="hr"
        fi
      fi

      if [ "${mfa_expiry_from_now}" != "1" ]; then
        mfa_suffix="${mfa_suffix}s"
      fi

      if [ "${mfa_expiry_seconds}" -le 0 ]; then
        mfa_expiry=" (EXPIRED)"
        state_color='%K{1}' # red - aka alert!
      elif [ "${mfa_expiry_seconds}" -lt "${mfa_expiry_warning_threshold}" ]; then
        mfa_expiry=" (EXPIRING IN ${mfa_expiry_from_now:-} ${mfa_suffix:u})"
        state_color='%K{220}' # yellow - aka warning
      else
        mfa_expiry=" (${mfa_expiry_from_now:-} ${mfa_suffix:-})"
      fi
    fi

    profile_name="${AWS_PROFILE}"
    assumed_role="$( aws configure get "${profile_name}.assumed_role_arn" )"

    if [ "${assumed_role}" != "" ]; then
      assumed_role_account_no="${assumed_role}"
      assumed_role_account_no="${assumed_role_account_no/arn:aws:iam::/}"
      assumed_role_account_no="${assumed_role_account_no/%:*/}"
      profile_name="${profile_name}-${assumed_role_account_no}"
    fi

    result="${profile_name}${mfa_expiry:-}"
    result="%{$state_color%}${profile_name}${mfa_expiry:-}"
  fi

  # Save to cache, and output it now (with a tiny 'cache update' marker).
  echo "${result:-}" > "${cache_file}"
  if [ "${result}" != "" ]; then
    echo -n "• "
  fi
  echo "${result:-}"

} # tdm_aws_context

# Enables command auto-correction.
ENABLE_CORRECTION="true"

# Displays red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins to load. Add wisely; too many plugins slow down startup.
# TODO: These plugins appear to add aliases - probably wise to look into those aliases before just
#       dumping them in!
# @see ~/.oh-my-zsh/plugins
# @see ~/.oh-my-zsh/custom/plugins
plugins=(
  #git
  #kubectl
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

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/tim/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/tim/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/tim/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/tim/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh
complete -o nospace -C /usr/local/bin/terraform terraform

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tim/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tim/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tim/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tim/google-cloud-sdk/completion.zsh.inc'; fi

# Enable kube-ps1.
# @see https://github.com/jonmosco/kube-ps1
# source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
# PS1='$(kube_ps1) %~ # '

PATH="${PATH}:/Users/tim/Library/Python/3.7/bin"
