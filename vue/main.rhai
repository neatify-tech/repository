// Doc-first formatter entrypoint for Vue.
import "vue/kinds.rhai" as kinds;
import "vue/configuration.rhai" as configuration;
import "shared/whitespace.rhai" as whitespace;

fn doc_concat_list(docs) {
	if docs.len() == 0 {
		return doc_text("");
	}
	if docs.len() == 1 {
		return docs[0];
	}
	doc_concat(docs)
}

fn doc_for_child(node, idx) {
	let d = node.doc(idx);
	if d == () {
		let r = node.range(idx);
		return doc_range(start(r), end(r));
	}
	d
}

fn trim_text_range(range) {
	trim(slice(range))
}

fn is_whitespace_range(range) {
	trim_text_range(range) == ""
}

fn doc_attribute(node) {
	let k_attr_name = kinds::attribute_name;
	let k_attr_value = kinds::attribute_value;
	let k_attr_qvalue = kinds::quoted_attribute_value;
	let name_idx = -1;
	let value_idx = -1;
	let i = 0;
	while i < node.len {
		let k = node.kind(i);
		if k == k_attr_name && name_idx < 0 {
			name_idx = i;
		}
		else if (k == k_attr_qvalue || k == k_attr_value) && value_idx < 0 {
			value_idx = i;
		}
		i += 1;
	}
	if name_idx < 0 {
		return doc_text("");
	}
	let name_doc = doc_for_child(node, name_idx);
	if value_idx < 0 {
		return name_doc;
	}
	let value_doc = doc_for_child(node, value_idx);
	doc_concat_list([name_doc, doc_text("="), value_doc])
}

fn doc_directive_attribute(node) {
	let r = byte_range(node);
	doc_range(start(r), end(r))
}

fn doc_tag_name(node) {
	let k_tag_name = kinds::tag_name;
	let i = 0;
	while i < node.len {
		if node.kind(i) == k_tag_name {
			return doc_for_child(node, i);
		}
		i += 1;
	}
	doc_text("")
}

fn doc_start_or_self_tag(node, close_text) {
	let attrs = [];
	let k_attr = kinds::attribute;
	let k_directive = kinds::directive_attribute;
	let i = 0;
	while i < node.len {
		let k = node.kind(i);
		if k == k_attr || k == k_directive {
			attrs.push(doc_for_child(node, i));
		}
		i += 1;
	}
	let name_doc = doc_tag_name(node);
	if attrs.len() == 0 {
		return doc_concat_list([doc_text("<"), name_doc, doc_text(close_text)]);
	}
	let raw = text(node);
	let max_width = configuration::values["max_width"];
	let should_wrap = attrs.len() >= 3 || raw.len() > max_width || raw.index_of("\n") >= 0 || raw.index_of("\r") >= 0;
	if !should_wrap {
		let parts = [doc_text("<"), name_doc, doc_text(" ")];
		i = 0;
		while i < attrs.len() {
			parts.push(attrs[i]);
			if i < attrs.len() - 1 {
				parts.push(doc_text(" "));
			}
			i += 1;
		}
		parts.push(doc_text(close_text));
		return doc_concat_list(parts);
	}
	let attr_docs = [];
	let last_idx = attrs.len() - 1;
	i = 0;
	while i < attrs.len() {
		if i == last_idx {
			attr_docs.push(doc_concat_list([attrs[i], doc_text(close_text)]));
		}
		else {
			attr_docs.push(attrs[i]);
		}
		if i < last_idx {
			attr_docs.push(doc_hardline());
		}
		i += 1;
	}
	let indent_size = configuration::values["tab_width"];
	doc_concat_list([
		doc_text("<"),
		name_doc,
		doc_indent(indent_size, doc_concat_list([doc_hardline(), doc_concat_list(attr_docs)]))
	])
}

fn tag_name_from_start_tag_text(text) {
	let idx = text.index_of("<");
	if idx < 0 {
		return "";
	}
	let start = idx + 1;
	let end = start;
	while end < text.len() {
		let ch = text.sub_string(end, 1);
		if ch == " " || ch == "\t" || ch == "\n" || ch == "\r" || ch == ">" || ch == "/" {
			break;
		}
		end += 1;
	}
	if end <= start {
		return "";
	}
	text.sub_string(start, end - start)
}

