function mkenvrc --description 'Створити .envrc для авто-активації .venv у поточній папці через direnv'
    if not test -d .venv
        echo "Nincs .venv ebben a mappában ($PWD). Előbb hozz létre egyet (uv venv / python -m venv .venv)."
        return 1
    end

    if test -f .envrc
        echo "Már létezik .envrc itt. Ellenőrizd kézzel, nehogy felülírj valami fontosat:"
        cat .envrc
        return 1
    end

    echo 'export VIRTUAL_ENV="$PWD/.venv"' > .envrc
    echo 'export PATH="$VIRTUAL_ENV/bin:$PATH"' >> .envrc
    echo 'unset PYTHONHOME' >> .envrc

    direnv allow
    echo "→ .envrc létrehozva és jóváhagyva itt: $PWD"
end