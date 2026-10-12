extends Area2D


var vel = 70
var dir = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += vel * delta * dir

func set_dir(dirBala):
	self.dir = dirBala
