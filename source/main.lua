-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/ui"

-- Libraries
import "scripts/libraries/utilities"
import "scripts/libraries/lifecycle"
import "scripts/libraries/simulator"
import "scripts/libraries/button"
import "scripts/libraries/crank"
import "scripts/libraries/SceneManager"

-- Game
import "scripts/game/gameScene.lua"
import "scripts/game/player"
-- Title/UIs
import "scripts/title/gameOverScene"
import "scripts/title/titleScene"
import "scripts/title/menu"
-- Entities
import "scripts/game/entities/wall"
import "scripts/game/entities/toy"
import "scripts/game/entities/goal"
import "scripts/game/entities/mechanism"
import "scripts/game/entities/extension"
import "scripts/game/entities/cable"
-- NPCS
import "scripts/game/npcs/scoreDisplay"

SCENE_MANAGER = SceneManager()

-- myGameSetUp()
print("Starting game.")	
TitleScene()
