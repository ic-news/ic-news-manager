# ICNewsManager

A Rust-based canister on ICP for managing channels and languages for ic.news.

## Installation

1. Install DFX: `sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"`
2. Run `dfx start --background`
3. Deploy: `dfx deploy`

## Usage

- Add a manager: `dfx canister call icnewshub add_manager '(principal "bbbbb-bb")'`
- Create a language: `dfx canister call icnewshub create_language '("English", "en", opt "US", true)'`
- Batch create channels: `dfx canister call icnewshub create_channels '(vec {record {"news_en"; "telegram"; true}})'`
- Batch create RSS: `dfx canister call icnewshub create_rss '(vec {record {"rss_en"; "https://rss.panewslab.com/en/tvsq/rss"; true}})'`
