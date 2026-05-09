extends Control

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
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
	overlay.color = Color(0.0, 0.02, 0.06, 0.85)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	var center = VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.offset_left = -350
	center.offset_right = 350
	center.offset_top = -250
	center.offset_bottom = 250
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 20)
	add_child(center)

	var title = Label.new()
	title.text = Global.selected_country["name"].to_upper()
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.35))
	center.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Your new government awaits"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.6, 0.72))
	center.add_child(subtitle)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	center.add_child(spacer)

	var stats_label = Label.new()
	var country = Global.selected_country
	stats_label.text = "⚡ Economy: %d  |  ⚔️ Military: %d  |  👥 Pop: %d  |  🏛️ Stability: %d" % [
		country.get("gdp", 50),
		country.get("military", 50),
		country.get("population", 50),
		country.get("stability", 50)
	]
	stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats_label.add_theme_font_size_override("font_size", 14)
	stats_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.85))
	center.add_child(stats_label)

	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 30)
	center.add_child(spacer2)

	var begin_btn = _make_btn("▶  BEGIN YOUR TERM", Color(0.15, 0.35, 0.15))
	begin_btn.pressed.connect(_on_begin_game)
	center.add_child(begin_btn)

	var back_btn = _make_btn("← CHOOSE DIFFERENT COUNTRY", Color(0.20, 0.20, 0.30))
	back_btn.pressed.connect(_on_back_to_select)
	center.add_child(back_btn)

func _make_btn(text: String, bg_color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(350, 50)
	btn.add_theme_font_size_override("font_size", 16)
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = bg_color.lightened(0.3)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	btn.add_theme_stylebox_override("normal", style)
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = bg_color.lightened(0.15)
	hover_style.border_color = bg_color.lightened(0.4)
	hover_style.set_border_width_all(1)
	hover_style.set_corner_radius_all(6)
	btn.add_theme_stylebox_override("hover", hover_style)
	return btn

func _on_begin_game():
	Global.game_date = {"month": 1, "year": 2024}
	Global.treasury = 1000
	Global.approval = 50
	Global.months_in_power = 0
	Global.at_war = false
	get_tree().change_scene_to_file("res://GameStartBriefing.tscn")

func _on_back_to_select():
	get_tree().change_scene_to_file("res://CountrySelect.tscn")