fn element_tag_name(node) {
	let k_start = kinds::start_tag;
	let i = 0;
	while i < node.len {
		if node.kind(i) == k_start {
			let r = node.range(i);
			return tag_name_from_start_tag_text(slice(r));
		}
		i += 1;
	}
	""
}

fn inline_container_tag(tag) {
	let list = [
		"a",
		"abbr",
		"b",
		"bdi",
		"bdo",
		"button",
		"cite",
		"code",
		"data",
		"del",
		"dfn",
		"em",
		"i",
		"ins",
		"kbd",
		"label",
		"li",
		"mark",
		"p",
		"q",
		"s",
		"samp",
		"small",
		"span",
		"strong",
		"sub",
		"sup",
		"time",
		"u",
		"var"
	];
	let i = 0;
	while i < list.len() {
		if list[i] == tag {
			return true;
		}
		i += 1;
	}
	false
}

fn inline_child_ok(node, idx) {
	let k_text = kinds::text;
	let k_raw = kinds::raw_text;
	let k_entity = kinds::interpolation;
	let k_element = kinds::element;
	let k_component = kinds::component;
	let k_template = kinds::template_element;
	let k = node.kind(idx);
	if k == k_text || k == k_raw || k == k_entity {
		return true;
	}
	if k == k_element || k == k_component || k == k_template {
		let tag = tag_name_from_start_tag_text(slice(node.range(idx)));
		return inline_container_tag(tag);
	}
	false
}

fn doc_text_node(node) {
	let trimmed = trim(text(node));
	if trimmed == "" {
		return doc_text("");
	}
	doc_text(trimmed)
}

