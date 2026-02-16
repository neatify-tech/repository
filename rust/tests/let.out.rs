let (lines, count, total, truncated, truncated_reason, long_lines) = fs::format_line_slices(
	&raw,
	start_line,
	limit,
	max_total,
	max_line
);
