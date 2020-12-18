extends RigidBody

signal Hit()

var shoot = false

export var SPEED = 4
export var DAMAGE = 50

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	if shoot :
		apply_impulse(transform.basis.z, -transform.basis.z)


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		emit_signal("Hit")
		print("hit")
		body.health -= DAMAGE
		queue_free()
	else :
		queue_free()

func _on_lifeSpan_timeout():
	queue_free()
