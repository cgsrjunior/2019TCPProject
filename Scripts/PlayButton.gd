extends Button

onready var n_Text = get_node("../Text")
onready var n_SoundPlayer = get_node("../SoundPlayer")
onready var n_MusicDecoder = get_node("../MusicDecoder")

func _on_Play_pressed():
	var text = n_Text.text
	var notes = n_MusicDecoder.decodeText(text)
	n_SoundPlayer.playMusic(notes)
