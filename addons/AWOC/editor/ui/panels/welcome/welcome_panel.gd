@tool
class_name AWOCWelcomePanel
extends SSDMHorizontalMenu


@export var new_awoc_menu: SSDMNewResourceMenuBase
@export var list_management_menu: SSDMListManagementBase


func _ready() -> void:
	AWOCPlugin.work_manager.set_library_ref("welcome", null)
	list_management_menu.set_menu_button()
	list_management_menu.populate()
	super()
