;; extends

((code_block
  (code_block_language) @_lang
  (code_block_line)+ @injection.content)
 (#any-of? @_lang "ts" "typescript")
 (#offset! @injection.content 0 4 0 0)
 (#set! injection.language "typescript")
 (#set! injection.combined))

((code_block
  (code_block_language) @_lang
  (code_block_line)+ @injection.content)
 (#any-of? @_lang "js" "javascript")
 (#offset! @injection.content 0 4 0 0)
 (#set! injection.language "javascript")
 (#set! injection.combined))
