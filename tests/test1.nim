import debuggle, unittest

test "Example":
  let
    a = "Hello "
    b = "World"
    c = 123456
    d = "Name"

  debug a, b, "Heading", c, a & d
