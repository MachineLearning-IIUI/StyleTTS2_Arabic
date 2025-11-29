#!/bin/bash

# Set your Hugging Face repo and token
REPO_ID="blits-ai/style_tts2_finetune_Duaa_v2"
LOCAL_FOLDER="style_tts2/Models/FineTune.AudioBook"
HF_TOKEN="${HUGGINGFACE_TOKEN:?Please set HUGGINGFACE_TOKEN environment variable}"

# Check if checkpoint file is provided as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <checkpoint_file>"
    echo "Example: $0 epoch_00025.pth"
    echo ""
    echo "Available checkpoint files:"
    ls -1 "$LOCAL_FOLDER"/*.pth 2>/dev/null || echo "No .pth files found in $LOCAL_FOLDER"
    exit 1
fi

CHECKPOINT_FILE="$LOCAL_FOLDER/$1"

# Check if the file exists
if [ ! -f "$CHECKPOINT_FILE" ]; then
    echo "Error: File $CHECKPOINT_FILE not found"
    echo ""
    echo "Available checkpoint files:"
    ls -1 "$LOCAL_FOLDER"/*.pth 2>/dev/null || echo "No .pth files found in $LOCAL_FOLDER"
    exit 1
fi

echo "Uploading checkpoint: $CHECKPOINT_FILE"

# Install huggingface_hub CLI if not present
if ! command -v huggingface-cli &> /dev/null; then
    pip install huggingface_hub
fi

# Create the repo if it doesn't exist
poetry run huggingface-cli repo create "$REPO_ID" --type=model --token "$HF_TOKEN" --yes

# Upload the file using the CLI
poetry run huggingface-cli upload "$REPO_ID" "$CHECKPOINT_FILE" --token "$HF_TOKEN" --repo-type model

echo "Upload complete."