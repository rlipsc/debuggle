## Simple utility to `debugEcho`


import macros, strutils

macro debugAnnotate*(annotation: string, columnWidth: int, values: varargs[untyped]) =
  ## Outputs decorated `debugEcho` statements for `values`.
  ## 
  ## The call site location is aligned to the `columnWidth` parameter
  ## plus two spaces.
  result = newStmtList()
  let
    lInfo = newLit "debug " & values.lineInfo & ":"
    lAlign = columnWidth.copy
    rep = bindSym "repeat"
  var
    indent: string
  
  result.add(quote do:
    debugEcho `lInfo`
  )

  var hasTitles: bool
  for s in values:
    if s.kind == nnkStrLit:
      hasTitles = true
      break

  if values.len > 0:
    if hasTitles: 
      indent = "    "
    else:
      indent = "  "
  
  for s in values:
    let
      title = 
        if s.kind == nnkStrLit: newLit "  "
        else: newLit indent & s.repr & ": "
      tLen = newLit title.strVal.len

    result.add(quote do:
      block:
        when compiles($(`s`)):
          var str = $(`s`)
        else:
          var str = repr(`s`)

        let
          firstNL = str.find "\n"

        if firstNL >= 0:
          # Insert the call site info at the first new line.
          let spaces = `lAlign` - (`tLen` mod `lAlign`)
          debugEcho `title` & `rep`(' ', spaces) & `annotation` & "\n" & str
        else:
          let spaces = `lAlign` - ((`tLen` + str.len) mod `lAlign`)
          debugEcho `title` & str & `rep`(' ', spaces) & `annotation`
    )


template debug*(values: varargs[untyped]) =
  ## Outputs decorated `debugEcho` statements for `values` along with the
  ## call site location.
  debugAnnotate "", 64, `values`

template debugAlign*(colWidth: int, values: varargs[untyped]) =
  ## Outputs decorated `debugEcho` statements for `values` along with the
  ## call site location.
  debugAnnotate "", colWidth, `values`


when isMainModule:
  let
    a = 1
    b = "1"
    c = "12"
    d = "123"
    e = "1234"
    f = "12345"
    g = "123456"
    h = "1234567"
    i = "12345678"
    j = "12345678\n90123"
  debug a, b, c, d, e, f, g, h, i, j
  debugAlign 5, a, b, c, d, e, f, g, h, i, j
  let x = 70
  debugAlign x, a, b, c, d, e, f, g, h, i, j
  debug i
  debug j
  debug "Title1", a, b, c, "Title2", d, e, f, "Title3", i, j
