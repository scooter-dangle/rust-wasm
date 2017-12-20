#![feature(proc_macro)]

extern crate wasm_bindgen;
use wasm_bindgen::prelude::*;

extern crate regex;
use regex::Regex;

use std::error::Error;

wasm_bindgen! {
    pub fn greet(name: &str) -> String {
        format!("Hello, {}!", name)
    }

    pub fn validate_regex(string: &str) -> String {
        match Regex::new(string) {
            Ok(_) => "".into(),
            Err(err) => err.description().into(),
        }
    }

    pub fn regex_compare(needle: &str, haystack: &str) -> u8 {
        match Regex::new(needle)
            .map(|needle| needle.is_match(haystack))
            .unwrap_or(false) {
                true => 1,
                false => 0,
            }
    }
}
