#!/bin/bash

# Default values
NETWORK="local"
CANISTER_ID=""

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --canister) CANISTER_ID="$2"; shift ;;
        --network) NETWORK="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Check if Canister ID is provided
if [ -z "$CANISTER_ID" ]; then
    echo "Error: Please provide a Canister ID using --canister <CANISTER_ID>"
    echo "Usage: $0 --canister <CANISTER_ID> [--network local|ic]"
    exit 1
fi

# Check if network parameter is valid
if [ "$NETWORK" != "local" ] && [ "$NETWORK" != "ic" ]; then
    echo "Error: Invalid network. Use 'local' or 'ic'."
    echo "Usage: $0 --canister <CANISTER_ID> [--network local|ic]"
    exit 1
fi

# Force using ic-news identity
dfx identity use ic-news
echo "Using identity: $(dfx identity whoami)"

# Check if DFX is running (only applicable for local network)
if [ "$NETWORK" == "local" ]; then
    if ! pgrep -f "dfx start" > /dev/null; then
        echo "DFX is not running. Starting DFX in the background..."
        dfx start --background
    fi
fi

# Set dfx command parameters based on network
DFX_CALL="dfx canister call $CANISTER_ID"
if [ "$NETWORK" == "ic" ]; then
    DFX_CALL="$DFX_CALL --network ic"
fi

# Initialize Telegram channels
echo "Initializing Telegram Channels..."
TG_CHANNELS=(
    "BWEnews" "WatcherGuru" "followin_zh" "theblockbeats" "SolidIntelX" "jinse2017" "chaincatcher" "fenchacaij" "Odaily_News" "wublock" "foresightnews" "TechFlowDaily" "fionasdailynews" "telonews_cn" "MMSnews" "cointime_cn" "cointime_en" "bitpush" "jinsecaijinpingdao" "HuaErJie1" "abmedia_news" "blocktemponews" "ChannelPANews" "chainfeedsxyz" "SoSoValue_CN" "toncoin" "bimi_chs" "binance_announcements" "Bybit_Announcements" "bitgetcn_announcement" "dabingyitai" "cryptoquant_alert" "cexmonitor" "whale_alert_io" "onecryptofeed" "observers_com" "newsbtcofficial" "blockworks_news" "cryptoslatenews" "utoday_en" "the_block_crypto" "cryptonews_official" "bitcoinistnews" "CryptoPotato" "cointelegraph" "news_crypto" "Fin_Watch" "cryptobullet" "Coin_Signals" "ClayTrading" "CTMarkets" "thenewscrypto" "crypto_dot_news" "www_Bitcoin_com" "dlnewsinfo" "CoinDeskGlobal" "unfolded" "coinedition" "TreeNewsFeed" "cookiesreads" "bitcoin"
)

TG_BATCH=""
for channel in "${TG_CHANNELS[@]}"; do
    EXISTS=$($DFX_CALL get_channels '(opt "telegram")' | grep "name = \"$channel\"")
    if [ -z "$EXISTS" ]; then
        TG_BATCH="$TG_BATCH record {\"$channel\"; \"telegram\"; true};"
    else
        echo "Skipping $channel (telegram) - already exists"
    fi
done
if [ -n "$TG_BATCH" ]; then
    $DFX_CALL create_channels "(vec { $TG_BATCH })"
else
    echo "All Telegram channels already exist"
fi

# Initialize X channels
echo "Initializing X Channels..."
X_CHANNELS=(
    "dfinity" "lendfinity_xyz" "ICPSwap" "ICExplorer_io" "ICPSquad" "IcProvenance" "cryptocloudsicp" "ICPandaDAO" "AndaICP" "memefunicp" "tacodaoicp" "ICPTokens" "ICP_Updates" "dieter_icp" "ND64_ICP" "realclownicp" "icphub_BG" "ICPExchange" "dominic_w" "OpenChat" "dfinitydev" "sayitkind" "_geekfactory" "icstats" "elementumone" "yral_app" "shillgatesy" "blockchainpill" "icsneed" "kylelangham" "icpagent" "canistore" "real0xjason" "JesseThaGreat_" "Personal_dao" "odin_godofrunes" "bobbodily" "alexandria_lbry" "fuel_ev" "nfididentitykit" "identitymaxis" "andaicp" "fomowellcomdot" "nfidwallet" "alicedotfun" "aaaaa_agent_ai" "jancamenisch" "av8cado" "icpsquad" "lomeshdutta" "chepreghy" "berniesanders" "spider_icp" "fullyonchain" "zero2herozombie" "gnpunksai" "pickpump_xyz" "whale_alert_io" "boomdaosns" "catalyze_one" "dao_cecil" "DecideAI_" "dogfinity" "ghost_icp" "Yral_app" "kinic_app" "gldrwa" "kongswap" "waterneuron" "SeersApp" "icvcofficial" "nuancedapp" "sonic_ooo" "onlyontrax" "ICLighthouse" "ICPCoins" "elna_live" "OpenFPL_DAO" "Fomowellcomdot" "yukuapp" "icp_cc" "NFIDWallet" "EstateDAO_ICP" "ORIGYNTech" "MotokoGhosts"
)

X_BATCH=""
for channel in "${X_CHANNELS[@]}"; do
    EXISTS=$($DFX_CALL get_channels '(opt "x")' | grep "name = \"$channel\"")
    if [ -z "$EXISTS" ]; then
        X_BATCH="$X_BATCH record {\"$channel\"; \"x\"; true};"
    else
        echo "Skipping $channel (x) - already exists"
    fi
done
if [ -n "$X_BATCH" ]; then
    $DFX_CALL create_channels "(vec { $X_BATCH })"
else
    echo "All X channels already exist"
fi

# Initialize languages
echo "Initializing Languages..."
LANGUAGES=(
    "record {\"简体中文\"; \"zh\"; \"cn\"; true}"
    "record {\"日本語\"; \"ja\"; \"jp\"; true}"
    "record {\"한국어\"; \"ko\"; \"kr\"; false}"
    "record {\"Español\"; \"es\"; \"es\"; false}"
    "record {\"Tiếng Việt\"; \"vi\"; \"vn\"; false}"
    "record {\"ไทย\"; \"th\"; \"th\"; false}"
    "record {\"Türkçe\"; \"tr\"; \"tr\"; false}"
    "record {\"Français\"; \"fr\"; \"fr\"; false}"
    "record {\"Deutsch\"; \"de\"; \"de\"; false}"
    "record {\"Русский\"; \"ru\"; \"ru\"; false}"
)

LANGUAGE_BATCH=""
for lang in "${LANGUAGES[@]}"; do
    LANG_NAME=$(echo "$lang" | sed 's/record {\("\w*"\);.*}/\1/' | tr -d '"')
    EXISTS=$($DFX_CALL get_languages '(null)' | grep "language = \"$LANG_NAME\"")
    if [ -z "$EXISTS" ]; then
        LANGUAGE_BATCH="$LANGUAGE_BATCH $lang;"
    else
        echo "Skipping $LANG_NAME - already exists"
    fi
done
if [ -n "$LANGUAGE_BATCH" ]; then
    $DFX_CALL create_languages "(vec { $LANGUAGE_BATCH })"
else
    echo "All languages already exist"
fi

echo "=== Initialization Completed ==="