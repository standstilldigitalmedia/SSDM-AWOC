@tool
class_name AWOCWelcomePanel
extends SSDMHorizontalMenu


func _ready() -> void:
	var create = await AWOCPlugin.work_manager.get_manager("welcome").get_or_create_welcome_resource()
	if !create.is_success():
		print("error: " + create.message)
	var new_awoc_res_ref = SSDMResourceReference.new()
	var get_new = AWOCPlugin.work_manager.create_resource("welcome")
	if get_new.is_success():
		new_awoc_res_ref.resource = get_new.data
	else:
		print("error: " + get_new.message)
	new_awoc_res_ref.res_path = "res://testing/new_awoc"
	AWOCPlugin.work_manager.get_manager("welcome")._parent_resource_reference = create.data
	AWOCPlugin.work_manager.get_manager("welcome")._resource_dictionary = create.data.resource.awoc_dictionary
	var new_awoc = await AWOCPlugin.work_manager.add_resource("welcome", "my_awoc", new_awoc_res_ref)
	if !new_awoc.is_success():
		print("error: " + new_awoc.message)
