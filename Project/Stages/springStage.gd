extends Node2D

@onready var musicPlayer = $MusicPlayer
@onready var audioProcess = $AudioProcess as AudioProcess
@onready var wave1Position = $Wave/Path2D/Wave1Position as PathFollow2D

func _ready():
	pass

func _process(delta):
	if musicPlayer.playing:
		var musicData = audioProcess.GetMusicData()
		wave1Position.progress_ratio = lerpf(wave1Position.progress_ratio, musicData.WaveValue, 0.5) 
		print_debug("p: " + str(musicData.PlataformValue) + " o: " + str(musicData.ObstacleValue) + " w: " + str(musicData.WaveValue))
	
func _on_audio_process_on_music_event(event):
	pass # Replace with function body.
