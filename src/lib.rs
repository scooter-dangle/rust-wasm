#![feature(proc_macro)]

extern crate wasm_bindgen;
use wasm_bindgen::prelude::*;

extern crate regex;
use regex::Regex;

use std::error::Error;

wasm_bindgen! {
    pub struct CompiledRegex {
        compiled_regex: Option<Regex>,
        pub error: String,
    }

    impl CompiledRegex {
        pub fn new(reg: &str) -> CompiledRegex {
            let (compiled_regex, error) = match Regex::new(reg) {
                Ok(reg) => (Some(reg), "".into()),
                Err(error) => (None, error.description().into()),
            };

            Self { compiled_regex, error }
        }

        pub fn is_match(&self, target: &str) -> bool {
            self.compiled_regex
                .as_ref()
                .map(|reg| reg.is_match(target))
                .unwrap_or(false)
        }

        pub fn is_valid(&self) -> bool {
            self.compiled_regex.is_some()
        }

        pub fn error_message(&self) -> String {
            self.error.clone()
        }
    }
}
