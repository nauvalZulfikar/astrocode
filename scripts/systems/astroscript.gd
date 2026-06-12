## AstroScript — Simplified Python-like interpreter for in-game robot programming.
## Tree-walking interpreter: tokenize -> parse -> evaluate.
## Supports Tier 1 syntax: variables, print, math, comparison, boolean logic,
## if/elif/else, while loops, string concat, comments.
class_name AstroScript
extends RefCounted

# --- Constants ---
const MAX_LOOP_ITERATIONS: int = 1000
const MAX_STEPS: int = 10000

# --- Token types ---
enum TokenType {
	NUMBER,
	STRING,
	IDENTIFIER,
	KEYWORD,
	OPERATOR,
	ASSIGN,
	LPAREN,
	RPAREN,
	COMMA,
	DOT,
	COLON,
	NEWLINE,
	INDENT,
	DEDENT,
	EOF,
}

# --- Keywords ---
const KEYWORDS: PackedStringArray = [
	"if", "elif", "else", "while", "and", "or", "not",
	"True", "False", "None", "print", "str",
]

# --- Execution state ---
var _output: Array[String] = []
var _errors: Array[String] = []
var _step_count: int = 0
var _robot_ref: Node2D = null
var _halted: bool = false


## Execute AstroScript source code with an optional context.
## context may include "robot" (Node2D reference) and "variables" (preset scope).
## Returns {output: Array[String], errors: Array[String], variables: Dictionary}.
func execute(source: String, context: Dictionary = {}) -> Dictionary:
	_output.clear()
	_errors.clear()
	_step_count = 0
	_halted = false

	# Bind robot reference from context.
	_robot_ref = context.get("robot", null) as Node2D

	# Build initial scope with preset variables.
	var scope: Dictionary = {}
	if context.has("variables") and context["variables"] is Dictionary:
		scope = (context["variables"] as Dictionary).duplicate()

	# Tokenize.
	var tokens: Array = tokenize(source)
	if not _errors.is_empty():
		return {"output": _output.duplicate(), "errors": _errors.duplicate(), "variables": scope}

	# Parse.
	var ast: Array = parse(tokens)
	if not _errors.is_empty():
		return {"output": _output.duplicate(), "errors": _errors.duplicate(), "variables": scope}

	# Evaluate.
	evaluate(ast, scope)

	return {"output": _output.duplicate(), "errors": _errors.duplicate(), "variables": scope}


# =============================================================================
# TOKENIZER
# =============================================================================

## Tokenize source code into a flat list of token dictionaries.
## Each token: {type: TokenType, value: Variant, line: int}
func tokenize(source: String) -> Array:
	var tokens: Array = []
	var lines: PackedStringArray = source.split("\n")
	var indent_stack: Array[int] = [0]

	for line_idx: int in range(lines.size()):
		var line: String = lines[line_idx]
		var line_num: int = line_idx + 1

		# Skip blank lines and comment-only lines.
		var stripped: String = line.strip_edges()
		if stripped == "" or stripped.begins_with("#"):
			continue

		# --- Measure indentation (count leading spaces/tabs) ---
		var indent_level: int = 0
		var ci: int = 0
		while ci < line.length():
			if line[ci] == " ":
				indent_level += 1
			elif line[ci] == "\t":
				indent_level += 2  # Tab = 2 spaces
			else:
				break
			ci += 1

		# Emit INDENT / DEDENT tokens.
		if indent_level > indent_stack[-1]:
			indent_stack.append(indent_level)
			tokens.append({"type": TokenType.INDENT, "value": indent_level, "line": line_num})
		else:
			while indent_stack.size() > 1 and indent_level < indent_stack[-1]:
				indent_stack.pop_back()
				tokens.append({"type": TokenType.DEDENT, "value": indent_level, "line": line_num})

		# --- Tokenize the rest of the line ---
		var pos: int = ci  # Start after indentation.
		while pos < line.length():
			var ch: String = line[pos]

			# Skip whitespace.
			if ch == " " or ch == "\t":
				pos += 1
				continue

			# Comment — skip rest of line.
			if ch == "#":
				break

			# String literal (double or single quotes).
			if ch == "\"" or ch == "'":
				var result: Dictionary = _tokenize_string(line, pos, line_num)
				if result.has("error"):
					_errors.append("Line %d: %s" % [line_num, result["error"]])
					return tokens
				tokens.append(result["token"])
				pos = result["end_pos"]
				continue

			# Number literal.
			if ch >= "0" and ch <= "9":
				var result: Dictionary = _tokenize_number(line, pos, line_num)
				tokens.append(result["token"])
				pos = result["end_pos"]
				continue

			# Identifiers and keywords.
			if _is_alpha_or_underscore(ch):
				var result: Dictionary = _tokenize_identifier(line, pos, line_num)
				tokens.append(result["token"])
				pos = result["end_pos"]
				continue

			# Two-character operators.
			if pos + 1 < line.length():
				var two: String = line.substr(pos, 2)
				if two in ["==", "!=", "<=", ">=", "//", "**"]:
					tokens.append({"type": TokenType.OPERATOR, "value": two, "line": line_num})
					pos += 2
					continue

			# Single-character tokens.
			match ch:
				"+", "-", "*", "/", "%", "<", ">":
					tokens.append({"type": TokenType.OPERATOR, "value": ch, "line": line_num})
					pos += 1
				"=":
					tokens.append({"type": TokenType.ASSIGN, "value": "=", "line": line_num})
					pos += 1
				"(":
					tokens.append({"type": TokenType.LPAREN, "value": "(", "line": line_num})
					pos += 1
				")":
					tokens.append({"type": TokenType.RPAREN, "value": ")", "line": line_num})
					pos += 1
				",":
					tokens.append({"type": TokenType.COMMA, "value": ",", "line": line_num})
					pos += 1
				".":
					tokens.append({"type": TokenType.DOT, "value": ".", "line": line_num})
					pos += 1
				":":
					tokens.append({"type": TokenType.COLON, "value": ":", "line": line_num})
					pos += 1
				_:
					_errors.append("Line %d: unexpected character '%s'" % [line_num, ch])
					return tokens

		# End of line.
		tokens.append({"type": TokenType.NEWLINE, "value": "\\n", "line": line_num})

	# Emit remaining DEDENT tokens.
	while indent_stack.size() > 1:
		indent_stack.pop_back()
		var last_line: int = lines.size()
		tokens.append({"type": TokenType.DEDENT, "value": 0, "line": last_line})

	tokens.append({"type": TokenType.EOF, "value": "", "line": lines.size()})
	return tokens


