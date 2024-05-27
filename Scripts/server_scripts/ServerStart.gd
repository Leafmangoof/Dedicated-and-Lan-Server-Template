# THIS SCRIPT IS AN AUTOLOAD
extends Node

func _ready():
	# As of right now as soon as the server starts it creates a lobby and nobody else can make a new one :)
	#
	# When exporting a game you can specify certian 'features' that the exported game can have and one of them is 'dedicated_server'
	# so basically this will start the server as soon as it can on only the exported server version of godot
	if OS.has_feature("dedicated_server"):
	# The Server script is an autoload
		#Setting the Server address to this is more of a safety measure then an actual thing that needs to happen
		Server.address = "0.0.0.0"
		Server.hostGame(7777)
