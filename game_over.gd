extends Control

func _ready():
	_build_ui()

func setup(data: Dictionary):
	var years_lbl = find_child("YearsLabel", true, false)
	var reason_lbl = find_child("ReasonLabel", true, false)
	var approval_lbl = find_child("ApprovalLabel", true, false)
	var treasury_lbl = find_child("TreasuryLabel", true, false)
	var rating_lbl = find_child("RatingLabel", true, false)

	if years_lbl:
		years_lbl.text = str(data.get("years", 0)) + " years in power"
	if reason_lbl:
		reason_lbl.text = data.get("reason", "")
	if approval_lbl:
		approval_lbl.text = "Final Approval: " + str(data.get("approval", 0)) + "%"
	if treasury_lbl:
		treasury_lbl.text = "Final Treasury: $" + str(data.get("treasury", 0)) + "B"
	if rating_lbl:
		rating_lbl.text = _get_legacy_rating(data.get("approval", 0), data.get("years", 0))

func _get_legacy_rating(approval: int, years: int) -> String:
	if years >= 16 and approval >= 70:
		return "🏆 LEGENDARY LEADER\nYou will be remembered for generations."
	elif years >= 8 and approval >= 55:
		return "⭐ RESPECTED STATESMAN\nHistory will judge you kindly."
	elif years >= 4 and approval >= 40:
		return "📜 AVERAGE LEADER\nYou kept things together, mostly."
	elif years >= 4:
		return "👎 UNPOPULAR LEADER\nThe people were glad to see you go."
	else:
		return "💀 DISGRACED\nYou didn't last long."

func _build_ui():
	var bg = ColorRect.new()
	bg.color = Color(0.05, 0.06, 0.10)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left = 400
	vbox.offset_right = -400
	vbox.offset_top = 80
	vbox.offset_bottom = -80
	vbox.add_theme_constant_override("separation", 24)
	add_child(vbox)

	var game_over_lbl = Label.new()
	game_over_lbl.text = "GAME OVER"
	game_over_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_lbl.add_theme_font_size_override("font_size", 64)
	game_over_lbl.add_theme_color_override("font_color", Color(0.9, 0.25, 0.25))
	vbox.add_child(game_over_lbl)

	var country_lbl = Label.new()
	country_lbl.text = "Your rule of " + Global.selected_country.get("name", "") + " has ended."
	country_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	country_lbl.add_theme_font_size_override("font_size", 22)
	country_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.8))
	vbox.add_child(country_lbl)

	vbox.add_child(HSeparator.new())

	var reason_lbl = Label.new()
	reason_lbl.name = "ReasonLabel"
	reason_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reason_lbl.add_theme_font_size_override("font_size", 20)
	reason_lbl.add_theme_color_override("font_color", Color(0.95, 0.8, 0.4))
	reason_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(reason_lbl)

	vbox.add_child(HSeparator.new())

	for lbl_name in ["YearsLabel", "ApprovalLabel", "TreasuryLabel"]:
		var lbl = Label.new()
		lbl.name = lbl_name
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_font_size_override("font_size", 20)
		lbl.add_theme_color_override("font_color", Color(0.75, 0.75, 0.9))
		vbox.add_child(lbl)

	vbox.add_child(HSeparator.new())

	var rating_lbl = Label.new()
	rating_lbl.name = "RatingLabel"
	rating_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rating_lbl.add_theme_font_size_override("font_size", 24)
	rating_lbl.add_theme_color_override("font_color", Color(0.9, 0.85, 0.5))
	rating_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(rating_lbl)

	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(spacer)

	var btn_row = HBoxContainer.new()
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_row.add_theme_constant_override("separation", 20)
	vbox.add_child(btn_row)

	var retry_btn = Button.new()
	retry_btn.text = "🔄  PLAY AGAIN"
	retry_btn.custom_minimum_size = Vector2(220, 55)
	retry_btn.add_theme_font_size_override("font_size", 18)
	retry_btn.pressed.connect(func():
		Global.reset()
		get_tree().change_scene_to_file("res://CountrySelect.tscn")
	)
	btn_row.add_child(retry_btn)

	var quit_btn = Button.new()
	quit_btn.text = "❌  QUIT"
	quit_btn.custom_minimum_size = Vector2(220, 55)
	quit_btn.add_theme_font_size_override("font_size", 18)
	quit_btn.pressed.connect(func(): get_tree().quit())
	btn_row.add_child(quit_btn)