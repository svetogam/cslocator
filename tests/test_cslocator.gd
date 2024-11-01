extends GutTest

const TestScene := preload("test_scene.tscn")
var scene: Node


func before_each():
	scene = TestScene.instantiate()
	add_child(scene)


func after_each():
	scene.free()


func test_find_registered_services():
	var context = $Top/Context
	var subcontext = $Top/Context/Subcontext
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var service_3 = $Top/Context/Subcontext/Service3
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).register("service_b", service_2)
	CSLocator.with(subcontext).register("service_a", service_3)
	assert_eq(CSLocator.with(context).find("service_a").name, "Service1")
	assert_eq(CSLocator.with(context).find("service_b").name, "Service2")
	assert_eq(CSLocator.with(agent_1).find("service_a").name, "Service1")
	assert_eq(CSLocator.with(agent_1).find("service_b").name, "Service2")
	assert_eq(CSLocator.with(subcontext).find("service_a").name, "Service3")
	assert_eq(CSLocator.with(subcontext).find("service_b").name, "Service2")
	assert_eq(CSLocator.with(agent_2).find("service_a").name, "Service3")
	assert_eq(CSLocator.with(agent_2).find("service_b").name, "Service2")


func test_do_not_find_unregistered_services():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent = $Top/Context/Agent
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).unregister("service_a")
	CSLocator.with(context).register("service_b", service_2)
	CSLocator.with(context).register("service_b", null)
	assert_eq(CSLocator.with(agent).find("service_a"), null)
	assert_eq(CSLocator.with(agent).find("service_b"), null)
	assert_eq(CSLocator.with(agent).find("service_c"), null)


func test_reregistering_overwrites():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent = $Top/Context/Agent
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).register("service_a", service_2)
	assert_eq(CSLocator.with(agent).find("service_a").name, "Service2")


func test_handle_default_services_for_find():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent = $Top/Context/Agent
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).register("service_b", service_1)
	CSLocator.with(context).unregister("service_b")
	assert_eq(CSLocator.with(agent).find("service_a", service_2).name, "Service1")
	assert_eq(CSLocator.with(agent).find("service_b", service_2).name, "Service2")
	assert_eq(CSLocator.with(agent).find("service_c", service_2).name, "Service2")


func test_callback_immediately_if_already_registered():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).register("service_b", service_2)
	CSLocator.with(agent_1).connect_service_found("service_a", agent_1.service_callback)
	CSLocator.with(agent_2).connect_service_found("service_b", agent_2.service_callback)
	assert_eq_deep(agent_1.event_order, ["found_service: Service1"])
	assert_eq_deep(agent_2.event_order, ["found_service: Service2"])


func test_callback_once_upon_registration_if_registered_later():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(agent_1).connect_service_found("service_a", agent_1.service_callback)
	CSLocator.with(agent_2).connect_service_found("service_b", agent_2.service_callback)
	assert_eq_deep(agent_1.event_order, [])
	assert_eq_deep(agent_2.event_order, [])

	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).register("service_b", service_2)
	CSLocator.with(context).register("service_a", service_2)
	CSLocator.with(context).register("service_b", service_1)
	assert_eq_deep(agent_1.event_order, ["found_service: Service1"])
	assert_eq_deep(agent_2.event_order, ["found_service: Service2"])


func test_callback_does_not_react_to_unregistration():
	var context = $Top/Context
	var service = $Top/Context/Service1
	var agent = $Top/Context/Agent
	CSLocator.with(agent).connect_service_found("service_a", agent.service_callback)
	CSLocator.with(context).register("service_a", service)
	CSLocator.with(context).unregister("service_a")
	assert_eq_deep(agent.event_order, ["found_service: Service1"])


