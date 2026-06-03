@tool
@abstract class_name SSDMRowManagementBase
extends PanelContainer

var resource_reference: SSDMResourceReference

@export_group("Nodes")
@export var name_line_edit: LineEdit
@export var rename_button: Button
@export var message_display: SSDMMessageDisplay
@export var rename_confirmation_dialog: ConfirmationDialog
@export var delete_confirmation_dialog: ConfirmationDialog

@abstract func _on_rename_confirmation_dialog_confirmed() -> void
@abstract func _on_delete_confirmation_dialog_confirmed() -> void


func set_row(res_reference: SSDMResourceReference) -> void:
	resource_reference = res_reference


func _on_name_line_edit_text_changed(new_text: String) -> void:
	var validate_text: SSDMResult = SSDMValidator.is_valid_name(new_text)
	if validate_text.is_success() and new_text != resource_reference.res_name:
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
	message_display.set_label(SSDMResult.success())
