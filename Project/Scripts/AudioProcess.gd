extends Node2D
class_name  AudioProcess

signal OnMusicEvent(event : MusicEvent)

const MIN_DB = 80

@export var MusicPlayer : AudioStreamPlayer
@export var MusicParametersPath : String

var spectrum : AudioEffectInstance
var musicParameters : MusicParameters

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	musicParameters = MusicParameters.LoadFromFile(MusicParametersPath)
	
func GetMusicData() -> MusicData: 
	var result = MusicData.new()

	var magnitude: float = spectrum.get_magnitude_for_frequency_range(musicParameters.PlataformHzRange.Min, musicParameters.PlataformHzRange.Max).length()
	result.PlataformValue = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	result.PlataformValue = remap(result.PlataformValue, musicParameters.PlataformHzRange.DbMin, musicParameters.PlataformHzRange.DbMax, 0, 1)
		
	magnitude = spectrum.get_magnitude_for_frequency_range(musicParameters.ObstacleHzRange.Min, musicParameters.ObstacleHzRange.Max).length()
	result.ObstacleValue = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	result.ObstacleValue = remap(result.ObstacleValue, musicParameters.ObstacleHzRange.DbMin, musicParameters.ObstacleHzRange.DbMax, 0, 1)
	
	magnitude = spectrum.get_magnitude_for_frequency_range(musicParameters.WaveHzRange.Min, musicParameters.WaveHzRange.Max).length()
	result.WaveValue = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	result.WaveValue = remap(result.WaveValue, musicParameters.WaveHzRange.DbMin, musicParameters.WaveHzRange.DbMax, 0, 1)
	
	for i in range(musicParameters.Events.size()):
		if musicParameters.Events[i].TimeSeconds >= MusicPlayer.get_playback_position():
			emit_signal("OnMusicEvent", musicParameters.Events[i])
			musicParameters.Events.remove_at(i)
			continue
	
	return result

