extends RayCast3D

var current_collider: Object
@onready var interaction_label = get_node("music_project/Contol/HUD/InteractionLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_interaction_text("")

# Called every frame. Handles detecting objects and processing interaction logic.
func _process(_delta):
	var collider = get_collider()  # Get the object the RayCast3D is hitting.
	if is_colliding() and collider is InteractableMessage:
		# If the collider is new or changes, update the label.
		if current_collider != collider:
			set_interaction_text(collider.get_interaction_text())
			current_collider = collider

		# If the interact key is pressed, interact with the object.
		if Input.is_action_just_pressed("interact"):
			current_collider.interact()
			set_interaction_text(collider.get_interaction_text())
	elif is_instance_valid(current_collider):
		# If no valid collider is detected, clear the interaction label.
		current_collider = null
		set_interaction_text("")

# Updates the text of the interaction label.
func set_interaction_text(text):
	if !text:
		interaction_label.visible = false
	else:
		# Fetch the key bound to the "interact" action and update the label.
		var interact_key = OS.get_keycode_string(InputMap.action_get_events("interact")[0].keycode)
		interaction_label.text = "Press %s to %s" % [interact_key, text]
		interaction_label.visible = true
