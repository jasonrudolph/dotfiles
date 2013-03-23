PLATFORM='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  PLATFORM='osx'
elif [[ "$unamestr" == 'Linux' ]]; then
  PLATFORM='linux'
fi

source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/gitprompt
source ~/.bash/functionjunction

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi
