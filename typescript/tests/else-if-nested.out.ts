function diffLines(text) {
	if (!text) return [];
	return text.split("\n")
		.map(
			(line) => {
				let className = "diff-line";
				if (line.startsWith("+")) className += " diff-added";
				else if (line.startsWith("-")) className += " diff-removed";
				else if (line.startsWith("@@")) className += " diff-hunk";
				return { text: line, className };
			}
		);
}
