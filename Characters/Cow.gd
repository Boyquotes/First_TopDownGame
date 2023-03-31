extends CharacterBody2D

#cow states with enum 
enum COW_STATE {IDLE, WALK }

@export var move_speed : float = 20
@export var idle_time : float = 8
@export var walk_time : float = 6
@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer
var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE

func _ready():
	pick_new_state()

func _physics_process(_delta):
	if(current_state == COW_STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()
func select_new_direction():
	move_direction = Vector2(randi_range(-1,1), randi_range(-1, 1) )
	if(move_direction.x < 0 ):
		sprite.flip_h = true
	elif (move_direction.x > 0):
		sprite.flip_h = false
func  pick_new_state():
	if(current_state == COW_STATE.IDLE):
		#change to walk state
		select_new_direction()
		if(move_direction != Vector2(0,0)):
			state_machine.travel("Move")
			current_state = COW_STATE.WALK
		timer.start(walk_time)
	elif (current_state == COW_STATE.WALK):
		#change to idle state
		state_machine.travel("Idle")
		current_state = COW_STATE.IDLE
		timer.start(idle_time)
		
func _on_timer_timeout():
	pick_new_state()
