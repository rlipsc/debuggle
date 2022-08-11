# Debuggle

A `debug` utility to display annotated expression results.

This is a simple compile time transformation to `debugEcho` statements, with the added advantage that the source path and line number is displayed with each statement in an editor friendly 'clickable' format (for example in VSCode output).

As a special case, string literals are interpreted as headings to group output.

Example:

```nim
import debuggle

let
  a = "Hello "
  b = "World"
  c = 123456
  d = "Name"

debug a, b, "Heading", c, a & d
```

Output (where `<path>` is the source path):
```
debug <path>\test1.nim(9, 6):
    a: Hello
    b: world
  Heading
    c: 123456
    a & d: Hello Name
```

