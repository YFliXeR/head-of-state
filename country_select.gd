extends Control

const COUNTRIES = [
	{"name": "United States", "flag": "USA", "gdp": 95, "military": 95, "population": 60, "stability": 70},
	{"name": "China", "flag": "CN", "gdp": 85, "military": 88, "population": 99, "stability": 65},
	{"name": "Egypt", "flag": "EG", "gdp": 40, "military": 55, "population": 65, "stability": 50},
	{"name": "Germany", "flag": "DE", "gdp": 80, "military": 60, "population": 50, "stability": 90},
	{"name": "Brazil", "flag": "BR", "gdp": 55, "military": 50, "population": 80, "stability": 45},
	{"name": "Russia", "flag": "RU", "gdp": 50, "military": 85, "population": 55, "stability": 55},
	{"name": "India", "flag": "IN", "gdp": 60, "military": 70, "population": 98, "stability": 60},
	{"name": "Nigeria", "flag": "NG", "gdp": 30, "military": 35, "population": 75, "stability": 35},
]

var selected_country = null
var start_button: Button

func _ready():
	_build_ui()

func _build_ui():
	var bg = ColorRect.new()
	bg.color = Color(0.08, 0.10, 0.14)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var title = Label.new()
	title.text = "HEAD OF STATE"
	title.set_anchors_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 40
	title.offset_bottom = 105
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Choose your country"
	subtitle.set_anchors_preset(Control.PRESET_TOP_WIDE)
	subtitle.offset_top = 108
	subtitle.offset_bottom = 145
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 20)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	add_child(subtitle)

	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.offset_top = 155
	center.offset_bottom = -90
	add_child(center)

	var grid = GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 20)
	center.add_child(grid)

	for country in COUNTRIES:
		grid.add_child(_make_card(country))

	var btn_container = HBoxContainer.new()
	btn_container.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	btn_container.offset_top = -78
	btn_container.offset_bottom = -22
	btn_container.offset_left = 200
	btn_container.offset_right = -200
	btn_container.add_theme_constant_override("separation", 20)
	btn_container.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(btn_container)

	var back_btn = Button.new()
	back_btn.text = "← BACK"
	back_btn.custom_minimum_size = Vector2(200, 56)
	back_btn.add_theme_font_size_override("font_size", 16)
	var back_style = StyleBoxFlat.new()
	back_style.bg_color = Color(0.15, 0.15, 0.22)
	back_style.border_color = Color(0.28, 0.28, 0.38)
	back_style.set_border_width_all(1)
	back_style.set_corner_radius_all(6)
	back_btn.add_theme_stylebox_override("normal", back_style)
	back_btn.pressed.connect(_on_back)
	btn_container.add_child(back_btn)

	var start_btn = Button.new()
	start_btn.name = "StartButton"
	start_btn.text = "SELECT A COUNTRY TO BEGIN"
	start_btn.custom_minimum_size = Vector2(400, 56)
	start_btn.add_theme_font_size_override("font_size", 18)
	start_btn.disabled = true
	start_btn.pressed.connect(_on_start_pressed)
	btn_container.add_child(start_btn)
	start_button = start_btn

func _make_card(country: Dictionary) -> PanelContainer:
	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(280, 210)

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.10, 0.16, 1.0)
	style.border_color = Color(0.25, 0.28, 0.38)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	card.add_theme_stylebox_override("panel", style)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	card.add_child(vbox)

	var name_label = Label.new()
	name_label.text = country["flag"] + "  " + country["name"]
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.add_theme_color_override("font_color", Color(0.95, 0.95, 1.0))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(name_label)

	vbox.add_child(HSeparator.new())

	var stats = [
		["⚡ Economy", country["gdp"]],
		["⚔️ Military", country["military"]],
		["👥 Population", country["population"]],
		["🏛️ Stability", country["stability"]],
	]
	for stat in stats:
		vbox.add_child(_make_stat_bar(stat[0], stat[1]))

	var btn = Button.new()
	btn.flat = true
	btn.set_anchors_preset(Control.PRESET_FULL_RECT)
	btn.pressed.connect(_on_country_selected.bind(country, card))
	card.add_child(btn)

	return card

func _make_stat_bar(label_text: String, value: int) -> HBoxContainer:
	var hbox = HBoxContainer.new()

	var lbl = Label.new()
	lbl.text = label_text
	lbl.custom_minimum_size = Vector2(130, 0)
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.8))
	hbox.add_child(lbl)

	var bar_bg = PanelContainer.new()
	bar_bg.custom_minimum_size = Vector2(100, 12)
	bar_bg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var bar_style = StyleBoxFlat.new()
	bar_style.bg_color = Color(0.2, 0.2, 0.3)
	bar_style.set_corner_radius_all(4)
	bar_bg.add_theme_stylebox_override("panel", bar_style)

	var bar_fill = PanelContainer.new()
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = _stat_color(value)
	fill_style.set_corner_radius_all(4)
	bar_fill.add_theme_stylebox_override("panel", fill_style)
	bar_fill.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar_fill.custom_minimum_size = Vector2(value, 12)
	bar_bg.add_child(bar_fill)

	hbox.add_child(bar_bg)
	return hbox

func _stat_color(value: int) -> Color:
	if value >= 75:
		return Color(0.2, 0.8, 0.4)
	elif value >= 45:
		return Color(0.9, 0.7, 0.2)
	else:
		return Color(0.8, 0.3, 0.3)

func _on_country_selected(country: Dictionary, card: PanelContainer):
	selected_country = country.duplicate()
	start_button.text = "▶  LEAD " + country["name"].to_upper()
	start_button.disabled = false

func _on_start_pressed():
	if selected_country:
		Global.selected_country = selected_country.duplicate()
		get_tree().change_scene_to_file("res://MainGameMenu.tscn")

func _on_back():
	get_tree().change_scene_to_file("res://GameModeSelect.tscn")