## Tokenize a string literal starting at [pos]. Returns {token, end_pos} or {error}.
func _tokenize_string(line: String, pos: int, line_num: int) -> Dictionary:
	var quote_char: String = line[pos]
	var result: String = ""
	var i: int = pos + 1
	while i < line.length():
		var ch: String = line[i]
		if ch == "\\":
			# Escape sequence.
			if i + 1 < line.length():
				var next_ch: String = line[i + 1]
				match next_ch:
					"n": result += "\n"
					"t": result += "\t"
					"\\": result += "\\"
					"\"": result += "\""
					"'": result += "'"
					_: result += "\\" + next_ch
				i += 2
				continue
		if ch == quote_char:
			# End of string.
			var token: Dictionary = {"type": TokenType.STRING, "value": result, "line": line_num}
			return {"token": token, "end_pos": i + 1}
		result += ch
		i += 1
	return {"error": "unterminated string literal"}


## Tokenize a number starting at [pos]. Returns {token, end_pos}.
func _tokenize_number(line: String, pos: int, line_num: int) -> Dictionary:
	var start: int = pos
	var has_dot: bool = false
	while pos < line.length():
		var ch: String = line[pos]
		if ch >= "0" and ch <= "9":
			pos += 1
		elif ch == "." and not has_dot:
			has_dot = true
			pos += 1
		else:
			break
	var num_str: String = line.substr(start, pos - start)
	var value: Variant
	if has_dot:
		value = num_str.to_float()
	else:
		value = num_str.to_int()
	var token: Dictionary = {"type": TokenType.NUMBER, "value": value, "line": line_num}
	return {"token": token, "end_pos": pos}


## Tokenize an identifier or keyword starting at [pos]. Returns {token, end_pos}.
func _tokenize_identifier(line: String, pos: int, line_num: int) -> Dictionary:
	var start: int = pos
	while pos < line.length() and _is_alnum_or_underscore(line[pos]):
		pos += 1
	var word: String = line.substr(start, pos - start)
	var ttype: TokenType
	if word in KEYWORDS:
		ttype = TokenType.KEYWORD
	else:
		ttype = TokenType.IDENTIFIER
	var token: Dictionary = {"type": ttype, "value": word, "line": line_num}
	return {"token": token, "end_pos": pos}


func _is_alpha_or_underscore(ch: String) -> bool:
	return (ch >= "a" and ch <= "z") or (ch >= "A" and ch <= "Z") or ch == "_"


func _is_alnum_or_underscore(ch: String) -> bool:
	return _is_alpha_or_underscore(ch) or (ch >= "0" and ch <= "9")


# =============================================================================
# PARSER
# =============================================================================

## Parser state.
var _tokens: Array = []
var _tok_pos: int = 0


## Parse a token list into an AST (Array of statement Dictionaries).
func parse(tokens: Array) -> Array:
	_tokens = tokens
	_tok_pos = 0
	var ast: Array = []

	while not _at_end():
		_skip_newlines()
		if _at_end():
			break
		var stmt: Dictionary = _parse_statement()
		if stmt.is_empty():
			break
		ast.append(stmt)

	return ast


## Return the current token without consuming it.
func _peek() -> Dictionary:
	if _tok_pos >= _tokens.size():
		return {"type": TokenType.EOF, "value": "", "line": 0}
	return _tokens[_tok_pos]


## Consume and return the current token.
func _advance() -> Dictionary:
	var tok: Dictionary = _peek()
	_tok_pos += 1
	return tok


