extends Node

var address: String
var port: int
var peer

var username: String = "null"

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#This will automatically detect when a new player has joined the game
func peer_connected(id):
	print("Player Connected: " + str(id))

#This will automatically remove any disconnected players from the game 
func peer_disconnected(id):
	print("Player Disconnected: " + str(id))
	GameManager.Players.erase(id)
	

#Whenever you join a game it will send a command to the server saying certain data like your username and multiplayer ID
func connected_to_server():
	print("Connected to server!")
	SendPlayerInfo.rpc_id(
		1, 
		username, 
		multiplayer.get_unique_id(),
		false
	)

#This will create a new player in the "GameManager" Player dictonary. Having this allows you to keep certain info for the server to use
@rpc("any_peer")
func SendPlayerInfo(playerName, id, localHost):
	if id != null:
		if !GameManager.Players.has(id):
			GameManager.Players[id] = {
				"localGameHost": localHost,
				"playerName": playerName,
				"id": id,
			}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInfo.rpc(GameManager.Players[i].playerName, i, localHost)

func connection_failed():
	print("Connection Failed :(")

#Starts a basic game server
func hostGame(port):
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 10)
	if error != OK:
		print("cannot host: " + str(error))
		return
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players!")

#Joining script
func joinGame(madename):
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address,7777)
	if error != OK:
		print("cannot join: " + str(error))
		return
	username = madename
	print("made peer!")
	multiplayer.set_multiplayer_peer(peer)


func leaveGame(id):
	peer_disconnected(id)
	GameManager.Players.clear()
	peer.close()
	peer = null
