# Reaction Line

## Description

Reaction Line is a minimalistic, hardcore, single-player game that aims to be the most entertaining (and aggravating) mobile game for iOS. The game is simple: sort 100 lines into red and blue stacks as quickly as possible. The catch? You only have one life.

The mechanics are simple to learn, but the game is hard to master. Do you have the hand-eye coordination and quick thinking skills to tap your way to the top?


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
* Credits ("About The Game")

### Controls/Input
* Tap based controls
  * Tap on the left side to register a blue tap
  * Tap on the right side to register a red tap

### Classes/CCBs
* Scenes
  * Main Menu
  * Gameplay
  * Options
  * Credits ("About The Game")
* Nodes/Sprites
  * Line

## MVP Milestones

### Completed:
* Complete base game without much polish
* Add end-game animations for polish
* Use `NSUserDefaults` for high score integration
* Polish up graphics

### Week 1 - Weekend:
* Try to start working on implementing `NSUserDefaults` into game files for easier implementation of options in Week 2
* Complete some sort of sound design plan
* Add sounds
* Integrate Game Center leaderboard API


### Week 2
* Complete integration of options via `NSUserDefaults`
* Add an options menu
* Add multiple playmodes, as suggested by playtesters
* Final last-minute bug fixes
* Submit the app to the App Store for approval (and pray)
* Get the app approved

### Week 3
* Start raking in the ad revenue
