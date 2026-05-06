extends Node

var selected_country = {}
var game_date = {"year": 2024, "month": 1}
var treasury = 1000
var approval = 50
var months_in_power = 0
var last_election_month = 0

# War state
var at_war = false
var war_target = {}
var war_months = 0
var war_score = 0

func reset():
	selected_country = {}
	game_date = {"year": 2024, "month": 1}
	treasury = 1000
	approval = 50
	months_in_power = 0
	last_election_month = 0
	at_war = false
	war_target = {}
	war_months = 0
	war_score = 0
