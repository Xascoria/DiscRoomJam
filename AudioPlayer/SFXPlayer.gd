extends AudioStreamPlayer

var sfx_dict := {
	"kacha": load("res://Resources/kacha.wav"),
	"key1": load("res://Resources/key1.wav"),
	"key2": load("res://Resources/key2.wav"),
	"key3": load("res://Resources/key3.wav"),
	"tick1": load("res://Resources/tick1.wav"),
}
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func play_kacha():
	self.stream = sfx_dict["kacha"]
	self.play()

func play_keys():
	var key = "key" + str(rng.randi_range(1,3))
	self.stream = sfx_dict[key]
	self.play()

func play_tick():
	self.stream = sfx_dict["tick1"]
	self.play()
