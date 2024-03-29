eval "$(rbenv init -)"

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

source ~/.bash/config
source ~/.bash/functionjunction
source ~/.bash/completions
source ~/.bash/aliases
source ~/.bash/paths

# configure magicmonty/bash-git-prompt
GIT_PROMPT_FETCH_REMOTE_STATUS=0
GIT_PROMPT_SHOW_UNTRACKED_FILES=all
GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0
GIT_PROMPT_THEME=Custom
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="$(brew --prefix)/opt/bash-git-prompt/share"
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
