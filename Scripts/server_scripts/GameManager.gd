# THIS SCRIPT IS AN AUTOLOAD
extends Node

#This is for keeping track of players
# You can imagine the data being stored like this
#[codeblock]
# ID :{
#    "localGameHost": false
#    "playerName": Example
#    "id": ID
#}
#[/codeblock]
# The ID is the key in the Players dictionary
var Players = {}
