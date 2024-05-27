extends Node

func _ready():
	# As of right now as soon as the server starts it creates a lobby and nobody else can make a new one :)
	if OS.has_feature("dedicated_server"):
		Server.address = "0.0.0.0"
		Server.hostGame(7777)
