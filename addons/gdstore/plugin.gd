@tool
extends EditorPlugin

const STORE_SINGLETON_NAME = "GDStore"
const STORE_PATH = "res://addons/gdstore/core/gdstore.gd"

func _enable_plugin() -> void:
	if not ProjectSettings.has_setting("autoload/%s" % STORE_SINGLETON_NAME):
		add_autoload_singleton(STORE_SINGLETON_NAME, STORE_PATH)
		print("GDStore Added.")

func _disable_plugin() -> void:
	remove_autoload_singleton(STORE_SINGLETON_NAME)

func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
