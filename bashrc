PLATFORM='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  PLATFORM='osx'
elif [[ "$unamestr" == 'Linux' ]]; then
  PLATFORM='linux'
fi

eval "$(rbenv init -)"

source ~/.bash/completions
source ~/.bash/aliases
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/gitprompt
source ~/.bash/functionjunction

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi
