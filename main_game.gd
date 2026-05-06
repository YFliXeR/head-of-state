extends Control

var COUNTRY_PINS = [
	{"name": "United States", "px": 0.15, "py": 0.30, "gdp": 95, "military": 95, "population": 60, "stability": 70},
	{"name": "China", "px": 0.78, "py": 0.35, "gdp": 85, "military": 88, "population": 99, "stability": 65},
	{"name": "Egypt", "px": 0.55, "py": 0.42, "gdp": 40, "military": 55, "population": 65, "stability": 50},
	{"name": "Germany", "px": 0.50, "py": 0.28, "gdp": 80, "military": 60, "population": 50, "stability": 90},
	{"name": "Brazil", "px": 0.28, "py": 0.80, "gdp": 55, "military": 50, "population": 80, "stability": 45},
	{"name": "Russia", "px": 0.67, "py": 0.10, "gdp": 50, "military": 85, "population": 55, "stability": 55},
	{"name": "India", "px": 0.72, "py": 0.45, "gdp": 60, "military": 70, "population": 98, "stability": 60},
	{"name": "Nigeria", "px": 0.50, "py": 0.55, "gdp": 30, "military": 35, "population": 75, "stability": 35},
]

const MINISTER_ROLES = ["Finance", "Defense", "Foreign Affairs", "Interior"]
const MINISTER_REPORTS = {
	"Finance": ["Economy is stable.", "Markets are volatile.", "Growth is strong.", "Debt is rising."],
	"Defense": ["Military is ready.", "Tensions are high.", "Forces need upgrades.", "Border is secure."],
	"Foreign Affairs": ["No active conflicts.", "Trade deal pending.", "Allies are restless.", "Sanctions incoming."],
	"Interior": ["Public mood is neutral.", "Protests reported.", "Citizens are content.", "Crime rates rising."],
}

