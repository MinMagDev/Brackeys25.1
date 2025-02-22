extends Area2D

signal start()

@export
var mistproj_sprite : Texture2D
@export
var electron_pistol_sprite : Texture2D
@export
var leng_glas_sprite : Texture2D

var artifact : ArtifactGlobal.ArtifactType

func set_artifact(_artifact: ArtifactGlobal.ArtifactType) -> void:
	artifact = _artifact
	var sprite : Texture2D
	match artifact:
		ArtifactGlobal.ArtifactType.MISTPROJ:
			sprite = mistproj_sprite
		ArtifactGlobal.ArtifactType.ELECTRONPISTOL:
			sprite = electron_pistol_sprite
		ArtifactGlobal.ArtifactType.LENGGLAS:
			sprite = leng_glas_sprite
	$ArtifactSprite.texture = sprite
		

func _on_body_entered(body: Node2D) -> void:
	start.emit()
	$ArtifactSprite.visible = false
	ArtifactGlobal.collect_artifact(artifact)
