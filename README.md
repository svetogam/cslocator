
# Contextual Service Locator

## Overview

The Contextual Service Locator is an implementation of the [Service Locator pattern](https://gameprogrammingpatterns.com/service-locator.html) in [Godot](https://godotengine.org/). It provides a clean interface to register objects on some node in the scene tree, which nodes below it can find as services.

The purpose is to enhance decoupling and flexibility in mid-to-large games. This comes at the cost of extra processing time spent searching for services, but this decrease in performance will be negligible for most games. For a longer explanation of why using the Contextual Service Locator might improve your codebase, see [my article on the problem it solves and its competing solutions](https://codeberg.org/svetogam/ContextualServiceLocator/wiki/Problem-and-Solutions).


## Funny Pitch

Are singletons giving you a *headache*? Is injecting dependencies getting you *down*? The *Contextual Service Locator* could be the *answer* to your game programming architecture woes! You'll be *amazed* at how flexibly and *contextually* it locates your services! Try the *Contextual Service Locator* (formerly known as *"I can't believe it's not a Singleton!"*) today!
