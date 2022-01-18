# this file is the equivalent of ~/.bash_profile
if status is-interactive

  # skip the fish greeting
  set fish_greeting

  # Have `tree` colour directories yellowish
  set -gx LS_COLORS 'di=33'

  # Bat (a better cat) https://github.com/sharkdp/bat
  set -gx BAT_THEME TwoDark

  # Homebrew
  eval (/opt/homebrew/bin/brew shellenv)
  set -gx HOMEBREW_AUTO_UPDATE_SECS (echo '60 * 60 * 24 * 7' | bc)

  # things in terminal.app that we changed
  # option as meta key

  # nodenv things
  export PATH="$HOME/bin:$PATH"
  export PATH="$HOME/.nodenv/bin:$PATH"
  export PATH="$HOME/.nodenv/shims:$PATH"
  export PATH="$HOME/.pyenv/bin:$PATH"
  export PATH="$HOME/.pyenv/shims:$PATH"
  export PATH="$HOME/.rbenv/bin:$PATH"
  export PATH="$HOME/.rbenv/shims:$PATH"

  set -x NODENV_SHELL fish
  set -x PYENV_SHELL fish
  set -x RBENV_SHELL fish

  function nodenv
    set command $argv[1]
    set -e argv[1]
    switch "$command"
    case rehash shell update
      source (nodenv "sh-$command" $argv|psub)
    case '*'
      command nodenv "$command" $argv
    end
  end

  # Utils to set terminal.app tab titles
  set -g my_term_title fish

  function terminal_title
    set -g my_term_title $argv[1]
  end

  function fish_title
    echo $my_term_title
  end

  # aliases
  alias tt "terminal_title"
  alias e "subl"
  alias ls "exa --icons"
  alias ll "exa -lah --icons"
  alias dc "docker-compose"
  alias cat "bat"
  alias be "bundle exec"
  alias gg "git grep"
  alias tree "exa --icons --tree -L2"
  alias rmnm "find . -name 'node_modules' -exec rm -rf '{}' +"
  alias rmpl "find . -name 'package-lock.json' -exec rm -f '{}' +"
  alias gitflush "git branch --merged master | grep -v master | xargs git branch -d && git remote prune origin"
end
