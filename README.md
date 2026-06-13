# keyval

keyval is a plain-text format for flat key-value pairs and trees. Keys are dotted paths; values are the rest of the line. Files are lexicographically sorted, making output deterministic and diffs noise-free. There is no quoting and no type system. The full grammar fits on a page.

File extension: `.kv`

## Spec

| Format | Download |
|--------|----------|
| HTML | [keyval.html](https://unixfile.github.io/keyval/keyval.html) |
| A4 | [keyval-a4.pdf](https://unixfile.github.io/keyval/keyval-a4.pdf) |
| Screen | [keyval-screen.pdf](https://unixfile.github.io/keyval/keyval-screen.pdf) |

See [keyval.md](keyval.md) for the source. MIT licensed.

## Example

```
build.00 ./configure --prefix=/usr
build.01 make
build.parallel yes
person.0.email \0
person.0.name Charles Ingvar Jönsson
person.1.name Anna
planets
```

## Implementations

- [unixfile/kv](https://github.com/unixfile/kv) (Go)
