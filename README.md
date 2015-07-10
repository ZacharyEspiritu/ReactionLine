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
* Add end-game animations for polish
* Try to start working on implementing `NSUserDefaults` into game files for easier implementation of options in Week 2
* Complete some sort of sound design plan
* Integrate Game Center leaderboard API
* Use `NSUserDefaults` for high score integration

### Week 2
* Add sounds
* Polish up graphics
* Complete integration of options via `NSUserDefaults`
* Add an options menu
* Add multiple playmodes, as suggested by playtesters


### Week 3
* Final last-minute bug fixes
* Submit the app to the App Store for approval (and pray)
* Get the app approved

### Week 4
* Start raking in the ad revenue
