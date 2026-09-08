starship init fish | source

# direnv hook
direnv hook fish | source

# Привітання угорською замість дефолтного
set fish_greeting "Üdvözöllek! A fish shell készen áll."


# ALIACES: start

# швидкий бекап поточної папки з тими ж виключеннями
alias tarhere='tar --exclude-from="$HOME/.tarignore" -czvf (basename (pwd)).tar.gz .'

# перевірка перед архівуванням — що саме потрапить
alias tarcheck='tar --exclude-from="$HOME/.tarignore" -tvf'

# brew: швидкий цикл cleanup + install за твоїм Brewfile
alias brewup='brew bundle cleanup --file="$HOME/Brewfile" --force && brew bundle install --file="$HOME/Brewfile"'

# ALIACES: end


# ENV VARS: start

set -gx UV_PUBLISH_TOKEN "pypi-AgEIcHlwaS5vcmcCKB4r7yU10x_Y-DUMMY-UPDATE-THIS-TOKEN"

# ENV VARS: end

# Автоматична активація venv при запуску в PyCharm
if test -n "$VIRTUAL_ENV"
    if test -f "$VIRTUAL_ENV/bin/activate.fish"
        source "$VIRTUAL_ENV/bin/activate.fish"
    end
end

