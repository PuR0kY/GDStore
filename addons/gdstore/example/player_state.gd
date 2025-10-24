extends Node
class_name PlayerState

const PLAYER_STATE = "player"

var initial_state := {
	"id": 0,
	"health": 100
}

var selectors := {
	"get_health": func(state: Dictionary) -> int:
		return state["health"]
}

var player_state: Dictionary = {
	"initial_state": initial_state,
	"update": Callable(self, "update"),
	"actions": actions,
	"selectors": selectors
}

func _ready() -> void:
	GDStore.register_module(PLAYER_STATE, player_state)

func update(state: Dictionary, action: Action) -> Dictionary:
	var new_state = state.duplicate(true)
	match action.type:
		"PLAYER_HIT":
			new_state["health"] -= action.payload
		"PLAYER_HEAL":
			new_state["health"] += action.payload
		_:
			return {}
	return new_state

var actions: Dictionary = {
	"hit": func(amount: int) -> Action:
		var action := Action.new("PLAYER_HIT", {"amount": amount})
		print("action payload: " + str(action.to_string()))
		return action
}

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		# DMG
		GDStore.dispatch(PlayerActions.hit(20))
		var hp = GDStore.select(PLAYER_STATE, "get_health")
		print("health: " + str(hp))
		
	if event.is_action_pressed("shift"):	
		# HEAL
		GDStore.dispatch(PlayerActions.heal(20))
		var hp = GDStore.select(PLAYER_STATE, "get_health")
		print("health: " + str(hp))
