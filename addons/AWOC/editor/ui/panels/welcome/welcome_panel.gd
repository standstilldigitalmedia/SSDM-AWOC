@tool
class_name AWOCWelcomePanel
extends SSDMHorizontalMenuBase


@export var new_awoc_menu: SSDMNewResourceMenuBase
@export var list_management_menu: SSDMListManagementMenuBase


func _ready() -> void:
	AWOCPlugin.work_manager.set_library_ref("welcome", null)
	list_management_menu.set_menu_button()
	list_management_menu.populate()
