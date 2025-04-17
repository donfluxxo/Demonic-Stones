@tool
extends BTAction
## Finds a target (player or mob) on the map, sets it as target_var on the blackboard
## returning [code]SUCCESS[/code]. If no player is found it sets a random mob as temporary
## target

# Enter the group you want to set as target
@export var group : StringName 
@export var target_var : StringName = &"target"


var target : Node2D


# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "FindTarget" + LimboUtility.decorate_var(target_var)


func _tick(delta: float) -> Status:
	if group == "mobs":
		target = get_mob_node()
	elif group == "player":
		target = get_player_node()
	blackboard.set_var(target_var, target)
	return SUCCESS


# If the target is supposed to be a mob, get any in the group except itself
func get_mob_node() -> Node2D:
	var nodes : Array[Node] = agent.get_tree().get_nodes_in_group(group)
	if nodes.size() >= 2:
		while agent.check_for_self(nodes.front()):
			nodes.shuffle()
	return nodes.front()


# Return the player node if there is one, else return a random mob
func get_player_node() -> Node2D:
	var nodes : Array[Node] = agent.get_tree().get_nodes_in_group(group)
	if nodes.front() != null:
		return nodes[0]
	else:
		var alternative : Array[Node] = agent.get_tree().get_nodes_in_group("mobs")
		return alternative[0]
