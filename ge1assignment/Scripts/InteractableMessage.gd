extends Node

class_name InteractableMessage

# Returns the text to display when interacting with this object.
func get_interaction_text() -> String:
	return "interact"

# Called when the player interacts with this object.
func interact() -> void:
	print("Interacted with an InteractableMessage!")
