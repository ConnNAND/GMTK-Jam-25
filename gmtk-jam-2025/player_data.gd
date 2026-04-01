extends Node

var players = [] #each item contains a tuple, [controller id, character being played]
var bestTime : Dictionary = {}
var lapCount : Dictionary = {}
enum mode {local, daily}
var current_mode:mode

func load_players(playerinfo):
	players.clear()
	for i in playerinfo:
		players.append(i)
