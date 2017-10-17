extern crate regex;

extern {}

fn main() {
    /* Intentionally left blank */
}

// from https://github.com/mrfr0g/rust-webassembly/blob/master/examples/string/src/main.rs
use std::os::raw::c_char;
use std::ffi::CStr;

use regex::Regex;
use std::error::Error;

macro_rules! regex {
    ($reg:expr) => { Regex::new($reg).map_err(From::from) }
}

macro_rules! ptr_to_string {
    ($item:expr) => { CStr::from_ptr($item).to_string_lossy().into_owned() }
}

fn safe_regex_compare(reg: String, target: String) -> Result<bool, Box<Error>> {
    regex!(&reg).map(|reg| reg.is_match(&target))
}

// See the declarations of this function in .cargo/config and wasm.html
#[no_mangle]
pub unsafe fn regex_compare(reg: *const c_char, target: *const c_char) -> bool {
    let reg    = ptr_to_string!(reg);
    let target = ptr_to_string!(target);
    safe_regex_compare(reg, target).unwrap()
}

#[no_mangle]
pub fn plus(a: i32, b: i32) -> i32 {
    a + b
}
