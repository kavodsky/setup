###############################################################################
# ~/Brewfile
#
# Відновлено з `brew bundle dump --describe` після інциденту зі стиранням.
# Тримати під git. Використання:
#
#   brew bundle          --file=~/Brewfile          # встановити все зі списку
#   brew bundle check    --file=~/Brewfile          # що зі списку ще не стоїть
#   brew bundle cleanup  --file=~/Brewfile --dry-run  # що стоїть, але не в списку
#
# Разова настройка після першого встановлення (brew bundle цього не робить):
#
#   micromamba shell init --shell fish --root-prefix ~/micromamba
#   pixi config append default-channels bioconda
#
# Порядок рядків для brew неважливий — групування суто для людини.
###############################################################################


###############################################################################
# Тапи
###############################################################################

tap "anomalyco/tap"


###############################################################################
# Оболонка та базові CLI-інструменти
# Те, без чого не працює щоденний термінал.
###############################################################################

brew "fish"                 # основна оболонка
brew "starship"             # промпт
brew "tmux"                 # мультиплексор терміналу
brew "direnv"               # автопідвантаження env залежно від $PWD
brew "eza"                  # заміна ls
brew "bat"                  # cat із підсвіткою синтаксису
brew "fzf"                  # інтерактивний нечіткий пошук
brew "ripgrep"              # швидкий grep по деревах
brew "fd"                   # швидкий find зі зрозумілим синтаксисом
brew "zoxide"               # стрибки по каталогах за частотою (z замість cd)
brew "tree"                 # дерево каталогів
brew "jq"                   # обробка JSON у пайпах
brew "yq"                   # те саме для YAML: helm-чарти, k8s-маніфести, CI-конфіги
brew "wget"                 # завантаження файлів


###############################################################################
# GNU-userland
# macOS має BSD-версії утиліт, у яких прапорці розходяться з GNU (`sed -i ''`
# проти `sed -i`, `date -v-1m` проти `date -d`, немає `readlink -f`).
# Дає gsed, gdate, gstat, greadlink, gxargs — з префіксом g, щоб не ламати
# системні скрипти. Щоб писати скрипти однаково локально й у CI, додай у
# config.fish:
#   fish_add_path (brew --prefix coreutils)/libexec/gnubin
#   fish_add_path (brew --prefix gnu-sed)/libexec/gnubin
###############################################################################

brew "coreutils"
brew "gnu-sed"


###############################################################################
# Секрети та шифрування
###############################################################################

brew "age"                  # шифрування файлів
brew "sops"                 # редагування зашифрованих конфігів (працює поверх age)


###############################################################################
# Git та збірка
###############################################################################

brew "git"                  # свіжий git замість системного від Apple
brew "gh"                   # GitHub CLI
brew "git-lfs"              # великі файли в git
brew "git-delta"            # диф із підсвіткою синтаксису; вмикається в ~/.gitconfig:
                            #   [core] pager = delta
                            #   [interactive] diffFilter = delta --color-only
brew "cmake"                # кросплатформна збірка
brew "just"                 # запуск проєктних команд (justfile)
brew "go-task"              # альтернативний таск-раннер (Taskfile.yml)


###############################################################################
# Мови та менеджери пакетів
###############################################################################

brew "uv"                   # Python: пакети, venv, запуск інструментів (тільки PyPI)
brew "pixi", postinstall: "pixi config append default-channels bioconda"
                            # власні проєкти: lockfile для conda + PyPI в одному
                            # маніфесті, середовище в каталозі проєкту
brew "micromamba"           # чужі environment.yml, Nextflow -profile conda;
                            # conda-сумісність без інсталяції самої conda.
                            # Разово: micromamba shell init --shell fish \
                            #           --root-prefix ~/micromamba
