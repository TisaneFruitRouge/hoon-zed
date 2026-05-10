; Tree-sitter highlight queries for Hoon.
;
; Order matters: in Zed's tree-sitter highlight engine, later patterns
; override earlier ones for overlapping ranges. We put `(rune)` LAST so
; that whenever the parser classifies a token as a rune (e.g. `%_`, `%~`,
; `++`, `?:`), it always wins over the more general (term)/(lark) patterns
; which can match the same characters in adjacent contexts.

(lineComment) @comment

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

(boolean) @constant.builtin
(date) @constant.builtin
(specialIndex) @constant.builtin
(fullContext) @constant.builtin

(aura) @type.builtin
(mold) @type.builtin

(term) @constant

(lark) @operator

; Runes go last so the @keyword highlight always wins.
(rune) @keyword
