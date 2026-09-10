# ~/.config/fish/functions/brew.fish
#
# Обгортка над brew: після успішного install/uninstall синхронізує ~/Brewfile.
#
# Важливо про fish: `set -l` створює змінну, локальну для ПОТОЧНОГО БЛОКУ
# (if / else / for / begin), а не для функції. Тому оголошення всередині
# if-гілки зникає після `end`. Через це в попередній версії $line і $pattern
# були порожні: grep з порожнім патерном збігався з усім (нічого не
# додавалося), а sed "/^/d" видаляв усі рядки Brewfile.

function brew --description 'brew wrapper: auto-syncs installs/uninstalls with ~/Brewfile'
    set -l brewfile "$HOME/Brewfile"
    set -l cmd $argv[1]

    # Усе, крім install/uninstall (та його аліасів), просто прокидуємо далі
    if not contains -- "$cmd" install uninstall remove rm
        command brew $argv
        return $status
    end

    set -l is_cask 0
    set -l dry_run 0
    set -l pkgs

    for arg in $argv[2..-1]
        switch $arg
            case --cask --casks
                set is_cask 1
            case -n --dry-run
                set dry_run 1
            case '-*'
                # решта прапорців (у т.ч. однодефісних) — не пакети
            case '*'
                set -a pkgs $arg
        end
    end

    command brew $argv
    set -l exit_code $status

    # Чіпаємо Brewfile лише після успішної реальної команди
    if test $exit_code -ne 0
        return $exit_code
    end
    if test $dry_run -eq 1; or test (count $pkgs) -eq 0
        return $exit_code
    end

    if not test -f $brewfile
        touch $brewfile
    end

    for pkg in $pkgs
        test -n "$pkg"; or continue

        if test "$cmd" = install
            __brewfile_add $brewfile $pkg $is_cask
        else
            __brewfile_remove $brewfile $pkg
        end
    end

    return $exit_code
end

function __brewfile_add -a brewfile pkg is_cask
    set -l prefix brew

    if test "$is_cask" -eq 1
        set prefix cask
    else if command brew list --cask -1 2>/dev/null | string match -qx -- "$pkg"
        # brew сам розпізнав cask, хоча --cask не передавали
        set prefix cask
    end

    set -l entry "$prefix \"$pkg\""

    if grep -qF -- "$entry" $brewfile
        return 0
    end

    cp $brewfile $brewfile.bak
    echo "$entry" >>$brewfile
    echo "→ Додано в Brewfile: $entry"
end

function __brewfile_remove -a brewfile pkg
    # Пакет уже видалено, тому визначити тип через brew list не вийде —
    # перевіряємо обидва префікси.
    for prefix in brew cask
        set -l entry "$prefix \"$pkg\""

        if not grep -qF -- "$entry" $brewfile
            continue
        end

        # grep -v замість sed: без regex, без різниці BSD/GNU,
        # і патерн гарантовано непорожній.
        set -l tmp (mktemp)
        grep -vF -- "$entry" $brewfile >$tmp

        # Запобіжник: якщо результат порожній, а вихідний файл ні —
        # щось пішло не так, краще не чіпати. Саме цей випадок колись
        # знищив Brewfile повністю.
        if not test -s $tmp; and test -s $brewfile
            echo "⚠ Відмова: результат порожній, Brewfile не змінено"
            rm -f $tmp
            continue
        end

        cp $brewfile $brewfile.bak
        mv $tmp $brewfile
        echo "→ Видалено з Brewfile: $entry"
    end
end
