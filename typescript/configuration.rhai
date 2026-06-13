// Centralized resolved settings for TypeScript/JavaScript formatter.
const VALUES = #{
	"max_width": setting("max_width", 100),
	"tab_width": setting("tab_width", 4),
	"indent_style": setting("indent_style", "tabs"),
	"force_single_line_if_block": setting("force_single_line_if_block", true),
	"profile": setting("profile", false),
};
export VALUES as values;
