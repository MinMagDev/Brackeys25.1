extends Node

var taken_damage_buff : int  = 0
var pistol_offset : int = 1

enum ArtifactType {
	MISTPROJ,
	#KAROTISPOISON,
	ELECTRONPISTOL,
	LENGGLAS
}

func reset():
	taken_damage_buff = 0
	pistol_offset = 1

func collect_artifact(artifact: ArtifactType) -> void:
	match artifact:
		ArtifactType.MISTPROJ:
			get_tree().get_nodes_in_group("Player")[0].get_child(3).visible = true
		ArtifactType.ELECTRONPISTOL:
			taken_damage_buff = 1
		ArtifactType.LENGGLAS:
			pistol_offset = -1

func generate_artifact() -> ArtifactType:
	var rand = randi_range(0,4)
	var artifact: ArtifactType
	match rand:
		0,1:
			artifact = ArtifactType.MISTPROJ
		2,3:
			artifact = ArtifactType.ELECTRONPISTOL
		4:
			artifact = ArtifactType.LENGGLAS
	return artifact
