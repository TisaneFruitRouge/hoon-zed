(number) @number

(string) @string

[
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

[
  (coreTerminator)
  (seriesTerminator)
] @punctuation.delimiter

(rune) @keyword

(term) @constant

(aura) @type.builtin

(lineComment) @comment

(boolean) @constant.builtin

(date) @constant.builtin
(mold) @type.builtin
(specialIndex) @constant.builtin
(lark) @operator
(fullContext) @constant.builtin
