PLATFORM='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  PLATFORM='osx'
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

# Workaround issue with RVM and Vim.
#
# Some Vim plugins (e.g., vim-preview) require that various Ruby gems are
# installed (e.g., bluecloth). Those gems are installed in the system Ruby
# installation. If you launch Vim when using a different Ruby version, Vim
# crashes when you try to use the plugin functionality that depends on the
# gem.
#
# Solution: Define Vim wrappers which unset GEM_HOME and GEM_PATH before
# invoking vim or any of its known aliases.
#
# @author Wael Nasreddine <wael.nasreddine@gmail.com>
#
# Credit: https://github.com/carlhuda/janus/wiki/Rvm/eed9b87
function wrap_vim_commands() {
  vim_commands=(
    eview evim gview gvim gvimdiff gvimtutor rgview
    rgvim rview rvim vim vimdiff vimtutor xxd mvim
  )

  for cmd in ${vim_commands[@]}; do
    cmd_path=`/usr/bin/env which "${cmd}" 2>/dev/null | grep '^/'`
    if [ -x "${cmd_path}" ]; then
      eval "function ${cmd} () { (unset GEM_HOME; unset GEM_PATH; $cmd_path \$@) }"
    fi
  done
}

wrap_vim_commands

# Added for rvm
# =============
# Place the folowing line at the end of your bash_profile after all PATH/variable settings:
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"
