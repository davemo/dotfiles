function fish_prompt
  # save exit status of previous command
  # -l for local variable
  set -l last_status $status

  # the time
  set_color E6E6E6 --background 4C4C4C
  # $() in bash, or backticks, don't need $ for fish
  echo -n (date +" %I:%M %p ")
  set_color --background normal
  # no newline on end
  echo -n ' '

  # the path
  set_color 4C4C4C --background 86D1D7
  echo -n " "(pwd | sed s:$HOME:~:)" "
  set_color --background normal
  echo -n ' '

  # the git shell
  if set -l branch_name (git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1 /')
    set_color 4C4C4C --background A6EBA6
    echo -n $branch_name
    set_color --background normal
  end

  # the prompt depends on the last status
  # normal bash syntax for bash tests with brackets
  if [ $last_status = 0 ]
    echo -n \n"🐠"
  else
    echo -n \n"🍣" # sushi
    # other option: 🎣
  end
  set_color --background normal
  echo -n ' '

end
