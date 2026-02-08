# Tree-sitter Binaries

Place platform-specific Tree-sitter binaries here.

Expected layout:

```
core/treesitter/<os>/<arch>/<language>.<ext>
```

Examples:

- `core/treesitter/linux/x86_64/java.so`
- `core/treesitter/darwin/arm64/javascript.dylib`
- `core/treesitter/windows/x86_64/rust.dll`

## Source of Tree-sitter Grammars

Use official Tree-sitter language repositories and prefer the upstream `main` branch wherever possible.

If a fork or pinned revision is required, document the source and reason in `REGISTRY.md` under "Core Registry: Tree-sitter Sources".