const DECISIONS = [
	{
		"title": "Infrastructure Crisis",
		"description": "Your roads and bridges are deteriorating. Citizens are frustrated.",
		"choices": [
			{"text": "Invest heavily in repairs", "effects": {"treasury": -120, "approval": 8, "stability": 5}},
			{"text": "Patch the worst areas only", "effects": {"treasury": -40, "approval": 2, "stability": 1}},
			{"text": "Ignore it for now", "effects": {"treasury": 0, "approval": -6, "stability": -3}},
		]
	},
	{
		"title": "Teacher Strike",
		"description": "Teachers across the country are demanding higher wages and better conditions.",
		"choices": [
			{"text": "Meet their demands fully", "effects": {"treasury": -80, "approval": 10, "stability": 4}},
			{"text": "Offer a partial raise", "effects": {"treasury": -30, "approval": 3, "stability": 2}},
			{"text": "Refuse and send police", "effects": {"treasury": 0, "approval": -10, "stability": -6}},
		]
	},
	{
		"title": "Foreign Investment Offer",
		"description": "A foreign corporation wants to build factories in your country.",
		"choices": [
			{"text": "Welcome them with tax breaks", "effects": {"treasury": -20, "approval": 4, "gdp": 5}},
			{"text": "Allow them with full taxation", "effects": {"treasury": 60, "approval": 1, "gdp": 2}},
			{"text": "Reject the offer", "effects": {"treasury": 0, "approval": -2, "gdp": -1}},
		]
	},
	{
		"title": "Corruption Scandal",
		"description": "A senior minister has been caught embezzling public funds.",
		"choices": [
			{"text": "Fire and prosecute them publicly", "effects": {"treasury": 20, "approval": 8, "stability": -2}},
			{"text": "Quietly remove them", "effects": {"treasury": 0, "approval": -3, "stability": 2}},
			{"text": "Deny everything", "effects": {"treasury": 0, "approval": -12, "stability": -5}},
		]
	},
	{
		"title": "Natural Disaster",
		"description": "Floods have devastated a coastal region. Thousands are displaced.",
		"choices": [
			{"text": "Deploy full emergency response", "effects": {"treasury": -150, "approval": 14, "stability": 3}},
			{"text": "Send limited aid", "effects": {"treasury": -50, "approval": 4, "stability": 0}},
			{"text": "Declare it a local issue", "effects": {"treasury": 0, "approval": -15, "stability": -8}},
		]
	},
	{
		"title": "Military Budget Review",
		"description": "Your generals are requesting a significant increase in defense spending.",
		"choices": [
			{"text": "Grant the full increase", "effects": {"treasury": -100, "military": 8, "approval": -3}},
			{"text": "Grant a modest increase", "effects": {"treasury": -40, "military": 3, "approval": 0}},
			{"text": "Cut military spending instead", "effects": {"treasury": 80, "military": -5, "approval": 2}},
		]
	},
	{
		"title": "Tax Reform Proposal",
		"description": "Your finance minister proposes raising taxes on the wealthy.",
		"choices": [
			{"text": "Implement progressive tax hike", "effects": {"treasury": 120, "approval": 6, "gdp": -3}},
			{"text": "Small tax adjustment only", "effects": {"treasury": 40, "approval": 2, "gdp": -1}},
			{"text": "Reject — lower taxes instead", "effects": {"treasury": -60, "approval": -3, "gdp": 4}},
		]
	},
	{
		"title": "Press Freedom Debate",
		"description": "Journalists are publishing critical reports about your government.",
		"choices": [
			{"text": "Protect press freedom fully", "effects": {"approval": 7, "stability": 4, "treasury": 0}},
			{"text": "Regulate media partially", "effects": {"approval": -4, "stability": 2, "treasury": 0}},
			{"text": "Crack down on critical outlets", "effects": {"approval": -10, "stability": -5, "treasury": 0}},
		]
	},
	{
		"title": "Healthcare Crisis",
		"description": "Hospitals are overwhelmed. Doctors are leaving the country.",
		"choices": [
			{"text": "Massive investment in healthcare", "effects": {"treasury": -140, "approval": 12, "stability": 4}},
			{"text": "Recruit foreign doctors", "effects": {"treasury": -50, "approval": 5, "stability": 2}},
			{"text": "Ignore — private sector will handle it", "effects": {"treasury": 0, "approval": -8, "stability": -4}},
		]
	},
	{
		"title": "Student Protests",
		"description": "University students are flooding the streets demanding free education.",
		"choices": [
			{"text": "Subsidise tuition fully", "effects": {"treasury": -90, "approval": 9, "stability": 5}},
			{"text": "Offer partial grants", "effects": {"treasury": -35, "approval": 3, "stability": 2}},
			{"text": "Deploy riot police", "effects": {"treasury": -10, "approval": -11, "stability": -7}},
		]
	},
	{
		"title": "Energy Shortage",
		"description": "Rolling blackouts are hitting cities. Industry is slowing down.",
		"choices": [
			{"text": "Emergency energy imports", "effects": {"treasury": -100, "approval": 6, "gdp": 3}},
			{"text": "Invest in renewables long-term", "effects": {"treasury": -60, "approval": 4, "stability": 3}},
			{"text": "Ration power to industry only", "effects": {"treasury": 0, "approval": -7, "gdp": -3}},
		]
	},
	{
		"title": "Drug Epidemic",
		"description": "A surge in drug use is devastating communities across the country.",
		"choices": [
			{"text": "Fund rehabilitation centres", "effects": {"treasury": -70, "approval": 7, "stability": 4}},
			{"text": "Harsh crackdown and arrests", "effects": {"treasury": -30, "approval": -3, "stability": -2}},
			{"text": "Decriminalise and regulate", "effects": {"treasury": 20, "approval": 2, "stability": 3}},
		]
	},
	{
		"title": "Diplomatic Incident",
		"description": "Your ambassador made controversial comments abroad, sparking outrage.",
		"choices": [
			{"text": "Issue formal apology", "effects": {"approval": 4, "stability": 3, "treasury": 0}},
			{"text": "Defend the ambassador publicly", "effects": {"approval": -5, "stability": -4, "treasury": 0}},
			{"text": "Quietly recall and replace them", "effects": {"approval": 1, "stability": 2, "treasury": -10}},
		]
	},
	{
		"title": "Prison Overcrowding",
		"description": "Your prisons are at 180% capacity. Human rights groups are alarmed.",
		"choices": [
			{"text": "Build new facilities", "effects": {"treasury": -110, "approval": 3, "stability": 4}},
			{"text": "Early release non-violent offenders", "effects": {"treasury": 0, "approval": -4, "stability": 2}},
			{"text": "Ignore the problem", "effects": {"treasury": 0, "approval": -6, "stability": -4}},
		]
	},
	{
		"title": "Tech Company Monopoly",
		"description": "A single tech giant controls 80% of your country's internet and data.",
		"choices": [
			{"text": "Break up the company", "effects": {"treasury": 30, "approval": 8, "gdp": -2}},
			{"text": "Regulate but allow to operate", "effects": {"treasury": 40, "approval": 3, "gdp": 1}},
			{"text": "Allow — they create jobs", "effects": {"treasury": 0, "approval": -4, "gdp": 4}},
		]
	},
	{
		"title": "Aging Population",
		"description": "More retirees, fewer workers. The pension system is under severe strain.",
		"choices": [
			{"text": "Raise retirement age", "effects": {"treasury": 60, "approval": -9, "stability": -3}},
			{"text": "Increase immigration to fill gaps", "effects": {"treasury": 20, "approval": -4, "stability": -2}},
			{"text": "Increase pension funding", "effects": {"treasury": -100, "approval": 10, "stability": 3}},
		]
	},
	{
		"title": "Flood Defence Failure",
		"description": "Ageing flood barriers have failed. Several towns are underwater.",
		"choices": [
			{"text": "Full emergency reconstruction", "effects": {"treasury": -130, "approval": 10, "stability": 4}},
			{"text": "Temporary repairs only", "effects": {"treasury": -40, "approval": 2, "stability": 1}},
			{"text": "Relocate affected residents", "effects": {"treasury": -60, "approval": -5, "stability": -2}},
		]
	},
	{
		"title": "Space Programme Proposal",
		"description": "Scientists want to launch a national space agency. Costly but prestigious.",
		"choices": [
			{"text": "Fund the full programme", "effects": {"treasury": -150, "approval": 7, "gdp": 5}},
			{"text": "Join a multinational effort instead", "effects": {"treasury": -40, "approval": 4, "gdp": 2}},
			{"text": "Reject — too expensive", "effects": {"treasury": 0, "approval": -3, "gdp": -1}},
		]
	},
	{
		"title": "Minimum Wage Debate",
		"description": "Labour unions are demanding a 40% increase in the minimum wage.",
		"choices": [
			{"text": "Grant the full increase", "effects": {"treasury": -50, "approval": 11, "gdp": -3}},
			{"text": "Compromise at 20% increase", "effects": {"treasury": -20, "approval": 5, "gdp": -1}},
			{"text": "Reject — let market decide", "effects": {"treasury": 0, "approval": -8, "gdp": 2}},
		]
	},
	{
		"title": "Famine Warning",
		"description": "Crop failures in rural regions are threatening food security.",
		"choices": [
			{"text": "Emergency food imports + subsidies", "effects": {"treasury": -120, "approval": 13, "stability": 5}},
			{"text": "Open food banks in affected areas", "effects": {"treasury": -45, "approval": 6, "stability": 2}},
			{"text": "Declare it a regional problem", "effects": {"treasury": 0, "approval": -14, "stability": -8}},
		]
	},
]

var portrait_paths: Array = []
var selected_pin_country = null
var event_log_node: VBoxContainer
var stats_labels = {}
var http_request: HTTPRequest
var popup_open: bool = false

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	portrait_paths = _get_portrait_paths()
	_build_ui()

func _get_portrait_paths() -> Array:
	var paths = []
	var dir = DirAccess.open("res://portraits")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".png") and not file.begins_with("."):
				paths.append("res://portraits/" + file)
				if paths.size() >= 4:
					break
			file = dir.get_next()
		dir.list_dir_end()
	return paths

func _pin_to_screen(px: float, py: float) -> Vector2:
	var screen_size = get_viewport_rect().size
	var map_x_start = 200.0
	var map_y_start = 58.0
	var map_width = screen_size.x - map_x_start
	var map_height = screen_size.y - map_y_start - 165.0
	return Vector2(map_x_start + px * map_width, map_y_start + py * map_height)

func _build_ui():
	var bg = ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var map = TextureRect.new()
	map.name = "MapTexture"
	map.set_anchors_preset(Control.PRESET_FULL_RECT)
	map.stretch_mode = TextureRect.STRETCH_SCALE
	var map_tex = load("res://world_map.svg")
	if map_tex:
		map.texture = map_tex
	add_child(map)

	var overlay = ColorRect.new()
	overlay.color = Color(0.0, 0.03, 0.08, 0.55)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	for country in COUNTRY_PINS:
		_add_pin(country)

	_build_top_bar()
	_build_left_panel()
	_build_country_panel()
	_build_minister_bar()
	_build_decision_panel()
	_build_election_panel()
	_build_news_system()
	_build_war_panel()

