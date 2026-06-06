var a = ResourceUtils.find(
		getRoot(),
		resource -> {
			boolean accept = resource instanceof ResourceContainer;
			if (namePattern != null && accept) {
				accept = resource.getName().matches("(?i)" + namePattern);
			}
			return accept;
		},
		true
	)
	.stream()
	.map(r -> ResourceUtils.getPath(r))
	.toList();
var b = ResourceUtils.find(
	getRoot(),
	resource -> {
		boolean accept = resource instanceof ResourceContainer;
		if (namePattern != null && accept) {
			accept = resource.getName().matches("(?i)" + namePattern);
		}
		return accept;
	},
	true
);
