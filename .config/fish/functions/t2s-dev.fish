function t2s-dev --description 'Run SimpleTTS (Streamlit, dev mode with auto-reload)'
    pushd /Users/andras/Projects/T2S/simple-tts
    uv run streamlit run main.py --server.runOnSave true
    popd
end