func _safe_find(node_name: String) -> Node:
	var node = find_child(node_name, true, false)
	if not node:
		push_warning("Could not find node: " + node_name)
	return node

func _add_pin(country: Dictionary):
	var pos = _pin_to_screen(country["px"], country["py"])
	var is_player = country["name"] == Global.selected_country["name"]

	var btn = Button.new()
	btn.text = "⬤"
	btn.position = pos - Vector2(16, 16)
	btn.size = Vector2(32, 32)
	btn.flat = true
	btn.tooltip_text = country["name"]
	btn.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3) if is_player else Color(0.9, 0.85, 0.3))
	btn.add_theme_font_size_override("font_size", 18)
	btn.pressed.connect(_on_pin_clicked.bind(country))
	add_child(btn)

	var lbl = Label.new()
	lbl.text = country["name"]
	lbl.position = pos + Vector2(-40, 12)
	lbl.size = Vector2(120, 20)
	lbl.add_theme_font_size_override("font_size", 10)
	lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.85))
	add_child(lbl)

func _build_top_bar():
	var bar = ColorRect.new()
	bar.color = Color(0.03, 0.05, 0.09, 0.95)
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_bottom = 55
	add_child(bar)

	var country_lbl = Label.new()
	country_lbl.text = "🏛  " + Global.selected_country["name"].to_upper()
	country_lbl.set_anchors_preset(Control.PRESET_TOP_LEFT)
	country_lbl.offset_left = 20
	country_lbl.offset_top = 10
	country_lbl.offset_right = 500
	country_lbl.offset_bottom = 50
	country_lbl.add_theme_font_size_override("font_size", 22)
	country_lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	add_child(country_lbl)

	var date_lbl = Label.new()
	date_lbl.name = "DateLabel"
	date_lbl.text = _get_date_string()
	date_lbl.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	date_lbl.offset_left = -420
	date_lbl.offset_top = 14
	date_lbl.offset_right = -270
	date_lbl.offset_bottom = 50
	date_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	date_lbl.add_theme_font_size_override("font_size", 15)
	date_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	add_child(date_lbl)

	var next_btn = Button.new()
	next_btn.text = "⏭  NEXT MONTH"
	next_btn.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	next_btn.offset_left = -250
	next_btn.offset_top = 8
	next_btn.offset_right = -10
	next_btn.offset_bottom = 47
	next_btn.add_theme_font_size_override("font_size", 14)
	next_btn.pressed.connect(_on_next_month)
	add_child(next_btn)

func _build_left_panel():
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_LEFT_WIDE)
	panel.offset_top = 58
	panel.offset_bottom = -165
	panel.offset_right = 200
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.06, 0.11, 0.93)
	style.border_color = Color(0.18, 0.22, 0.36)
	style.set_border_width_all(1)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	var title = Label.new()
	title.text = "COUNTRY OVERVIEW"
	title.add_theme_font_size_override("font_size", 11)
	title.add_theme_color_override("font_color", Color(0.45, 0.45, 0.6))
	vbox.add_child(title)

	var stats = [
		["⚡ Economy", "gdp", Global.selected_country["gdp"]],
		["⚔️ Military", "military", Global.selected_country["military"]],
		["👥 Population", "population", Global.selected_country["population"]],
		["🏛 Stability", "stability", Global.selected_country["stability"]],
		["❤️ Approval", "approval", Global.approval],
		["💰 Treasury $B", "treasury", Global.treasury],
	]

	for s in stats:
		var hbox = HBoxContainer.new()
		vbox.add_child(hbox)

		var lbl = Label.new()
		lbl.text = s[0]
		lbl.custom_minimum_size = Vector2(120, 0)
		lbl.add_theme_font_size_override("font_size", 12)
		lbl.add_theme_color_override("font_color", Color(0.78, 0.78, 0.9))
		hbox.add_child(lbl)

		var val = Label.new()
		val.text = str(s[2])
		val.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		val.add_theme_font_size_override("font_size", 13)
		val.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
		hbox.add_child(val)
		stats_labels[s[1]] = val

	vbox.add_child(HSeparator.new())

	var log_title = Label.new()
	log_title.text = "BRIEFING"
	log_title.add_theme_font_size_override("font_size", 11)
	log_title.add_theme_color_override("font_color", Color(0.45, 0.45, 0.6))
	vbox.add_child(log_title)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	event_log_node = VBoxContainer.new()
	event_log_node.add_theme_constant_override("separation", 5)
	event_log_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(event_log_node)

	_add_event("Your term has begun.")
	_add_event("Treasury: $" + str(Global.treasury) + "B")
	_add_event("Approval: " + str(Global.approval) + "%")

func _build_country_panel():
	var panel = PanelContainer.new()
	panel.name = "CountryPanel"
	panel.set_anchors_preset(Control.PRESET_RIGHT_WIDE)
	panel.offset_top = 58
	panel.offset_bottom = -165
	panel.offset_left = -300
	panel.visible = false
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.06, 0.13, 0.95)
	style.border_color = Color(0.28, 0.33, 0.5)
	style.set_border_width_all(1)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	var close_btn = Button.new()
	close_btn.text = "✕  CLOSE"
	close_btn.flat = true
	close_btn.add_theme_color_override("font_color", Color(0.55, 0.55, 0.68))
	close_btn.pressed.connect(func(): panel.visible = false)
	vbox.add_child(close_btn)

	var name_lbl = Label.new()
	name_lbl.name = "CPName"
	name_lbl.add_theme_font_size_override("font_size", 20)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	vbox.add_child(name_lbl)

	vbox.add_child(HSeparator.new())

	for key in ["Economy", "Military", "Population", "Stability"]:
		var hbox = HBoxContainer.new()
		vbox.add_child(hbox)
		var lbl = Label.new()
		lbl.text = key
		lbl.custom_minimum_size = Vector2(110, 0)
		lbl.add_theme_font_size_override("font_size", 13)
		lbl.add_theme_color_override("font_color", Color(0.65, 0.65, 0.78))
		hbox.add_child(lbl)
		var val = Label.new()
		val.name = "CP" + key
		val.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		val.add_theme_font_size_override("font_size", 14)
		val.add_theme_color_override("font_color", Color(0.3, 0.88, 0.5))
		hbox.add_child(val)

	vbox.add_child(HSeparator.new())

	var diplo_lbl = Label.new()
	diplo_lbl.text = "DIPLOMACY"
	diplo_lbl.add_theme_font_size_override("font_size", 11)
	diplo_lbl.add_theme_color_override("font_color", Color(0.45, 0.45, 0.6))
	vbox.add_child(diplo_lbl)

	for action in ["🤝 Propose Trade Deal", "📜 Sign Alliance", "🚫 Impose Sanctions"]:
		var btn = Button.new()
		btn.text = action
		btn.add_theme_font_size_override("font_size", 13)
		btn.pressed.connect(_on_diplo_action.bind(action))
		vbox.add_child(btn)
	# War button
	var war_btn = Button.new()
	war_btn.name = "WarButton"
	war_btn.text = "⚔️ Declare War"
	war_btn.add_theme_font_size_override("font_size", 13)
	var war_style = StyleBoxFlat.new()
	war_style.bg_color = Color(0.5, 0.1, 0.1)
	war_style.set_corner_radius_all(4)
	war_btn.add_theme_stylebox_override("normal", war_style)
	war_btn.add_theme_color_override("font_color", Color(1, 0.7, 0.7))
	war_btn.pressed.connect(_on_declare_war)
	vbox.add_child(war_btn)

