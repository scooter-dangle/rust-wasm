#![deny(warnings)]

extern crate regex;

pub use regex::Regex;

use std::error::Error;

#[macro_export]
macro_rules! regex {
    ($reg:expr) => { Regex::new($reg).map_err(From::from) }
}

pub fn safe_regex_compare(reg: String, target: String) -> Result<bool, Box<Error>> {
    regex!(&reg).map(|reg| reg.is_match(&target))
}
