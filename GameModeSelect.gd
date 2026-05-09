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
	overlay.color = Color(0.0, 0.02, 0.06, 0.82)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	var center = VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.offset_left = -400
	center.offset_right = 400
	center.offset_top = -300
	center.offset_bottom = 300
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 30)
	add_child(center)

	var title = Label.new()
	title.text = "GAME MODE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.35))
	center.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Select how you want to lead"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.6, 0.72))
	center.add_child(subtitle)

	# IRL Mode - Unlocked
	var irl_container = VBoxContainer.new()
	center.add_child(irl_container)

	var irl_btn = Button.new()
	irl_btn.text = "🌍  IRL MODE  (CURRENT)"
	irl_btn.custom_minimum_size = Vector2(600, 70)
	irl_btn.add_theme_font_size_override("font_size", 18)
	var irl_style = StyleBoxFlat.new()
	irl_style.bg_color = Color(0.15, 0.35, 0.15)
	irl_style.border_color = Color(0.3, 0.7, 0.3)
	irl_style.set_border_width_all(2)
	irl_style.set_corner_radius_all(8)
	irl_btn.add_theme_stylebox_override("normal", irl_style)
	irl_btn.pressed.connect(_on_irl_mode)
	irl_container.add_child(irl_btn)

	var irl_desc = Label.new()
	irl_desc.text = "📰 Real-world news integration: Global events from BBC News impact your country"
	irl_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	irl_desc.add_theme_font_size_override("font_size", 12)
	irl_desc.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	irl_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	irl_container.add_child(irl_desc)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	center.add_child(spacer)

	# Locked Modes
	var modes = [
		{"name": "SANDBOX MODE", "desc": "Unlimited treasury, no elections, no approval loss"},
		{"name": "CHALLENGE MODE", "desc": "Hard mode with aggressive AI and double crisis frequency"},
		{"name": "HISTORICAL MODE", "desc": "Lead real countries through actual historical events"},
	]

	for mode in modes:
		_add_locked_mode(center, mode["name"], mode["desc"])

	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 20)
	center.add_child(spacer2)

	var back_btn = Button.new()
	back_btn.text = "← BACK TO MENU"
	back_btn.custom_minimum_size = Vector2(600, 50)
	back_btn.add_theme_font_size_override("font_size", 14)
	var back_style = StyleBoxFlat.new()
	back_style.bg_color = Color(0.12, 0.12, 0.18)
	back_style.border_color = Color(0.25, 0.25, 0.35)
	back_style.set_border_width_all(1)
	back_style.set_corner_radius_all(6)
	back_btn.add_theme_stylebox_override("normal", back_style)
	back_btn.pressed.connect(_on_back)
	center.add_child(back_btn)

func _add_locked_mode(parent: Node, name: String, desc: String):
	var container = VBoxContainer.new()
	parent.add_child(container)

	var btn = Button.new()
	btn.text = "🔒  " + name
	btn.custom_minimum_size = Vector2(600, 60)
	btn.add_theme_font_size_override("font_size", 16)
	btn.disabled = true
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.15)
	style.border_color = Color(0.2, 0.2, 0.25)
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6))
	container.add_child(btn)

	var desc_lbl = Label.new()
	desc_lbl.text = "Coming soon · " + desc
	desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_lbl.add_theme_font_size_override("font_size", 11)
	desc_lbl.add_theme_color_override("font_color", Color(0.4, 0.4, 0.5))
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	container.add_child(desc_lbl)

func _on_irl_mode():
	get_tree().change_scene_to_file("res://CountrySelect.tscn")

func _on_back():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