func _build_minister_bar():
	var bar = ColorRect.new()
	bar.color = Color(0.03, 0.05, 0.09, 0.95)
	bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bar.offset_top = -162
	add_child(bar)

	var hbox = HBoxContainer.new()
	hbox.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	hbox.offset_top = -158
	hbox.offset_bottom = -4
	hbox.offset_left = 8
	hbox.offset_right = -8
	hbox.add_theme_constant_override("separation", 8)
	add_child(hbox)

	for i in range(4):
		var card = PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.07, 0.10, 0.17)
		style.border_color = Color(0.18, 0.22, 0.34)
		style.set_border_width_all(1)
		style.set_corner_radius_all(4)
		card.add_theme_stylebox_override("panel", style)
		hbox.add_child(card)

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		card.add_child(row)

		if i < portrait_paths.size():
			var portrait_rect = TextureRect.new()
			portrait_rect.custom_minimum_size = Vector2(80, 80)
			portrait_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			portrait_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			var tex = load(portrait_paths[i])
			if tex:
				portrait_rect.texture = tex
			row.add_child(portrait_rect)

		var info = VBoxContainer.new()
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(info)

		var role_lbl = Label.new()
		role_lbl.text = MINISTER_ROLES[i]
		role_lbl.add_theme_font_size_override("font_size", 14)
		role_lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
		info.add_child(role_lbl)

		var report_lbl = Label.new()
		report_lbl.name = "MinReport" + str(i)
		report_lbl.text = MINISTER_REPORTS[MINISTER_ROLES[i]][0]
		report_lbl.add_theme_font_size_override("font_size", 12)
		report_lbl.add_theme_color_override("font_color", Color(0.62, 0.62, 0.73))
		report_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		info.add_child(report_lbl)

func _on_pin_clicked(country: Dictionary):
	if country["name"] == Global.selected_country["name"]:
		_add_event("This is your country — " + country["name"] + ".")
		return
	var panel = find_child("CountryPanel", true, false)
	if not panel:
		return
	panel.visible = true
	selected_pin_country = country
	find_child("CPName", true, false).text = country["name"]
	find_child("CPEconomy", true, false).text = str(country["gdp"])
	find_child("CPMilitary", true, false).text = str(country["military"])
	find_child("CPPopulation", true, false).text = str(country["population"])
	find_child("CPStability", true, false).text = str(country["stability"])

func _on_diplo_action(action: String):
	if not selected_pin_country:
		return
	var cname = selected_pin_country["name"]
	if "Trade Deal" in action:
		Global.treasury += 50
		_add_event("Trade deal with " + cname + ". +$50B", Color(0.3, 0.9, 0.5))
	elif "Alliance" in action:
		Global.selected_country["stability"] = min(100, Global.selected_country["stability"] + 5)
		_add_event("Alliance with " + cname + ". +5 Stability", Color(0.3, 0.9, 0.5))
	elif "Sanctions" in action:
		Global.approval -= 3
		_add_event("Sanctions on " + cname + ". -3 Approval", Color(0.9, 0.5, 0.3))
	_update_stats()
	find_child("CountryPanel", true, false).visible = false

func _on_next_month():
	if popup_open:
		return

	Global.game_date["month"] += 1
	Global.months_in_power += 1
	if Global.game_date["month"] > 12:
		Global.game_date["month"] = 1
		Global.game_date["year"] += 1

	var date_lbl = _safe_find("DateLabel")
	if date_lbl:
		date_lbl.text = _get_date_string()

	Global.treasury += randi_range(-30, 80)
	Global.approval += randi_range(-3, 3)
	Global.approval = clamp(Global.approval, 0, 100)

	_simulate_ai_countries()
	_maybe_trigger_ai_event()
	_update_stats()
	_update_minister_reports()

	_add_event("— " + _get_date_string() + " — Treasury: $" + str(Global.treasury) + "B | Approval: " + str(Global.approval) + "%")

	if Global.approval <= 20:
		_add_event("⚠️ Approval critically low!", Color(0.95, 0.3, 0.3))
	if Global.treasury < 0:
		_add_event("⚠️ Treasury in deficit!", Color(0.95, 0.3, 0.3))

	if Global.approval <= 0:
		_trigger_game_over("Your approval collapsed. The military forced you out.")
		return

	# Election check
	if Global.months_in_power > 0 and Global.months_in_power % 48 == 0:
		_trigger_election()
		return

	# War takes priority over everything else
	if Global.at_war:
		Global.war_months += 1
		Global.treasury -= 20
		_add_event("⚔️ War ongoing — Month " + str(Global.war_months) + ". Upkeep: -$20B", Color(0.9, 0.4, 0.3))
		_update_stats()
		if Global.war_months >= 6:
			_add_event("⚠️ War dragged on too long. Forcing resolution.", Color(0.9, 0.3, 0.3))
			_resolve_war(false)
			return
		if Global.war_months % 2 == 0:
			_show_war_decision()
		return

	# Normal month — decision or news, never both
	if Global.game_date["month"] % 2 == 0:
		_show_decision()
	elif Global.game_date["month"] % 3 == 0:
		_fetch_news()

func _update_stats():
	for key in stats_labels:
		if is_instance_valid(stats_labels[key]):
			match key:
				"approval": stats_labels[key].text = str(Global.approval)
				"treasury": stats_labels[key].text = str(Global.treasury)
				"stability": stats_labels[key].text = str(Global.selected_country.get("stability", 0))

