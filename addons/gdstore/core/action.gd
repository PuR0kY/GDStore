class_name Action
extends RefCounted

var type: String
var payload: Variant

func _init(_type: String, _payload: Variant = null):
	type = _type
	payload = _payload

func dispatch(store: GDStore):
	store.dispatch(self)

func _to_string() -> String:
	return "Action(%s, %s)" % [type, str(payload)]
