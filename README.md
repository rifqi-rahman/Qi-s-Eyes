# 🎮 Qi's Eyes - Guess the Coin

A captivating iOS game built with Swift and SpriteKit in Swift Playgrounds. Test your visual focus and eye coordination in this medieval tavern-themed shell game!

## 🎯 Game Overview

"Qi's Eyes" is a classic shell game where players must track a coin hidden beneath cups as they shuffle around a wooden tavern table. The game challenges your attention and memory while providing an immersive medieval atmosphere.

### Core Gameplay
- **Starting Balance**: $3 in coins
- **Betting System**: Place bets of $1, $2, or $3 before each round
- **Objective**: Track the coin's location through shuffling cups
- **Reward**: Win double your bet for correct guesses
- **Progression**: Game difficulty increases with each successful round

## 🚀 How to Play

1. **Place Your Bet**: Use the +/- buttons to select your wager (up to your current balance)
2. **Click "PLACE BET"**: Confirm your bet to start the round
3. **Watch the Coin**: A golden coin will appear under one of the cups for 2 seconds
4. **Follow the Shuffles**: Watch carefully as the cups move and swap positions
5. **Make Your Guess**: Tap the cup you think contains the coin
6. **Win or Lose**: 
   - ✅ Correct guess = Win double your bet
   - ❌ Wrong guess = Lose your bet amount

## 🎮 Game Features

### Progressive Difficulty
- **Level 1-2**: 3 cups, moderate shuffling
- **Level 4-5**: 4 cups, faster shuffling  
- **Level 7+**: Up to 6 cups, complex shuffle patterns

### Visual Design
- **Tavern Theme**: Medieval atmosphere with wooden textures
- **Top-Down View**: Classic shell game perspective
- **Smooth Animations**: Fluid cup movements and transitions
- **Visual Feedback**: Clear win/lose indicators

### Audio Experience
- **Shuffle Sounds**: Realistic swoosh effects during cup movements
- **Interactive Audio**: Button taps and cup selection sounds
- **Result Audio**: Distinct win/lose sound effects
- **Ambient Sound**: Subtle tavern atmosphere

## 🛠️ Technical Implementation

### Architecture
- **GameScene**: Main game logic and state management
- **Cup Class**: Individual cup behavior and animations
- **HUD System**: User interface and controls
- **AudioManager**: Programmatically generated sound effects

### Key Technologies
- **SpriteKit**: 2D game framework
- **AVFoundation**: Audio generation and playback
- **Swift Playgrounds**: Development environment

## 📱 System Requirements

- **Platform**: iOS (Swift Playgrounds)
- **Development**: Xcode with Swift Playgrounds support
- **Target**: iPad/iPhone with iOS 13+

## 🎨 Visual Assets

The game uses programmatically generated visual elements:
- **Cups**: Bronze-colored rectangles with borders and shadows
- **Coins**: Golden circles with metallic borders
- **Background**: Layered wooden table texture with tavern walls
- **UI Elements**: Medieval-styled buttons and text

## 🔊 Audio Design

All audio is generated programmatically using AVAudioEngine:
- **Shuffle Sound**: Filtered white noise with frequency sweeps
- **Tap Sound**: Sharp click with exponential decay
- **Win Sound**: Ascending chord progression with harmonics
- **Lose Sound**: Descending frequency with subharmonics
- **Ambience**: Continuous crackling fire sound for atmosphere

## 🚀 Installation & Setup

1. **Download**: Clone or download the project files
2. **Open**: Launch `QisEyes.playground` in Swift Playgrounds
3. **Run**: Press the play button to start the game
4. **Enjoy**: The game will appear in the live view panel

## 🎯 Game Strategy Tips

- **Focus Training**: Keep your eyes on the correct cup throughout shuffling
- **Pattern Recognition**: Look for shuffle patterns that might repeat
- **Bet Management**: Start with small bets to build your balance
- **Attention Span**: Take breaks to maintain concentration
- **Progressive Challenge**: Use easier levels to warm up

## 🏆 Scoring & Progression

- **Win Condition**: Successfully guess the correct cup
- **Level Advancement**: Each correct guess increases your level
- **Difficulty Scaling**: More cups added every 3 levels
- **Game Over**: When balance reaches $0
- **High Score**: Try to reach the highest level possible!

## 🎮 Educational Value

This game helps develop:
- **Visual Tracking**: Following moving objects
- **Working Memory**: Remembering positions through changes
- **Sustained Attention**: Maintaining focus during shuffling
- **Risk Assessment**: Betting strategy and decision making

## 📝 Code Structure

```
QisEyes.playground/
├── Contents.swift          # Main playground entry point
└── Sources/
    ├── GameScene.swift     # Core game logic and flow
    ├── Cup.swift          # Cup object with states and animations  
    ├── HUD.swift          # User interface and controls
    └── AudioManager.swift  # Sound generation and management
```

## 🤝 Contributing

This is an educational project demonstrating Swift/SpriteKit game development. Feel free to:
- Experiment with different difficulty curves
- Add new visual effects or animations
- Enhance the audio system
- Create new game modes or variations

## 📄 License

This project is open source. See LICENSE file for details.

---

**Enjoy playing Qi's Eyes and training your visual focus! 🎯👁️**
