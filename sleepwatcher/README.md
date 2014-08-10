# Sleepwatcher

This directory contains the configuration and scripts used by [Sleepwatcher](https://github.com/Homebrew/homebrew/blob/bbf83c2203201895dad00b5d8c95db2caeb45409/Library/Formula/sleepwatcher.rb).

## Setup

```sh
brew install sleepwatcher

ln -s ~/.dotfiles/sleepwatcher/de.bernhard-baehr.sleepwatcher.plist \
  ~/Library/LaunchAgents/

launchctl load ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
```
