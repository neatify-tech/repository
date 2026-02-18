fn node_is_multiline(node) {
let start_pos = start_position(node);
let end_pos = end_position(node);
row(end_pos) > row(start_pos)
}
