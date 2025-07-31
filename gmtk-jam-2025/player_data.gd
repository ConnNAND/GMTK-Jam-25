extends Node

var players = [] #each item contains a tuple, [controller id, character being played]

func load_players(playerinfo):
	players.clear()
	for i in playerinfo:
		players.append(i)
