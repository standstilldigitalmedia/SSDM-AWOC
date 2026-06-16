@tool
class_name AWOCSlotLibraryManager
extends SSDMLibraryManagerBase


func add_resource(params: Dictionary) -> SSDMResult:
	var ref_type: String = params.get("type")
	if ref_type.is_empty():
		return SSDMResult.failure("Type can not be empty")
	if ref_type == "slot":
		var slot_ref := SSDMResourceReference.new()
		slot_ref.res_name = params.get("name")
		slot_ref.stored_value = []
		var add_dictionary_result: SSDMResult = await add_dictionary_resource(slot_ref)
		if !add_dictionary_result.is_success():
			return add_dictionary_result
		var save_resource_result: SSDMResult = disk_resource_reference.save_resource_to_disk()
		if !save_resource_result.is_success():
			return save_resource_result
		return SSDMResult.success("Resource " + slot_ref.res_name + " created successfully")
	elif ref_type == "hideslot":
		pass
	return SSDMResult.failure("Resource could not be added")
	

func rename_resource(new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	return await rename_dictionary_resource(new_name, resource_reference)
	

func delete_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	return await delete_dictionary_resource(resource_reference)