## Check if we are at the end of the token stream.
func _at_end() -> bool:
	return _tok_pos >= _tokens.size() or _peek()["type"] == TokenType.EOF


## Skip NEWLINE tokens.
func _skip_newlines() -> void:
	while not _at_end() and _peek()["type"] == TokenType.NEWLINE:
		_advance()


## Check if current token matches a type and optional value.
func _check(ttype: TokenType, value: Variant = null) -> bool:
	if _at_end():
		return false
	var tok: Dictionary = _peek()
	if tok["type"] != ttype:
		return false
	if value != null and tok["value"] != value:
		return false
	return true


## Consume a token matching type and optional value, or add an error.
func _expect(ttype: TokenType, value: Variant = null) -> Dictionary:
	if _check(ttype, value):
		return _advance()
	var tok: Dictionary = _peek()
	var expected_str: String = str(value) if value != null else str(ttype)
	var got_str: String = str(tok["value"])
	# Suggest corrections for common typos.
	var hint: String = ""
	if tok["type"] == TokenType.IDENTIFIER:
		hint = _suggest_keyword(tok["value"])
	_errors.append("Line %d: expected '%s', got '%s'%s" % [tok["line"], expected_str, got_str, hint])
	return tok


## Suggest a keyword correction for common typos.
func _suggest_keyword(word: String) -> String:
	var suggestions: Dictionary = {
		"iff": " -- did you mean 'if'?",
		"whlie": " -- did you mean 'while'?",
		"wile": " -- did you mean 'while'?",
		"esle": " -- did you mean 'else'?",
		"elseif": " -- did you mean 'elif'?",
		"prnt": " -- did you mean 'print'?",
		"pritn": " -- did you mean 'print'?",
		"ture": " -- did you mean 'True'?",
		"flase": " -- did you mean 'False'?",
	}
	return suggestions.get(word, "")


## Parse a single statement.
func _parse_statement() -> Dictionary:
	_skip_newlines()
	if _at_end():
		return {}

	var tok: Dictionary = _peek()

	# if / elif / else
	if _check(TokenType.KEYWORD, "if"):
		return _parse_if()

	# while
	if _check(TokenType.KEYWORD, "while"):
		return _parse_while()

	# print
	if _check(TokenType.KEYWORD, "print"):
		return _parse_print()

	# Assignment or expression statement.
	if tok["type"] == TokenType.IDENTIFIER:
		return _parse_assign_or_expr()

	# Unknown — try to parse as expression.
	var expr: Dictionary = _parse_expression()
	if expr.is_empty():
		# Skip the bad token to avoid infinite loops.
		var bad: Dictionary = _advance()
		_errors.append("Line %d: unexpected token '%s'" % [bad["line"], bad["value"]])
		return {}

	_skip_newlines()
	return {"type": "expr", "value": expr, "line": tok["line"]}


## Parse an assignment (x = ...) or a bare expression (function call etc).
func _parse_assign_or_expr() -> Dictionary:
	# Peek ahead to determine if this is an assignment.
	# We save position and try to parse a target + "=".
	var save_pos: int = _tok_pos
	var target: Dictionary = _parse_dot_access()

	if _check(TokenType.ASSIGN):
		_advance()  # Consume '='
		var value: Dictionary = _parse_expression()
		_skip_newlines()
		return {"type": "assign", "target": target, "value": value, "line": target.get("line", 0)}

	# Not an assignment — restore and parse as expression.
	_tok_pos = save_pos
	var expr: Dictionary = _parse_expression()
	var line: int = expr.get("line", 0)
	_skip_newlines()
	return {"type": "expr", "value": expr, "line": line}


## Parse dot-access chain: identifier.attr.attr...
func _parse_dot_access() -> Dictionary:
	var tok: Dictionary = _advance()  # Consume identifier
	var result: Dictionary = {"type": "var", "name": tok["value"], "line": tok["line"]}

	while _check(TokenType.DOT):
		_advance()  # Consume '.'
		var attr_tok: Dictionary = _expect(TokenType.IDENTIFIER)
		result = {"type": "attr", "object": result, "attr": attr_tok["value"], "line": tok["line"]}

	return result


## Parse a print statement: print(expr, expr, ...)
func _parse_print() -> Dictionary:
	var tok: Dictionary = _advance()  # Consume 'print'
	_expect(TokenType.LPAREN)
	var args: Array = []
	if not _check(TokenType.RPAREN):
		args.append(_parse_expression())
		while _check(TokenType.COMMA):
			_advance()  # Consume ','
			args.append(_parse_expression())
	_expect(TokenType.RPAREN)
	_skip_newlines()
	return {"type": "print", "args": args, "line": tok["line"]}


