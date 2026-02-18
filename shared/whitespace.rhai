// Whitespace and indentation helpers (shared).
fn normalize_varargs(text) {
	let out = text;
	let idx = out.index_of("... ");
	while idx >= 0 {
		out = out.sub_string(0, idx + 3) + out.sub_string(idx + 4, out.len() - idx - 4);
		idx = out.index_of("... ");
	}
	idx = out.index_of(" ...");
	while idx >= 0 {
		out = out.sub_string(0, idx) + "..." + out.sub_string(idx + 4, out.len() - idx - 4);
		idx = out.index_of(" ...");
	}
	out
}
fn normalize_inline_ws(text) {
	let out = "";
	let i = 0;
	let in_ws = false;
	while i < text.len() {
		let ch = text.sub_string(i, 1);
		if ch == " " || ch == "\t" || ch == "\n" || ch == "\r" {
			if !in_ws {
				out += " ";
				in_ws = true;
			}
		}
		else {
			out += ch;
			in_ws = false;
		}
		i += 1;
	}
	out.trim()
}

fn repeat_str(text, count) {
	if count <= 0 {
		return "";
	}
	let out = "";
	let i = 0;
	while i < count {
		out += text;
		i += 1;
	}
	out
}

fn leading_ws_len(text) {
	let i = 0;
	while i < text.len() {
		let ch = text.sub_string(i, 1);
		if ch != " " && ch != "\t" {
			break;
		}
		i += 1;
	}
	i
}

fn strip_leading_ws(text) {
	let ws = leading_ws_len(text);
	if ws == 0 {
		return text;
	}
	text.sub_string(ws, text.len() - ws)
}

fn join_lines(lines) {
	let out = "";
	let i = 0;
	while i < lines.len() {
		out += lines[i];
		if i < lines.len() - 1 {
			out += "\n";
		}
		i += 1;
	}
	out
}

fn strip_incidental_ws_block(lines, start_idx, end_idx) {
	let min_ws = -1;
	let i = start_idx;
	while i <= end_idx {
		let line = lines[i];
		if !line.trim().is_empty() {
			let ws = leading_ws_len(line);
			if min_ws < 0 || ws < min_ws {
				min_ws = ws;
			}
		}
		i += 1;
	}
	if min_ws < 0 {
		min_ws = 0;
	}
	min_ws
}

fn indent_cols_from_prefix(text, tab_width) {
	let col = 0;
	let i = 0;
	while i < text.len() {
		let ch = text.sub_string(i, 1);
		if ch == "\t" {
			let w = tab_width.max(1);
			let add = w - (col % w);
			col += add;
		}
		else if ch == " " {
			col += 1;
		}
		else {
			break;
		}
		i += 1;
	}
	col
}

fn text_cols(text, tab_width) {
	let col = 0;
	let i = 0;
	while i < text.len() {
		let ch = text.sub_string(i, 1);
		if ch == "\t" {
			let w = tab_width.max(1);
			let add = w - (col % w);
			col += add;
		}
		else if ch == "\n" || ch == "\r" {
			col = 0;
		}
		else {
			col += 1;
		}
		i += 1;
	}
	col
}

fn is_safe_wrap_char(ch) {
	ch == " " || ch == ","
}

fn find_wrap_break(text, max_len, backtrack_limit, overflow_limit) {
	if max_len <= 0 {
		return -1;
	}
	let len = text.len();
	if len <= max_len {
		return len;
	}
	let last_safe = -1;
	let i = 0;
	let upper = if max_len < len {
		max_len
	}
	else {
		len - 1
	};
	while i <= upper {
		let ch = text.sub_string(i, 1);
		if is_safe_wrap_char(ch) {
			last_safe = i;
		}
		i += 1;
	}
	if last_safe >= 0 {
		let take = last_safe + 1;
		if max_len - last_safe <= backtrack_limit {
			return take;
		}
	}
	if overflow_limit > 0 {
		let i = max_len + 1;
		let upper = max_len + overflow_limit;
		if upper >= len {
			upper = len - 1;
		}
		while i <= upper {
			let ch = text.sub_string(i, 1);
			if is_safe_wrap_char(ch) {
				return i + 1;
			}
			i += 1;
		}
	}
	if last_safe >= 0 {
		return last_safe + 1;
	}
	max_len
}
// Exports are implicit via module import.
