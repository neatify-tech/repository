Box::pin(
	async move {
		fs::create_dir_all(&to).await?;
		let mut entries = fs::read_dir(&from).await?;
		while let Some(entry) = entries.next_entry().await? {
			let src = entry.path();
			let dst = to.join(entry.file_name());
			let meta = fs::metadata(&src).await?;
			if meta.is_dir() {
				copy_dir_recursive(src, dst).await?;
			}
			else {
				copy_file_with_meta(&src, &dst).await?;
			}
		}
		let meta = fs::metadata(&from).await?;
		fs::set_permissions(&to, meta.permissions()).await?;
		let atime = FileTime::from_last_access_time(&meta);
		let mtime = FileTime::from_last_modification_time(&meta);
		set_file_times(&to, atime, mtime)?;
		Ok(())
	}
);
