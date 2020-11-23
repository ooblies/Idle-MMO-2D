extends Node

var parties = []

func create_party(name):
	var p = Party.new()
	p.name = name
	parties.append(p)

func delete_party(name):
	for party_index in parties.size():
		if parties[party_index].name == name:
			parties.remove(party_index)

func get_party_by_name(party_name):
	for party in parties:
		if party.name == party_name:
			return party
	return null

func add_character_to_party(party_name, character : Character):
	for party in parties:
		if party.name == party_name:
			party.add_character(character)
		else:
			if party.is_character_in_party(character):
				party.remove_character(character)

func remove_character_from_party(party_name, character):
	get_party_by_name(party_name).remove_character(character)

func get_parties():
	return parties
