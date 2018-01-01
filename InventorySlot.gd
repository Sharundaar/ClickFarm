extends TextureFrame

export(Texture) var unselectedTexture
export(Texture) var selectedTexture
export(bool)    var selected = false setget set_selected, is_selected

func is_selected():
	return selected

func set_selected( value ):
	selected = value
	if selected:
		set_texture( selectedTexture )
	else:
		set_texture( unselectedTexture )
