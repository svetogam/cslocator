extends Node

var event_order: Array = []


func service_callback(found_service: Node) -> void:
	if found_service != null:
		event_order.append("found_service: " + found_service.name)
	else:
		event_order.append("service_not_found")


func callback_1(_arg = null) -> void:
	event_order.append("callback_1")


func callback_2(_arg = null) -> void:
	event_order.append("callback_2")