## Parse if / elif / else block.
func _parse_if() -> Dictionary:
	var tok: Dictionary = _advance()  # Consume 'if'
	var condition: Dictionary = _parse_expression()
	_expect(TokenType.COLON)
	_skip_newlines()
	var body: Array = _parse_block()

	# Collect elif branches.
	var elif_branches: Array = []
	while _check(TokenType.KEYWORD, "elif"):
		_advance()  # Consume 'elif'
		var elif_cond: Dictionary = _parse_expression()
		_expect(TokenType.COLON)
		_skip_newlines()
		var elif_body: Array = _parse_block()
		elif_branches.append({"condition": elif_cond, "body": elif_body})

	# Optional else.
	var else_body: Array = []
	if _check(TokenType.KEYWORD, "else"):
		_advance()  # Consume 'else'
		_expect(TokenType.COLON)
		_skip_newlines()
		else_body = _parse_block()

	return {
		"type": "if",
		"condition": condition,
		"body": body,
		"elif_branches": elif_branches,
		"else_body": else_body,
		"line": tok["line"],
	}


## Parse a while loop.
func _parse_while() -> Dictionary:
	var tok: Dictionary = _advance()  # Consume 'while'
	var condition: Dictionary = _parse_expression()
	_expect(TokenType.COLON)
	_skip_newlines()
	var body: Array = _parse_block()

	return {"type": "while", "condition": condition, "body": body, "line": tok["line"]}


## Parse a block of statements (after INDENT, until DEDENT).
func _parse_block() -> Array:
	var stmts: Array = []

	if not _check(TokenType.INDENT):
		# Single-line block (no indent) — treat next statement as the block.
		_skip_newlines()
		if not _at_end() and not _check(TokenType.DEDENT) and not _check(TokenType.KEYWORD, "elif") and not _check(TokenType.KEYWORD, "else"):
			var stmt: Dictionary = _parse_statement()
			if not stmt.is_empty():
				stmts.append(stmt)
		return stmts

	_advance()  # Consume INDENT.

	while not _at_end() and not _check(TokenType.DEDENT):
		_skip_newlines()
		if _at_end() or _check(TokenType.DEDENT):
			break
		var stmt: Dictionary = _parse_statement()
		if stmt.is_empty():
			break
		stmts.append(stmt)

	if _check(TokenType.DEDENT):
		_advance()  # Consume DEDENT.

	return stmts


# --- Expression parsing (precedence climbing) ---

## Parse a full expression.
func _parse_expression() -> Dictionary:
	return _parse_or()


## Parse 'or' expressions.
func _parse_or() -> Dictionary:
	var left: Dictionary = _parse_and()
	while _check(TokenType.KEYWORD, "or"):
		var op_tok: Dictionary = _advance()
		var right: Dictionary = _parse_and()
		left = {"type": "binop", "op": "or", "left": left, "right": right, "line": op_tok["line"]}
	return left


## Parse 'and' expressions.
func _parse_and() -> Dictionary:
	var left: Dictionary = _parse_not()
	while _check(TokenType.KEYWORD, "and"):
		var op_tok: Dictionary = _advance()
		var right: Dictionary = _parse_not()
		left = {"type": "binop", "op": "and", "left": left, "right": right, "line": op_tok["line"]}
	return left


## Parse 'not' expressions.
func _parse_not() -> Dictionary:
	if _check(TokenType.KEYWORD, "not"):
		var op_tok: Dictionary = _advance()
		var operand: Dictionary = _parse_not()
		return {"type": "unaryop", "op": "not", "operand": operand, "line": op_tok["line"]}
	return _parse_comparison()


## Parse comparison: ==, !=, <, >, <=, >=
func _parse_comparison() -> Dictionary:
	var left: Dictionary = _parse_addition()
	while _check(TokenType.OPERATOR) and _peek()["value"] in ["==", "!=", "<", ">", "<=", ">="]:
		var op_tok: Dictionary = _advance()
		var right: Dictionary = _parse_addition()
		left = {"type": "binop", "op": op_tok["value"], "left": left, "right": right, "line": op_tok["line"]}
	return left


## Parse addition and subtraction.
func _parse_addition() -> Dictionary:
	var left: Dictionary = _parse_multiplication()
	while _check(TokenType.OPERATOR) and _peek()["value"] in ["+", "-"]:
		var op_tok: Dictionary = _advance()
		var right: Dictionary = _parse_multiplication()
		left = {"type": "binop", "op": op_tok["value"], "left": left, "right": right, "line": op_tok["line"]}
	return left


## Parse multiplication, division, modulo.
func _parse_multiplication() -> Dictionary:
	var left: Dictionary = _parse_unary()
	while _check(TokenType.OPERATOR) and _peek()["value"] in ["*", "/", "%"]:
		var op_tok: Dictionary = _advance()
		var right: Dictionary = _parse_unary()
		left = {"type": "binop", "op": op_tok["value"], "left": left, "right": right, "line": op_tok["line"]}
	return left


## Parse unary minus.
func _parse_unary() -> Dictionary:
	if _check(TokenType.OPERATOR, "-"):
		var op_tok: Dictionary = _advance()
		var operand: Dictionary = _parse_unary()
		return {"type": "unaryop", "op": "-", "operand": operand, "line": op_tok["line"]}
	return _parse_call()