func test_multiple_callbacks_for_the_same_service():
	var context = $Top/Context
	var service = $Top/Context/Service1
	var agent = $Top/Context/Agent
	CSLocator.with(agent).connect_service_found("service_a", agent.service_callback)
	CSLocator.with(agent).connect_service_found("service_a", agent.callback_1)
	CSLocator.with(agent).connect_service_found("service_a", agent.callback_2)
	CSLocator.with(agent).connect_service_found("service_a", agent.callback_2)
	CSLocator.with(context).register("service_a", service)
	assert_eq_deep(agent.event_order,
			["found_service: Service1", "callback_1", "callback_2", "callback_2"])


func test_call_service_changed_callback_immediately_and_on_change():
	var context = $Top/Context
	var subcontext = $Top/Context/Subcontext
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var service_3 = $Top/Context/Subcontext/Service3
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(agent_1).connect_service_changed("service_a", agent_1.service_callback)
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).register("service_b", service_2)
	CSLocator.with(agent_2).connect_service_changed("service_b", agent_2.service_callback)
	CSLocator.with(context).unregister("service_a")
	CSLocator.with(context).unregister("service_b")
	CSLocator.with(subcontext).register("service_a", service_3)
	CSLocator.with(subcontext).register("service_b", service_3)
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).register("service_b", service_2)
	assert_eq_deep(agent_1.event_order,
			["service_not_found", "found_service: Service1", "service_not_found",
			"found_service: Service1"])
	assert_eq_deep(agent_2.event_order,
			["found_service: Service2", "service_not_found", "found_service: Service3"])


func test_handle_default_services_for_connect_service_changed():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(agent_1).connect_service_changed(
			"service_a", agent_1.service_callback, service_2)
	CSLocator.with(agent_2).connect_service_changed(
			"service_b", agent_2.service_callback, service_2)
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(context).unregister("service_a")
	CSLocator.with(context).register("service_a", null)
	assert_eq_deep(agent_1.event_order,
			["found_service: Service2", "found_service: Service1",
			"found_service: Service2"])
	assert_eq_deep(agent_2.event_order,
			["found_service: Service2"])


func test_disconnect_service_changed():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(agent_1).connect_service_changed("service_a", agent_1.service_callback)
	CSLocator.with(agent_2).connect_service_changed("service_b", agent_2.service_callback)
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(agent_1).disconnect_service("service_a")
	CSLocator.with(agent_2).disconnect_service("service_b")
	CSLocator.with(context).register("service_a", service_2)
	CSLocator.with(context).register("service_b", service_2)
	assert_eq_deep(agent_1.event_order, ["service_not_found", "found_service: Service1"])
	assert_eq_deep(agent_2.event_order, ["service_not_found"])


func test_disconnect_service_found():
	var context = $Top/Context
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(agent_1).connect_service_found("service_a", agent_1.service_callback)
	CSLocator.with(agent_2).connect_service_found("service_b", agent_2.service_callback)
	CSLocator.with(context).register("service_a", service_1)
	CSLocator.with(agent_1).disconnect_service("service_a")
	CSLocator.with(agent_2).disconnect_service("service_b")
	CSLocator.with(context).register("service_a", service_2)
	CSLocator.with(context).register("service_b", service_2)
	assert_eq_deep(agent_1.event_order, ["found_service: Service1"])
	assert_eq_deep(agent_2.event_order, [])


func test_exiting_tree_disconnects_service_finding():
	var context = $Top/Context
	var subcontext = $Top/Context/Subcontext
	var service_1 = $Top/Context/Service1
	var service_2 = $Top/Context/Service2
	var agent_1 = $Top/Context/Agent
	var agent_2 = $Top/Context/Subcontext/Agent
	CSLocator.with(agent_1).connect_service_found("service_a", agent_1.service_callback)
	CSLocator.with(agent_2).connect_service_changed("service_a", agent_2.service_callback)
	context.remove_child(agent_1)
	subcontext.remove_child(agent_2)
	CSLocator.with(context).register("service_a", service_1)
	context.add_child(agent_1)
	subcontext.add_child(agent_2)
	CSLocator.with(context).register("service_a", service_2)
	assert_eq_deep(agent_1.event_order, [])
	assert_eq_deep(agent_2.event_order, ["service_not_found"])
