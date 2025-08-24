extends Lobby

const PACKET_READ_LIMIT: int = 32

var lobby_id: int = 0
var lobby_members_max: int = 4

func _ready() -> void:
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)


func create_lobby():
	if lobby_id == 0:
		is_host = true
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, lobby_members_max)

func _on_lobby_created(connect: int, this_lobby_id: int):
	if connect == 1:
		lobby_id = this_lobby_id

		Steam.setLobbyJoinable(lobby_id, true)
		Steam.setLobbyData(lobby_id, "name", "Test Lobby")
		
		var set_relay: bool = Steam.allowP2PPacketRelay(true)
		on_lobby_connected.emit()

func join_lobby(this_lobby_id: int):
	Steam.joinLobby(this_lobby_id)

func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobby_id = this_lobby_id
		on_lobby_connected.emit()



func refresh_lobby_members():
	lobby_members.clear()
	
	for member in range(0, Steam.getNumLobbyMembers(lobby_id)):
		
		var member_info = PlayerInfo.new()
		member_info.uid = Steam.getLobbyMemberByIndex(lobby_id, member)
		var member_steam_name = Steam.getFriendPersonaName(member_info.uid)
		
		lobby_members.append(member_info)


#func send_p2p_packet(this_target: int, packet_data: Dictionary, send_type: int = 0):
#	var channel: int = 0
#	var this_data: PackedByteArray
#	this_data.append_array(var_to_bytes(packet_data))
#	
#	if this_target == 0:
#		for member in lobby_members:
#			if member.uid != Global.steam_id:
#				Steam.sendP2PPacket(member.uid, this_data, send_type, channel)
#	else:
#		Steam.sendP2PPacket(this_target, this_data, send_type, channel)
