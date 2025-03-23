use candid::{CandidType, Principal};
use serde::{Deserialize, Serialize};
use std::collections::{HashMap, HashSet};
use ic_cdk::storage;
use ic_cdk_macros::*;
use crate::models::{language::Language, channel::Channel, rss::Rss};

#[derive(CandidType, Serialize, Deserialize, Default)]
pub struct Storage {
    pub languages: HashMap<String, Language>,
    pub channels: HashMap<String, Channel>,
    pub rss: Option<HashMap<String, Rss>>,
    pub managers: HashSet<Principal>,
    pub admin: Option<Principal>,
}

thread_local! {
    pub static STORAGE: std::cell::RefCell<Storage> = std::cell::RefCell::new(Storage::default());
}

#[pre_upgrade]
pub fn pre_upgrade() {
    STORAGE.with(|storage| {
        if let Err(e) = storage::stable_save((storage.borrow().clone(),)) {
            ic_cdk::trap(&format!("Failed to save state: {:?}", e));
        }
    });
}

#[post_upgrade]
pub fn post_upgrade() {
    match storage::stable_restore::<(Storage,)>() {
        Ok((old_storage,)) => {
            STORAGE.with(|storage| {
                *storage.borrow_mut() = old_storage;
            });
        }
        Err(e) => {
            ic_cdk::println!("Failed to restore state: {:?}. Initializing with default.", e);
            STORAGE.with(|storage| {
                *storage.borrow_mut() = Storage::default();
            });
        }
    }
}

impl Clone for Storage {
    fn clone(&self) -> Self {
        Storage {
            languages: self.languages.clone(),
            channels: self.channels.clone(),
            rss: self.rss.clone(),
            managers: self.managers.clone(),
            admin: self.admin.clone(),
        }
    }
}