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

### Week 1:
* **Complete!** ~~Complete base game without much polish~~
* **Complete!** ~~Add end-game animations for polish~~
* **Complete!** ~~Use `NSUserDefaults` for high score integration~~
* **Complete!** ~~Polish up graphics~~
* **Complete!** ~~Complete some sort of sound design plan~~
* **Complete!** ~~Overhaul main menu design~~
* **Complete!** ~~Add some more animations in the main menu~~
* **Complete!** ~~Add Infinite Mode~~

### Week 2:
* **Complete!** ~~Add an options menu~~
* **Complete!** ~~Complete integration of options via `NSUserDefaults`~~
* **Complete!** ~~Complete stat tracking integration~~
* Add ability to challenge other players
* Integrate Game Center leaderboard API
* Facebook/Twitter sharing from app
* Add sounds
* Run some final playtesting sessions
* Take some screenshots for iTunes Connect
* **Complete!** ~~Finalize description (or have someone else willing enough write it themselves)~~
* Submit the app to the App Store for approval (and pray that it does)

### Week 3
* Start raking in the ad revenue

## List of Feedback

### Week 1: Office Hours
* **Complete!** ~~Lines need to be thicker because they're hard to see, especially when they're moving at the same time.~~
* **Complete!** ~~Menu needs to be redesigned, so it doesn't look like the MTA signs.~~ 
* **Complete!** ~~End-game needs to be more polished, maybe with an animation or something.~~
* **Complete!** ~~EK: End-game animation sequence needs to be shortened, or, at the very least, able to be skipped.~~
* EK: Color blind option needs to be implemented, because ~~inclusiveity~~ ~~inclusivety~~ inclusivity. 
* **Complete!** ~~Everyone: More gameplay modes. (EK suggests an infinite mode where you have a constantly decreasing time meter and get additional time added with a correct tap.)~~
* **Complete-ish!** ~~Everyone: Leaderboards of some kind. (What does this mean? Does this mean we do a Piano Tiles-esque "top 10" scores saved locally on the device? or Game Center integration? or both? or a Flappy Bird-style single high score, so your friends can get higher scores than you on your device and irritate you for the rest of your life until you beat it?)~~

### Week 1: Weekend
* **Complete!** ~~Parents: Add text below each of the circular buttons because they're unclear on what they do.~~
* SS & CK: Need to find a better font. ("You can't just use Helvetica Neue for all of your games, Zach!" - my mother)
* **Complete!** ~~CK: Menu icons need to be slightly redesigned so they have more padding between the edge of the circle and the icon.~~
* **Complete-ish!** ~~SS: Not sure about the lowercase letter design. Also, header and footer should be closer to the buttons, with the padding at the top and bottom of the screen.~~
* **Complete!** ~~JT: The "hamburger" icon might be too unclear on what it actually does, so you'll want to run some more user testing to see if people understand. (The fact that he thought it was a hamburger also should be a cause for concern.)~~

### Week 2: Office Hours
* **Nah!** ~~EK: Add a counter to the top of the screen in Timed Mode, because I'm not good enough to beat CK without that unnecessary feature implemented.~~

## Sound Design Plan

### Pop Sounds:
* http://freesound.org/people/unfa/sounds/245645/
* http://freesound.org/people/greenvwbeetle/sounds/244652/
* http://freesound.org/people/kwahmah_02/sounds/260614/
* http://freesound.org/people/yottasounds/sounds/176727/
