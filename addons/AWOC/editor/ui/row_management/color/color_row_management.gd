@tool
class_name AWOCColorRowManagement
extends AWOCRowManagementBase

@export var color_picker_button: ColorPickerButton


func _on_color_picker_button_popup_closed() -> void:
	var params: Dictionary = {}
	params.set("prop", "color")
	params.set("value", color_picker_button.color)
	var modify_result: SSDMResult = AWOCPlugin.work_manager.modify_resource_property(
		resource_type, resource_reference, params)
	message_display.set_label(modify_result)
	
	
func set_row(res_type: String, res_reference: SSDMResourceReference) -> void:
	color_picker_button.color = res_reference.stored_value
	super(res_type, res_reference)
