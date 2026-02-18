const KIND_PAIRS = [
	["program", true],
	["statement_block", true],
	["expression_statement", true],
	["lexical_declaration", true],
	["import_statement", true],
	["import_clause", true],
	["named_imports", true],
	["import_specifier", true],
	["namespace_import", true],
	["variable_declaration", true],
	["variable_declarator", true],
	["if_statement", true],
	["for_statement", true],
	["_for_header", true],
	["for_in_statement", true],
	["while_statement", true],
	["do_statement", true],
	["switch_statement", true],
	["switch_body", true],
	["switch_case", true],
	["return_statement", true],
	["break_statement", true],
	["continue_statement", true],
	["throw_statement", true],
	["try_statement", true],
	["catch_clause", true],
	["finally_clause", true],
	["function_declaration", true],
	["arrow_function", true],
	["call_expression", true],
	["class_declaration", true],
	["class_body", true],
	["method_definition", true],
	["member_expression", true],
	["arguments", true],
	["formal_parameters", true],
	["binary_expression", true],
	["assignment_expression", true],
	["update_expression", true],
	["unary_expression", true],
	["await_expression", true],
	["parenthesized_expression", true],
	["array", true],
	["object", true],
	["pair", true],
	["shorthand_property_identifier", true],
	["spread_element", true],
	["type_alias_declaration", true],
	["type_identifier", true],
	["object_type", true],
	["property_signature", true],
	["type_annotation", true],
	["predefined_type", true],
	["ternary_expression", true],
	["identifier", true],
	["property_identifier", true],
	["string", true],
	["template_string", true],
	["template_substitution", true],
	["string_fragment", true],
	["number", true],
	["true", true],
	["false", true],
	["null", true],
	["comment", true],
	["else_clause", true],
	["line_comment", true],
	["block_comment", true],
	["{", false],
	["}", false],
	["(", false],
	[")", false],
	["[", false],
	["]", false],
	[",", false],
	[";", false],
	["?", false],
	[":", false],
	[".", false],
	["?.", false],
	["=", false],
	["=>", false],
	["+", false],
	["-", false],
	["*", false],
	["/", false],
	["%", false],
	["==", false],
	["!=", false],
	["===", false],
	["!==", false],
	["??", false],
	["<", false],
	[">", false],
	["<=", false],
	[">=", false],
	["&&", false],
	["||", false],
	["!", false],
	["&", false],
	["|", false],
	["^", false],
	["<<", false],
	[">>", false],
	[">>>", false],
	["+=", false],
	["-=", false],
	["*=", false],
	["/=", false],
	["%=", false],
	["**", false],
	["<<=", false],
	[">>=", false],
	[">>>=", false],
	["&=", false],
	["|=", false],
	["^=", false],
	["??=", false],
	["&&=", false],
	["||=", false],
	["if", false],
	["else", false],
	["for", false],
	["in", false],
	["of", false],
	["instanceof", false],
	["typeof", false],
	["void", false],
	["delete", false],
	["await", false],
	["while", false],
	["do", false],
	["switch", false],
	["case", false],
	["default", false],
	["return", false],
	["break", false],
	["continue", false],
	["throw", false],
	["try", false],
	["catch", false],
	["async", false],
	["function", false],
	["const", false],
	["let", false],
	["var", false]
];
fn build_kind_map(pairs) {
	let out = #{};
	let i = 0;
	while i < pairs.len() {
		let entry = pairs[i];
		out[entry[0]] = kind_id("typescript", entry[0], entry[1]);
		i += 1;
	}
	out
}
let kinds = build_kind_map(KIND_PAIRS);
export kinds as map;
export const program = kind_id("typescript", "program", true);
export const statement_block = kind_id("typescript", "statement_block", true);
export const expression_statement = kind_id("typescript", "expression_statement", true);
export const lexical_declaration = kind_id("typescript", "lexical_declaration", true);
export const import_statement = kind_id("typescript", "import_statement", true);
export const import_clause = kind_id("typescript", "import_clause", true);
export const named_imports = kind_id("typescript", "named_imports", true);
export const import_specifier = kind_id("typescript", "import_specifier", true);
export const namespace_import = kind_id("typescript", "namespace_import", true);
export const variable_declaration = kind_id("typescript", "variable_declaration", true);
export const variable_declarator = kind_id("typescript", "variable_declarator", true);
export const if_statement = kind_id("typescript", "if_statement", true);
export const for_statement = kind_id("typescript", "for_statement", true);
export const _for_header = kind_id("typescript", "_for_header", true);
export const for_in_statement = kind_id("typescript", "for_in_statement", true);
export const while_statement = kind_id("typescript", "while_statement", true);
export const do_statement = kind_id("typescript", "do_statement", true);
export const switch_statement = kind_id("typescript", "switch_statement", true);
export const switch_body = kind_id("typescript", "switch_body", true);
export const switch_case = kind_id("typescript", "switch_case", true);
export const switch_default = kind_id("typescript", "switch_default", true);
export const return_statement = kind_id("typescript", "return_statement", true);
export const break_statement = kind_id("typescript", "break_statement", true);
export const continue_statement = kind_id("typescript", "continue_statement", true);
export const throw_statement = kind_id("typescript", "throw_statement", true);
export const try_statement = kind_id("typescript", "try_statement", true);
export const catch_clause = kind_id("typescript", "catch_clause", true);
export const finally_clause = kind_id("typescript", "finally_clause", true);
export const function_declaration = kind_id("typescript", "function_declaration", true);
export const arrow_function = kind_id("typescript", "arrow_function", true);
export const call_expression = kind_id("typescript", "call_expression", true);
export const class_declaration = kind_id("typescript", "class_declaration", true);
export const class_body = kind_id("typescript", "class_body", true);
export const method_definition = kind_id("typescript", "method_definition", true);
export const member_expression = kind_id("typescript", "member_expression", true);
export const arguments = kind_id("typescript", "arguments", true);
export const formal_parameters = kind_id("typescript", "formal_parameters", true);
export const binary_expression = kind_id("typescript", "binary_expression", true);
export const assignment_expression = kind_id("typescript", "assignment_expression", true);
export const update_expression = kind_id("typescript", "update_expression", true);
export const unary_expression = kind_id("typescript", "unary_expression", true);
export const await_expression = kind_id("typescript", "await_expression", true);
export const parenthesized_expression = kind_id("typescript", "parenthesized_expression", true);
export const array = kind_id("typescript", "array", true);
export const object = kind_id("typescript", "object", true);
export const pair = kind_id("typescript", "pair", true);
export const shorthand_property_identifier = kind_id("typescript", "shorthand_property_identifier", true);
export const spread_element = kind_id("typescript", "spread_element", true);
export const type_alias_declaration = kind_id("typescript", "type_alias_declaration", true);
export const type_identifier = kind_id("typescript", "type_identifier", true);
export const object_type = kind_id("typescript", "object_type", true);
export const property_signature = kind_id("typescript", "property_signature", true);
export const type_annotation = kind_id("typescript", "type_annotation", true);
export const predefined_type = kind_id("typescript", "predefined_type", true);
export const ternary_expression = kind_id("typescript", "ternary_expression", true);
export const identifier = kind_id("typescript", "identifier", true);
export const property_identifier = kind_id("typescript", "property_identifier", true);
export const string = kind_id("typescript", "string", true);
export const template_string = kind_id("typescript", "template_string", true);
export const template_substitution = kind_id("typescript", "template_substitution", true);
export const string_fragment = kind_id("typescript", "string_fragment", true);
export const number = kind_id("typescript", "number", true);
export const lit_true = kind_id("typescript", "true", true);
export const lit_false = kind_id("typescript", "false", true);
export const lit_null = kind_id("typescript", "null", true);
export const comment = kind_id("typescript", "comment", true);
export const else_clause = kind_id("typescript", "else_clause", true);
export const line_comment = kind_id("typescript", "line_comment", true);
export const block_comment = kind_id("typescript", "block_comment", true);
export const lbrace = kind_id("typescript", "{", false);
export const rbrace = kind_id("typescript", "}", false);
export const lparen = kind_id("typescript", "(", false);
export const rparen = kind_id("typescript", ")", false);
export const lbracket = kind_id("typescript", "[", false);
export const rbracket = kind_id("typescript", "]", false);
export const comma = kind_id("typescript", ",", false);
export const semi = kind_id("typescript", ";", false);
export const qmark = kind_id("typescript", "?", false);
export const colon = kind_id("typescript", ":", false);
export const dot = kind_id("typescript", ".", false);
export const qdot = kind_id("typescript", "?.", false);
export const assign = kind_id("typescript", "=", false);
export const arrow = kind_id("typescript", "=>", false);
export const plus = kind_id("typescript", "+", false);
export const minus = kind_id("typescript", "-", false);
export const star = kind_id("typescript", "*", false);
export const slash = kind_id("typescript", "/", false);
export const percent = kind_id("typescript", "%", false);
export const eq_eq = kind_id("typescript", "==", false);
export const not_eq = kind_id("typescript", "!=", false);
export const eq_eq_eq = kind_id("typescript", "===", false);
export const not_eq_eq = kind_id("typescript", "!==", false);
export const coalesce = kind_id("typescript", "??", false);
export const lt = kind_id("typescript", "<", false);
export const gt = kind_id("typescript", ">", false);
export const lt_eq = kind_id("typescript", "<=", false);
export const gt_eq = kind_id("typescript", ">=", false);
export const and_and = kind_id("typescript", "&&", false);
export const or_or = kind_id("typescript", "||", false);
export const bang = kind_id("typescript", "!", false);
export const amp = kind_id("typescript", "&", false);
export const pipe = kind_id("typescript", "|", false);
export const caret = kind_id("typescript", "^", false);
export const shl = kind_id("typescript", "<<", false);
export const shr = kind_id("typescript", ">>", false);
export const ushr = kind_id("typescript", ">>>", false);
export const plus_assign = kind_id("typescript", "+=", false);
export const minus_assign = kind_id("typescript", "-=", false);
export const star_assign = kind_id("typescript", "*=", false);
export const slash_assign = kind_id("typescript", "/=", false);
export const percent_assign = kind_id("typescript", "%=", false);
export const pow = kind_id("typescript", "**", false);
export const shl_assign = kind_id("typescript", "<<=", false);
export const shr_assign = kind_id("typescript", ">>=", false);
export const ushr_assign = kind_id("typescript", ">>>=", false);
export const and_assign = kind_id("typescript", "&=", false);
export const or_assign = kind_id("typescript", "|=", false);
export const xor_assign = kind_id("typescript", "^=", false);
export const coalesce_assign = kind_id("typescript", "??=", false);
export const and_and_assign = kind_id("typescript", "&&=", false);
export const or_or_assign = kind_id("typescript", "||=", false);
export const kw_if = kind_id("typescript", "if", false);
export const kw_else = kind_id("typescript", "else", false);
export const kw_for = kind_id("typescript", "for", false);
export const kw_in = kind_id("typescript", "in", false);
export const kw_of = kind_id("typescript", "of", false);
export const kw_instanceof = kind_id("typescript", "instanceof", false);
export const kw_typeof = kind_id("typescript", "typeof", false);
export const kw_void = kind_id("typescript", "void", false);
export const kw_delete = kind_id("typescript", "delete", false);
export const kw_await = kind_id("typescript", "await", false);
export const kw_while = kind_id("typescript", "while", false);
export const kw_do = kind_id("typescript", "do", false);
export const kw_switch = kind_id("typescript", "switch", false);
export const kw_case = kind_id("typescript", "case", false);
export const kw_default = kind_id("typescript", "default", false);
export const kw_return = kind_id("typescript", "return", false);
export const kw_break = kind_id("typescript", "break", false);
export const kw_continue = kind_id("typescript", "continue", false);
export const kw_throw = kind_id("typescript", "throw", false);
export const kw_try = kind_id("typescript", "try", false);
export const kw_catch = kind_id("typescript", "catch", false);
export const kw_async = kind_id("typescript", "async", false);
export const kw_function = kind_id("typescript", "function", false);
export const kw_const = kind_id("typescript", "const", false);
export const kw_let = kind_id("typescript", "let", false);
export const kw_var = kind_id("typescript", "var", false);
