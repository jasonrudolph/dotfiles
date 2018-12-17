eval "$(rbenv init -)"

source ~/.bash/functionjunction
source ~/.bash/completions
source ~/.bash/aliases
source ~/.bash/paths
source ~/.bash/config

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

# configure magicmonty/bash-git-prompt
GIT_PROMPT_FETCH_REMOTE_STATUS=0
GIT_PROMPT_SHOW_UNTRACKED_FILES=all
GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0
GIT_PROMPT_THEME=Custom
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="$(brew --prefix)/opt/bash-git-prompt/share"
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Make this lazy 'cause it adds too much slowness to starting a new shell
nvmify() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  true
}
