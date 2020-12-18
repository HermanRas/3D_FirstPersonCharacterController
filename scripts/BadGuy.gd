extends KinematicBody

export var health = 200

func _process(delta):
	if health <= 0 :
		queue_free()
