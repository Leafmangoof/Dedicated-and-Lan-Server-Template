extends Control


func _ready():
	Server.update_list.connect(show_data)

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
		# "127.0.0.1" is your IP address to connect to your local network
		# everyone has the same one
		$VBoxContainer/address.text = "127.0.0.1"
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
