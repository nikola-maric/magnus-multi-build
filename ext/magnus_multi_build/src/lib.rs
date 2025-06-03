use magnus::{function, prelude::*, Error, Ruby};

fn reverse_string(input: String) -> String {
    input.chars().rev().collect()
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let class = ruby.define_class("RustStringUtils", ruby.class_object())?;
    class.define_singleton_method("reverse", function!(reverse_string, 1))?;
    Ok(())
}