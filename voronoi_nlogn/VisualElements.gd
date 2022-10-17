extends Node


func _on_LineEditRange_text_changed(new_text):
	get_tree().root.get_node("/root/Node2D/Generator").change_main_range(new_text)


func _on_Button_pressed():
	get_tree().root.get_node("/root/Node2D/Generator").regenerate()

func hide():
	for child in self.get_children():
		child.hide()

func show():
	for child in self.get_children():
		child.show()
