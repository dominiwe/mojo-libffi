# Mojo libffi example

Make sure `/usr/lib/libffi.so` is available.

```sh
uv sync
source .venv/bin/activate

# first, build the provided small c library
clang -shared -o mylib.so -fPIC examples/mylib.c

# build the example with mojo
mojo build -I src/ examples/ffi_repl.mojo

# then run it
./ffi_repl
```

Example usage (small repl to call C functions):

```
Enter lib path: ./mylib.so
> add 3 4
7
> multiply 5 1
5
> negate 4
-4
> multiply -5 9
-45
> var_add 3 2 2 2
6
```

Note that this is just a small example which only supports functions with int args.
More types could be supported in the same way but for the REPL one would need a way to specify the types. Or a lexer could be added, that would be useful for strings and more types anyway.

Anther thing is that `mojo build` seems to not support static linking yet, thus the libffi symbols are also queried and called at runtime here.

## Package

To create a `.mojopkg`:

```shell
# create package
mojo package src/ffi -o ffi.mojopkg
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.