extends Resource
class_name Mission

enum MissionType {
	Main,
	Side,
	Hidden,
	Test,
}

enum Status {
	Completed,
	Discoverd,
	Undiscoverd,
}

@export var type: MissionType
@export var status: Status

@export var level: Level
@export var next_mission: Array[Mission]

@export var title: String
@export_multiline var mission_text: String
@export var sender: Character
