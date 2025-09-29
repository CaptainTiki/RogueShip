extends CSGBox3D

@export var x_amt :float = 0.1
@export var y_amt :float = 0.1
@export var z_amt :float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.rotation.x += x_amt * delta
	self.rotation.y += y_amt * delta
	self.rotation.z += z_amt * delta
	pass