func _update_minister_reports():
	for i in range(4):
		var lbl = find_child("MinReport" + str(i), true, false)
		if lbl and is_instance_valid(lbl):
			var reports = MINISTER_REPORTS[MINISTER_ROLES[i]]
			lbl.text = reports[randi() % reports.size()]

func _add_event(text: String, color: Color = Color(0.72, 0.72, 0.86)):
	if not event_log_node or not is_instance_valid(event_log_node):
		return
	var lbl = Label.new()
	lbl.text = "▸ " + text
	lbl.add_theme_font_size_override("font_size", 12)
	lbl.add_theme_color_override("font_color", color)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	event_log_node.add_child(lbl)
	if event_log_node.get_child_count() > 20:
		var old = event_log_node.get_child(0)
		event_log_node.remove_child(old)
		old.queue_free()

func _get_date_string() -> String:
	var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
	return months[Global.game_date["month"] - 1] + " " + str(Global.game_date["year"])

func _build_decision_panel():
	var overlay = ColorRect.new()
	overlay.name = "DecisionOverlay"
	overlay.color = Color(0, 0, 0, 0.85)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	add_child(overlay)

	var panel = PanelContainer.new()
	panel.name = "DecisionPanel"
	panel.visible = false
	panel.position = Vector2(620, 200)
	panel.size = Vector2(680, 480)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.10, 0.14, 0.22, 1.0)
	style.border_color = Color(0.4, 0.45, 0.65)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	panel.add_child(vbox)

	var header = Label.new()
	header.text = "⚡ DECISION REQUIRED"
	header.add_theme_font_size_override("font_size", 13)
	header.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(header)

	vbox.add_child(HSeparator.new())

	var title_lbl = Label.new()
	title_lbl.name = "DecisionTitle"
	title_lbl.add_theme_font_size_override("font_size", 22)
	title_lbl.add_theme_color_override("font_color", Color(0.95, 0.95, 1.0))
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(title_lbl)

	var desc_lbl = Label.new()
	desc_lbl.name = "DecisionDesc"
	desc_lbl.add_theme_font_size_override("font_size", 14)
	desc_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.82))
	desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_lbl)

	vbox.add_child(HSeparator.new())

	var choices_vbox = VBoxContainer.new()
	choices_vbox.name = "ChoicesBox"
	choices_vbox.add_theme_constant_override("separation", 8)
	vbox.add_child(choices_vbox)

func _show_decision():
	if popup_open:
		return
	popup_open = true

	var overlay = find_child("DecisionOverlay", true, false)
	var panel = find_child("DecisionPanel", true, false)
	var title_lbl = find_child("DecisionTitle", true, false)
	var desc_lbl = find_child("DecisionDesc", true, false)
	var choices_box = find_child("ChoicesBox", true, false)

	if not overlay or not panel or not title_lbl or not desc_lbl or not choices_box:
		popup_open = false
		return

	var decision = DECISIONS[randi() % DECISIONS.size()]
	title_lbl.text = decision["title"]
	desc_lbl.text = decision["description"]

	for child in choices_box.get_children():
		child.queue_free()

	for choice in decision["choices"]:
		var btn = Button.new()
		btn.text = choice["text"]
		btn.add_theme_font_size_override("font_size", 14)
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var effects_text = ""
		for key in choice["effects"]:
			var val = choice["effects"][key]
			var val_sign = "+" if val > 0 else ""
			effects_text += "  " + key.capitalize() + ": " + val_sign + str(val)
		btn.tooltip_text = effects_text.strip_edges()
		btn.pressed.connect(_on_decision_chosen.bind(choice["effects"], overlay))
		choices_box.add_child(btn)

	overlay.visible = true
	panel.visible = true

func _on_decision_chosen(effects: Dictionary, overlay: ColorRect):
	popup_open = false
	if is_instance_valid(overlay):
		overlay.visible = false
	var panel = find_child("DecisionPanel", true, false)
	if panel:
		panel.visible = false

	for key in effects:
		match key:
			"treasury": Global.treasury += effects[key]
			"approval":
				Global.approval += effects[key]
				Global.approval = clamp(Global.approval, 0, 100)
			"stability":
				Global.selected_country["stability"] = clamp(
					Global.selected_country.get("stability", 50) + effects[key], 0, 100)
			"military":
				Global.selected_country["military"] = clamp(
					Global.selected_country.get("military", 50) + effects[key], 0, 100)
			"gdp":
				Global.selected_country["gdp"] = clamp(
					Global.selected_country.get("gdp", 50) + effects[key], 0, 100)

	_update_stats()
	_add_event("Decision made. Effects applied.", Color(0.9, 0.8, 0.4))

# ─── ELECTIONS ───────────────────────────────────────────

func _build_election_panel():
	var overlay = ColorRect.new()
	overlay.name = "ElectionOverlay"
	overlay.color = Color(0, 0, 0, 0.88)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	add_child(overlay)

	var panel = PanelContainer.new()
	panel.name = "ElectionPanel"
	panel.visible = false
	panel.position = Vector2(560, 160)
	panel.size = Vector2(800, 560)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.10, 0.18, 1.0)
	style.border_color = Color(0.9, 0.8, 0.3)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	var header = Label.new()
	header.text = "🗳️  ELECTION DAY"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 32)
	header.add_theme_color_override("font_color", Color(0.9, 0.8, 0.3))
	vbox.add_child(header)

	vbox.add_child(HSeparator.new())

	var poll_lbl = Label.new()
	poll_lbl.name = "PollLabel"
	poll_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	poll_lbl.add_theme_font_size_override("font_size", 18)
	poll_lbl.add_theme_color_override("font_color", Color(0.75, 0.75, 0.9))
	poll_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(poll_lbl)

	var approval_lbl = Label.new()
	approval_lbl.name = "ElectionApprovalLabel"
	approval_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	approval_lbl.add_theme_font_size_override("font_size", 48)
	approval_lbl.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	vbox.add_child(approval_lbl)

	var result_lbl = Label.new()
	result_lbl.name = "ElectionResultLabel"
	result_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_lbl.add_theme_font_size_override("font_size", 22)
	result_lbl.add_theme_color_override("font_color", Color(0.95, 0.95, 1.0))
	result_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(result_lbl)

	vbox.add_child(HSeparator.new())

	var continue_btn = Button.new()
	continue_btn.name = "ElectionContinueBtn"
	continue_btn.text = "CONTINUE"
	continue_btn.custom_minimum_size = Vector2(0, 50)
	continue_btn.add_theme_font_size_override("font_size", 18)
	continue_btn.visible = false
	continue_btn.pressed.connect(_on_election_continue)
	vbox.add_child(continue_btn)