brew "rustup"               # тулчейн Rust
brew "openjdk@17"           # JDK для JVM-інструментів
brew "yarn"                 # менеджер пакетів JS
brew "angular-cli"          # генерація та збірка Angular
brew "cocoapods"            # залежності iOS/Cocoa (потрібне для Flutter під iOS)

uv "ruff"                   # лінтер і форматер Python, поставлений через uv


###############################################################################
# Контейнери, Kubernetes, хмара
###############################################################################

brew "colima"               # VM для контейнерів на macOS (заміна Docker Desktop)
brew "docker"               # CLI docker
brew "docker-compose"       # багатоконтейнерні середовища
brew "kubernetes-cli"       # kubectl — без нього helm не працює
brew "helm"                 # пакети Kubernetes
brew "awscli"               # CLI AWS
brew "infracost"            # оцінка вартості Terraform-змін.
                            # Terraform/OpenTofu свідомо не в списку — поки
                            # не потрібні; тоді й infracost без застосування


###############################################################################
# Дані та бази даних
###############################################################################

brew "duckdb"               # аналітична СУБД в одному файлі
brew "pgcli"                # клієнт Postgres з автодоповненням
brew "visidata"             # табличний перегляд/обробка даних у терміналі


###############################################################################
# Біоінформатика
# Робота з послідовностями та варіантами.
###############################################################################

brew "samtools"             # SAM/BAM: NGS-дані
brew "bcftools"             # BCF/VCF: варіанти
brew "seqkit"               # маніпуляції з FASTA/FASTQ
brew "mmseqs2"              # швидкий пошук і кластеризація послідовностей


###############################################################################
# Локальні LLM та AI-інструменти
###############################################################################

brew "ollama", restart_service: :changed   # сервіс перезапускається лише
                            # при оновленні пакета, не при кожному bundle
brew "llama.cpp"            # інференс GGUF напряму
brew "macmon"               # реальне споживання CPU/GPU/ANE та unified memory
                            # під час інференсу; без sudo, Activity Monitor
                            # цих даних не показує
brew "mlx-lm"               # MLX на Apple Silicon: mlx_lm.server (OpenAI-сумісний
                            # ендпоінт), generate, chat, convert, lora
brew "hf"                   # CLI Hugging Face Hub
brew "anomalyco/tap/opencode", trusted: true   # AI-агент для терміналу


###############################################################################
# Документи, текст, OCR
###############################################################################

brew "pandoc"               # конвертація між форматами розмітки
brew "docutils"             # обробка reStructuredText
brew "glow"                 # перегляд markdown у терміналі
brew "poppler"              # утиліти PDF (pdftotext, pdfimages)
brew "xpdf", link: false    # ще один набір утиліт PDF; НЕ лінкується,
                            # бо конфліктує з бінарниками poppler
brew "tesseract"            # OCR


###############################################################################
# Медіа
###############################################################################

brew "ffmpeg"               # конвертація аудіо/відео
brew "yt-dlp"               # завантаження відео
brew "handbrake"            # транскодування відео (CLI)


###############################################################################
# Бібліотеки та рантайми
# Ймовірно, підтягнулися як залежності. Перед видаленням перевірити:
#   brew uses --installed icu4c@76
###############################################################################

brew "icu4c@76"             # Unicode/локалізація
brew "libmagic"             # визначення типів файлів (потрібне для python-magic)
brew "python-tk@3.13"       # Tk для Python GUI (matplotlib TkAgg тощо)


###############################################################################
# Термінал та редактори (GUI)
###############################################################################

cask "iterm2"               # емулятор терміналу
cask "visual-studio-code"
cask "cursor"               # IDE з LLM, основний інструмент реалізації
cask "pycharm-oss"          # Python IDE
cask "claude-code"          # агент кодування


###############################################################################
# Хмара та інфраструктура (GUI/бінарники)
###############################################################################

cask "aws-vault-binary"     # зберігання облікових даних AWS
cask "gcloud-cli"           # CLI Google Cloud
cask "ngrok"                # тунелі до localhost
cask "dbeaver-community"    # універсальний SQL-клієнт


