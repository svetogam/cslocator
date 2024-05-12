# That this node doesn't know anything about where or when it finds
# the service demonstrates the flexibility the CSLocator gives.
# It's like using a less global and constant autoload.

extends Node

var my_service = null
var my_var = 0


func _enter_tree():
	CSLocator.with(self).connect_service_changed("my_service", _on_service_changed)


func _ready():
	do_a_thing()


func _on_service_changed(found_service):
	my_service = found_service


func _on_timer_1_timeout():
	do_a_thing()


func do_a_thing():
	if my_service != null:
		my_service.do_something(my_var)
	my_var += 1
