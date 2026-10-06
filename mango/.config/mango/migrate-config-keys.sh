#!/usr/bin/env bash
#
# migrate-config-keys.sh - normalize mangowm config keys to snake_case.
#
# Renames the legacy run-together config keys to their split, underscore
# separated form (option keys, rule types and directives alike). Point it at a
# folder and it recurses through it, rewriting every match in the files it
# targets (default: *.conf, *.toml and *.sh).
#
set -euo pipefail

# old=new pairs, applied on whole-word boundaries.
RENAMES=(
	# rule types and directives
	'windowrule-once=window_rule_once'
	'windowrule=window_rule'
	'monitorrule=monitor_rule'
	'tagrule=tag_rule'
	'layerrule=layer_rule'
	'devicerule=device_rule'
	'source-optional=source_optional'
	'exec-once=exec_once'
	'keymode=key_mode'
	# no_* flags
	'isnoborder=no_border'
	'isnoshadow=no_shadow'
	'isnoradius=no_radius'
	'isnoanimation=no_animation'
	'isnosizehint=no_size_hint'
	'noblur=no_blur'
	'noshadow=no_shadow'
	'noanim=no_animation'
	'nofocus=no_focus'
	'nofadein=no_fade_in'
	'nofadeout=no_fade_out'
	'noswallow=no_swallow'
	# gaps, master/stack, animation
	'special_gappih=special_gap_inner_horizontal'
	'special_gappiv=special_gap_inner_vertical'
	'special_gappoh=special_gap_outer_horizontal'
	'special_gappov=special_gap_outer_vertical'
	'gappih=gap_inner_horizontal'
	'gappiv=gap_inner_vertical'
	'gappoh=gap_outer_horizontal'
	'gappov=gap_outer_vertical'
	'overviewgappi=overview_gap_inner'
	'overviewgappo=overview_gap_outer'
	'default_mfact=default_master_factor'
	'default_nmaster=default_master_count'
	'animation_curve_opafadein=animation_curve_opacity_fade_in'
	'animation_curve_opafadeout=animation_curve_opacity_fade_out'
	'dwindle_hsplit=dwindle_horizontal_split'
	'dwindle_vsplit=dwindle_vertical_split'
	'fadein_begin_opacity=fade_in_begin_opacity'
	'fadeout_begin_opacity=fade_out_begin_opacity'
	# misc run-together keys
	'focusdir_only_zone_overlap=focus_direction_only_zone_overlap'
	'force_fakemaximize=force_fake_maximize'
	'idleinhibit_ignore_visible=idle_inhibit_ignore_visible'
	'idleinhibit_when_focus=idle_inhibit_when_focus'
	'idleinhibit_when_fullscreen=idle_inhibit_when_fullscreen'
	'syncobj_enable=sync_obj_enable'
	'isfakefullscreen=is_fake_fullscreen'
	'isfloating=is_floating'
	'isfullscreen=is_fullscreen'
	'isunglobal=is_unmanaged_global'
	'isglobal=is_global'
	'isnamedscratchpad=is_named_scratchpad'
	'isopensilent=is_open_silent'
	'isoverlay=is_overlay'
	'istagsilent=is_tag_silent'
	'isterm=is_term'
	'appid=app_id'
	'bordercolor=border_color'
	'borderpx=border_px'
	'dropcolor=drop_color'
	'focuscolor=focus_color'
	'globalcolor=global_color'
	'globalkeybinding=global_key_binding'
	'maximizescreencolor=maximized_screen_color'
	'mfact=master_factor'
	'nmaster=master_count'
	'numlockon=numlock_on'
	'offsetx=offset_x'
	'offsety=offset_y'
	'overlaycolor=overlay_color'
	'rootcolor=root_color'
	'scratchpadcolor=scratchpad_color'
	'shadowscolor=shadows_color'
	'sloppyfocus=sloppy_focus'
	'smartgaps=smart_gaps'
	'splitcolor=split_color'
	'urgentcolor=urgent_color'
	'warpcursor=warp_cursor'
)

