# related plugin:
class_name SceneManagerEnum
## Tracks values related to [SceneManager] and [SceneManagerWrapper], i.e. maktoobgar's addon: [br]
## - https://github.com/maktoobgar/scene_manager
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## Tracks "Scenes" (relevant .tscn files) used in [SceneManager] and [SceneManagerWrapper].
# Special scenes: NULL, BACK, RELOAD, REFRESH, RESTART, EXIT, QUIT
# Project scenes: MENU_SCENE, GAME_SCENE
enum Scene { NULL, BACK, RELOAD, REFRESH, RESTART, EXIT, QUIT, MENU_SCENE, GAME_SCENE }

## Tracks [".../addons/scene_manager/shader_patterns/"] values used in [SceneManagerOptions].
enum ShaderPattern {
	FADE,
	CIRCLE,
	CROOKED_TILES,
	CURTAINS,
	DIAGONAL,
	DIRT,
	HORIZONTAL,
	PIXEL,
	RADIAL,
	SCRIBBLES,
	SPLASHED_DIRT,
	SQUARES,
	VERTICAL
}


static func scene_name(scene: SceneManagerEnum.Scene) -> String:
	return (SceneManagerEnum.Scene.keys()[scene] as String).to_lower()


static func shader_pattern_name(shader_pattern: SceneManagerEnum.ShaderPattern) -> String:
	return (SceneManagerEnum.ShaderPattern.keys()[shader_pattern] as String).to_lower()
