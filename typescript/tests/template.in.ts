const treeSummary = computed(
		() => {
			const count = countNodes(treeNodes.value);
			return `${count.files} file${count.files === 1 ? "" : "s"}, ${count.dirs} folder${
    count.dirs === 1 ? "" : "s"
  }`;
		}
	);
