use candid::{CandidType, Deserialize};
use serde::Serialize;

#[derive(CandidType, Serialize, Deserialize, Clone, Debug)]
pub struct Rss {
    pub name: String,
    pub rss: String,
    pub enabled: bool,
    pub updated_at: u64,
}