fn doc_element(node) {
	let k_start = kinds::start_tag;
	let k_end = kinds::end_tag;
	let k_self = kinds::self_closing_tag;
	let k_text = kinds::text;
	let k_raw = kinds::raw_text;
	let k_element = kinds::element;
	let k_component = kinds::component;
	let k_template = kinds::template_element;
	let tag_name = element_tag_name(node);
	if tag_name == "style" {
		return doc_script_style(node, "css");
	}
	if tag_name == "script" {
		return doc_script_style(node, "typescript");
	}
	let start_idx = -1;
	let end_idx = -1;
	let self_idx = -1;
	let content = [];
	let i = 0;
	while i < node.len {
		let k = node.kind(i);
		if k == k_start {
			start_idx = i;
		}
		else if k == k_end {
			end_idx = i;
		}
		else if k == k_self {
			self_idx = i;
		}
		else if k == k_text || k == k_raw {
			let r = node.range(i);
			if !is_whitespace_range(r) {
				content.push(i);
			}
		}
		else {
			content.push(i);
		}
		i += 1;
	}
	if self_idx >= 0 && start_idx < 0 {
		return doc_for_child(node, self_idx);
	}
	if start_idx < 0 {
		return doc_range(start(byte_range(node)), end(byte_range(node)));
	}
	let start_doc = doc_for_child(node, start_idx);
	let end_doc = if end_idx >= 0 {
		doc_for_child(node, end_idx)
	}
	else {
		doc_text("")
	};
	if content.len() == 0 {
		return doc_concat_list([start_doc, end_doc]);
	}
	let raw = text(node);
	let max_width = configuration::values["max_width"];
	let tag_name = tag_name;
	let inline_allowed = inline_container_tag(tag_name);
	let no_newlines = raw.index_of("\n") < 0 && raw.index_of("\r") < 0;
	let fits = raw.len() <= max_width;
	let inline_ok = false;
	if inline_allowed && no_newlines && fits {
		let j = 0;
		let all_inline = true;
		while j < content.len() {
			if !inline_child_ok(node, content[j]) {
				all_inline = false;
				break;
			}
			j += 1;
		}
		inline_ok = all_inline;
	}
	if !inline_ok {
		let inline_kind = if content.len() == 1 {
			node.kind(content[0])
		}
		else {
			-1
		};
		let inline_allowed = inline_kind == k_text || inline_kind == k_raw || inline_kind == kinds::interpolation || ((inline_kind == k_element || inline_kind == k_component || inline_kind == k_template) && inline_container_tag(tag_name));
		inline_ok = content.len() == 1 && inline_allowed && no_newlines && fits;
	}
	let simple_inline = false;
	if !inline_ok {
		let all_simple = content.len() > 0;
		let j = 0;
		while j < content.len() {
			let idx = content[j];
			let k = node.kind(idx);
			if k != k_text && k != k_raw && k != kinds::interpolation {
				all_simple = false;
				break;
			}
			let r = node.range(idx);
			let raw = slice(r);
			if raw.index_of("\n") >= 0 || raw.index_of("\r") >= 0 {
				all_simple = false;
				break;
			}
			j += 1;
		}
		simple_inline = all_simple;
	}
	if content.len() == 1 {
		let idx = content[0];
		let k = node.kind(idx);
		if k == k_text || k == k_raw || k == kinds::interpolation {
			let r = node.range(idx);
			let raw = slice(r);
			if raw.index_of("\n") < 0 && raw.index_of("\r") < 0 {
				return doc_concat_list([start_doc, doc_range(start(r), end(r)), end_doc]);
			}
		}
	}
	if simple_inline {
		let inline_docs = [];
		let j = 0;
		let prev_range = ();
		while j < content.len() {
			let idx = content[j];
			let r = node.range(idx);
			if prev_range != () {
				let gap = slice(range(end(prev_range), start(r)));
				if gap.len() > 0 && trim(gap) == "" {
					inline_docs.push(doc_text(" "));
				}
			}
			inline_docs.push(doc_range(start(r), end(r)));
			prev_range = r;
			j += 1;
		}
		return doc_concat_list([start_doc, doc_concat_list(inline_docs), end_doc]);
	}
	if inline_ok {
		if content.len() == 1 {
			let inner_doc = doc_for_child(node, content[0]);
			if inner_doc == () {
				return doc_concat_list([start_doc, end_doc]);
			}
			return doc_concat_list([start_doc, inner_doc, end_doc]);
		}
		let inline_docs = [];
		let j = 0;
		let prev_range = ();
		let prev_kind = -1;
		while j < content.len() {
			let idx = content[j];
			let k = node.kind(idx);
			let r = node.range(idx);
			let raw = slice(r);
			if prev_kind == kinds::interpolation && (k == kinds::text || k == kinds::raw_text) {
				if raw.starts_with(" ") || raw.starts_with("\t") {
					inline_docs.push(doc_text(" "));
				}
			}
			let d = doc_for_child(node, idx);
			if prev_range != () {
				let gap = slice(range(end(prev_range), start(r)));
				if gap.len() > 0 && trim(gap) == "" {
					inline_docs.push(doc_text(" "));
				}
			}
			if d != () {
				inline_docs.push(d);
			}
			let next_idx = if j + 1 < content.len() { content[j + 1] } else { -1 };
			if next_idx >= 0 {
				let next_kind = node.kind(next_idx);
				if (k == kinds::text || k == kinds::raw_text) && next_kind == kinds::interpolation {
					if raw.ends_with(" ") || raw.ends_with("\t") {
						inline_docs.push(doc_text(" "));
					}
				}
			}
			prev_range = r;
			prev_kind = k;
			j += 1;
		}
		return doc_concat_list([start_doc, doc_concat_list(inline_docs), end_doc]);
	}
	let inner_docs = [];
	i = 0;
	while i < content.len() {
		inner_docs.push(doc_for_child(node, content[i]));
		if i < content.len() - 1 {
			inner_docs.push(doc_hardline());
		}
		i += 1;
	}
	let indent_size = configuration::values["tab_width"];
	doc_concat_list([
		start_doc,
		doc_indent(indent_size, doc_concat_list([doc_hardline(), doc_concat_list(inner_docs)])),
		doc_hardline(),
		end_doc
	])
}

