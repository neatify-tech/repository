// Centralized resolved settings for Rust formatter.
const VALUES = #{
	"max_width": setting("max_width", 100),
	"tab_width": setting("tab_width", 4),
	"indent_style": setting("indent_style", "tabs"),
	"wrap_call_args_min_count": setting("wrap_call_args_min_count", 4),
	"profile": setting("profile", false),
};
export VALUES as values;
