class_name Lobby extends Node

var is_connected: bool = false
var is_host: bool = false

var lobby_members: Array[int] = []

signal on_lobby_connected
signal on_lobby_disconnected
signal on_player_connected(pid: int)
