# this file is the equivalent of ~/.bash_profile
if status is-interactive

  # skip the fish greeting
  set fish_greeting

  # things in terminal.app that we changed
  # option as meta key

  # nodenv things
  export PATH="$HOME/bin:$PATH"
  export PATH="$HOME/.nodenv/bin:$PATH"
  export PATH="$HOME/.nodenv/shims:$PATH"
  export PATH="$HOME/.pyenv/bin:$PATH"
  export PATH="$HOME/.pyenv/shims:$PATH"
  set -x NODENV_SHELL fish

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

  alias tt terminal_title
  alias e subl
end