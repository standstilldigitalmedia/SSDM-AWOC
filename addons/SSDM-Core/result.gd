class_name SSDMResult
extends RefCounted

enum Severity
{
	SUCCESS,
	INFO,
	WARNING,
	ERROR,
}

var message: String
var data: Variant
var error: Error
var severity: Severity
var details: Array[Dictionary] = []


static func success(msg: String = "", data: Variant = null) -> SSDMResult:
	return SSDMResult.new(msg, data, OK, Severity.SUCCESS)
	
	
static func print_success(msg: String = "", data: Variant = null) -> SSDMResult:
	printerr("SSDM Success: " + msg)
	print_stack()
	return SSDMResult.new(msg, data, OK, Severity.SUCCESS)


static func failure(msg: String = "", data: Variant = null, p_error: Error = FAILED) -> SSDMResult:
	return SSDMResult.new(msg, data, p_error, Severity.ERROR)
	
	
static func print_failure(msg: String = "", data: Variant = null, p_error: Error = FAILED) -> SSDMResult:
	printerr("SSDM Error: " + msg)
	print_stack()
	return SSDMResult.new(msg, data, p_error, Severity.ERROR)


static func warning(msg: String = "", data: Variant = null, p_error: Error = OK) -> SSDMResult:
	return SSDMResult.new(msg, data, p_error, Severity.WARNING)
	
	
static func print_warning(msg: String = "", data: Variant = null, p_error: Error = OK) -> SSDMResult:
	printerr("SSDM Warning: " + msg)
	print_stack()
	return SSDMResult.new(msg, data, p_error, Severity.WARNING)


static func info(msg: String = "", data: Variant = null, p_error: Error = OK) -> SSDMResult:
	return SSDMResult.new(msg, data, p_error, Severity.INFO)
	
	
static func print_info(msg: String = "", data: Variant = null, p_error: Error = OK) -> SSDMResult:
	printerr("SSDM Info: " + msg)
	print_stack()
	return SSDMResult.new(msg, data, p_error, Severity.INFO)
	

func is_success() -> bool:
	return error == OK


func _init(p_message: String, p_data: Variant, p_error: Error, p_severity: Severity) -> void:
	message = p_message
	data = p_data
	error = p_error
	severity = p_severity
