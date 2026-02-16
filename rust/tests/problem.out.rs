async fn execute_tool(
	config: &Config,
	name: &str,
	arguments: &Value,
	meta: &Value) -> Result<ToolOutcome> {
	let params = arguments.as_object().ok_or_else(|| ProtocolError::new(-32602, "arguments must be an object"))?;
	let args = Value::Object(params.clone());
	let preview = parse_meta_preview(meta.get("preview"));
	let granted_roots = granted_roots_for_tool(config, name, meta);
	let allowed_roots = allowed_roots_for_call(config, &granted_roots);
	let result = match name {
		"list_roots" => run_tool(
			"list_roots",
			config,
			None,
			|| async {
				let granted = granted_roots_for_tool(config, name, meta);
				let roots = build_roots_output(config, &granted);
				Ok(json!({
					"roots": roots
				}))
			}
		).await,
		"search_files" => run_tool(
			"search_files",
			config,
			None,
			|| async {
				let pattern = args.get("pattern")
					.and_then(Value::as_str)
					.ok_or_else(|| anyhow!("pattern is required"))?;
				let root_param = args.get("root")
					.and_then(Value::as_str)
					.unwrap_or(".");
				let root_path = fs::resolve_path(
					&config.root,
					&config.root_canon,
					root_param,
					config.allow_escape,
					&allowed_roots
				)
					.map_err(
						|err| {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								let scope = requested_scope_for_root("read", root_param, config);
								return RequestedScopeError {
									scopes: vec![scope]
								}.into();
							}
							err
						}
					)?;
				if !root_path.exists() {
					return Err(anyhow!("root not found: {}", root_param));
				}
				let root_label = if std::path::Path::new(root_param).is_absolute() {
					root_param.to_string()
				}
				else {
					fs::normalize_relative(root_param)
				};
				let glob = args.get("glob")
					.and_then(Value::as_array)
					.map(
						|values| {
							values.iter()
								.filter_map(Value::as_str)
								.map(|value| value.to_string())
								.collect::<Vec<_>>()
						})
					.unwrap_or_default();
				let case_sensitive = parse_case_sensitivity(args.get("case_sensitive"))?;
				let before_context = args.get("before_context")
					.and_then(Value::as_u64)
					.map(|value| value as usize);
				let after_context = args.get("after_context")
					.and_then(Value::as_u64)
					.map(|value| value as usize);
				let context = args.get("context")
					.and_then(Value::as_u64)
					.map(|value| value as usize);
				let options = fs::SearchOptions {
					glob,
					case_sensitive,
					before_context,
					after_context,
					context,
					max_bytes: config.search_max_bytes,
					summary_top: config.search_summary_top
				};
				fs::rg_search(
					&root_path,
					&root_label,
					pattern,
					options
				).await
			}
		).await,
		"find_files" => run_tool(
			"find_files",
			config,
			None,
			|| async {
				let pattern = args.get("pattern")
					.and_then(Value::as_str)
					.unwrap_or("");
				let root_param = args.get("root")
					.and_then(Value::as_str)
					.unwrap_or(".");
				let root_path = fs::resolve_path(
					&config.root,
					&config.root_canon,
					root_param,
					config.allow_escape,
					&allowed_roots
				)
					.map_err(
						|err| {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								let scope = requested_scope_for_root("read", root_param, config);
								return RequestedScopeError {
									scopes: vec![scope]
								}.into();
							}
							err
						}
					)?;
				if !root_path.exists() {
					return Err(anyhow!("root not found: {}", root_param));
				}
				let file_type = args.get("type")
					.and_then(Value::as_str)
					.map(|value| value.to_string());
				let max_depth = args.get("max_depth")
					.and_then(Value::as_u64)
					.map(|value| value as usize);
				let follow = args.get("follow")
					.and_then(Value::as_bool)
					.unwrap_or(false);
				let glob = args.get("glob")
					.and_then(Value::as_bool)
					.unwrap_or(false);
				let case_sensitive = parse_case_sensitivity(args.get("case_sensitive"))?;
				let exclude = args.get("exclude")
					.and_then(Value::as_array)
					.map(
						|values| {
							values.iter()
								.filter_map(Value::as_str)
								.map(|value| value.to_string())
								.collect::<Vec<_>>()
						})
					.unwrap_or_default();
				let limit = parse_limit(args.get("limit"))?.or(config.find_limit);
				let offset = args.get("offset")
					.and_then(Value::as_u64)
					.unwrap_or(0) as usize;
				let options = fs::FindOptions {
					file_type,
					max_depth,
					follow,
					glob,
					case_sensitive,
					exclude,
					limit,
					offset
				};
				let root_label = if std::path::Path::new(root_param).is_absolute() {
					root_param.to_string()
				}
				else {
					fs::normalize_relative(root_param)
				};
				fs::find(
					&root_path,
					&root_label,
					pattern,
					options
				).await
			}
		).await,
		"read_file" => run_tool(
			"read_file",
			config,
			None,
			|| async {
				let path = args.get("path")
					.and_then(Value::as_str)
					.ok_or_else(|| anyhow!("path is required"))?;
				let start_line = args.get("start_line")
					.and_then(Value::as_u64)
					.unwrap_or(1) as usize;
				let limit = parse_read_limit(args.get("limit"))?.unwrap_or(200);
				let highlight = parse_meta_highlight(meta.get("highlight"));
				let resolved = fs::resolve_path(
					&config.root,
					&config.root_canon,
					path,
					config.allow_escape,
					&allowed_roots
				)
					.map_err(
						|err| {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								let scope = requested_scope_for_path("read", path, config);
								return RequestedScopeError {
									scopes: vec![scope]
								}.into();
							}
							anyhow!("invalid path {}: {}", path, err)
						}
					)?;
				let rel_path = relative_to_root(&config.root, &resolved);
				let max_total = config.read_max_bytes.unwrap_or(usize::MAX);
				let max_line = config.read_max_line_bytes.unwrap_or(usize::MAX);
				if highlight {
					let raw = tokio::fs::read_to_string(&resolved).await.map_err(|err| format_io_error("read", &rel_path, err.into()))?;
					let (lines, count, total, truncated, truncated_reason, long_lines) = fs::format_line_slices(
						&raw,
						start_line,
						limit,
						max_total,
						max_line
					);
					let line_truncated = start_line.saturating_sub(1) + count < total;
					let truncated = truncated || line_truncated;
					let mut rows = String::new();
					let syntax = syntax_for_path(&rel_path);
					let mut hl = ParseState::new(syntax);
					for line in lines {
						let html = highlight_line_html(&mut hl, &line.text);
						rows.push_str(
							&format!(
								"<tr class='eq'><td class='ln'>{}</td><td class='code'><pre><code>{}</code></pre></td></tr>",
								line.number, html
							)
						);
					}
					let mut obj = serde_json::Map::new();
					obj.insert("path".to_string(), Value::String(rel_path));
					obj.insert(
						"content".to_string(),
						Value::String(format!("<table class=\"diff unified\"><tbody>{}</tbody></table>", rows))
					);
					obj.insert("count".to_string(), Value::Number(count.into()));
					obj.insert("total".to_string(), Value::Number(total.into()));
					obj.insert("start_line".to_string(), Value::Number(start_line.into()));
					obj.insert("truncated".to_string(), Value::Bool(truncated));
					if count == 0 && start_line > total && total > 0 {
						obj.insert("code".to_string(), Value::String("EMPTY_RANGE".to_string()));
					}
					if truncated {
						if let Some(reason) = truncated_reason {
							obj.insert("truncated_reason".to_string(), Value::Array(reason));
						}
						else if line_truncated {
							obj.insert("truncated_reason".to_string(), Value::Array(vec![Value::String("line_limit".to_string())]));
						}
					}
					if long_lines {
						obj.insert("code".to_string(), Value::String("TRUNCATED_LONG_LINES".to_string()));
					}
					Ok(Value::Object(obj))
				}
				else {
					let data = fs::read_file(
						&resolved,
						start_line,
						limit,
						max_total,
						max_line
					).await.map_err(|err| format_io_error("read", &rel_path, err))?;
					Ok(
						json!({
							"path": rel_path,
							"content": data.get("content").cloned().unwrap_or(Value::Null),
							"count": data.get("count").cloned().unwrap_or(Value::Null),
							"total": data.get("total").cloned().unwrap_or(Value::Null),
							"start_line": data.get("start_line").cloned().unwrap_or(Value::Null),
							"truncated": data.get("truncated").cloned().unwrap_or(Value::Null),
							"truncated_reason": data.get("truncated_reason").cloned().unwrap_or(Value::Null),
							"code": data.get("code").cloned().unwrap_or(Value::Null)
						})
					)
				}
			}
		).await,
		"read_multiple_files" => run_tool(
			"read_multiple_files",
			config,
			None,
			|| async {
				let paths = args.get("paths").ok_or_else(|| anyhow!("paths is required"))?.as_array()
					.ok_or_else(|| anyhow!("paths must be an array"))?;
				if paths.is_empty() {
					return Err(anyhow!("paths is empty"));
				}
				let max_total = config.read_max_bytes.unwrap_or(usize::MAX);
				let max_line = config.read_max_line_bytes.unwrap_or(usize::MAX);
				let per_file = if max_total == usize::MAX {
					usize::MAX
				}
				else {
					max_total / paths.len().max(1)
				};
				let mut files = Vec::new();
				let mut requested_scopes = Vec::new();
				for path_value in paths {
					let path = match path_value.as_str() {
						Some(value) => value,
						None => continue,
					};
					let resolved = match fs::resolve_path(
						&config.root,
						&config.root_canon,
						path,
						config.allow_escape,
						&allowed_roots
					) {
						Ok(resolved) => resolved,
						Err(err) => {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								requested_scopes.push(requested_scope_for_path("read", path, config));
							}
							let rel_path = relative_to_root(&config.root, &PathBuf::from(path));
							files.push(json!({
								"path": rel_path,
								"code": "INVALID_PATH"
							}));
							continue;
						}
					};
					let rel_path = relative_to_root(&config.root, &resolved);
					match fs::read_file_head(&resolved, per_file, max_line).await {
						Ok((content, count, total, truncated, long_lines)) => {
							let mut entry = serde_json::Map::new();
							entry.insert("path".to_string(), Value::String(rel_path));
							entry.insert("content".to_string(), Value::String(content));
							entry.insert("count".to_string(), Value::Number(count.into()));
							entry.insert("total".to_string(), Value::Number(total.into()));
							entry.insert("truncated".to_string(), Value::Bool(truncated));
							if long_lines {
								entry.insert("code".to_string(), Value::String("TRUNCATED_LONG_LINES".to_string()));
							}
							files.push(Value::Object(entry));
						}
						Err(err) => {
							let code = if let Some(io_err) = err.downcast_ref::<std::io::Error>() {
								if io_err.kind() == std::io::ErrorKind::NotFound {
									"FILE_NOT_FOUND"
								}
								else if io_err.kind() == std::io::ErrorKind::PermissionDenied {
									"PERMISSION_DENIED"
								}
								else {
									"EXECUTION_ERROR"
								}
							}
							else {
								"EXECUTION_ERROR"
							};
							files.push(json!({
								"path": rel_path,
								"code": code
							}));
						}
					}
				}
				if !requested_scopes.is_empty() && !config.allow_escape {
					return Err(RequestedScopeError {
						scopes: requested_scopes
					}.into());
				}
				Ok(json!({
					"files": files
				}))
			}
		).await,
		"move_file" => run_tool(
			"move_file",
			config,
			None,
			|| async {
				let from = args.get("from")
					.and_then(Value::as_str)
					.ok_or_else(|| anyhow!("from is required"))?;
				let to = args.get("to")
					.and_then(Value::as_str)
					.ok_or_else(|| anyhow!("to is required"))?;
				let resolved_from = fs::resolve_path(
					&config.root,
					&config.root_canon,
					from,
					config.allow_escape,
					&allowed_roots
				)
					.map_err(
						|err| {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								let scope = requested_scope_for_path("write", from, config);
								return RequestedScopeError {
									scopes: vec![scope]
								}.into();
							}
							anyhow!("invalid path {}: {}", from, err)
						}
					)?;
				let resolved_to = fs::resolve_path(
					&config.root,
					&config.root_canon,
					to,
					config.allow_escape,
					&allowed_roots
				)
					.map_err(
						|err| {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								let scope = requested_scope_for_path("write", to, config);
								return RequestedScopeError {
									scopes: vec![scope]
								}.into();
							}
							anyhow!("invalid path {}: {}", to, err)
						}
					)?;
				if resolved_from == config.root_canon || resolved_to == config.root_canon {
					return Err(anyhow!("cannot move root"));
				}
				let rel_from = relative_to_root(&config.root, &resolved_from);
				let rel_to = relative_to_root(&config.root, &resolved_to);
				fs::move_path(&resolved_from, &resolved_to).await.map_err(|err| format_io_error("move", &rel_from, err))?;
				Ok(json!({
					"from": rel_from, "to": rel_to
				}))
			}
		).await,
		"delete_file" => run_tool(
			"delete_file",
			config,
			None,
			|| async {
				let path = args.get("path")
					.and_then(Value::as_str)
					.ok_or_else(|| anyhow!("path is required"))?;
				let resolved = fs::resolve_path(
					&config.root,
					&config.root_canon,
					path,
					config.allow_escape,
					&allowed_roots
				)
					.map_err(
						|err| {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								let scope = requested_scope_for_path("write", path, config);
								return RequestedScopeError {
									scopes: vec![scope]
								}.into();
							}
							anyhow!("invalid path {}: {}", path, err)
						}
					)?;
				if resolved == config.root_canon {
					return Err(anyhow!("cannot delete root"));
				}
				let rel_path = relative_to_root(&config.root, &resolved);
				fs::delete_path(&resolved).await.map_err(|err| format_io_error("delete", &rel_path, err))?;
				Ok(json!({
					"path": rel_path
				}))
			}
		).await,
		"write_file" => run_tool(
			"write_file",
			config,
			Some(preview),
			|| async {
				let path = args.get("path")
					.and_then(Value::as_str)
					.ok_or_else(|| anyhow!("path is required"))?;
				let content = args.get("content")
					.and_then(Value::as_str)
					.ok_or_else(|| anyhow!("content is required"))?;
				let mode = args.get("mode")
					.and_then(Value::as_str)
					.unwrap_or("overwrite");
				let apply = !preview;
				let resolved = fs::resolve_path(
					&config.root,
					&config.root_canon,
					path,
					config.allow_escape,
					&allowed_roots
				)
					.map_err(
						|err| {
							if err.to_string().contains("path outside root") && !config.allow_escape {
								let scope = requested_scope_for_path("write", path, config);
								return RequestedScopeError {
									scopes: vec![scope]
								}.into();
							}
							anyhow!("invalid path {}: {}", path, err)
						}
					)?;
				let rel_path = relative_to_root(&config.root, &resolved);
				let data = fs::write_file(
					&resolved,
					content,
					mode,
					apply
				).await.map_err(|err| format_io_error("write", &rel_path, err))?;
				let mut structured = json!({
					"path": rel_path
				});
				if preview {
					let before = data.get("before")
						.and_then(Value::as_str)
						.unwrap_or("");
					let after = data.get("after")
						.and_then(Value::as_str)
						.unwrap_or("");
					let edit_id = uuid::Uuid::new_v4().to_string();
					let review_uri = format!("ui://write_file/{}", edit_id);
					let html = render_diff_html(
						before,
						after,
						&rel_path,
						&review_uri
					);
					let entry = PreviewEntry {
						uri: review_uri,
						html,
						diff: data.get("diff")
							.and_then(Value::as_str)
							.unwrap_or("")
							.to_string(),
						path: structured.get("path")
							.and_then(Value::as_str)
							.unwrap_or("file")
							.to_string()
					};
					let mut cache = PREVIEW_CACHE.lock().expect("preview cache lock");
					cache.insert(entry);
					if let Some(obj) = structured.as_object_mut() {
						obj.insert("edit_id".to_string(), Value::String(edit_id));
					}
				}
				Ok(structured)
			}
		).await,
		"edit_file" => run_tool(
			"edit_file",
			config,
			Some(preview),
			|| async { edit_file_tool(config, &args, preview, &allowed_roots).await }
		).await,
		_ => return Err(ProtocolError::new(-32601, "unknown tool").into()),
	};
	Ok(result)
}
