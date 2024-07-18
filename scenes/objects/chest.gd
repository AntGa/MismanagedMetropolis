extends Interactable

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var container: Control = $Container

var item_scene: PackedScene = preload("res://scenes/buildings/bronze_pickaxe.tscn")
@export var opened: bool = false
var in_area: bool = false

func _ready() -> void:
	Interact_UI = container
	hide_interact()

func _process(delta: float) -> void:
	if not in_area:
		return
	if Input.is_action_just_pressed("interact"):
		on_open_chest()

func _on_animated_sprite_2d_animation_finished() -> void:
	spawn_item(2)
	
func on_open_chest() -> void:
	sprite.play("ChestOpen")
	hide_interact()

func spawn_item(amount: int) -> void:
	for i in range(amount):
		var item_instance = item_scene.instantiate()
		add_child(item_instance)
		item_instance.position = Vector2(0,0)
		var random_angle = randf_range(0, 2 * PI)
		var force_magnitude = 500
		var item_velocity = Vector2(cos(random_angle), sin(random_angle)) * force_magnitude
		item_instance.set("velocity", item_velocity) 
		opened = true
		
		SoundManager.play_sound("Tap")
		
		await(get_tree().create_timer(0.25).timeout)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not (body is Player):
		return
	if !opened:
		in_area = true
		show_interact()
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if not (body is Player):
		return
	in_area = false
	hide_interact()

