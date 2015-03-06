# Badger

Badger is an experimental programming language.

It can be compiled to multiple languages or can be interpreted by the reference interpreter.

## Links

- [Wiki](https://github.com/DirectMyFile/badger/wiki)
- [Compiler Demo](http://directmyfile.github.io/badger-site/compiler.html)

## Features

### Language

- Method Calls
- Variables
- Immutable Variables
- Function Definitions
- While Statements
- If Then Else Statements
- For In Statements

### Implementation

- JavaScript Compiler
- Dart Compiler
- Compiler API
- Generate JSON from AST
- Generate AST from JSON

## Links

- [Wiki]()


## Example:

```badger
func greet(name) {
  return "Hello $(name)"
}

let names = ["Kenneth", "Logan", "Sam", "Mike"]

for name in names {
  print(greet(name))
}
```

## Getting Started

To install the badger interpreter, run the following command:

```bash
pub global activate -sgit git://github.com/DirectMyFile/badger.git
```

To run an example, run the following command:

```bash
badger example/greeting.badger
```

To compile to JavaScript, run the following command:

```bash
badger --compile=js example/greeting.badger > hello.js
```
