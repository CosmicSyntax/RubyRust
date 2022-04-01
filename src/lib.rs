#![allow(improper_ctypes_definitions)]
#[macro_use]
extern crate rutie;

use rutie::{Class, Object, VM, Integer};
use tokio::runtime::Runtime;

// A little bit of boilerplate code to map Ruby datatypes to Rust's
class!(RutieExample);
methods!(
    RutieExample,
    _rtself,

    fn pub_iter(input: Integer) -> Integer {
        let ruby_int = input.
          map_err(VM::raise_ex ).
          unwrap();

        let upper = ruby_int.to_i64();

        let answer = new_thread_iter(upper);

        Integer::new(
            answer
        )
    }
);

// This is just to show case we can utilize green threads in Rust
fn new_thread_iter(n: i64) -> i64 {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        tokio::spawn(async move {
            println!("Hello from Rust using a green thread to do calculations!");
            let mut x: i64 = 0;
            for i in 0..n {
                x += i;
            }

            x
        }).await.unwrap()
    })
}

// Export the function signature using C ABI
#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_rutie_ruby_example() {
    Class::new("RutieExample", None).define(|klass| {
        klass.def_self("iterate", pub_iter);
    });
}