fn doc_script_style(node, language) {
	let k_start = kinds::start_tag;
	let k_end = kinds::end_tag;
	let k_raw = kinds::raw_text;
	let start_idx = -1;
	let end_idx = -1;
	let raw_idx = -1;
	let i = 0;
	while i < node.len {
		let k = node.kind(i);
		if k == k_start {
			start_idx = i;
		}
		else if k == k_end {
			end_idx = i;
		}
		else if k == k_raw {
			raw_idx = i;
		}
		i += 1;
	}
	if start_idx < 0 {
		return doc_range(start(byte_range(node)), end(byte_range(node)));
	}
	let start_doc = doc_for_child(node, start_idx);
	let end_doc = if end_idx >= 0 {
		doc_for_child(node, end_idx)
	}
	else {
		doc_text("")
	};
	if raw_idx < 0 {
		return doc_concat_list([start_doc, end_doc]);
	}
	let raw_range = node.range(raw_idx);
	if is_whitespace_range(raw_range) {
		return doc_concat_list([start_doc, end_doc]);
	}
	let raw_doc = format_fragment_doc(language, raw_range);
	if raw_doc == () {
		raw_doc = doc_range(start(raw_range), end(raw_range));
	}
	let indent_size = configuration::values["tab_width"];
	doc_concat_list([
		start_doc,
		doc_indent(indent_size, doc_concat_list([doc_hardline(), raw_doc])),
		doc_hardline(),
		end_doc
	])
}

fn build_doc(node) {
	let k = node.kind_id();
	if k == kinds::component {
		let parts = [];
		let i = 0;
		while i < node.len {
			let d = doc_for_child(node, i);
			if d != () {
				if parts.len() > 0 {
					parts.push(doc_hardline());
				}
				parts.push(d);
			}
			i += 1;
		}
		return doc_concat_list(parts);
	}
	if k == kinds::element || k == kinds::template_element {
		return doc_element(node);
	}
	if k == kinds::script_element {
		return doc_script_style(node, "typescript");
	}
	if k == kinds::style_element {
		return doc_script_style(node, "css");
	}
	if k == kinds::start_tag {
		return doc_start_or_self_tag(node, ">");
	}
	if k == kinds::self_closing_tag {
		let raw = text(node).trim();
		let close_text = if raw.ends_with("/>") {
			"/>"
		}
		else {
			">"
		};
		return doc_start_or_self_tag(node, close_text);
	}
	if k == kinds::end_tag || k == kinds::comment || k == kinds::erroneous_end_tag || k == kinds::erroneous_end_tag_name || k == kinds::_implicit_end_tag {
		let r = byte_range(node);
		return doc_range(start(r), end(r));
	}
	if k == kinds::text || k == kinds::raw_text || k == kinds::interpolation {
		return doc_text_node(node);
	}
	if k == kinds::attribute || k == kinds::directive_attribute {
		if k == kinds::directive_attribute {
			return doc_directive_attribute(node);
		}
		return doc_attribute(node);
	}
	let r = byte_range(node);
	doc_range(start(r), end(r))
}
doc_reset();
let queries = [
	"(component) @n",
	"(element) @n",
	"(template_element) @n",
	"(script_element) @n",
	"(style_element) @n",
	"(start_tag) @n",
	"(end_tag) @n",
	"(self_closing_tag) @n",
	"(attribute) @n",
	"(directive_attribute) @n",
	"(text) @n",
	"(raw_text) @n",
	"(interpolation) @n",
	"(comment) @n",
	"(erroneous_end_tag) @n",
	"(erroneous_end_tag_name) @n"
];
let root_doc = walk(
	"vue",
	queries,
	|node| {
		build_doc(node)
	}
);
let width = configuration::values["max_width"];
let indent_style = configuration::values["indent_style"];
let tab_width = configuration::values["tab_width"];
let output = doc_render_with_indent(root_doc, width, indent_style, tab_width);
let lines = output.split("\n");
let i = 0;
while i < lines.len() {
	let line = lines[i];
	if line.trim().is_empty() {
		lines[i] = "";
	}
	i += 1;
}
let output = whitespace::join_lines(lines);
while output.len() > 0 {
	let last = output.sub_string(output.len() - 1, 1);
	if last == "\n" || last == "\r" || last == " " || last == "\t" {
		output = output.sub_string(0, output.len() - 1);
	}
	else {
		break;
	}
}
let output = output + "\n";
set_output(output);
