if (response && typeof response === "object" && "result" in response) {
	return response.result;
}