func _trigger_election():
	if popup_open:
		return
	popup_open = true

	var overlay = find_child("ElectionOverlay", true, false)
	var panel = find_child("ElectionPanel", true, false)
	var poll_lbl = find_child("PollLabel", true, false)
	var approval_lbl = find_child("ElectionApprovalLabel", true, false)
	var result_lbl = find_child("ElectionResultLabel", true, false)
	var btn = find_child("ElectionContinueBtn", true, false)

	if not overlay or not panel or not poll_lbl or not approval_lbl or not result_lbl or not btn:
		popup_open = false
		return

	var years = int(Global.months_in_power / 12.0)
	var win_chance = (float(Global.approval) / 100.0) * 0.7 + 0.15
	var won = randf() < win_chance

	poll_lbl.text = "After " + str(years) + " years in power, the nation votes.\nYour approval rating going into the election: "
	approval_lbl.text = str(Global.approval) + "%"

	if won:
		result_lbl.text = "🎉 YOU WON THE ELECTION!\nThe people have granted you another term."
		result_lbl.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
		btn.text = "▶  BEGIN NEW TERM"
		Global.last_election_month = Global.months_in_power
		Global.approval = max(40, Global.approval - 10)
	else:
		result_lbl.text = "❌ YOU LOST THE ELECTION.\nThe people have spoken. Your rule is over."
		result_lbl.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
		btn.text = "VIEW YOUR LEGACY"

	btn.visible = true
	overlay.visible = true
	panel.visible = true
	panel.set_meta("election_won", won)

func _on_election_continue():
	popup_open = false
	var panel = find_child("ElectionPanel", true, false)
	var won = panel.get_meta("election_won", false)

	find_child("ElectionOverlay", true, false).visible = false
	panel.visible = false

	if not won:
		_trigger_game_over("You lost the election.")

func _trigger_game_over(reason: String):
	if http_request and is_instance_valid(http_request):
		http_request.cancel_request()
	var years = int(Global.months_in_power / 12.0)
	var scene = load("res://GameOver.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.setup({
		"years": years,
		"reason": reason,
		"approval": Global.approval,
		"treasury": Global.treasury,
	})
	get_tree().current_scene = scene
	queue_free()

# ─── AI COUNTRIES ────────────────────────────────────────

var AI_EVENTS = [
	{"msg": "⚔️ {A} and {B} are on the brink of war. Regional tensions rise.", "effects": {"stability": -4}},
	{"msg": "🤝 {A} and {B} sign a landmark trade agreement.", "effects": {"treasury": 20}},
	{"msg": "📉 Economic crisis hits {A}. Global markets react.", "effects": {"treasury": -30, "gdp": -2}},
	{"msg": "🛢️ {A} discovers massive oil reserves. Energy prices shift.", "effects": {"treasury": 15}},
	{"msg": "🗳️ Political unrest in {B} after disputed elections.", "effects": {"stability": -3}},
	{"msg": "💣 Terrorist attack in {A} shocks the world.", "effects": {"stability": -5, "approval": -2}},
	{"msg": "🌿 {A} and {B} sign a major climate agreement.", "effects": {"approval": 3}},
	{"msg": "🚀 {A} launches new military expansion programme.", "effects": {"military": -2}},
	{"msg": "📦 {B} imposes trade sanctions on your exports.", "effects": {"treasury": -25, "gdp": -1}},
	{"msg": "🏦 IMF warns of global recession. All economies contract.", "effects": {"treasury": -40, "gdp": -3}},
]

const NEWS_EVENTS = [
	{
		"keywords": ["interest rate", "federal reserve", "central bank", "rates"],
		"title": "Global Interest Rates Shift",
		"msg": "📈 Central banks adjust interest rates. Your borrowing costs change.",
		"effects": {"treasury": -35, "gdp": -2}
	},
	{
		"keywords": ["oil", "opec", "crude", "energy price", "petroleum"],
		"title": "Oil Price Surge",
		"msg": "🛢️ Global oil prices spike. Energy costs hit your economy.",
		"effects": {"treasury": -25, "approval": -3}
	},
	{
		"keywords": ["war", "conflict", "attack", "missile", "troops", "invasion"],
		"title": "Global Conflict Escalates",
		"msg": "⚔️ Military conflict abroad rattles global markets and stability.",
		"effects": {"stability": -6, "military": -3}
	},
	{
		"keywords": ["sanction", "embargo", "trade war", "tariff"],
		"title": "Trade Sanctions Ripple",
		"msg": "🚫 International sanctions shake global trade flows.",
		"effects": {"treasury": -30, "gdp": -3}
	},
	{
		"keywords": ["recession", "economic crisis", "gdp", "slowdown", "downturn"],
		"title": "Global Economic Slowdown",
		"msg": "📉 Signs of global recession emerge. Investor confidence drops.",
		"effects": {"treasury": -50, "gdp": -5, "approval": -4}
	},
	{
		"keywords": ["election", "vote", "president", "prime minister", "government"],
		"title": "Political Shifts Abroad",
		"msg": "🗳️ Political change in a major nation creates regional uncertainty.",
		"effects": {"stability": -3}
	},
	{
		"keywords": ["climate", "flood", "earthquake", "disaster", "hurricane", "drought"],
		"title": "Natural Disaster Abroad",
		"msg": "🌊 A major natural disaster abroad disrupts global supply chains.",
		"effects": {"treasury": -20, "approval": -2}
	},
	{
		"keywords": ["tech", "ai", "technology", "innovation", "digital"],
		"title": "Tech Boom",
		"msg": "💻 A global tech surge opens new economic opportunities.",
		"effects": {"gdp": 4, "treasury": 20}
	},
	{
		"keywords": ["peace", "deal", "agreement", "treaty", "ceasefire"],
		"title": "Peace Agreement Reached",
		"msg": "🕊️ A major peace deal stabilises the region. Markets rally.",
		"effects": {"stability": 5, "treasury": 15, "approval": 3}
	},
	{
		"keywords": ["inflation", "prices", "cost of living", "food price"],
		"title": "Global Inflation Pressure",
		"msg": "💸 Rising global prices squeeze your citizens' wallets.",
		"effects": {"approval": -5, "treasury": -20}
	},
	{
		"keywords": ["pandemic", "virus", "outbreak", "health", "disease"],
		"title": "Health Crisis Spreading",
		"msg": "🦠 A disease outbreak abroad puts pressure on your health system.",
		"effects": {"treasury": -40, "approval": -4, "stability": -4}
	},
	{
		"keywords": ["refugee", "migration", "border", "asylum"],
		"title": "Migration Crisis",
		"msg": "🚶 A regional migration crisis creates political pressure.",
		"effects": {"approval": -3, "stability": -3}
	},
]

