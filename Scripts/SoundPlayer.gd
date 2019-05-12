extends AudioStreamPlayer

var defaultInstrument: String = "Banjo"
var defaultTone: int = 4
var defaultBPM: float = 480.0
var defaultVolume: float = 0.0

var currentInstrument: String = defaultInstrument
var currentTone: int = defaultTone
var currentBPM: float  = defaultBPM
var currentVolume: float = defaultVolume

var toneRange: Dictionary = {"Min": 2 , "Max": 6}
var BPMRange: Dictionary = {"Min": 1.0 , "Max": 5_000.0}
var volumeRange: Dictionary = {"Min": -80.0 , "Max": 24.0}
var instruments: Array = ["Bass", "CleanGuitar", "ElectricGuitar", "SynthBass", "Banjo"]

var lowerPitchFrequency: Dictionary = {
	'C': 32.7,
	'C#': 34.6,
	'D': 36.7,
	'D#': 38.9,
	'E': 41.2,
	'F': 43.7,
	'F#': 46.2,
	'G': 49.0,
	'G#': 51.9,
	'A': 55.0,
	'A#': 58.3,
	'B': 61.7,
	}

var baseNote: Dictionary = {
	"Banjo": 'A',
	"Bass": 'A',
	"CleanGuitar": 'C',
	"ElectricGuitar": 'C',
	"Mandonlin": 'A',
	"Saxophone": 'A',
	"SynthBass": 'C',
	"Trombone": 'A',
	"Violin": 'A',
	}

func _ready() -> void:
	setDefaults()

func playMusic(actions: Array) -> void:
	for action in actions:
		if action[0] == "Note":
			playNote(action[1])
			yield(wait(), "timeout")
		
		elif action[0] == "Tone":
			if action[1] == "Default":
				setTone(defaultTone)
			
			elif action[1].begins_with("+") or action[1].begins_with("-"):
				shiftTone(int(action[1]))
		
		elif action[0] == "BPM":
			if action[1] == "Default":
				setBPM(defaultBPM)
			
			elif action[1].begins_with("+") or action[1].begins_with("-"):
				shiftBPM(float(action[1]))
			
			elif action[1].begins_with("*"):
				multiplyBPM(float(action[1].trim_prefix("*")))
		
		elif action[0] == "Volume":
			if action[1] == "Default":
				setVolume(defaultVolume)
			
			if action[1].begins_with("+") or action[1].begins_with("-"):
				shiftVolume(float(action[1]))
			
			elif action[1].begins_with("*"):
				multiplyVolume(float(action[1].trim_prefix("*")))
		
		elif action[0] == "Instrument":
			if action[1] == "Next":
				nextInstrument()
		
		elif action[0] == "Action":
			if action[1] == "Wait":
				yield(wait(), "timeout")
	
	setDefaults()

func setDefaults() -> void:
	setTone(defaultTone)
	setBPM(defaultBPM)
	setVolume(defaultVolume)
	setIntrument(defaultInstrument)

func wait() -> Object:
	return get_tree().create_timer(60.0/currentBPM)

func playNote(note: String) -> void:
	pitch_scale = lowerPitchFrequency[note] / lowerPitchFrequency[baseNote[currentInstrument]]
	play()

func shiftTone(valueOffset: int) -> void:
	setTone(currentTone + valueOffset)
	
func shiftBPM(valueOffset: float) -> void:
	setBPM(currentBPM + valueOffset)

func shiftVolume(valueOffset: float) -> void:
	setVolume(currentVolume + valueOffset)

func multiplyTone(valueMultiplier: int) -> void:
	setTone(currentTone * valueMultiplier)

func multiplyBPM(valueMultiplier: float) -> void:
	setBPM(currentBPM * valueMultiplier)

func multiplyVolume(valueMultiplier: float) -> void:
	setVolume(currentVolume * valueMultiplier)

func nextInstrument() -> void:
	setIntrument(instruments[0])

func setTone(newTone: int) -> void:
	newTone = toneRange["Min"] if newTone < toneRange["Min"] else newTone
	newTone = toneRange["Max"] if newTone > toneRange["Max"] else newTone
	
	currentTone = newTone
	updateStreamFile()

func setIntrument(newInstrument: String) -> void:
	currentInstrument = newInstrument if instruments.has(newInstrument) else defaultInstrument
	
	updateStreamFile()
	
	instruments.remove(instruments.find(currentInstrument))
	instruments.append(currentInstrument)
	print(instruments)

func setBPM(newBPM: float) -> void:
	newBPM = BPMRange["Min"] if newBPM < BPMRange["Min"] else newBPM
	newBPM = BPMRange["Max"] if newBPM > BPMRange["Max"] else newBPM
	
	currentBPM = newBPM

func setVolume(newVolume: float) -> void:
	newVolume = volumeRange["Min"] if newVolume < volumeRange["Min"] else newVolume
	newVolume = volumeRange["Max"] if newVolume > volumeRange["Max"] else newVolume
	
	currentVolume = newVolume
	volume_db = currentVolume

func updateStreamFile() -> void:
	stream = load("res://BaseSounds/" + currentInstrument +"/"+ baseNote[currentInstrument] + String(currentTone) + ".wav")