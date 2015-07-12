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

## List of Feedback

### Week 1: Office Hours
* **Complete!** ~~Lines need to be thicker because they're hard to see, especially when they're moving at the same time.~~
* **Complete!** ~~Menu needs to be redesigned, so it doesn't look like the MTA signs.~~ 
* **Complete!** ~~End-game needs to be more polished, maybe with an animation or something.~~
* EK: End-game animation sequence needs to be shortened, or, at the very least, able to be skipped.
* EK: Color blind option needs to be implemented, because ~~inclusiveity~~ ~~inclusivety~~ inclusivity. 
* Everyone: More gameplay modes. (EK suggests an infinite mode where you have a constantly decreasing time meter and get additional time added with a correct tap.)
* Everyone: Leaderboards of some kind. (What does this mean? Does this mean we do a Piano Tiles-esque "top 10" scores saved locally on the device? or Game Center integration? or both? or a Flappy Bird-style single high score, so your friends can get higher scores than you on your device and irritate you for the rest of your life until you beat it?)

### Week 1: Weekend
* Everyone: Need to find a better font. ("You can't just use Helvetica Neue for all of your games, Zach!" - my mother)
* CK: Menu icons need to be slightly redesigned so they look less jumbled together.
* SS: Not sure about the lowercase letter design.
* JT: The "hamburger" icon might be too unclear on what it actually does.
