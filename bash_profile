eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export PATH="$HOME/go/bin:$PATH"
