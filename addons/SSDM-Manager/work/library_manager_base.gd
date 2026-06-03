@abstract class_name SSDMLibraryManagerBase
extends RefCounted

var library_manager_ref: SSDMResourceReference
var library_manager: SSDMLibrary
	

func set_library_ref(resource_reference: SSDMResourceReference) -> SSDMResult:
	library_manager_ref = resource_reference
	var library_manager_result: SSDMResult = library_manager_ref.get_resource()
	if !library_manager_result.is_success():
		return library_manager_result
	library_manager = library_manager_result.data
	return SSDMResult.success()
	
	
@abstract func add_resource(resource_reference: SSDMResourceReference) -> SSDMResult
@abstract func rename_resource(new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult
@abstract func delete_resource(resource_reference: SSDMResourceReference) -> SSDMResult
