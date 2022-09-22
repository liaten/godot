extends Area2D

signal hit

export var speed = 400 # Как быстро игрок будет двигаться (пиксели/с)
var screen_size # Размер игрового окна

func _ready():
	screen_size = get_viewport_rect().size
	# hide()

func _process(delta):
	var velocity = Vector2.ZERO # Вектор движения игрока
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	var width_radius = get_node("CollisionShape2D").shape.radius
	var height_radius = width_radius * 1.2
	position.x = clamp(position.x, width_radius, (screen_size.x - width_radius))
	position.y = clamp(position.y, height_radius , screen_size.y - height_radius)
	if velocity.x !=0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y !=0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # Игрок исчезает после попадания
	emit_signal("hit")
	# Должно быть отложено, тк мы не можем изменить физ.
	# свойства при обратном вызове функции
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
