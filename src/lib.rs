#[macro_use]
extern crate seed;
use seed::prelude::*;

use regex::Regex;
use std::error::Error;

struct Model {
    target: String,
    regex: String,
    compiled: Result<Regex, String>,
}

#[wasm_bindgen(start)]
pub fn render() {
    seed::App::build(|_, _| Model::default(), update, view)
        .finish()
        .run();
}

pub fn validate_regex(reg: &str) -> Option<String> {
    Regex::new(reg)
        .map_err(|err| err.description().into())
        .err()
}

impl Default for Model {
    fn default() -> Self {
        Self {
            target: "".into(),
            regex: "".into(),
            compiled: Regex::new("").map_err(|_| unreachable!()),
        }
    }
}

enum Msg {
    Target(String),
    Regex(String),
}

fn update(msg: Msg, model: &mut Model, _: &mut impl Orders<Msg>) {
    match msg {
        Msg::Regex(regex) => {
            model.regex = regex;
            model.compiled = Regex::new(&model.regex).map_err(|err| err.description().into());
        }
        Msg::Target(target) => model.target = target,
    }
}

fn view(model: &Model) -> Node<Msg> {
    div![
        input![
            attrs! {
                "type"=>"text";
                At::Value => model.regex;
            },
            input_ev(Ev::Input, Msg::Regex)
        ],
        input![
            attrs! {
                "type"=>"text";
                At::Value => model.target;
            },
            input_ev(Ev::Input, Msg::Target)
        ],
        p![match model.compiled.as_ref() {
            Ok(reg) => partial::match_status(&model.regex, &reg, &model.target),
            Err(err) => partial::regex_error(&err),
        }],
    ]
}

mod partial {
    use super::*;

    fn nbsp<T>(string: T) -> String
    where
        String: From<T>,
    {
        String::from(string).replace(' ', "\u{00a0}")
    }

    fn match_string(match_cond: bool) -> &'static str {
        if match_cond {
            " matches "
        } else {
            " does not match "
        }
    }

    pub(super) fn regex_error(error: &str) -> Node<Msg> {
        div![
            style![
                "font-family" => "'Monaco', monospace"
                "color" => "salmon"
            ],
            nbsp(error)
                .lines()
                .map(|line| div![line])
                .collect::<Vec<Node<Msg>>>()
        ]
    }

    pub(super) fn match_status(regex: &str, compiled_regex: &Regex, target: &str) -> Node<Msg> {
        div![
            span![
                style![
                    "font-family" => "'Monaco', monospace"
                    "color" => "royalblue"
                ],
                nbsp(format!("/{}/", regex)),
            ],
            span![nbsp(match_string(compiled_regex.is_match(target)))],
            span![
                style![
                    "font-family" => "'Monaco', monospace"
                    "color" => "royalblue"
                ],
                nbsp(format!("{:?}", target)),
            ],
        ]
    }
}
