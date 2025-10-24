extends Node

signal state_changed(new_state: Dictionary)

var _state: Dictionary = {}
var _modules: Dictionary = {}

func initialize():
	_state.clear()
	_modules.clear()
	emit_signal("state_changed", _state)

# Adds state module to main Store, thanks to this it can be called from the main store from anywhere
func register_module(name: String, module: Dictionary):
	if _modules.has(name):
		push_warning("Module '%s' already registered!" % name)
		return
	_modules[name] = module
	var initial_state = module.get("initial_state", {})
	_state[name] = initial_state.duplicate(true)
	emit_signal("state_changed", _state)

# Removes module by name
func unregister_module(name: String):
	if not _modules.has(name):
		return
	_modules.erase(name)
	_state.erase(name)
	emit_signal("state_changed", _state)

# Fired action gets handled in reducers
func dispatch(action):
	for module_name in _modules:
		var reducer: Callable = _modules[module_name].get("update")
		if not reducer.is_valid():
			continue
		var new_state = reducer.call(_state[module_name], action)
		if new_state == null:
			continue
		if new_state != _state[module_name]:
			_state[module_name] = new_state
			emit_signal("state_changed", _state)
			return
	push_warning("No reducer handled action: %s" % action.type)

# Gets value from selected module / store
func select(module_name: String, selector_name: String, args: Array = []):
	if not _modules.has(module_name):
		push_error("Module '%s' not found!" % module_name)
		return null
	var selectors = _modules[module_name].get("selectors", {})
	if not selectors.has(selector_name):
		push_error("Selector '%s' not found in module '%s'!" % [selector_name, module_name])
		return null
	var state = _state[module_name]
	return selectors[selector_name].callv([state] + args)

# Gets complete dictionary of Store's state
func get_state() -> Dictionary:
	return _state.duplicate(true)
