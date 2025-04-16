# racket-redex

This repository contains a Racket implementation utilizing the Redex library to model and manipulate regular expressions. It demonstrates the application of Redex for defining and testing the semantics of regular expressions.

## Features

- **Regular Expression Modeling**: Defines the syntax and semantics of regular expressions.
- **Reduction Semantics**: Implements reduction relations to model the evaluation of regular expressions.
- **Testing Framework**: Includes properties and tests to verify the correctness of the regular expression semantics.

## Files

- `typed-expr.rkt`: Defines the syntax and type system for the language.
- `arith.rkt`: Contains arithmetic operations and evaluation functions.
- `gen-expr.rkt`: Generates random expressions for testing.
- `properties.rkt`: Defines properties for testing the expressions.
- `typed-exp-prof.rkt`: Profiles the performance of typed expressions.
- `regex-vm-compiler.rkt`: Contains the compilation logic for transforming regular expressions into executable forms.
- `regex-vm-processor.rkt`: Implements the evaluation of regular expressions.
- `assembly.rkt`: Defines the assembly language for the virtual machine.
- `typed-expr.rkt`: Defines the typed expressions and their semantics.

## Installation

To get started, clone this repository:

```bash
git clone https://github.com/daher13/racket-redex.git
```

## Usage
To run the project, execute the typed-expr.rkt file:

```bash
racket typed-expr.rkt
```

This will evaluate the regular expressions defined within the project and run the associated tests.
