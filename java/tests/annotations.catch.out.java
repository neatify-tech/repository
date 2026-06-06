try {
	doWork();
}
catch (@Nullable IOException ex) {
	handle(ex);
}
