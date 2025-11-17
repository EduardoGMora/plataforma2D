# 2D Platformer Prototype (Godot 4)

A small, playable 2D platformer prototype demonstrating reusable scenes, physics, signals, TileMap collisions, basic animations, a following camera, and a simple HUD/menu.

## How to Run
1. Open the project in Godot 4.4 (or 4.x).
2. Press F5 (Run). The main menu scene loads.
3. Click Play to start the level.

## Controls
- Move: Arrow Keys or A/D
- Jump: Space
- Attack: D (as configured)
- Roll: S (as configured)

## Goals
- Collect coins (target: 10) or reach the flag to win.
- Touching enemies deals damage. Falling into the void defeats you.

## Scenes & Architecture
- `Scenes/main.tscn`: Root scene (menu HUD overlays the game).
- `Scenes/level.tscn`: Level container with Player + TileMap.
- `Scenes/player.tscn` + `Scripts/player.gd`: Player (CharacterBody2D) movement, jump, double jump, attack, health, signals.
- `Scenes/mob.tscn` + `Scripts/mob.gd`: Enemy patrol with raycasts, contact damage.
- `Scenes/coin.tscn` + `Scripts/coin.gd`: Collectible coin with animation and optional SFX.
- `Scenes/goal.tscn` + `Scripts/goal.gd`: Flag/goal (Area2D) for victory.
- `Scenes/hud.tscn` + `Scripts/hud.gd`: Menu buttons + in-game coin counter and casual win/lose messages.
- `Scripts/camera_2d.gd`: Camera follow with optional smoothing and limits.

## Requirements Coverage
- Player: move left/right, jump, double jump; clean constants (SPEED, GRAVITY, JUMP_VELOCITY).
- Physics: solid collisions via TileMap; void fall triggers defeat.
- Enemy: patrol using raycasts; lateral contact damage.
- Collectibles: coins with visual feedback and SFX hook; level provides many coins.
- Goal: win by reaching the flag or collecting the target number of coins (10).
- HUD: coin counter, casual win/lose messages.
- Camera: Camera2D follows player; limits/smoothing configurable.
- Level: TileMap with collision.
- Architecture: modular scenes (Player/Enemy/Coin/Goal/Level/Main), signals.
- Code: GDScript with clear constants and simple state handling.

## Audio & Particles
- Coin SFX: Add an audio file to the `Audio/` folder and set it on the `AudioStreamPlayer` in `Scenes/coin.tscn`.
- Optional: Add jump/death SFX on the player and simple particles on coin pickup for extra juice.

## Export
- HTML5 or Desktop: Use Godot's Export menu. If HTML5, enable Threads=Off unless you configure proper headers on hosting.

## Notes
- Camera limits can be tuned in `Scripts/camera_2d.gd` or directly on the Camera2D node.
- You can adjust the coin target in `Scripts/player.gd` (`COINS_TO_WIN`).
