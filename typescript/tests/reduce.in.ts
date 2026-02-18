text.split("\n")
		.reduce(		(acc, line) => {				const trimmed = line.trim();
				if (!trimmed) return acc;
				const [key, ...rest] = trimmed.split("=");
				acc[key] = rest.join("=");
				return acc;
			},
			{}		);
