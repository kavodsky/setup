###############################################################################
# ~/.config/fish/config.fish
###############################################################################

# --- PATH -------------------------------------------------------------------
# fish_add_path замість `set -gx PATH $PATH ...`: не дублює записи при
# вкладених оболонках і не залежить від порядку виконання.

fish_add_path $HOME/.lmstudio/bin

# GNU-утиліти без префікса g (щоб `sed -i` і `date -d` працювали як у CI).
# Розкоментуй після встановлення coreutils і gnu-sed:
# fish_add_path (brew --prefix coreutils)/libexec/gnubin
# fish_add_path (brew --prefix gnu-sed)/libexec/gnubin


# --- Інтерактивна оболонка ---------------------------------------------------
# Ці хуки потрібні лише в інтерактивному режимі. Без перевірки вони
# виконуються й у скриптах, сповільнюючи кожен виклик `fish -c`.

if status is-interactive
    starship init fish | source
    direnv hook fish | source
    zoxide init fish | source
    fzf --fish | source

    # Привітання угорською замість дефолтного
    set fish_greeting "Üdvözöllek! A fish shell készen áll."
end


# --- Аліаси ------------------------------------------------------------------

# швидкий бекап поточної папки з тими ж виключеннями
alias tarhere='tar --exclude-from="$HOME/.tarignore" -czvf (basename (pwd)).tar.gz .'

# перевірка перед архівуванням — що саме потрапить
alias tarcheck='tar --exclude-from="$HOME/.tarignore" -tvf'

# brew: синхронізація системи з Brewfile.
# УВАГА: `cleanup --force` ВИДАЛЯЄ все, чого немає у Brewfile.
# Спершу завжди дивись, що саме піде під ніж.
alias brewcheck='brew bundle cleanup --file="$HOME/Brewfile"'
alias brewup='brew bundle install --file="$HOME/Brewfile"'


# --- Секрети -----------------------------------------------------------------
# Токени в цьому файлі не тримаємо: він іде в git і читається будь-яким
# процесом. Зберігати в Keychain:
#
#   security add-generic-password -a (whoami) -s uv-publish-token -w 'НОВИЙ_ТОКЕН'
#
# Далі токен підтягується лише тоді, коли справді потрібен:

function uv-publish --description 'uv publish з токеном із Keychain'
    set -lx UV_PUBLISH_TOKEN (security find-generic-password -s uv-publish-token -w 2>/dev/null)
    if test -z "$UV_PUBLISH_TOKEN"
        echo "Немає uv-publish-token у Keychain" >&2
        return 1
    end
    uv publish $argv
end


# --- Python ------------------------------------------------------------------
# Автоматична активація venv при запуску в PyCharm

if test -n "$VIRTUAL_ENV"; and test -f "$VIRTUAL_ENV/bin/activate.fish"
    source "$VIRTUAL_ENV/bin/activate.fish"
end


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
# Перевірка наявності бінарника: без неї видалений micromamba дає помилку
# при кожному старті оболонки.
set -gx MAMBA_EXE "/opt/homebrew/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "$HOME/micromamba"
if test -x "$MAMBA_EXE"
    $MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
end
# <<< mamba initialize <<<
