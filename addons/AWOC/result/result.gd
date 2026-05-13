class_name AWOCResult
extends RefCounted


var message: String
var data: Variant
var error: Error
var severity: AWOCSeverity.Level
var details: Array[Dictionary] = []


static func success(msg: String = "", data: Variant = null) -> AWOCResult:
	return AWOCResult.new(msg, data, OK, AWOCSeverity.Level.SUCCESS)


static func failure(msg: String = "", data: Variant = null, p_error: Error = FAILED) -> AWOCResult:
	return AWOCResult.new(msg, data, p_error, AWOCSeverity.Level.ERROR)


static func warning(msg: String = "", data: Variant = null, p_error: Error = FAILED) -> AWOCResult:
	return AWOCResult.new(msg, data, p_error, AWOCSeverity.Level.WARNING)


static func info(msg: String = "", data: Variant = null, p_error: Error = FAILED) -> AWOCResult:
	return AWOCResult.new(msg, data, p_error, AWOCSeverity.Level.INFO)


func with_detail(msg: String, sev: AWOCSeverity.Level) -> AWOCResult:
	details.append({"message": msg, "severity": sev})
	return self

	
func with_warning(msg: String) -> AWOCResult:
	return with_detail(msg, AWOCSeverity.Level.WARNING)


func with_info(msg: String) -> AWOCResult:
	return with_detail(msg, AWOCSeverity.Level.INFO)


func with_error(msg: String, err: Error = FAILED) -> AWOCResult:
	error = err
	return with_detail(msg, AWOCSeverity.Level.ERROR)
	
	
func to_failure(msg: String = "", err: Error = FAILED) -> AWOCResult:
	if !msg.is_empty():
		message = msg
	error = err
	severity = AWOCSeverity.Level.ERROR
	return self


func to_success(msg: String = "") -> AWOCResult:
	if !msg.is_empty():
		message = msg
	error = OK
	severity = AWOCSeverity.Level.SUCCESS
	return self


func to_warning(msg: String = "", err: Error = FAILED) -> AWOCResult:
	if !msg.is_empty():
		message = msg
	error = err
	severity = AWOCSeverity.Level.WARNING
	return self


func to_info(msg: String = "", err: Error = FAILED) -> AWOCResult:
	if !msg.is_empty():
		message = msg
	error = err
	severity = AWOCSeverity.Level.INFO
	return self


func merge_from(other: AWOCResult, takeover_message: bool = true) -> AWOCResult:
	if takeover_message:
		message = other.message
		severity = other.severity
		error = other.error
		data = other.data
	elif not other.message.is_empty():
		details.append({"message": other.message, "severity": other.severity})
	for detail in other.details:
		details.append(detail)
	return self


func has_details() -> bool:
	return details.size() > 0


func is_success() -> bool:
	return error == OK


func _init(p_message: String, p_data: Variant, p_error: Error, p_severity: AWOCSeverity.Level) -> void:
	message = p_message
	data = p_data
	error = p_error
	severity = p_severity
