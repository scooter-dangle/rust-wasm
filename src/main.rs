extern crate regex;

use regex::Regex;
use std::error::Error;

macro_rules! regex {
    ($reg:expr) => { Regex::new($reg) }
}

#[macro_use]
extern crate yew;
use yew::html::*;

fn main() {
    program(Model::new(), update, view);
}

struct Model {
    target: String,
    regex: String,
    compiled_regex: Result<Regex, String>,
}

impl Default for Model {
    fn default() -> Self {
        Self {
            target: "".into(),
            regex: "".into(),
            compiled_regex: regex!("").map_err(|_| unreachable!()),
        }
    }
}

impl Model {
    fn new() -> Self {
        Self::default()
    }
}

enum Msg {
    Target(String),
    Regex(String),
}

fn update(_context: &mut Context<Msg>, model: &mut Model, msg: Msg) {
    match msg {
        Msg::Target(new_target) => {
            model.target = new_target;
        },
        Msg::Regex(new_regex) => {
            model.regex = new_regex;
            model.compiled_regex = regex!(&model.regex)
                .map_err(|err| err.description().into());
        },
    }
}

fn view(model: &Model) -> Html<Msg> {
    html! {
        <div>
            <input oninput=|InputData { value }| Msg::Regex(value),  type="text", value={ &model.regex  }, ></input>
            <input oninput=|InputData { value }| Msg::Target(value), type="text", value={ &model.target }, ></input>
            <p>{
                match model.compiled_regex {
                    Ok(ref reg)  => partial::match_status(&model.regex, reg, &model.target),
                    Err(ref err) => partial::regex_error(err),
                }
            }</p>
        </div>
    }
}

mod partial {
    use super::*;

    fn nbsp<T>(string: T) -> String where String: From<T> {
        String::from(string).replace(' ', "\u{00a0}")
    }

    fn match_string(match_cond: bool) -> &'static str {
        if match_cond { " matches " } else { " does not match " }
    }

    pub(super) fn regex_error(error: &str) -> Html<Msg> {
        html! {
            <div
                style="
                    font-family: 'Monaco', monospace;
                    color: salmon;
                ",
            >{ nbsp(error) }</div>
        }
    }

    pub(super) fn match_status(regex: &str, compiled_regex: &Regex, target: &str) -> Html<Msg> {
        html! {
            <div>
                <span style="font-family: 'Monaco', monospace;", >{ nbsp(format!("/{}/", regex)) }</span>
                { nbsp(match_string(compiled_regex.is_match(target))) }
                <span style="font-family: 'Monaco', monospace;", >{ nbsp(format!("{:?}", target)) }</span>
            </div>
        }
    }
}
