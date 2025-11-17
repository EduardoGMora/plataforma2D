# Knight Platformer 2D

A classic 2D platformer game built with Godot 4.4 featuring a knight character collecting coins and battling skeleton enemies.

## 🎮 Game Features

### Core Gameplay
- **Player Movement**: Smooth left/right movement with physics-based controls
- **Jump System**: Single and double jump mechanics for enhanced platforming
- **Combat System**: Melee attack with hit detection against enemies
- **Collectibles**: 10 coins scattered throughout the level
- **Victory Conditions**: Win by collecting all 10 coins OR reaching the goal flag
- **Health System**: 3 HP with visual animated heart display
- **Enemy AI**: Skeleton enemies with patrol and attack behavior

### Technical Features
- **Camera System**: Smooth camera following with position smoothing
- **HUD Display**: 
  - Animated heart sprites showing current HP
  - Coin counter tracking progress
  - Victory/defeat messages
- **Animations**: 
  - Player: idle, walk, jump, attack, hit, death, roll
  - Enemies: idle, walk, attack, death
- **Sound Effects**: Procedural audio for all actions (jump, coin pickup, hit, attack, death, victory)
- **Particle Effects**: Visual feedback for coin collection
- **Physics**: TileMap-based collision system with proper layering

### Enemy Behavior
- Patrol with edge/wall detection using raycasts
- Player detection within 150 pixels
- Turn to face and attack nearby players
- Contact damage with attack animations
- Death animations and removal

## 🎯 Controls

| Action | Keys |
|--------|------|
| Move Left | ← / Left Arrow |
| Move Right | → / Right Arrow |
| Jump/Double Jump | Space |
| Attack | D |

## 📋 Project Requirements Coverage

### Must Have (All Implemented ✅)
- ✅ Player movement (left/right)
- ✅ Jump mechanics with physics
- ✅ Enemy with patrol behavior
- ✅ 10+ collectible coins
- ✅ Goal/victory condition
- ✅ HUD with coin counter
- ✅ Camera following player
- ✅ TileMap with collisions

### Should Have (All Implemented ✅)
- ✅ Animations for player and enemies
- ✅ Sound effects (procedural beeps)
- ✅ Checkpoint system (via respawn)

### Could Have (Implemented ✅)
- ✅ Double jump mechanic
- ✅ Particle effects on coin pickup
- ✅ Advanced enemy AI (player detection)
- ✅ Combat system with attack animations

## 🛠️ Technical Details

### Engine
- **Godot Engine**: 4.4
- **Renderer**: Forward+
- **Resolution**: 1280x720

### Architecture
- **Signal-based communication** for decoupled systems
- **Scene composition** with reusable components
- **Node-based structure** following Godot best practices

### Key Scripts
- `player.gd` - Player controller with movement, combat, and health
- `mob.gd` - Enemy AI with patrol, detection, and attack
- `coin.gd` - Collectible item with animations and effects
- `goal.gd` - Victory trigger
- `hud.gd` - UI management with camera tracking
- `camera_2d.gd` - Camera configuration

### Audio System
Procedural sound generation using `AudioStreamGenerator`:
- **Jump**: 660 Hz (quick beep)
- **Coin**: 1100 Hz (pickup sound)
- **Hit**: 180 Hz (damage sound)
- **Death**: 140 Hz (low dramatic tone)
- **Victory**: 880 Hz → 1320 Hz (triumph chord)
- **Player Attack**: 440 Hz (hit enemy)
- **Enemy Attack**: 320 Hz (swoosh)
- **Enemy Death**: 200 Hz (defeat sound)

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/EduardoGMora/plataforma2D.git
   cd plataforma2D
   ```

2. **Open in Godot**
   - Open Godot 4.4+
   - Import the project
   - Run the main scene

3. **Play**
   - Press Play button in menu
   - Collect coins and defeat enemies
   - Reach the goal or collect all 10 coins to win!

## 📁 Project Structure

```
plataforma2D/
├── Scenes/          # Game scenes (.tscn files)
│   ├── main.tscn      # Entry point
│   ├── hud.tscn       # Menu and UI overlay
│   ├── level.tscn     # Main gameplay level
│   ├── player.tscn    # Player character
│   ├── mob.tscn       # Enemy skeleton
│   ├── coin.tscn      # Collectible coin
│   ├── goal.tscn      # Victory flag
│   └── hp.tscn        # Health hearts UI
├── Scripts/         # GDScript files
│   ├── player.gd      # Player controller
│   ├── mob.gd         # Enemy AI
│   ├── coin.gd        # Coin pickup logic
│   ├── goal.gd        # Victory trigger
│   ├── hud.gd         # UI management
│   └── camera_2d.gd   # Camera settings
├── assets/          # Sprites and textures
│   ├── 120x80_PNGSheets/  # Player animations
│   └── Sprite Sheets/      # Enemy animations
├── UI/              # UI elements and backgrounds
└── Audio/           # (Empty - uses procedural audio)
```

## 🎨 Assets

- **Player sprites**: 120x80 PNG sheets with animations (idle, run, jump, attack, hit, death, roll, etc.)
- **Enemy sprites**: Skeleton sprite sheets (idle, walk, attack, death)
- **Collectibles**: Pixel art coins and animated hearts for HP
- **Background**: Parallax mountain layers

## 🎯 Game Mechanics

### Player
- **Health**: 3 HP (displayed as animated hearts)
- **Speed**: 300 units/second
- **Jump Velocity**: -450 (with double jump)
- **Gravity**: 980 units/second²
- **Invulnerability**: 1.5 seconds after taking damage
- **Void Fall**: Falling below y=3000 triggers defeat

### Enemies
- **Health**: 3 HP
- **Speed**: 100 units/second
- **Detection Range**: 150 pixels
- **Damage**: 1 HP on contact attack

### Win Conditions
- Collect all 10 coins, OR
- Reach the goal flag

## 🐛 Known Issues

None currently reported.

## 🚢 Export

The game can be exported to:
- **HTML5** (web browser)
- **Windows** (executable)
- **Linux** (executable)
- **macOS** (executable)

Use Godot's export presets to build for your target platform.

## 📝 License

Educational project for learning Godot Engine.

## 👤 Author

**Eduardo G. Mora**
- GitHub: [@EduardoGMora](https://github.com/EduardoGMora)
- Repository: [plataforma2D](https://github.com/EduardoGMora/plataforma2D)

---

*Built with ❤️ using Godot Engine 4.4*
