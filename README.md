
# Contextual Service Locator

## Overview

The Contextual Service Locator (CSLocator) is an implementation of the [Service Locator pattern](https://gameprogrammingpatterns.com/service-locator.html) in [Godot](https://godotengine.org/). It provides a clean interface to register objects on some node in the scene tree, which nodes below it can find as services.

The purpose is to enhance decoupling and flexibility in mid-to-large games. This comes at the cost of extra processing time spent searching for services, but this decrease in performance will be negligible for most games. For a longer explanation of why using the CSLocator might improve your codebase, see [my article on the problem it solves and its competing solutions](https://codeberg.org/svetogam/ContextualServiceLocator/wiki/Problem-and-Solutions) and the [Usage Guide](https://codeberg.org/svetogam/cslocator/wiki/Usage-Guide).


## Funny Pitch

Are singletons giving you a *headache*? Is injecting dependencies getting you *down*? The *Contextual Service Locator* could be the *answer* to your game programming architecture woes! You'll be *amazed* at how flexibly and *contextually* it locates your services! Don't delay! Try the *Contextual Service Locator* (formerly known as *"I can't believe it's not a Singleton!"*) today!


## How to Use

### Requirements

This is an addon for [Godot](https://godotengine.org/). Godot must be version 4.2.0 or later.


### Install

* Option 1: Get it from the [Godot Asset Library](https://godotengine.org/asset-library/asset) through the Godot editor.
* Option 2: Download it from the [Releases page](https://codeberg.org/svetogam/cslocator/releases) and put the `/cslocator/` folder into the `/addons/` folder in your project.


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
	
func _on_service_changed(found_service):
	my_service = found_service
```


### Usage Guide

It is recommended to read the [Usage Guide](https://codeberg.org/svetogam/cslocator/wiki/Usage-Guide) to use the CSLocator effectively. This tells you the situations it can be useful in and gives recommended patterns of use.


### API Reference

You can read the API reference either from inside the Godot editor or through [this page](https://codeberg.org/svetogam/cslocator/wiki/API-Reference).


## Contributing

Contributions, bug reports, requests, and general feedback are welcome.

To contribute, first make an issue discussing what you what you want to do. Reading the [Design Philosophy](https://codeberg.org/svetogam/cslocator/wiki/Design-Philosophy) will give you an idea of what sorts of things will be accepted.

Any feedback about real use-cases is appreciated. How did using the CSLocator go for your project? Did everything work nicely or were there unexpected problems? You can make an issue about this to tell me. This kind of feedback helps me to develop this better and improve the usage guide.


## Shameless Plug

If you found value in the CSLocator then please visit/bookmark/contribute-to/fund/talk-up/otherwise-relate-to-in-a-favoring-way the FOSS game I'm developing, [Super Practica](https://superpractica.org/). Thanks.

The Contextual Service Locator works well together with the [Composite Reverter](https://codeberg.org/svetogam/creverter)! It's exactly the kind of "service" that it's good for locating!
