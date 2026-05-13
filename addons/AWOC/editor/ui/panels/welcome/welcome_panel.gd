@tool
class_name AWOCWelcomePanel
extends AWOCHorizontalMenu


func _ready() -> void:
	super()
	var create = await AWOCPlugin.work_manager.get_manager("welcome").get_or_create_welcome_resource()
	if !create.is_success():
		print("error: " + create.message)
	var new_awoc_res_ref = AWOCResourceReference.new()
	var get_new = AWOCPlugin.work_manager.get_new_resource("welcome")
	if get_new.is_success():
		new_awoc_res_ref.resource = get_new.data
	else:
		print("error: " + get_new.message)
	AWOCPlugin.work_manager.set_manager("welcome", create.data, create.data.resource.awoc_dictionary)
