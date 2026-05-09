extends Control

var country: Dictionary

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	country = Global.selected_country
	_build_ui()

func _build_ui():
	var bg = ColorRect.new()
	bg.color = Color(0.05, 0.07, 0.11)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var map = TextureRect.new()
	map.set_anchors_preset(Control.PRESET_FULL_RECT)
	map.stretch_mode = TextureRect.STRETCH_SCALE
	var map_tex = load("res://world_map.svg")
	if map_tex:
		map.texture = map_tex
	add_child(map)

	var overlay = ColorRect.new()
	overlay.color = Color(0.0, 0.02, 0.06, 0.88)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -500
	panel.offset_right = 500
	panel.offset_top = -350
	panel.offset_bottom = 350
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.10, 0.16, 1.0)
	style.border_color = Color(0.35, 0.4, 0.6)
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	var header = Label.new()
	header.text = "PRESIDENT'S BRIEFING"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 28)
	header.add_theme_color_override("font_color", Color(0.95, 0.8, 0.3))
	vbox.add_child(header)

	vbox.add_child(HSeparator.new())

	var country_label = Label.new()
	country_label.text = "You are now President of " + country["name"]
	country_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	country_label.add_theme_font_size_override("font_size", 20)
	country_label.add_theme_color_override("font_color", Color(0.9, 0.9, 1.0))
	vbox.add_child(country_label)

	var briefing = _get_briefing_text()
	var brief_label = Label.new()
	brief_label.text = briefing["summary"]
	brief_label.add_theme_font_size_override("font_size", 13)
	brief_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.88))
	brief_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(brief_label)

	vbox.add_child(HSeparator.new())

	var goals_title = Label.new()
	goals_title.text = "YOUR IMMEDIATE PRIORITIES:"
	goals_title.add_theme_font_size_override("font_size", 12)
	goals_title.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6))
	vbox.add_child(goals_title)

	for goal in briefing["goals"]:
		var goal_label = Label.new()
		goal_label.text = "• " + goal
		goal_label.add_theme_font_size_override("font_size", 12)
		goal_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.8))
		goal_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(goal_label)

	vbox.add_child(HSeparator.new())

	var begin_btn = Button.new()
	begin_btn.text = "▶  BEGIN YOUR PRESIDENCY"
	begin_btn.custom_minimum_size = Vector2(0, 50)
	begin_btn.add_theme_font_size_override("font_size", 16)
	begin_btn.pressed.connect(_on_begin)
	vbox.add_child(begin_btn)

func _get_briefing_text() -> Dictionary:
	var gdp = country.get("gdp", 50)
	var military = country.get("military", 50)
	var stability = country.get("stability", 50)

	var summary = ""
	var goals = []

	# Economic situation
	if gdp > 75:
		summary += "Your economy is booming. "
		goals.append("Maintain economic growth and prevent recession")
	elif gdp > 50:
		summary += "Your economy is stable but needs attention. "
		goals.append("Invest in growth and productivity")
	else:
		summary += "Your economy is struggling. This is critical. "
		goals.append("Urgently stimulate economic growth")

	# Military situation
	if military > 75:
		summary += "Your military is strong and well-equipped. "
		goals.append("Maintain military dominance and regional influence")
	elif military > 50:
		summary += "Your military is adequate but aging. "
		goals.append("Consider military modernization")
	else:
		summary += "Your military is weak. Prepare for vulnerability. "
		goals.append("Urgently rebuild military capacity")

	# Stability situation
	if stability > 75:
		summary += "Citizens are content. "
	elif stability > 50:
		summary += "Social stability is moderate. "
	else:
		summary += "The nation is unstable. Unrest is brewing. "

	summary += "Your approval stands at 50%. An election awaits in 4 years."
	goals.append("Build approval before the election (target: 60%+)")

	return {
		"summary": summary,
		"goals": goals
	}

func _on_begin():
	get_tree().change_scene_to_file("res://Maingame.tscn")
