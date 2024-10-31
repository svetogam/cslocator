# Contextual Service Locator

The Contextual Service Locator (CSLocator) (formerly known as *"I can't believe it's not a Singleton!"*) is a lightweight and contextual implementation of the [Service Locator pattern](https://gameprogrammingpatterns.com/service-locator.html) for [Godot](https://godotengine.org/). It provides a clean interface to register and find objects through the scene tree like localized singletons.

Its purpose is to enhance structural and temporal decoupling in mid-to-large games. This helps make games more flexible to redesign and add new features even late in development with minimal time spent debugging. But it comes at the cost of extra processing time to find objects dynamically.

To make the most of CSLocator, check out the [Usage Guide](https://codeberg.org/svetogam/cslocator/wiki/Usage-Guide) and its companion addon, [CSConnector](https://codeberg.org/svetogam/csconnector). Happy decoupling!


## How to Use

### Requirements

Godot must be version 4.2.0 or later.


### Install

* Option 1: Get it from the [Godot Asset Library](https://godotengine.org/asset-library/asset) through the Godot editor.
* Option 2: Download it from the [Releases page](https://codeberg.org/svetogam/cslocator/releases) and put the `cslocator/` folder into the `res://addons/` folder in your project.


### Quickstart

In an ancestor node:

```
func _ready():
	CSLocator.with(self).register("my_service", $MyService)
```

In a descendant node:
```
var my_service = null

func _enter_tree():
	CSLocator.with(self).connect_service_changed("my_service", _on_service_changed)
	
func _on_service_changed(service):
	my_service = service
```


### Usage Guide

It is recommended to read the [Usage Guide](https://codeberg.org/svetogam/cslocator/wiki/Usage-Guide) to use the CSLocator effectively. It explains what problems CSLocator solves and the best ways to solve them with it.


### API Reference

To view the API reference from inside the Godot editor: Either press F1 or go to Script > Search Help, and then search for "CSLocator".


## Contributing

Contributions, bug reports, requests, and general feedback are welcome. Make a new issue to get started.


## Plug

If you found value in this addon then please check out [Super Practica](https://codeberg.org/superpractica/superpractica) and just generally relate to it in a positive way. Thanks!
