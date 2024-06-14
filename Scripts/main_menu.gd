extends Control

var local_ip = "127.0.0.1"


func _ready():
	Server.update_list.connect(show_data)
	# This grabs your local IPv4 Address
	# DONT PUBLICLY SHARE THIS ADDRESS. This is PRIVATE so please don't share it willy nilly
	# This one can only work on windows, but that isn't really a problem right now
	if OS.has_feature("windows"):
		if OS.has_environment("COMPUTERNAME"):
			local_ip = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	
func _on_host_button_down():
	Server.hostGame(7777, true, $VBoxContainer/usernameEntry.text)
	$VBoxContainer.hide()
	$Names.show()

func _on_join_button_down():
	$VBoxContainer/host.hide()
	$VBoxContainer/join.hide()
	$VBoxContainer/OptionButton.show()
	$VBoxContainer/address.show()
	$VBoxContainer/joinGame.show()


func _on_option_button_item_selected(index):
	if index == 0:
		$VBoxContainer/address.text = str(local_ip)
		$VBoxContainer/address.editable = false
	elif index == 1:
		$VBoxContainer/address.text = ""
		$VBoxContainer/address.editable = true
	
	
func _on_join_game_button_down():
	Server.joinGame($VBoxContainer/address.text, $VBoxContainer/usernameEntry.text)
	$VBoxContainer.hide()
	$Names.show()


# This is a visual on who has joined your server and it will just make labels based on what the GameManager.Players has in it
func show_data():
	for child in $Names.get_children():
		child.queue_free()
	for i in GameManager.Players:
		var label = Label.new()
		label.text = "Name: %s | ID: %s | LocalHost: %s " % [GameManager.Players[i].playerName,GameManager.Players[i].id,GameManager.Players[i].localGameHost]
		$Names.add_child(label)
