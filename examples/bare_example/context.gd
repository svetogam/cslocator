# That this runs cleanly when either, both, or neither of the two
# methods are commented out demonstrates the temporal flexibility
# that the CSLocator gives.
# You can also try registering another service on an intermediate
# context that will have priority over these services.

extends Node


func _ready():
	CSLocator.with(self).register("my_service", $Service1)


func _on_timer_2_timeout():
	CSLocator.with(self).register("my_service", $Service2)
