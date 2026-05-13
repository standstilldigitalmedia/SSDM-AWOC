@tool
class_name AWOCRowManagementBase
extends PanelContainer

var manager_type: String
var res_name: String
var resource_reference: AWOCResourceReference

@export_group("Nodes")
@export var name_line_edit: LineEdit
@export var rename_button: Button
@export var message_display: AWOCMessageDisplay
@export var rename_confirmation_dialog: ConfirmationDialog
@export var delete_confirmation_dialog: ConfirmationDialog


func set_row(type: String, resource_name: String, res_reference: AWOCResourceReference) -> void:
	manager_type = type
	res_name = resource_name
	resource_reference = res_reference


func _on_name_line_edit_text_changed(new_text: String) -> void:
	var validate_text: AWOCResult = AWOCValidator.is_valid_name(new_text)
	if validate_text.is_success() and new_text != res_name:
		rename_button.disabled = false
	else:
		message_display.set_label(validate_text)
		rename_button.disabled = true


func _on_rename_button_pressed() -> void:
	rename_confirmation_dialog.show()


func _on_delete_button_pressed() -> void:
	delete_confirmation_dialog.show()


func _on_edit_button_pressed() -> void:
	pass


func _ready() -> void:
	rename_button.disabled = true

func _on_rename_confirmation_dialog_confirmed() -> void:
	var rename = await AWOCPlugin.work_manager.rename_resource(manager_type, res_name, name_line_edit.text)
	message_display.set_label(rename)


func _on_delete_confirmation_dialog_confirmed() -> void:
	var delete = await AWOCPlugin.work_manager.delete_resource(manager_type, res_name, resource_reference)
	message_display.set_label(delete)
