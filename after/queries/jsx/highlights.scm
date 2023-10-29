;; extends

(jsx_element
  close_tag: (jsx_closing_element ["</" ">"] @tag.delimiter.end))

(jsx_closing_element
  name: (identifier) @tag.end)


; Handle the dot operator effectively - <My.Component>
(jsx_opening_element ((member_expression (identifier) @tag (property_identifier) @tag.constructor)))

; Handle the dot operator effectively - </My.Component>
(jsx_closing_element ((member_expression (identifier) @tag.end (property_identifier) @tag.constructor.end)))

; Handle the dot operator effectively - <My.Component />
(jsx_self_closing_element ((member_expression (identifier) @tag (property_identifier) @tag.constructor)))
