let text = input();
let params = params();

let holder_value = params.get("holder");
let year_value = params.get("year");
let force_value = params.get("force");
let force = false;
if force_value != () {
	let force_text = force_value.to_string().trim().to_lower();
	if force_text == "true" || force_text == "1" || force_text == "yes" {
		force = true;
	}
}
if holder_value == () || year_value == () {
	log("lgpl3: missing holder/year params; skipping");
	set_output(text);
	return;
}

let holder = holder_value.to_string();
let year = year_value.to_string();
if holder.trim().is_empty() || year.trim().is_empty() {
	log("lgpl3: empty holder/year params; skipping");
	set_output(text);
	return;
}

let header = "/*\n"
	+ "* Copyright (C) " + year + " " + holder + "\n"
	+ "*\n"
	+ "* This program is free software: you can redistribute it and/or modify\n"
	+ "* it under the terms of the GNU Lesser General Public License as published by\n"
	+ "* the Free Software Foundation, either version 3 of the License, or\n"
	+ "* (at your option) any later version.\n"
	+ "*\n"
	+ "* This program is distributed in the hope that it will be useful,\n"
	+ "* but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
	+ "* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n"
	+ "* GNU Lesser General Public License for more details.\n"
	+ "*\n"
	+ "* You should have received a copy of the GNU Lesser General Public License\n"
	+ "* along with this program. If not, see <https://www.gnu.org/licenses/>.\n"
	+ "*/";

let trimmed = text.trim_start();
if trimmed.starts_with(header) {
	set_output(text);
	return;
}

let lang = language();
let root = root_node(lang);
if root == () {
	set_output(header + "\n\n" + trimmed);
	return;
}

let matches = query(lang, "(comment) @c");
let first_comment = ();
let first_start = -1;
let i = 0;
while i < matches.len() {
	let m = matches[i];
	let c = m.captures()["c"];
	let r = byte_range(c);
	let s = start(r);
	if first_start < 0 || s < first_start {
		first_start = s;
		first_comment = c;
	}
	i += 1;
}

if first_comment != () {
	let r = byte_range(first_comment);
	let s = start(r);
	let e = end(r);
	let prefix = if s > 0 { text.sub_string(0, s) } else { "" };
	if prefix.trim().is_empty() {
		let block = text.sub_string(s, e - s);
		let block_lower = block.to_lower();
		if block.index_of("GNU Lesser General Public License") >= 0 && block.index_of("Copyright") >= 0 {
			set_output(text);
			return;
		}
		if force && block_lower.index_of("copyright") >= 0 {
			let after = text.sub_string(e, text.len() - e);
			let cleaned = after.trim_start();
			set_output(prefix + header + "\n\n" + cleaned);
			return;
		}
	}
}

set_output(header + "\n\n" + trimmed);
