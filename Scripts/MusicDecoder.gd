extends Node

var notePitch: Dictionary = {
	'A': 'C',
	'B': 'D',
	'C': 'E',
	'D': 'F',
	'E': 'G',
	'F': 'A',
	'G': 'B',
	}

func decodeText(inputText: String) -> Array:
	var lastCharComputed: String = ""
	var musicSheet: Array = []
	
	for c in inputText:
		if lastCharComputed == 'O':
			if c == '+':
				musicSheet.append(["Tone", "+1"])
			
			elif c == '-':
				musicSheet.append(["Tone", "-1"])
		
		elif lastCharComputed == 'B' && (c == '+' || c == '-'):
			if c == '+':
				musicSheet.append(["BPM", "+50"])
			
			elif c == '-':
				musicSheet.append(["BPM", "-50"])
		
		elif notePitch.has(String(c).to_upper()):
			var note = notePitch[String(c).to_upper()]
			musicSheet.append(["Note", note])
		
		elif c == ' ':
			musicSheet.append(["Action", "Wait"])
		
		elif c == '+':
			musicSheet.append(["Volume", "*2"])
		
		elif c == '-':
			musicSheet.append(["Volume", "*0.5"])
		
		elif String(c).to_upper() == 'I' || String(c).to_upper() == 'O' || String(c).to_upper() == 'U':
			if notePitch.has(String(lastCharComputed).to_upper()):
				var note = notePitch[String(lastCharComputed).to_upper()]
				musicSheet.append(["Note", note])
			
			else:
				musicSheet.append(["Action", "Wait"])
		
		elif c == '?' || c == '.':
			musicSheet.append(["Tone", "Default"])
		
		elif c == '\n':
			musicSheet.append(["Instrument", "Next"])
		
		lastCharComputed = c
	
	return musicSheet