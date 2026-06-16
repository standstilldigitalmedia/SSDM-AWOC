@tool
class_name AWOCWelcomePanel
extends SSDMHorizontalMenuBase

func _ready() -> void:
	AWOCPlugin.work_manager.set_library_ref("welcome", null, null)
	new_resource_menu.resource_type = "welcome"
	list_management_menu.resource_type = "welcome"
	list_management_menu.set_menu_button()
	list_management_menu.populate()
	menu_button.text = turn_string_sideways("Welcome")
