extends Node2D

@onready var musicPlayer = $MusicPlayer
@onready var audioProcess = $AudioProcess as AudioProcess
@onready var wave1Position = %Wave1Position as PathFollow2D
@onready var wave2Position = %Wave2Position as PathFollow2D
@onready var plataformTimer = $PlataformTimer

@onready var plataformPoint1 = $PlataformsPoints/PlataformPoint1
@onready var plataformPoint2 = $PlataformsPoints/PlataformPoint2
@onready var plataformPoint3 = $PlataformsPoints/PlataformPoint3
@onready var plataformPoint4 = $PlataformsPoints/PlataformPoint4
@onready var plataformPoint5 = $PlataformsPoints/PlataformPoint5
@onready var plataformPoint6 = $PlataformsPoints/PlataformPoint6
@onready var plataformPoint7 = $PlataformsPoints/PlataformPoint7
@onready var obstaclePoint1 = $ObstaclesPoints/ObstaclePoint1
@onready var obstaclePoint2 = $ObstaclesPoints/ObstaclePoint2
@onready var obstaclePoint3 = $ObstaclesPoints/ObstaclePoint3
@onready var obstaclePoint4 = $ObstaclesPoints/ObstaclePoint4
@onready var obstaclePoint5 = $ObstaclesPoints/ObstaclePoint5
@onready var obstaclePoint6 = $ObstaclesPoints/ObstaclePoint6
@onready var obstaclePoint7 = $ObstaclesPoints/ObstaclePoint7

var plataformDbMax = 0.1

var stageSpeed = 100
var plataform = preload("res://Objects/Plataform.tscn")
var obstacle = preload("res://Objects/Obstacle.tscn")
var lifeUp = preload("res://Objects/LifeUp.tscn")
var plataformBuffer : Vector2
var obstacleBuffer : Vector2

func _ready():
	plataformBuffer = plataformPoint4.global_position

func _process(delta):
	if musicPlayer.playing:
		var musicData = audioProcess.GetMusicData()
		wave1Position.progress_ratio = lerpf(wave1Position.progress_ratio, musicData.WaveValue, 0.1) 
		wave2Position.progress_ratio = lerpf(wave1Position.progress_ratio, musicData.WaveValue, 0.1) 
		SetPlataform(musicData)
		SetObstacle(musicData)

	
func SetPlataform(musicData : MusicData):
	if musicData.PlataformValue >= 0.7:
		plataformBuffer = plataformPoint1.global_position
	elif musicData.PlataformValue >= 0.6:
		plataformBuffer = plataformPoint6.global_position
	elif musicData.PlataformValue >= 0.5:
		plataformBuffer = plataformPoint2.global_position
	elif musicData.PlataformValue >= 0.4:
		plataformBuffer = plataformPoint5.global_position
	elif musicData.PlataformValue >= 0.3:
		plataformBuffer = plataformPoint3.global_position
	elif musicData.PlataformValue >= 0.2:
		plataformBuffer = plataformPoint7.global_position
	else:
		plataformBuffer = plataformPoint4.global_position	

func SetObstacle(musicData : MusicData):
	if musicData.ObstacleValue >= 0.7:
		obstacleBuffer = obstaclePoint4.global_position
	elif musicData.ObstacleValue >= 0.6:
		obstacleBuffer = obstaclePoint3.global_position
	elif musicData.ObstacleValue >= 0.7:
		obstacleBuffer = obstaclePoint5.global_position
	elif musicData.ObstacleValue >= 0.4:
		obstacleBuffer = obstaclePoint2.global_position
	elif musicData.ObstacleValue >= 0.3:
		obstacleBuffer = obstaclePoint6.global_position
	elif musicData.PlataformValue >= 0.2:
		obstacleBuffer = obstaclePoint1.global_position
	else:
		obstacleBuffer = obstaclePoint7.global_position	
		
func SpawnPlataform(point: Vector2):
	var instance = plataform.instantiate()
	instance.global_position = point
	add_child(instance)
	
func SpawnObstacle(point: Vector2):	
	var instance = obstacle.instantiate()
	instance.global_position = point
	add_child(instance)
	
func SpawnLifeUp(point: Vector2):	
	var instance = lifeUp.instantiate()
	instance.global_position = point
	add_child(instance)
	
	
func _on_audio_process_on_music_event(event):
	pass # Replace with function body.

func _on_plataform_timer_timeout():
	SpawnPlataform(plataformBuffer)


func _on_obstacle_timer_timeout():
	var chance = randi_range(0, 100)
	if chance > 20:	
		SpawnObstacle(obstacleBuffer)
	else:
		SpawnLifeUp(obstacleBuffer)
