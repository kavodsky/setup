function t2s --description 'Run SimpleTTS (Streamlit)'
    pushd /Users/andras/Projects/T2S/simple-tts
    uv run streamlit run main.py
    popd
end
