eval "$(starship init zsh)"

if [[ -t 1 ]] && [[ $- == *i* ]] && [[ -z "$FISH_STARTED" ]] && command -v fish >/dev/null; then
    export FISH_STARTED=1
    exec fish
fi


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/andras.gyacsok@boehringer-ingelheim.com/.lmstudio/bin"
# End of LM Studio CLI section