## Parse function calls and attribute access: foo.bar(args) or foo(args) or just foo.
func _parse_call() -> Dictionary:
	var expr: Dictionary = _parse_primary()

	# Chain dot-access and calls.
	while true:
		if _check(TokenType.DOT):
			_advance()  # Consume '.'
			var attr_tok: Dictionary = _expect(TokenType.IDENTIFIER)
			expr = {"type": "attr", "object": expr, "attr": attr_tok["value"], "line": expr.get("line", 0)}
		elif _check(TokenType.LPAREN):
			_advance()  # Consume '('
			var args: Array = []
			if not _check(TokenType.RPAREN):
				args.append(_parse_expression())
				while _check(TokenType.COMMA):
					_advance()
					args.append(_parse_expression())
			_expect(TokenType.RPAREN)
			expr = {"type": "call", "callee": expr, "args": args, "line": expr.get("line", 0)}
		else:
			break

	return expr


## Parse primary expressions: literals, identifiers, parenthesized expressions.
func _parse_primary() -> Dictionary:
	var tok: Dictionary = _peek()

	# Number literal.
	if tok["type"] == TokenType.NUMBER:
		_advance()
		return {"type": "literal", "value": tok["value"], "line": tok["line"]}

	# String literal.
	if tok["type"] == TokenType.STRING:
		_advance()
		return {"type": "literal", "value": tok["value"], "line": tok["line"]}

	# Boolean / None literals.
	if _check(TokenType.KEYWORD, "True"):
		_advance()
		return {"type": "literal", "value": true, "line": tok["line"]}
	if _check(TokenType.KEYWORD, "False"):
		_advance()
		return {"type": "literal", "value": false, "line": tok["line"]}
	if _check(TokenType.KEYWORD, "None"):
		_advance()
		return {"type": "literal", "value": null, "line": tok["line"]}

	# str() builtin.
	if _check(TokenType.KEYWORD, "str"):
		_advance()
		_expect(TokenType.LPAREN)
		var arg: Dictionary = _parse_expression()
		_expect(TokenType.RPAREN)
		return {"type": "str_call", "arg": arg, "line": tok["line"]}

	# Identifier (variable reference).
	if tok["type"] == TokenType.IDENTIFIER:
		_advance()
		return {"type": "var", "name": tok["value"], "line": tok["line"]}

	# Parenthesized expression.
	if tok["type"] == TokenType.LPAREN:
		_advance()  # Consume '('
		var expr: Dictionary = _parse_expression()
		_expect(TokenType.RPAREN)
		return expr

	# Fallback — unknown.
	_advance()
	_errors.append("Line %d: unexpected token '%s'" % [tok["line"], tok["value"]])
	return {"type": "literal", "value": null, "line": tok.get("line", 0)}


# =============================================================================
# EVALUATOR
# =============================================================================

## Evaluate an AST within the given scope.
func evaluate(ast: Array, scope: Dictionary) -> void:
	for stmt: Variant in ast:
		if _halted:
			break
		_step_count += 1
		if _step_count > MAX_STEPS:
			_errors.append("Execution exceeded step limit (%d). Check for infinite loops." % MAX_STEPS)
			_halted = true
			break
		if stmt is Dictionary:
			_eval_statement(stmt as Dictionary, scope)


## Evaluate a single statement.
func _eval_statement(stmt: Dictionary, scope: Dictionary) -> void:
	if _halted:
		return

	var stmt_type: String = str(stmt.get("type", ""))
	match stmt_type:
		"assign":
			_eval_assign(stmt, scope)
		"print":
			_eval_print(stmt, scope)
		"if":
			_eval_if(stmt, scope)
		"while":
			_eval_while(stmt, scope)
		"expr":
			# Bare expression — evaluate for side effects (e.g., robot.move("left")).
			_eval_expr(stmt.get("value", {}), scope)
		_:
			_errors.append("Line %d: unknown statement type '%s'" % [stmt.get("line", 0), stmt_type])


## Evaluate an assignment statement.
func _eval_assign(stmt: Dictionary, scope: Dictionary) -> void:
	var target: Dictionary = stmt.get("target", {})
	var value: Variant = _eval_expr(stmt.get("value", {}), scope)

	if target.get("type", "") == "var":
		scope[target["name"]] = value
	elif target.get("type", "") == "attr":
		# Attribute assignment — not supported for prototype.
		_errors.append("Line %d: attribute assignment is not supported" % stmt.get("line", 0))
	else:
		_errors.append("Line %d: invalid assignment target" % stmt.get("line", 0))


## Evaluate a print statement.
func _eval_print(stmt: Dictionary, scope: Dictionary) -> void:
	var args: Array = stmt.get("args", [])
	var parts: PackedStringArray = PackedStringArray()
	for arg: Variant in args:
		if arg is Dictionary:
			var val: Variant = _eval_expr(arg as Dictionary, scope)
			parts.append(_value_to_string(val))
	_output.append(" ".join(parts))


