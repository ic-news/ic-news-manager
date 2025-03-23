#!/bin/bash

# Configuration variables
dfx identity use default
DEFAULT_PRINCIPAL="$(dfx identity get-principal)"

dfx identity use ic-news
MANAGER_PRINCIPAL="$(dfx identity get-principal)"

CANISTER_ID="cpmcr-yeaaa-aaaaa-qaala-cai"

# Check if DFX is running
if ! pgrep -f "dfx start" > /dev/null; then
    echo "DFX is not running. Starting DFX in the background..."
    dfx start --background
fi


# Test cases
echo "=== Testing Admin Management ==="

echo "1. Adding a manager..."
dfx canister call $CANISTER_ID add_manager "(principal \"$DEFAULT_PRINCIPAL\")"

echo "2. Listing managers..."
dfx canister call $CANISTER_ID list_managers

echo "3. Use default identity..."
dfx identity use default

echo "=== Testing Language Operations ==="

echo "4. Creating a single language (English)..."
dfx canister call $CANISTER_ID create_language '("English", "en", "US", true)'

echo "5. Querying the language (English)..."
dfx canister call $CANISTER_ID get_language '("English")'

echo "6. Creating languages in batch (Spanish and French)..."
dfx canister call $CANISTER_ID create_languages '(vec { record {"Spanish"; "es"; "ES"; true}; record {"French"; "fr"; "FR"; false} })'  # Remove opt

echo "7. Querying the language (Spanish)..."
dfx canister call $CANISTER_ID get_language '("Spanish")'

echo "8. Deleting the language (English)..."
dfx canister call $CANISTER_ID delete_language '("English")'

echo "9. Querying the deleted language (English, should be null)..."
dfx canister call $CANISTER_ID get_language '("English")'

echo "10. Listing all languages (all)..."
dfx canister call $CANISTER_ID get_languages '(null)'

echo "11. Listing all enabled languages..."
dfx canister call $CANISTER_ID get_languages '(opt true)'

echo "=== Testing Channel Operations ==="

echo "12. Creating a single channel (news_en on telegram)..."
dfx canister call $CANISTER_ID create_channel '("news_en", "telegram", true)'

echo "14. Creating channels in batch (news_es on x, news_fr on telegram)..."
dfx canister call $CANISTER_ID create_channels '(vec { record {"news_es"; "x"; true}; record {"news_fr"; "telegram"; false} })'

echo "16. Deleting the channel (news_en on telegram)..."
dfx canister call $CANISTER_ID delete_channel '("news_en", "telegram")'
dfx canister call $CANISTER_ID delete_channel '("news_es", "x")'

echo "18. Testing invalid platform (should fail)..."
dfx canister call $CANISTER_ID create_channel '("news_test", "invalid", true)'

echo "19. Listing all channels (all)..."
dfx canister call $CANISTER_ID get_channels '(null)'

echo "20. Listing all telegram channels..."
dfx canister call $CANISTER_ID get_channels '(opt "telegram")'

echo "Use ic-news identity..."
dfx identity use ic-news

echo "21. Removing the manager..."
dfx canister call $CANISTER_ID remove_manager "(principal \"$DEFAULT_PRINCIPAL\")"

echo "22. Listing managers again (should be empty)..."
dfx canister call $CANISTER_ID list_managers

echo "=== Testing Language Operations ==="

echo "23. Creating a single language (English)..."
dfx canister call $CANISTER_ID create_language '("English", "en", "US", true)' 

echo "24. Querying the language (English)..."
dfx canister call $CANISTER_ID get_language '("English")'

echo "25. Creating languages in batch (Spanish and French)..."
dfx canister call $CANISTER_ID create_languages '(vec { record {"Spanish"; "es"; "ES"; true}; record {"French"; "fr"; "FR"; false} })'  # Remove opt

echo "25. Querying the language (Spanish)..."
dfx canister call $CANISTER_ID get_language '("Spanish")'

echo "26. Deleting the language (English)..."
dfx canister call $CANISTER_ID delete_language '("English")'

echo "27. Querying the deleted language (English, should be null)..."
dfx canister call $CANISTER_ID get_language '("English")'

echo "28. Listing all languages (all)..."
dfx canister call $CANISTER_ID get_languages '(null)'

echo "29. Listing all enabled languages..."
dfx canister call $CANISTER_ID get_languages '(opt true)'

echo "=== Testing Channel Operations ==="

echo "30. Creating a single channel (news_en on telegram)..."
dfx canister call $CANISTER_ID create_channel '("news_en", "telegram", true)'

echo "32. Creating channels in batch (news_es on x, news_fr on telegram)..."
dfx canister call $CANISTER_ID create_channels '(vec { record {"news_es"; "x"; true}; record {"news_fr"; "telegram"; false} })'

echo "34. Deleting the channel (news_en on telegram)..."
dfx canister call $CANISTER_ID delete_channel '("news_en", "telegram")'
dfx canister call $CANISTER_ID delete_channel '("news_es", "x")'

echo "36. Testing invalid platform (should fail)..."
dfx canister call $CANISTER_ID create_channel '("news_test", "invalid", true)'

echo "37. Listing all channels (all)..."
dfx canister call $CANISTER_ID get_channels '(null)'

echo "38. Listing all telegram channels..."
dfx canister call $CANISTER_ID get_channels '(opt "telegram")'

echo "=== Testing Completed ==="

dfx identity use default
dfx canister call $CANISTER_ID list_managers