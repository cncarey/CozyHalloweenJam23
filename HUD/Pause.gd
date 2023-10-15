extends CanvasLayer

@onready var MainContainer = $MainContainer
@onready var OptionsContainer = $OptionsContainer
@onready var SkillTreeContainer = $SkillsTreeContainer

#sound buses
@onready var master_bus :int = AudioServer.get_bus_index("Master")
@onready var music_bus :int = AudioServer.get_bus_index("Music")
@onready var sfx_bus :int = AudioServer.get_bus_index("SoundFx")

#sliders
@onready var masterSlider : HSlider = $OptionsContainer/VBoxContainer/HBoxContainer/VBoxContainer2/MasterSlider
@onready var musicSlider: HSlider = $OptionsContainer/VBoxContainer/HBoxContainer/VBoxContainer2/MusicSlider
@onready var sFxSlider: HSlider = $OptionsContainer/VBoxContainer/HBoxContainer/VBoxContainer2/SFxSlider
signal pauseChanged(state)

func _ready():
	
	self.visible = false
		
	var curMaster : int= AudioServer.get_bus_volume_db(master_bus)
	if curMaster != null:
		masterSlider.value = curMaster
		pass
	
	var curMusic : int= AudioServer.get_bus_volume_db(music_bus)
	if curMusic != null:
		musicSlider.value = curMusic
		pass
		
	var curSfx : int= AudioServer.get_bus_volume_db(sfx_bus)
	if curSfx != null:
		sFxSlider.value = curSfx
		pass
		
		
func _input(event):
	if event.is_action_pressed("Pause"):
		pause()
		
func pause():
	
	get_tree().paused = !get_tree().paused 
	pauseChanged.emit(get_tree().paused)
	self.visible = !self.visible
	#ensure the main container is showing
	hideShow(OptionsContainer, MainContainer)
	hideShow(SkillTreeContainer, MainContainer)

func resumePressed():
	get_tree().paused = false
	pauseChanged.emit(get_tree().paused)
	self.visible = false
	pass
	
func quitPressed():
	get_tree().paused = false
	pauseChanged.emit(get_tree().paused)
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
	pass

func hideOptions():
	hideShow(OptionsContainer, MainContainer)
	pass

func showOptions():
	hideShow(MainContainer, OptionsContainer)
	pass
	

func masterVolumeChanged(value: float):
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
	pass
	
func musicVolumeChanged(value: float):
	AudioServer.set_bus_volume_db(music_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(music_bus, true)
	else:
		AudioServer.set_bus_mute(music_bus, false)
	pass
	
func sfxVolumeChanged(value: float):
	AudioServer.set_bus_volume_db(sfx_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(sfx_bus, true)
	else:
		AudioServer.set_bus_mute(sfx_bus, false)
	pass
		
func hideSkillsTree():
	hideShow(SkillTreeContainer, MainContainer)
	pass

func showSkillsTree():
	hideShow(MainContainer, SkillTreeContainer)
	pass
	
func hideShow(hide, show):
	hide.hide()
	show.show()
	pass
