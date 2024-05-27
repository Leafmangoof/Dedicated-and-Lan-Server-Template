# THIS SCRIPT IS AN AUTOLOAD
extends Node

# This is just for the project it isn't needed, but can actually be helpful for diffrent lobby systems
signal update_list

# The address is the IP address of the server you are connecting to
# the best example is your local network. You can connect to is by using "127.0.0.1"
var address: String
# The port of the server for this code the number is "7777"
# TODO: Find out more about ports and what they are for a router
var port: int
# The peer that connects the client to the server
# You can imagine it as 
var peer

var username: String = "null"

# Godot handles people leaving and joining on it's own, but if we wanna have more control over what happens we need to make our own functions to call
# so this will just connect godots peer based signals to our own functions
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

#This will automatically detect when a new player has joined the game
func peer_connected(id):
	print("Player Connected: " + str(id))
	
#This will automatically remove any disconnected players from the game 
func peer_disconnected(id):
	print("Player Disconnected: " + str(id))
	# If we don't erase the ID the server may try to call something for the player that we doesn't exist
	GameManager.Players.erase(id)
	update_list.emit()
#Whenever you join a game it will send a command to the server saying certain data like your username and multiplayer ID
func connected_to_server():
	print("Connected to server!")
	SendPlayerInfo.rpc_id(
		1, 
		username, 
		multiplayer.get_unique_id(),
		false
	)

# If the client can't find the server in a certian amount of time then it will not connect anymore and spit out an error
func connection_failed():
	print_rich("[color=red]CONNECTION TO SERVER FAILED! DO YOU HAVE THE RIGHT IP ADDRESS AND PORT?[/color]")


# This will create a new player in the "GameManager" Player dictonary. Having this allows you to keep certain info for the server to use
# The infomation added in currently is just the basic things that I believe are needed
#
# "localGameHost" allows someone on hosting a LAN game to do the same things that a normal server would do, but without the restraints of not being able to play the game
# for Example: if you try to create a game locally you'll run into a problem where the server itself won't be added to the 'Players' in the GameManager script
# so this varible will be able to tell the server to create itself as a player that can play
#
# "playerName" is the players name that they input before they enter the game
#
# "id" is the players multiplayer ID. Each player has a unique one whenever they create a mulitplayer peer! We need this id to refrence a player while in game by using it as a key
# in the 'Player' varible in the GameManager script to find specfic things about the player
@rpc("any_peer")
func SendPlayerInfo(playerName, id, localHost):
	if id != null:
		if !GameManager.Players.has(id):
			GameManager.Players[id] = {
				"localGameHost": localHost,
				"playerName": playerName,
				"id": id,
			}
		update_list.emit()
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInfo.rpc(GameManager.Players[i].playerName, i, localHost)

#Starts a basic game server using a port
func hostGame(port, _lan = false, _username = ""):
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 10)
	if error != OK:
		print("cannot host: " + str(error))
		return
	if _lan:
		SendPlayerInfo(_username,multiplayer.get_unique_id(), _lan)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players!")

#Joining script
func joinGame(address, madename, port = 7777):
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address,port)
	if error != OK:
		print("cannot join: " + str(error))
		return
	print("made peer!")
	multiplayer.set_multiplayer_peer(peer)
	username = madename


func leaveGame(id):
	peer_disconnected(id)
	GameManager.Players.clear()
	peer.close()
	peer = null