usage() {
	cat <<'EOF'
Usage: migrate-config-keys.sh [OPTIONS] [DIRECTORY]

Rewrite legacy mangowm config keys to their split, underscore-separated names.
DIRECTORY defaults to the current folder and is searched recursively. Works on
both conf and TOML configs.

Options:
  -n, --dry-run     Only list the files that would change.
  -b, --backup      Keep a "<file>.bak" copy before rewriting.
  -e, --ext LIST    Comma-separated extensions to scan (default: conf,toml,sh).
      --all         Scan every text file, not just the configured extensions.
  -h, --help        Show this help.

Examples:
  ./migrate-config-keys.sh
  ./migrate-config-keys.sh ~/.config/mango
  ./migrate-config-keys.sh -n ~/.config/mango
  ./migrate-config-keys.sh -b -e conf,toml .
EOF
}

dir="."
dry_run=false
backup=false
all_files=false
ext_list="conf,toml,sh"

while (($#)); do
	case "$1" in
	-n | --dry-run) dry_run=true ;;
	-b | --backup) backup=true ;;
	--all) all_files=true ;;
	-e | --ext)
		ext_list="${2:?missing argument for $1}"
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	-*)
		echo "error: unknown option: $1" >&2
		usage >&2
		exit 2
		;;
	*) dir="$1" ;;
	esac
	shift
done

if [[ ! -d "$dir" ]]; then
	echo "error: not a directory: $dir" >&2
	exit 1
fi

script_path="$(realpath -- "$0")"

# Build the find expression: either every text file, or a set of extensions.
find_args=(-type f ! -name '*.bak')
if [[ "$all_files" == true ]]; then
	# Never rewrite status bar / desktop configs: their keys only
	# look similar (e.g. "mango/keymode") but are a different API.
	find_args+=(
		! -path '*/.git/*'
		! -path '*/node_modules/*'
		! -path '*/waybar/*'
		! -path '*/mangobar/*'
		! -name '*.json'
		! -name '*.jsonc'
		! -name '*.css'
	)
else
	name_expr=()
	IFS=',' read -r -a exts <<<"$ext_list"
	for ext in "${exts[@]}"; do
		ext="${ext#.}"
		[[ -z "$ext" ]] && continue
		((${#name_expr[@]})) && name_expr+=(-o)
		name_expr+=(-name "*.${ext}")
	done
	if ((${#name_expr[@]})); then
		find_args+=("(" "${name_expr[@]}" ")")
	fi
fi

# Build a single perl program. Each key is only replaced when it is not glued to
# another identifier, hyphen, slash or "#", so values such as "my-appid",
# Waybar module names like "mango/keymode" and CSS ids like "#keymode" are left
# untouched.
perl_prog=""
for pair in "${RENAMES[@]}"; do
	old="${pair%%=*}"
	new="${pair#*=}"
	perl_prog+="s{(?<![-/\\w#])\\Q${old}\\E(?![\\w#/-])}{${new}}g;"
done

changed=0
while IFS= read -r -d '' file; do
	fp="$(realpath -- "$file")"
	[[ "$fp" == "$script_path" ]] && continue # never rewrite this script
	[[ "$(basename -- "$file")" == "migrate-config-keys.sh" ]] && continue
	grep -Iq . "$file" 2>/dev/null || continue # skip binaries and empty files
	perl -pe "$perl_prog" -- "$file" | cmp -s -- "$file" - && continue

	if [[ "$dry_run" == true ]]; then
		printf 'would update: %s\n' "$file"
	else
		if [[ "$backup" == true ]]; then
			perl -i.bak -pe "$perl_prog" -- "$file"
		else
			perl -i -pe "$perl_prog" -- "$file"
		fi
		printf 'updated: %s\n' "$file"
	fi
	changed=$((changed + 1))
done < <(find "$dir" "${find_args[@]}" -print0)

if [[ "$dry_run" == true ]]; then
	echo "${changed} file(s) would change."
else
	echo "${changed} file(s) updated."
fi
