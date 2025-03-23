#!/bin/bash

# Configuration
CANISTER_ID="ibz7e-kqaaa-aaaag-at63a-cai"
NETWORK="ic" # If deploying to mainnet, change to "ic"
DFX_CALL="dfx canister call $CANISTER_ID"
IDENTITY="ic-news"

# Check if DFX is running (local network)
if [ "$NETWORK" == "local" ]; then
    if ! pgrep -f "dfx start" > /dev/null; then
        echo "DFX is not running. Starting DFX in the background..."
        dfx start --background
    fi
fi

# Set identity
dfx identity use "$IDENTITY"
echo "Using identity: $(dfx identity whoami)"

# If using mainnet, add --network ic
if [ "$NETWORK" == "ic" ]; then
    DFX_CALL="$DFX_CALL --network ic"
fi

# RSS list
RSS_LIST=(
    "https://rss.panewslab.com/en/tvsq/rss"
    "https://rss.panewslab.com/en/gtimg/rss"
    "https://cointelegraph.com/rss"
    "https://cointelegraph.com/editors_pick_rss"
    "https://coingape.com/feed/"
    "https://decrypt.co/feed"
    "https://feeds.libsyn.com/247424/rss"
)

# Initialize RSS
echo "Initializing RSS feeds..."
for rss_url in "${RSS_LIST[@]}"; do
    # Extract name from URL (based on domain or path)
    name=$(echo "$rss_url" | awk -F'/' '{print $3}' | cut -d'.' -f1)
    if [ -z "$name" ]; then
        name="rss_$RANDOM" # If extraction fails, use random name
    fi

    # Call create_rss, using correct tuple syntax
    echo "Adding RSS: $name -> $rss_url"
    $DFX_CALL create_rss "(record { \"$name\"; \"$rss_url\"; true })"
done

echo "RSS initialization completed."