## Evaluate an if/elif/else chain.
func _eval_if(stmt: Dictionary, scope: Dictionary) -> void:
	# Check main condition.
	var cond: Variant = _eval_expr(stmt.get("condition", {}), scope)
	if _is_truthy(cond):
		_eval_block(stmt.get("body", []), scope)
		return

	# Check elif branches.
	var elif_branches: Array = stmt.get("elif_branches", [])
	for branch: Variant in elif_branches:
		if _halted:
			return
		if branch is Dictionary:
			var b: Dictionary = branch as Dictionary
			var elif_cond: Variant = _eval_expr(b.get("condition", {}), scope)
			if _is_truthy(elif_cond):
				_eval_block(b.get("body", []), scope)
				return

	# Else branch.
	var else_body: Array = stmt.get("else_body", [])
	if not else_body.is_empty():
		_eval_block(else_body, scope)


## Evaluate a while loop with iteration protection.
func _eval_while(stmt: Dictionary, scope: Dictionary) -> void:
	var iterations: int = 0
	while true:
		if _halted:
			return
		iterations += 1
		if iterations > MAX_LOOP_ITERATIONS:
			_errors.append("Line %d: loop exceeded %d iterations — stopped to prevent infinite loop" % [stmt.get("line", 0), MAX_LOOP_ITERATIONS])
			_halted = true
			return

		var cond: Variant = _eval_expr(stmt.get("condition", {}), scope)
		if not _is_truthy(cond):
			break

		_eval_block(stmt.get("body", []), scope)


## Evaluate a block (list of statements).
func _eval_block(block: Array, scope: Dictionary) -> void:
	for stmt: Variant in block:
		if _halted:
			return
		_step_count += 1
		if _step_count > MAX_STEPS:
			_errors.append("Execution exceeded step limit (%d)." % MAX_STEPS)
			_halted = true
			return
		if stmt is Dictionary:
			_eval_statement(stmt as Dictionary, scope)


## Evaluate an expression and return its value.
func _eval_expr(expr: Dictionary, scope: Dictionary) -> Variant:
	if _halted:
		return null
	if expr.is_empty():
		return null

	var etype: String = str(expr.get("type", ""))

	match etype:
		"literal":
			return expr.get("value")

		"var":
			var name: String = str(expr.get("name", ""))
			if name == "robot":
				return _make_robot_proxy()
			if name == "sensor":
				return _make_sensor_proxy()
			if scope.has(name):
				return scope[name]
			_errors.append("Line %d: '%s' is not defined" % [expr.get("line", 0), name])
			return null

		"attr":
			var obj: Variant = _eval_expr(expr.get("object", {}), scope)
			var attr: String = str(expr.get("attr", ""))
			if obj is Dictionary and (obj as Dictionary).has(attr):
				return (obj as Dictionary)[attr]
			_errors.append("Line %d: cannot access attribute '%s'" % [expr.get("line", 0), attr])
			return null

		"binop":
			return _eval_binop(expr, scope)

		"unaryop":
			return _eval_unaryop(expr, scope)

		"call":
			return _eval_call(expr, scope)

		"str_call":
			var arg: Variant = _eval_expr(expr.get("arg", {}), scope)
			return _value_to_string(arg)

		"print":
			# print as expression — treat as statement.
			_eval_print(expr, scope)
			return null

		_:
			_errors.append("Line %d: unknown expression type '%s'" % [expr.get("line", 0), etype])
			return null


## Evaluate a binary operation.
func _eval_binop(expr: Dictionary, scope: Dictionary) -> Variant:
	var op: String = str(expr.get("op", ""))
	var left: Variant = _eval_expr(expr.get("left", {}), scope)
	var right: Variant = _eval_expr(expr.get("right", {}), scope)
	var line: int = expr.get("line", 0)

	match op:
		"+":
			if left is String or right is String:
				return _value_to_string(left) + _value_to_string(right)
			if left is float or right is float:
				return float(left) + float(right) if left != null and right != null else null
			if left is int and right is int:
				return int(left) + int(right)
			return null
		"-":
			if (left is int or left is float) and (right is int or right is float):
				if left is float or right is float:
					return float(left) - float(right)
				return int(left) - int(right)
			_errors.append("Line %d: cannot subtract these types" % line)
			return null
		"*":
			if (left is int or left is float) and (right is int or right is float):
				if left is float or right is float:
					return float(left) * float(right)
				return int(left) * int(right)
			_errors.append("Line %d: cannot multiply these types" % line)
			return null
		"/":
			if (left is int or left is float) and (right is int or right is float):
				if float(right) == 0.0:
					_errors.append("Line %d: division by zero" % line)
					return null
				return float(left) / float(right)
			_errors.append("Line %d: cannot divide these types" % line)
			return null
		"%":
			if left is int and right is int:
				if int(right) == 0:
					_errors.append("Line %d: modulo by zero" % line)
					return null
				return int(left) % int(right)
			if (left is int or left is float) and (right is int or right is float):
				if float(right) == 0.0:
					_errors.append("Line %d: modulo by zero" % line)
					return null
				return fmod(float(left), float(right))
			_errors.append("Line %d: cannot modulo these types" % line)
			return null
		"==": return left == right
		"!=": return left != right
		"<":
			if (left is int or left is float) and (right is int or right is float):
				return float(left) < float(right)
			return false
		">":
			if (left is int or left is float) and (right is int or right is float):
				return float(left) > float(right)
			return false
		"<=":
			if (left is int or left is float) and (right is int or right is float):
				return float(left) <= float(right)
			return false
		">=":
			if (left is int or left is float) and (right is int or right is float):
				return float(left) >= float(right)
			return false
		"and":
			return _is_truthy(left) and _is_truthy(right)
		"or":
			return _is_truthy(left) or _is_truthy(right)
		_:
			_errors.append("Line %d: unknown operator '%s'" % [line, op])
			return null