func _simulate_ai_countries():
	for country in COUNTRY_PINS:
		if country["name"] == Global.selected_country["name"]:
			continue
		country["gdp"] = clamp(country["gdp"] + randi_range(-2, 3), 5, 100)
		country["military"] = clamp(country["military"] + randi_range(-1, 2), 5, 100)
		country["stability"] = clamp(country["stability"] + randi_range(-3, 2), 5, 100)

func _maybe_trigger_ai_event():
	if randi() % 3 != 0:
		return

	var event = AI_EVENTS[randi() % AI_EVENTS.size()]
	var other_countries = COUNTRY_PINS.filter(func(c): return c["name"] != Global.selected_country["name"])
	if other_countries.size() < 2:
		return

	other_countries.shuffle()
	var country_a = other_countries[0]["name"]
	var country_b = other_countries[1]["name"]

	var msg = event["msg"].replace("{A}", country_a).replace("{B}", country_b)
	_add_event(msg, Color(0.85, 0.75, 0.4))

	for key in event["effects"]:
		match key:
			"treasury": Global.treasury += event["effects"][key]
			"approval":
				Global.approval = clamp(Global.approval + event["effects"][key], 0, 100)
			"stability":
				Global.selected_country["stability"] = clamp(
					Global.selected_country.get("stability", 50) + event["effects"][key], 0, 100)
			"gdp":
				Global.selected_country["gdp"] = clamp(
					Global.selected_country.get("gdp", 50) + event["effects"][key], 0, 100)
			"military":
				Global.selected_country["military"] = clamp(
					Global.selected_country.get("military", 50) + event["effects"][key], 0, 100)

	_update_stats()

# ─── NEWS SYSTEM ─────────────────────────────────────────

func _build_news_system():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_news_fetched)

func _fetch_news():
	if not http_request:
		return
	if http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return
	var url = "https://feeds.bbci.co.uk/news/world/rss.xml"
	var err = http_request.request(url)
	if err != OK:
		_add_event("📡 News feed unavailable.", Color(0.5, 0.5, 0.6))

func _on_news_fetched(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	if not is_inside_tree():
		return
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		_add_event("📡 Could not reach news feed.", Color(0.5, 0.5, 0.6))
		return

	var text = body.get_string_from_utf8().to_lower()
	var matched = false

	for event in NEWS_EVENTS:
		for keyword in event["keywords"]:
			if keyword in text:
				_add_event(event["msg"], Color(0.95, 0.85, 0.4))
				for key in event["effects"]:
					match key:
						"treasury": Global.treasury += event["effects"][key]
						"approval":
							Global.approval = clamp(Global.approval + event["effects"][key], 0, 100)
						"stability":
							Global.selected_country["stability"] = clamp(
								Global.selected_country.get("stability", 50) + event["effects"][key], 0, 100)
						"gdp":
							Global.selected_country["gdp"] = clamp(
								Global.selected_country.get("gdp", 50) + event["effects"][key], 0, 100)
						"military":
							Global.selected_country["military"] = clamp(
								Global.selected_country.get("military", 50) + event["effects"][key], 0, 100)
				_update_stats()
				matched = true
				break
		if matched:
			break

	if not matched:
		_add_event("📰 World news monitored. No major impact today.", Color(0.5, 0.5, 0.6))

# ─── WAR SYSTEM ──────────────────────────────────────────

func _on_declare_war():
	if Global.at_war:
		_add_event("⚠️ You are already at war!", Color(0.9, 0.4, 0.3))
		find_child("CountryPanel", true, false).visible = false
		return

	if not selected_pin_country:
		return

	if Global.treasury < 50:
		_add_event("⚠️ Not enough treasury to fund a war.", Color(0.9, 0.4, 0.3))
		return

	Global.at_war = true
	Global.war_target = selected_pin_country.duplicate()
	Global.war_months = 0
	Global.war_score = 0
	Global.treasury -= 50

	find_child("CountryPanel", true, false).visible = false
	_add_event("⚔️ WAR DECLARED on " + Global.war_target["name"] + "! Troops mobilising.", Color(0.95, 0.3, 0.3))
	_add_event("💰 War chest allocated. -$50B", Color(0.9, 0.5, 0.3))
	_update_stats()

func _build_war_panel():
	var overlay = ColorRect.new()
	overlay.name = "WarOverlay"
	overlay.color = Color(0, 0, 0, 0.88)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	add_child(overlay)

	var panel = PanelContainer.new()
	panel.name = "WarPanel"
	panel.visible = false
	panel.position = Vector2(560, 150)
	panel.size = Vector2(800, 580)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.14, 0.07, 0.07, 1.0)
	style.border_color = Color(0.8, 0.2, 0.2)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	panel.add_child(vbox)

	var header = Label.new()
	header.text = "⚔️  WAR ROOM"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 28)
	header.add_theme_color_override("font_color", Color(0.95, 0.4, 0.4))
	vbox.add_child(header)

	vbox.add_child(HSeparator.new())

	var vs_lbl = Label.new()
	vs_lbl.name = "WarVsLabel"
	vs_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vs_lbl.add_theme_font_size_override("font_size", 20)
	vs_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.5))
	vbox.add_child(vs_lbl)

	var status_lbl = Label.new()
	status_lbl.name = "WarStatusLabel"
	status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_lbl.add_theme_font_size_override("font_size", 15)
	status_lbl.add_theme_color_override("font_color", Color(0.75, 0.75, 0.85))
	status_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(status_lbl)

	vbox.add_child(HSeparator.new())

	var choices_label = Label.new()
	choices_label.text = "YOUR ORDERS:"
	choices_label.add_theme_font_size_override("font_size", 13)
	choices_label.add_theme_color_override("font_color", Color(0.55, 0.55, 0.65))
	vbox.add_child(choices_label)

	var war_choices = VBoxContainer.new()
	war_choices.name = "WarChoicesBox"
	war_choices.add_theme_constant_override("separation", 10)
	vbox.add_child(war_choices)

