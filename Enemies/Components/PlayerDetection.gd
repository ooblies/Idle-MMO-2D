extends Area2D

var players = null
var player = null

func can_see_player():
	if player == null:
		players = get_overlapping_bodies()
		if players.size() > 0:
			player = players[0]
		
	return player != null


func _on_PlayerDetection_body_entered(body):
	#print(body.name)
	pass


func _on_PlayerDetection_area_entered(area):
	print(area)
