extends Node

const SAVE_DIR = "user://saves/"
const MAX_SLOTS = 3

func save_game(slot: int) -> bool:
	var save_data = {
		"selected_country": Global.selected_country,
		"game_date": Global.game_date,
		"treasury": Global.treasury,
		"approval": Global.approval,
		"months_in_power": Global.months_in_power,
		"last_election_month": Global.last_election_month,
		"at_war": Global.at_war,
		"war_target": Global.war_target,
		"war_months": Global.war_months,
		"war_score": Global.war_score,
		"ai_relationships": Global.ai_relationships,
		"last_decisions": Global.last_decisions,
	}

	var json_string = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_DIR + "slot_%d.json" % slot, FileAccess.WRITE)
	if file == null:
		push_error("Failed to save game: ", FileAccess.get_open_error())
		return false

	file.store_string(json_string)
	return true

func load_game(slot: int) -> bool:
	var file_path = SAVE_DIR + "slot_%d.json" % slot

	if not FileAccess.file_exists(file_path):
		push_warning("Save file does not exist: ", file_path)
		return false

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to load game: ", FileAccess.get_open_error())
		return false

	var json_string = file.get_as_text()
	var save_data = JSON.parse_string(json_string)

	if save_data == null:
		push_error("Failed to parse JSON")
		return false

	Global.selected_country = save_data.get("selected_country", {})
	Global.game_date = save_data.get("game_date", {})
	Global.treasury = save_data.get("treasury", 1000)
	Global.approval = save_data.get("approval", 50)
	Global.months_in_power = save_data.get("months_in_power", 0)
	Global.last_election_month = save_data.get("last_election_month", 0)
	Global.at_war = save_data.get("at_war", false)
	Global.war_target = save_data.get("war_target", {})
	Global.war_months = save_data.get("war_months", 0)
	Global.war_score = save_data.get("war_score", 0)
	Global.ai_relationships = save_data.get("ai_relationships", {})
	Global.last_decisions = save_data.get("last_decisions", [])

	return true

func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_DIR + "slot_%d.json" % slot)

func slot_exists(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_DIR + "slot_%d.json" % slot)

func delete_save(slot: int) -> bool:
	var file_path = SAVE_DIR + "slot_%d.json" % slot
	if FileAccess.file_exists(file_path):
		var dir = DirAccess.open(SAVE_DIR)
		if dir:
			var error = dir.remove(file_path)
			return error == OK
	return false

func get_slot_info(slot: int) -> String:
	if not slot_exists(slot):
		return "Empty"

	var file_path = SAVE_DIR + "slot_%d.json" % slot
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return "Error reading save"

	var save_data = JSON.parse_string(file.get_as_text())
	if save_data == null:
		return "Corrupted"

	var country = save_data.get("selected_country", {}).get("name", "Unknown")
	var date = save_data.get("game_date", {})
	if date is Dictionary:
		return "%s - %s/%s" % [country, date.get("month", "?"), date.get("year", "?")]
	return country