## Evaluate a unary operation.
func _eval_unaryop(expr: Dictionary, scope: Dictionary) -> Variant:
	var op: String = str(expr.get("op", ""))
	var operand: Variant = _eval_expr(expr.get("operand", {}), scope)

	match op:
		"-":
			if operand is int:
				return -int(operand)
			if operand is float:
				return -float(operand)
			_errors.append("Line %d: cannot negate this type" % expr.get("line", 0))
			return null
		"not":
			return not _is_truthy(operand)
		_:
			return null


## Evaluate a function call.
func _eval_call(expr: Dictionary, scope: Dictionary) -> Variant:
	var callee: Dictionary = expr.get("callee", {})
	var args: Array = expr.get("args", [])
	var line: int = expr.get("line", 0)

	# Evaluate arguments.
	var eval_args: Array = []
	for arg: Variant in args:
		if arg is Dictionary:
			eval_args.append(_eval_expr(arg as Dictionary, scope))

	# --- Robot API calls: robot.method(args) ---
	if callee.get("type", "") == "attr":
		var obj_expr: Dictionary = callee.get("object", {})
		var method: String = str(callee.get("attr", ""))

		# Evaluate the object to get the proxy.
		var obj: Variant = _eval_expr(obj_expr, scope)

		if obj is Dictionary:
			var proxy: Dictionary = obj as Dictionary
			var proxy_type: String = str(proxy.get("_proxy_type", ""))

			if proxy_type == "robot":
				return _call_robot_api(method, eval_args, line)
			elif proxy_type == "sensor":
				return _call_sensor_api(method, eval_args, line)

		_errors.append("Line %d: '%s' is not callable" % [line, method])
		return null

	# --- Built-in function calls that weren't caught as keywords ---
	if callee.get("type", "") == "var":
		var func_name: String = str(callee.get("name", ""))
		if func_name == "str":
			if eval_args.size() >= 1:
				return _value_to_string(eval_args[0])
			return ""
		if func_name == "print":
			var parts: PackedStringArray = PackedStringArray()
			for a: Variant in eval_args:
				parts.append(_value_to_string(a))
			_output.append(" ".join(parts))
			return null
		if func_name == "int":
			if eval_args.size() >= 1:
				return int(eval_args[0]) if eval_args[0] != null else 0
			return 0
		if func_name == "float":
			if eval_args.size() >= 1:
				return float(eval_args[0]) if eval_args[0] != null else 0.0
			return 0.0
		if func_name == "abs":
			if eval_args.size() >= 1 and (eval_args[0] is int or eval_args[0] is float):
				return absf(float(eval_args[0]))
			return 0
		if func_name == "len":
			if eval_args.size() >= 1 and eval_args[0] is String:
				return (eval_args[0] as String).length()
			return 0

		_errors.append("Line %d: '%s' is not a function" % [line, func_name])
		return null

	_errors.append("Line %d: cannot call this expression" % line)
	return null


# =============================================================================
# ROBOT API BRIDGE
# =============================================================================

## Create a robot proxy dictionary (used as a sentinel in the scope).
func _make_robot_proxy() -> Dictionary:
	return {"_proxy_type": "robot"}


## Create a sensor proxy dictionary.
func _make_sensor_proxy() -> Dictionary:
	return {"_proxy_type": "sensor"}


