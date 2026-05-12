@tool
class_name SSDMRowManagementBase
extends VBoxContainer

var manager_type: String
var res_name: String
var resource_reference: SSDMResourceReference

@export_group("Nodes")
@export var name_line_edit: LineEdit
@export var rename_button: Button
@export var message_display: SSDMMessageDisplay
@export var rename_confirmation_dialog: ConfirmationDialog
@export var delete_confirmation_dialog: ConfirmationDialog


func set_row(type: String, resource_name: String, res_reference: SSDMResourceReference) -> void:
	manager_type = type
	res_name = resource_name
	resource_reference = res_reference


func _on_name_line_edit_text_changed(new_text: String) -> void:
	var validate_text: SSDMResult = SSDMValidator.is_valid_name(new_text)
	if validate_text.is_success() and new_text != res_name:
		rename_button.disabled = false
	else:
		rename_button.disabled = true


func _on_rename_button_pressed() -> void:
	rename_confirmation_dialog.show()


func _on_delete_button_pressed() -> void:
	delete_confirmation_dialog.show()


func _on_edit_button_pressed() -> void:
	pass


func _on_rename_confirmation_dialog_confirmed() -> void:
	pass


func _on_delete_confirmation_dialog_confirmed() -> void:
	pass


func _ready() -> void:
	rename_button.disabled = true
