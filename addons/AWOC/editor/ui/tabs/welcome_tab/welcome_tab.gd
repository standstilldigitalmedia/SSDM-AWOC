@tool
class_name AWOCWelcomeTab
extends SSDMTabBase


func _ready() -> void:
	AWOCPlugin.work_manager.set_library_ref("welcome", null, null)
	new_resource_menu.menu_button.text = "New AWOC"
	list_management_menu.menu_button.text = "Manage AWOCs"
	set_type("welcome")