## Dispatch a robot API call to the bound robot reference.
func _call_robot_api(method: String, args: Array, line: int) -> Variant:
	if _robot_ref == null or not is_instance_valid(_robot_ref):
		_errors.append("Line %d: no robot is connected" % line)
		return null

	match method:
		"move":
			# robot.move(direction_string) — "up", "down", "left", "right"
			if args.size() < 1:
				_errors.append("Line %d: robot.move() requires a direction argument" % line)
				return null
			var dir_str: String = str(args[0]).to_lower()
			var dir_vec: Vector2 = Vector2.ZERO
			match dir_str:
				"up": dir_vec = Vector2(0, -16)
				"down": dir_vec = Vector2(0, 16)
				"left": dir_vec = Vector2(-16, 0)
				"right": dir_vec = Vector2(16, 0)
				_:
					_errors.append("Line %d: unknown direction '%s' — use 'up', 'down', 'left', or 'right'" % [line, dir_str])
					return null
			var target: Vector2 = _robot_ref.global_position + dir_vec
			if _robot_ref.has_method("move_to"):
				_robot_ref.move_to(target)
			_output.append("[robot] Moving %s" % dir_str)
			return null

		"move_to":
			# robot.move_to(x, y)
			if args.size() < 2:
				_errors.append("Line %d: robot.move_to() requires x and y arguments" % line)
				return null
			var target: Vector2 = Vector2(float(args[0]), float(args[1]))
			if _robot_ref.has_method("move_to"):
				_robot_ref.move_to(target)
			_output.append("[robot] Moving to (%d, %d)" % [int(args[0]), int(args[1])])
			return null

		"gather":
			# robot.gather(resource_type)
			if args.size() < 1:
				_errors.append("Line %d: robot.gather() requires a resource type argument" % line)
				return null
			var resource_id: String = str(args[0])
			if _robot_ref.has_method("gather"):
				_robot_ref.gather(resource_id)
			_output.append("[robot] Gathering %s" % resource_id)
			return null

		"deposit":
			# robot.deposit()
			if _robot_ref.has_method("deposit"):
				_robot_ref.deposit()
			_output.append("[robot] Depositing cargo")
			return null

		"battery":
			# robot.battery() — returns current battery level.
			if "battery_current" in _robot_ref:
				return _robot_ref.battery_current
			return 0.0

		"status":
			# robot.status() — returns status dictionary.
			if _robot_ref.has_method("get_status"):
				var status: Dictionary = _robot_ref.get_status()
				# Convert to a simplified dict for the script.
				return {
					"battery": status.get("battery", 0.0),
					"cargo": status.get("cargo_count", 0),
					"max_cargo": status.get("max_cargo", 0),
					"status": status.get("status", "unknown"),
					"name": status.get("robot_name", ""),
				}
			return {}

		"log":
			# robot.log(message) — prints to SABLE terminal.
			if args.size() < 1:
				_errors.append("Line %d: robot.log() requires a message argument" % line)
				return null
			var msg: String = _value_to_string(args[0])
			_output.append("[%s] %s" % [str(_robot_ref.robot_name), msg])
			# Also send to SABLE terminal if available.
			var sable: Node = _robot_ref.get_tree().get_first_node_in_group("sable_terminal") if _robot_ref.get_tree() else null
			if sable == null:
				# Try to find SableTerminal in the scene tree by name.
				var scene: Node = _robot_ref.get_tree().current_scene if _robot_ref.get_tree() else null
				if scene and scene.has_node("SableTerminal"):
					sable = scene.get_node("SableTerminal")
			if sable and sable.has_method("add_message"):
				sable.add_message(msg, "system")
			return null

		_:
			_errors.append("Line %d: robot has no method '%s'" % [line, method])
			return null


## Dispatch a sensor API call.
func _call_sensor_api(method: String, args: Array, line: int) -> Variant:
	match method:
		"read":
			# sensor.read(type) — returns a simulated sensor value.
			if args.size() < 1:
				_errors.append("Line %d: sensor.read() requires a sensor type argument" % line)
				return null
			var sensor_type: String = str(args[0]).to_lower()
			return _get_simulated_sensor(sensor_type)
		_:
			_errors.append("Line %d: sensor has no method '%s'" % [line, method])
			return null


## Return a simulated sensor reading based on type and current game state.
func _get_simulated_sensor(sensor_type: String) -> Variant:
	match sensor_type:
		"wind":
			# Simulate wind speed 0-100.
			return randi_range(10, 60)
		"temp", "temperature":
			return GameManager.get_stat("temperature") if GameManager else 25.0
		"humidity":
			return randi_range(20, 80)
		"gas", "h2s":
			# Higher in toxic biomes.
			if GameManager and GameManager.current_biome in GameManager.TOXIC_BIOMES:
				return randi_range(40, 90)
			return randi_range(0, 20)
		"pressure":
			return randi_range(900, 1100)
		"ph":
			return randf_range(2.0, 8.0)
		"em_field":
			return randi_range(10, 100)
		"battery":
			if _robot_ref and is_instance_valid(_robot_ref) and "battery_current" in _robot_ref:
				return _robot_ref.battery_current
			return 0.0
		_:
			return 0


# =============================================================================
# UTILITIES
# =============================================================================

## Check if a value is truthy (Python semantics).
func _is_truthy(val: Variant) -> bool:
	if val == null:
		return false
	if val is bool:
		return val as bool
	if val is int:
		return int(val) != 0
	if val is float:
		return float(val) != 0.0
	if val is String:
		return (val as String).length() > 0
	return true


## Convert a value to its string representation.
func _value_to_string(val: Variant) -> String:
	if val == null:
		return "None"
	if val is bool:
		return "True" if (val as bool) else "False"
	if val is int:
		return str(val)
	if val is float:
		# Trim trailing zeros for cleaner display.
		var s: String = str(val)
		if "." in s:
			s = s.rstrip("0").rstrip(".")
			if s == "" or s == "-":
				s = "0"
		return s
	if val is String:
		return val as String
	if val is Dictionary:
		return str(val)
	return str(val)
