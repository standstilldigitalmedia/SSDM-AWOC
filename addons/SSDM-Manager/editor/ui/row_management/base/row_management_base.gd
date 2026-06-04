@tool
class_name SSDMRowManagementBase
extends PanelContainer

var resource_reference: SSDMResourceReference
var resource_type: String

@export_group("Nodes")
@export var name_line_edit: LineEdit
@export var rename_button: Button
@export var delete_button: Button
@export var edit_button: Button
@export var message_display: SSDMMessageDisplay
@export var rename_confirmation_dialog: ConfirmationDialog
@export var delete_confirmation_dialog: ConfirmationDialog


func set_row(res_type: String, res_reference: SSDMResourceReference) -> void:
	resource_type = res_type
	resource_reference = res_reference
	name_line_edit.text = resource_reference.res_name


func _on_rename_confirmation_dialog_confirmed() -> void:
	message_display.set_label(SSDMResult.failure("_on_rename_confirmation_dialog_confirmed must be overridden"))
	
	
func _on_delete_confirmation_dialog_confirmed() -> void:
	message_display.set_label(SSDMResult.failure("_on_delete_confirmation_dialog_confirmed must be overridden"))
	
	
func _on_name_line_edit_text_changed(new_text: String) -> void:
	var validate_text: SSDMResult = SSDMValidator.is_valid_name(new_text)
	if validate_text.is_success() and new_text != resource_reference.res_name:
		rename_button.disabled = false
	else:
		message_display.set_label(validate_text)
		rename_button.disabled = true


func _on_rename_button_pressed() -> void:
	rename_confirmation_dialog.title = "Rename " + resource_reference.res_name + "?"
	rename_confirmation_dialog.dialog_text = "Are you sure you wish to rename " + resource_reference.res_name + "?"
	rename_confirmation_dialog.show()


func _on_delete_button_pressed() -> void:
	delete_confirmation_dialog.title = "Delete " + resource_reference.res_name + "?"
	delete_confirmation_dialog.dialog_text = "Are you sure you wish to delete " + resource_reference.res_name + "?"
	delete_confirmation_dialog.show()


func _on_edit_button_pressed() -> void:
	message_display.set_label(SSDMResult.failure("_on_edit_button_pressed must be overridden"))
	
	
func _ready() -> void:
	rename_button.disabled = true
	message_display.set_label(SSDMResult.success())
