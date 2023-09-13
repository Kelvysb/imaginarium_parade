class_name MusicParameters

var PlataformHzRange : FrequencyRange = FrequencyRange.new()
var ObstacleHzRange : FrequencyRange = FrequencyRange.new()
var WaveHzRange : FrequencyRange = FrequencyRange.new()
var Events : Array[MusicEvent] = []

static func LoadFromFile(path) -> MusicParameters:
	var result = MusicParameters.new() as MusicParameters
	if not FileAccess.file_exists(path):
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	result.PlataformHzRange.Max = data.plataformHzRange.max
	result.PlataformHzRange.Min = data.plataformHzRange.min
	result.PlataformHzRange.DbMax = data.plataformHzRange.dbMax
	result.PlataformHzRange.DbMin = data.plataformHzRange.dbMin	
	result.ObstacleHzRange.Max = data.obstacleHzRange.max
	result.ObstacleHzRange.Min = data.obstacleHzRange.min
	result.ObstacleHzRange.DbMax = data.obstacleHzRange.dbMax
	result.ObstacleHzRange.DbMin = data.obstacleHzRange.dbMin
	result.WaveHzRange.Max = data.waveHzRange.max
	result.WaveHzRange.Min = data.waveHzRange.min
	result.WaveHzRange.DbMax = data.waveHzRange.dbMax
	result.WaveHzRange.DbMin = data.waveHzRange.dbMin
	for event in data.events:
		var newEvent = MusicEvent.new()
		newEvent.Key = event.key
		newEvent.Value = event.value
		newEvent.TimeSeconds = event.timeSeconds
		result.Events.append(newEvent)		
	return result
