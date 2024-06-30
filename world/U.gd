extends Node

func delay(secs):
	await get_tree().create_timer(secs).timeout
	return
	
func getTime():
	return Time.get_time_dict_from_system().second
