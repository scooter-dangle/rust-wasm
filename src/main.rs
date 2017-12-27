extern crate regex;

extern {}

fn main() {
    /* Intentionally left blank */
}

// from https://github.com/mrfr0g/rust-webassembly/blob/master/examples/string/src/main.rs
use std::os::raw::c_char;
use std::ffi::{CStr,CString};
use std::ptr;

use regex::Regex;
use std::error::Error;

macro_rules! ptr_to_string {
    ($item:expr) => { CStr::from_ptr($item).to_string_lossy().into_owned() }
}

// See the declarations of this function in .cargo/config and wasm.html
#[no_mangle]
pub unsafe fn regex_compare(reg: *const regex::Regex, target: *const c_char) -> bool {
    let target = ptr_to_string!(target);
    (*reg).is_match(&target)
}

#[no_mangle]
pub unsafe fn regex_compile(reg: *const c_char) -> *mut Result<regex::Regex, CString> {
    let reg = ptr_to_string!(reg);
    let out = Box::new(
        Regex::new(&reg)
        .map_err(|err| CString::new(String::from(err.description())).unwrap())
    );
    Box::into_raw(out)
}

#[no_mangle]
pub unsafe fn regex_is_ok(result: *const Result<regex::Regex, CString>) -> bool {
    (*result).is_ok()
}

#[no_mangle]
pub unsafe fn regex_get_regex(result: *mut Result<regex::Regex, CString>) -> *mut regex::Regex {
    let result = Box::from_raw(result);
    match *result {
        Ok(reg) => Box::into_raw(Box::new(reg)),
        Err(_) => ptr::null_mut(),
    }
}

#[no_mangle]
pub unsafe fn regex_get_err(result: *mut Result<regex::Regex, CString>) -> *mut c_char {
    let result: Box<Result<regex::Regex, CString>> = Box::from_raw(result);
    match *result {
        Err(err) => err.into_raw(),
        Ok(_) => ptr::null_mut(),
    }
}

#[no_mangle]
pub unsafe fn free_regex(reg: *mut regex::Regex) {
    Box::from_raw(reg);
}

#[no_mangle]
pub fn to_string(num: i32) -> *mut c_char {
    let c_out = CString::new(num.to_string()).unwrap();
    // Don't wanna actually drop this since we're passing it across the FFI
    // boundary.
    c_out.into_raw()
}

#[no_mangle]
pub unsafe fn free_c_string(ptr: *mut c_char) {
    if ptr.is_null() { return; }
    CString::from_raw(ptr);
}