func _show_war_decision():
	if not Global.at_war or popup_open:
		return
	popup_open = true

	var overlay = find_child("WarOverlay", true, false)
	var panel = find_child("WarPanel", true, false)
	if not overlay or not panel:
		return

	var my_mil = Global.selected_country.get("military", 50)
	var their_mil = Global.war_target.get("military", 50)
	var advantage = my_mil - their_mil

	var vs_lbl = _safe_find("WarVsLabel")
	if vs_lbl:
		vs_lbl.text = (Global.selected_country["name"] + "  ⚔️  " + Global.war_target.get("name", "enemy") + "\nMonth " + str(Global.war_months) + " of conflict")

	var status_lbl = _safe_find("WarStatusLabel")
	if status_lbl:
		if Global.war_score > 3:
			status_lbl.text = "🟢 Your forces are advancing. Victory is within reach."
		elif Global.war_score > 0:
			status_lbl.text = "🟡 The conflict is going in your favour, but it's not over."
		elif Global.war_score == 0:
			status_lbl.text = "⚪ The front lines are deadlocked. Neither side is gaining."
		elif Global.war_score > -3:
			status_lbl.text = "🟠 Your forces are struggling. The enemy is pushing back."
		else:
			status_lbl.text = "🔴 Your military is taking heavy losses. This war is going badly."

	var choices_box = find_child("WarChoicesBox", true, false)
	if not choices_box:
		popup_open = false
		return
	for child in choices_box.get_children():
		child.queue_free()

	var choices = [
		{
			"text": "🗡️ Launch Full Offensive",
			"desc": "High risk, high reward. Costs $80B.",
			"score_change": 3 if advantage > 10 else (1 if advantage > -10 else -1),
			"treasury": -80, "military": -3
		},
		{
			"text": "🛡️ Hold Defensive Lines",
			"desc": "Low risk. Costs $30B. Consolidate your position.",
			"score_change": 1 if advantage > 0 else -1,
			"treasury": -30, "military": -1
		},
		{
			"text": "🔀 Guerrilla Tactics",
			"desc": "Medium risk. Costs $50B. Unpredictable results.",
			"score_change": 99,
			"treasury": -50, "military": -2
		},
		{
			"text": "🕊️ Negotiate Ceasefire",
			"desc": "End the war now based on current standing.",
			"score_change": 0,
			"treasury": 0, "military": 0,
			"negotiate": true
		},
	]

	for choice in choices:
		var vbox = VBoxContainer.new()
		choices_box.add_child(vbox)

		var btn = Button.new()
		btn.text = choice["text"]
		btn.add_theme_font_size_override("font_size", 15)
		btn.pressed.connect(_on_war_choice.bind(choice, overlay, panel))
		vbox.add_child(btn)

		var desc = Label.new()
		desc.text = "     " + choice["desc"]
		desc.add_theme_font_size_override("font_size", 12)
		desc.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
		vbox.add_child(desc)

	overlay.visible = true
	panel.visible = true

func _on_war_choice(choice: Dictionary, overlay: ColorRect, panel: PanelContainer):
	popup_open = false
	overlay.visible = false
	panel.visible = false

	if choice.get("negotiate", false):
		_resolve_war(true)
		return

	var actual_score_change = choice["score_change"]
	if actual_score_change == 99:
		actual_score_change = randi_range(-1, 3)
	Global.war_score += actual_score_change
	Global.treasury += choice["treasury"]
	Global.treasury = max(Global.treasury, -500)
	Global.selected_country["military"] = clamp(
		Global.selected_country.get("military", 50) + choice["military"], 5, 100)

	_update_stats()

	var outcome_msg = ""
	if choice["score_change"] > 1:
		outcome_msg = "Your offensive gains ground! +"
	elif choice["score_change"] > 0:
		outcome_msg = "Slight gains on the front. +"
	elif choice["score_change"] == 0:
		outcome_msg = "Stalemate. Lines hold."
	else:
		outcome_msg = "Setback — enemy pushed back your lines."

	_add_event("⚔️ " + outcome_msg, Color(0.9, 0.5, 0.3))

	if Global.war_months >= 4:
		_resolve_war(false)

func _resolve_war(negotiated: bool):
	if not Global.at_war:
		return
	Global.at_war = false
	var score = Global.war_score
	var target_name = Global.war_target.get("name", "the enemy")

	if negotiated:
		if score > 0:
			_add_event("🕊️ Ceasefire agreed. You negotiated from a position of strength. +$80B reparations.", Color(0.4, 0.9, 0.5))
			Global.treasury += 80
			Global.approval += 5
		elif score == 0:
			_add_event("🕊️ Ceasefire agreed. The war ends in a draw. Both sides walk away.", Color(0.75, 0.75, 0.85))
		else:
			_add_event("🕊️ Ceasefire agreed. You negotiated to avoid total defeat. -$50B.", Color(0.9, 0.5, 0.3))
			Global.treasury -= 50
			Global.approval -= 5
	elif score >= 4:
		_add_event("🏆 DECISIVE VICTORY over " + target_name + "! +$200B reparations. National pride surges!", Color(0.3, 0.95, 0.5))
		Global.treasury += 200
		Global.approval = min(100, Global.approval + 15)
		Global.selected_country["stability"] = min(100, Global.selected_country.get("stability", 50) + 8)
	elif score >= 1:
		_add_event("✅ Victory over " + target_name + ". War ends in your favour. +$80B.", Color(0.3, 0.9, 0.5))
		Global.treasury += 80
		Global.approval = min(100, Global.approval + 8)
	elif score == 0:
		_add_event("⚪ The war ends in a stalemate. No clear winner. Heavy costs on both sides.", Color(0.75, 0.75, 0.85))
		Global.approval -= 4
	elif score >= -3:
		_add_event("❌ Defeat. " + target_name + " forces you back. -$80B. Approval plummets.", Color(0.9, 0.3, 0.3))
		Global.treasury -= 80
		Global.approval -= 12
		Global.selected_country["military"] = max(5, Global.selected_country.get("military", 50) - 10)
	else:
		_add_event("💀 CRUSHING DEFEAT. Your military is broken. -$150B. The nation is in crisis.", Color(0.95, 0.2, 0.2))
		Global.treasury -= 150
		Global.approval -= 20
		Global.selected_country["military"] = max(5, Global.selected_country.get("military", 50) - 20)
		Global.selected_country["stability"] = max(5, Global.selected_country.get("stability", 50) - 15)

	Global.war_target = {}
	Global.war_months = 0
	Global.war_score = 0
	_update_stats()
