extends Control

func _ready():
	$Iniciar.pressed.connect(_on_botao_jogar_pressed)

func _on_botao_jogar_pressed():
	get_tree().change_scene_to_file("res://subMenu.tscn")
