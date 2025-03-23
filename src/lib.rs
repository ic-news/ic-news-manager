use ic_cdk_macros::*;
use crate::models::{channel::Channel, language::Language, rss::Rss};
use crate::auth::init_admin;
use candid::Principal;

mod models;
mod storage;
mod auth;
mod services;

#[init]
fn init() {
    ic_cdk::setup();
    init_admin();
}

ic_cdk::export_candid!();