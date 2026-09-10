#!/usr/bin/env fish
#
# bootstrap.fish — піднімає машину з нуля за вмістом цього репозиторію.
#
#   ./bootstrap.fish             # виконати
#   ./bootstrap.fish --dry-run   # показати, що буде зроблено
#
# Ідемпотентний: повторний запуск нічого не ламає.
# Наявні файли не перезаписує — переносить у *.bak.<дата>.

set -l dry_run 0
contains -- --dry-run $argv; and set dry_run 1

set -l repo (realpath (dirname (status filename)))
set -l stamp (date +%Y%m%d-%H%M%S)
set -l failed 0

function step -a text
    echo ""
    echo "── $text"
end

function run -a desc
    set -l cmd $argv[2..-1]
    if test $dry_run -eq 1
        echo "  [dry-run] $desc"
        return 0
    end
    echo "  $desc"
    $cmd
end

# --- 1. Homebrew -------------------------------------------------------------

step "Homebrew"

if not command -q brew
    echo "  ✗ brew не встановлено. Спершу: https://brew.sh"
    exit 1
end

if test $dry_run -eq 1
    command brew bundle check --file=$repo/Brewfile; or true
else
    command brew bundle install --file=$repo/Brewfile; or set failed 1
end

# --- 2. Симлінки -------------------------------------------------------------
# Формат: джерело_в_репо|призначення

step "Конфіги"

set -l links \
    "gitconfig|$HOME/.gitconfig" \
    "fish/config.fish|$HOME/.config/fish/config.fish" \
    "fish/functions/brew.fish|$HOME/.config/fish/functions/brew.fish" \
    "Brewfile|$HOME/Brewfile"

for pair in $links
    set -l parts (string split '|' $pair)
    set -l src "$repo/$parts[1]"
    set -l dst $parts[2]

    if not test -e $src
        echo "  ⚠ немає в репо: $parts[1] — пропускаю"
        continue
    end

    # вже вказує куди треба
    if test -L $dst; and test (readlink $dst) = $src
        echo "  = $dst"
        continue
    end

    if test $dry_run -eq 1
        test -e $dst; and echo "  [dry-run] $dst → бекап, потім симлінк"
        test -e $dst; or echo "  [dry-run] $dst → симлінк на $parts[1]"
        continue
    end

    mkdir -p (dirname $dst)

    if test -e $dst; or test -L $dst
        mv $dst "$dst.bak.$stamp"
        echo "  → бекап: $dst.bak.$stamp"
    end

    ln -s $src $dst
    echo "  → $dst"
end

# --- 3. Разова ініціалізація -------------------------------------------------
# Те, що симлінком не робиться: команди дописують стан у чужі файли
# або в конфіги інструментів.

step "Ініціалізація інструментів"

# micromamba: дописує блок у config.fish (тому після симлінків)
if command -q micromamba
    if grep -q 'mamba initialize' $HOME/.config/fish/config.fish 2>/dev/null
        echo "  = micromamba вже ініціалізовано"
    else
        run "micromamba shell init" \
            micromamba shell init --shell fish --root-prefix $HOME/micromamba
    end
else
    echo "  ⚠ micromamba не встановлено"
end

# pixi: канал bioconda
if command -q pixi
    if pixi config list default-channels 2>/dev/null | grep -q bioconda
        echo "  = bioconda вже в каналах pixi"
    else
        run "pixi: додаю канал bioconda" \
            pixi config append default-channels bioconda
    end
else
    echo "  ⚠ pixi не встановлено"
end

# --- 4. Секрети --------------------------------------------------------------

step "Секрети"

if security find-generic-password -s uv-publish-token >/dev/null 2>&1
    echo "  = uv-publish-token у Keychain"
else
    echo "  ⚠ немає uv-publish-token. Додати:"
    echo "    security add-generic-password -a (whoami) -s uv-publish-token -w 'ТОКЕН'"
end

# --- Підсумок ----------------------------------------------------------------

echo ""
if test $dry_run -eq 1
    echo "Це був --dry-run, нічого не змінено."
else if test $failed -eq 1
    echo "⚠ Завершено з помилками — дивись вивід brew bundle вище."
    exit 1
else
    echo "Готово. Перезапусти оболонку: exec fish"
end