###############################################################################
# Мобільна та фронтенд-розробка
###############################################################################

cask "flutter"              # SDK Flutter (Dart)


###############################################################################
# Браузери та зв'язок
###############################################################################

cask "firefox@developer-edition"
cask "google-chrome"
cask "zoom"


###############################################################################
# Знання, нотатки, навчання
###############################################################################

cask "obsidian"             # база знань у markdown
cask "zotero"               # бібліографія та джерела
cask "calibre"              # бібліотека електронних книжок
cask "freeplane"            # ментальні карти
cask "tldraw"               # редактор .tldr
cask "anki"                 # інтервальні повторення


###############################################################################
# Графіка та медіа (GUI)
###############################################################################

cask "gimp"                 # растровий редактор
cask "krita"                # малювання
cask "audacity"             # аудіоредактор
cask "upscayl"              # апскейл зображень


###############################################################################
# VS Code: Python та Jupyter
###############################################################################

vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.debugpy"
vscode "ms-python.pylint"
vscode "ms-python.isort"
vscode "ms-python.vscode-python-envs"
vscode "kevinrose.vsc-python-indent"
vscode "ms-toolsai.jupyter"
vscode "ms-toolsai.jupyter-keymap"
vscode "ms-toolsai.jupyter-renderers"
vscode "ms-toolsai.vscode-jupyter-cell-tags"
vscode "ms-toolsai.vscode-jupyter-slideshow"


###############################################################################
# VS Code: дані та бази даних
###############################################################################

vscode "cweijan.vscode-postgresql-client2"
vscode "cweijan.dbclient-jdbc"
vscode "adpyke.vscode-sql-formatter"
vscode "dvirtz.parquet-viewer"
vscode "ms-toolsai.datawrangler"
vscode "nextflow.nextflow"          # пайплайни Nextflow (біоінформатика)


###############################################################################
# VS Code: веб і Angular
###############################################################################

vscode "angular.ng-template"
vscode "johnpapa.angular2"
vscode "dsznajder.es7-react-js-snippets"
vscode "xabikos.javascriptsnippets"
vscode "formulahendry.auto-rename-tag"
vscode "esbenp.prettier-vscode"
vscode "ritwickdey.liveserver"


###############################################################################
# VS Code: Flutter і Dart
###############################################################################

vscode "dart-code.dart-code"
vscode "dart-code.flutter"
vscode "nash.awesome-flutter-snippets"
vscode "robert-brunhage.flutter-riverpod-snippets"
vscode "jeroen-meijer.pubspec-assist"


###############################################################################
# VS Code: контейнери, API, збірка
###############################################################################

vscode "ms-azuretools.vscode-docker"
vscode "ms-azuretools.vscode-containers"
vscode "ms-vscode-remote.remote-containers"
vscode "ms-vscode.makefile-tools"
vscode "redhat.vscode-yaml"
vscode "42crunch.vscode-openapi"
vscode "postman.postman-for-vscode"


###############################################################################
# VS Code: документація та розмітка
###############################################################################

vscode "lextudio.restructuredtext"
vscode "trond-snekvik.simple-rst"
vscode "swyddfa.esbonio"            # мовний сервер Sphinx
vscode "chrisjsewell.myst-tml-syntax"
vscode "shd101wyy.markdown-preview-enhanced"
vscode "tehpeng.diagramspreviewer"


###############################################################################
# VS Code: git, AI, зовнішній вигляд
###############################################################################

vscode "eamodio.gitlens"
vscode "anthropic.claude-code"
vscode "moshfeu.compare-folders"
vscode "johnpapa.vscode-peacock"    # колір вікна на проєкт
vscode "pkief.material-icon-theme"
vscode "enkia.tokyo-night"
vscode "yurihs.sublime-vscode-theme"
