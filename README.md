# Reaction Line

## Game Design

### Objective
Tap randomly generating strings of red and blue lines without making a mistake to win.

### Gameplay Mechanics
Players will have to tap buttons on either side of the screen corresponding to the current line on the screen. If they mess up even once, they immediately lose.

### Level Design
There are no levels; only a one-player game mode.

## Technical

### Scenes
* Main Menu
* Gameplay
* Options

### Controls/Input
* Tap based controls
  * Tap on the left side to register a blue tap
  * Tap on the right side to register a red tap

### Classes/CCBs
* Scenes
  * Main Menu
  * Gameplay
  * Options
* Nodes/Sprites
  * Line

## MVP Milestones

### Week 1
* Complete base game without much polish

### Week 2
* Add sounds
* Polish up graphics
* Add some animations
* Add some options via `NSUserDefaults`
* Add a main menu
* Add an options menu

### Week 3
* Add a multiplayer mode?
