extends Node2D

@export var LifeTime = 10
@onready var particles = $GPUParticles2D as GPUParticles2D

var lifeTimer = 0.0

func _ready():
	lifeTimer = LifeTime
	particles.emitting = true
	
func _process(delta):
	lifeTimer -= delta
	if lifeTimer <= 0:
		queue_free()
