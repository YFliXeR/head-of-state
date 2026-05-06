extends Control

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	_build_ui()

func _build_ui():
	var bg = ColorRect.new()
	bg.color = Color(0.05, 0.07, 0.11)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Background map texture
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
	center.offset_left = -300
	center.offset_right = 300
	center.offset_top = -280
	center.offset_bottom = 280
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 24)
	add_child(center)

	var title = Label.new()
	title.text = "HEAD OF STATE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 72)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.35))
	center.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Lead a nation. Shape history."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 20)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.6, 0.72))
	center.add_child(subtitle)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 30)
	center.add_child(spacer)

	var play_btn = _make_btn("▶   NEW GAME", Color(0.15, 0.35, 0.15))
	play_btn.pressed.connect(func():
		Global.reset()
		get_tree().change_scene_to_file("res://CountrySelect.tscn")
	)
	center.add_child(play_btn)

	var how_btn = _make_btn("📖   HOW TO PLAY", Color(0.12, 0.18, 0.30))
	how_btn.pressed.connect(_show_how_to_play)
	center.add_child(how_btn)

	var quit_btn = _make_btn("✕   QUIT", Color(0.28, 0.10, 0.10))
	quit_btn.pressed.connect(func(): get_tree().quit())
	center.add_child(quit_btn)

	var version = Label.new()
	version.text = "v0.1 Early Build"
	version.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	version.offset_left = -200
	version.offset_top = -40
	version.offset_right = -20
	version.offset_bottom = -10
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	version.add_theme_font_size_override("font_size", 13)
	version.add_theme_color_override("font_color", Color(0.4, 0.4, 0.5))
	add_child(version)

	_build_how_to_play_panel()

func _make_btn(text: String, bg_color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(400, 60)
	btn.add_theme_font_size_override("font_size", 20)
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

func _build_how_to_play_panel():
	var overlay = ColorRect.new()
	overlay.name = "HowOverlay"
	overlay.color = Color(0, 0, 0, 0.88)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	add_child(overlay)

	var panel = PanelContainer.new()
	panel.name = "HowPanel"
	panel.visible = false
	panel.position = Vector2(360, 80)
	panel.size = Vector2(1200, 800)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.10, 0.16, 1.0)
	style.border_color = Color(0.35, 0.4, 0.6)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	var header = Label.new()
	header.text = "📖  HOW TO PLAY"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 28)
	header.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	vbox.add_child(header)

	vbox.add_child(HSeparator.new())

	var grid = GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 40)
	grid.add_theme_constant_override("v_separation", 20)
	vbox.add_child(grid)

	var tips = [
		["🌍 PICK YOUR COUNTRY", "Each country starts with different stats. Strong military, weak economy — or stable but poor. Your starting position shapes your strategy."],
		["📅 NEXT MONTH", "Advance time each month. Your treasury and approval shift automatically based on your decisions and world events."],
		["⚡ DECISIONS", "Every 2 months a crisis hits. Your choices have real tradeoffs — money vs approval vs stability. Choose carefully."],
		["📰 REAL NEWS", "Every 3 months the game fetches real BBC headlines. Wars, recessions and disasters abroad actually affect your stats."],
		["🤝 DIPLOMACY", "Click any country pin on the map to trade, form alliances or impose sanctions. Your relationships matter."],
		["⚔️ WAR", "Declare war from the diplomacy panel. Wars last up to 6 months. You make tactical decisions each month — offensive, defensive or negotiate."],
		["🗳️ ELECTIONS", "Every 4 years you face an election. High approval = high chance of winning. Lose and it's game over."],
		["💀 GAME OVER", "Approval hitting 0 means a coup. Losing an election ends your term. Build your legacy before time runs out."],
	]

	for tip in tips:
		var tip_vbox = VBoxContainer.new()
		tip_vbox.add_theme_constant_override("separation", 6)
		grid.add_child(tip_vbox)

		var tip_title = Label.new()
		tip_title.text = tip[0]
		tip_title.add_theme_font_size_override("font_size", 16)
		tip_title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
		tip_vbox.add_child(tip_title)

		var tip_body = Label.new()
		tip_body.text = tip[1]
		tip_body.add_theme_font_size_override("font_size", 13)
		tip_body.add_theme_color_override("font_color", Color(0.7, 0.7, 0.82))
		tip_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		tip_vbox.add_child(tip_body)

	vbox.add_child(HSeparator.new())

	var close_btn = Button.new()
	close_btn.text = "✕  CLOSE"
	close_btn.custom_minimum_size = Vector2(0, 48)
	close_btn.add_theme_font_size_override("font_size", 16)
	close_btn.pressed.connect(func():
		find_child("HowOverlay", true, false).visible = false
		find_child("HowPanel", true, false).visible = false
	)
	vbox.add_child(close_btn)

func _show_how_to_play():
	find_child("HowOverlay", true, false).visible = true
	find_child("HowPanel", true, false).visible = true