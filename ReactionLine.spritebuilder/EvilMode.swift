//
//  EvilMode.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/8/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

class EvilMode: CCNode {
    
    // MARK: Constants
    
    let padding: CGFloat = 5          // How much space do we want between each row?
    let numberOfLines: Int = 100       // How many lines should be played in this game instance?
    let animationRowDelay = 0.15       // How long should it take for a correctly tapped line to move from its current position to the side of the screen?
    let animationLinesDownDelay = 0.1  // How long should it take for the stack of lines to move down on a correct tap?
    
    let audio = OALSimpleAudio.sharedInstance()  // System object used to handle audio files.
    
    let mixpanel = Mixpanel.sharedInstance()
    
    let adHandler = iAdHandler.sharedInstance
    
    
    // MARK: Memory Variables
    
    let memoryHandler = MemoryHandler()
    
    let statsHandler: Stats = Stats.sharedInstance
    
    
    // MARK: Variables
    
    // The label that appears when the WinSequence animation is played.
    weak var winLabel: CCLabelTTF!
    
    // Highscore handling system.
    weak var highScoreLabel: CCLabelTTF!
    
    // Refers to the two colored touch "buttons" at the bottom of the screen.
    weak var blueTouchZone: CCNode!
    weak var redTouchZone: CCNode!
    
    // All lines are made children of this node so they can be animated easier during the game.
    weak var lineGroupingNode: CCNode!
    
    // The two buttons that appear at the end of each game.
    weak var againButton: CCControl!
    weak var mainMenuButton: CCControl!
    
    // `countdownLabel` and `countdown` work together in tandem via the `didSet` property of `countdown` to display the countdown at the beginning of each game. Similarly, the `countdownLabel` is repurposed to display the time by working with the `didSet` property of the `time` variable.
    weak var countdownLabel: CCLabelTTF!
    var countdown: String = "" {
        didSet {
            countdownLabel.string = countdown
        }
    }
    var time: Double = 0.4 {
        didSet {
            countdownLabel.string = String(format: "%.3f", time)
        }
    }
    
    // Variables used to handle correct tap checking and individual line animation.
    var lineArray: [Line] = []
    var lineIndex = 0
    
    // The game state of the current game instnace.
    var gameState: GameState = .Playing
    
    weak var backgroundGroupingNode: CCNode!
    
    var numberOfLinesCleared: Int = 0
    
    weak var effectNode: CCEffectNode!
    
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    
    :param: delay  how long, in milliseconds, to wait until the program should run the code in the closure statement
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    // MARK: Start-Game Functions
    
    /**
    Called whenever the `EvilMode.ccb` file loads into the scene.
    */
    func didLoadFromCCB() {
        
        mixpanel.identify(mixpanel.distinctId)
        mixpanel.people.increment("Evil Mode Plays", by: 1)
        mixpanel.track("Evil Mode Plays")
        
        effectNode.effect = CCEffectDropShadow(shadowOffset: GLKVector2Make(0, 0), shadowColor: CCColor(red: 0/255, green: 0/255, blue: 0/255), blurRadius: 10)
        
        // Sets up each of the lines before the game begins.
        for index in 0..<numberOfLines {
            
            var line = CCBReader.load("Line") as! Line
            line.setRandomColor()
            
            var lineHeight = (line.contentSizeInPoints.height + padding) * CGFloat(index)
            line.position = CGPoint(x: 0, y: lineHeight)
            
            lineGroupingNode.addChild(line)
            lineArray.append(line)
            
        }
        
        lineGroupingNode.position = CGPoint(x: 0.50, y: -3238)
        blueTouchZone.opacity = 0
        redTouchZone.opacity = 0
        
        backgroundGroupingNode.runAction(CCActionEaseSineInOut(action: CCActionMoveTo(duration: 2.5, position: CGPoint(x: 0, y: 0))))
        lineGroupingNode.runAction(CCActionEaseSineInOut(action: CCActionMoveTo(duration: 2.5, position: CGPoint(x: 0.50, y: 175))))
        
        self.animationManager.runAnimationsForSequenceNamed("InitialFlythrough")
        
        if memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey) {
            redTouchZone.color = CCColor(red: 255/255, green: 255/255, blue: 255/255)
            blueTouchZone.color = CCColor(red: 0/255, green: 0/255, blue: 0/255)
        }
        
        countdownBeforeGameBegins() // Initiates the pre-game countdown.
        
    }
    
    /**
    Initiates the pre-game countdown.
    */
    func countdownBeforeGameBegins() {
        countdownLabel.visible = true
        countdownLabel.opacity = 0
        
        countdownLabel.runAction(CCActionFadeIn(duration: 0.5))
        self.countdown = "ready?"
        delay(1.2) {
            self.countdown = "3"
            self.delay(0.6) {
                self.countdown = "2"
                self.blueTouchZone.runAction(CCActionFadeIn(duration: 1))
                self.redTouchZone.runAction(CCActionFadeIn(duration: 1))
                self.delay(0.22) {
                    self.adHandler.displayAds() // Make money
                }
                self.delay(0.6) {
                    self.countdown = "1"
                    self.delay(0.6) {
                        self.countdownLabel.position = CGPoint(x: 0.5, y: 0.65)
                        self.countdownLabel.runAction(CCActionFadeIn(duration: 1))
                        self.userInteractionEnabled = true
                        self.multipleTouchEnabled = true
                        self.schedule("timer", interval: 0.001)
                        return
                    }
                }
            }
        }
    }
    
    
    // MARK: Timing Functions
    
    /**
    Adds 0.001 to the `time` variable.
    */
    func timer() {
        time += 0.001
    }
    
    
    // MARK: In-Game Functions
    
    /**
    Called whenever a tap is registered on the screen.
    
    It checks to see if the game is currently in the `Playing` state, and if so, checks to see which side the player tapped on and passes that value to the `checkIfRightTap()` function.
    */
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        if gameState == .Playing {
            
            let xPos = touch.locationInWorld().x
            let yPos = touch.locationInWorld().y
            let width = CCDirector.sharedDirector().viewSize().width
            
            if yPos < 130 { // Check if in the button zone.
                if xPos < (width / 2) {
                    checkIfRightTap(tapSide: .Blue)
                }
                else {
                    checkIfRightTap(tapSide: .Red)
                }
            }
            
        }
        
    }
    
    /**
    Checks to see if the latest registered tap was on the correct `tapSide` of the screen, corresponding to the current `Line` in question.
    
    It checks to see if the `tapSide` is equal to the `lineColor` of the current `Line`, and if so, runs the associated animation with that action. If the tap was incorrect, it calls the `gameOver()` function and ends the game there.
    
    The function also checks to see if the current tap may have caused a win state to occur.
    
    :param: tapSide  the side that the player just tapped on (value should be passed from `touchBegan()`)
    */
    func checkIfRightTap(#tapSide: Color) {
        
        var currentLine = lineArray[lineIndex]
        var lineColor = currentLine.colorType
        
        // Check if the tap was on the correct side of the screen.
        if tapSide == lineColor {
            if tapSide == .Red {
                moveStackDown(sideAnimation: .Red)
            }
            else {
                moveStackDown(sideAnimation: .Blue)
            }
        }
        else {
            gameOver()
            return
        }
        
        // Check to see if a win state just occured.
        if lineIndex == lineArray.count {
            win(lineArray[lineIndex - 1])
        }
        
    }
    
    
    // MARK: Animation Functions
    
    /**
    Runs the animation sequence corresponding to a correct tap.
    
    It "slides" the `currentLine` over to its corresponding `Color` side, and moves the `lineGroupingNode` down to account for the now moved piece.
    */
    func moveStackDown(#sideAnimation: Color) {
        
        numberOfLinesCleared++
        
        var currentLine = lineArray[lineIndex]
        var flyOutAction: CCActionMoveTo? = nil
        
        if sideAnimation == .Blue {
            flyOutAction = CCActionMoveTo(duration: animationRowDelay, position: CGPoint(x: -currentLine.contentSize.width, y: currentLine.position.y))
        }
        else {
            flyOutAction = CCActionMoveTo(duration: animationRowDelay, position: CGPoint(x: currentLine.contentSize.width, y: currentLine.position.y))
        }
        
        currentLine.runAction(flyOutAction!)
        
        var moveLinesDown = CCActionMoveBy(duration: animationLinesDownDelay, position: CGPoint(x: 0, y: -(currentLine.contentSize.height + padding)))
        lineGroupingNode.runAction(moveLinesDown)
        
        lineIndex++
        
        for index in lineIndex..<lineArray.count {
            lineArray[index].swapColors()
        }
        
    }
    
    
    // MARK: End-Game Functions
    
    /**
    Ends the game in a winning state, and runs the corresponding animations for that state.
    
    It should only be called whenever the player makes a move that would land the game in a winning state.
    
    :param: line  used to determine the positioning of several animation sequences called by the win state. It doesn't matter which one of the `Line` objects that are loaded in the game are passed into this function, because it simply uses it to determine how tall each of the `Line` objects are.
    */
    func win(line: Line) {
        
        adHandler.hideAds()
        
        statsHandler.addEvilModeWin()
        statsHandler.addMoreLinesCleared(numberOfLinesToAdd: numberOfLinesCleared)
        statsHandler.calculateNewAverageTapTime(numberOfTaps: numberOfLinesCleared, timeSpent: time)
        
        self.unschedule("timer")
        println("win!")
        
        audio.playEffect("tada.wav")
        
        gameState = .GameOver
        
        lineGroupingNode.runAction(CCActionEaseElasticOut(action: CCActionMoveBy(duration: 1.5, position: CGPoint(x: 0, y: (Double(line.contentSize.height + padding) * Double(numberOfLines - 20))))))
        
        redTouchZone.runAction(CCActionFadeOut(duration: 0.5))
        blueTouchZone.runAction(CCActionFadeOut(duration: 0.5))
        
        memoryHandler.checkForNewTopEvilScore(time)
        getHighScore()
        
        self.animationManager.runAnimationsForSequenceNamed("WinSequence")
        
        againButton.visible = true
        
    }
    
    /**
    Ends the game in a losing state, and runs the corresponding animations for that state.
    
    It should only be called when the player makes a move that would land the game in a losing state.
    */
    func gameOver() {
        
        statsHandler.addEvilModeLoss()
        statsHandler.addMoreLinesCleared(numberOfLinesToAdd: numberOfLinesCleared)
        statsHandler.calculateNewAverageTapTime(numberOfTaps: numberOfLinesCleared, timeSpent: time)
        
        getHighScore()
        
        self.unschedule("timer")
        self.userInteractionEnabled = false
        
        var currentLine = lineArray[lineIndex]
        
        if currentLine.colorType == .Blue {
            currentLine.runAction(CCActionEaseElasticOut(action: CCActionMoveBy(duration: animationRowDelay * 2.5, position: CGPoint(x: 100, y: 0))))
        }
        else {
            currentLine.runAction(CCActionEaseElasticOut(action: CCActionMoveBy(duration: animationRowDelay * 2.5, position: CGPoint(x: -100, y: 0))))
        }
        
        delay(0.6) {
            
            if self.memoryHandler.defaults.boolForKey(self.memoryHandler.vibrationSettingKey) {
                self.delay(0.07) {
                    AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
                }
            }
            
            for index in 0..<self.lineArray.count {
                var currentLine = self.lineArray[index]
                var random = Int(arc4random_uniform(9))
                var negativeRandom = Int(arc4random_uniform(2))
                
                random = random * 4
                
                if random == 0 {
                    random = 30
                }
                
                if negativeRandom != 0 {
                    random = -random
                }
                
                var tiltAction = CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: Float(random)))
                
                currentLine.runAction(tiltAction)
            }
            
            // Randomize "broken" position of the `blueTouchZone`.
            var blueRandom = Int(arc4random_uniform(9))
            var blueNegativeRandom = Int(arc4random_uniform(2))
            blueRandom = blueRandom * 4 + 3
            if blueNegativeRandom == 0 {
                blueRandom = -blueRandom
            }
            // Randomize "broken" position of the `redTouchZone`.
            var redRandom = Int(arc4random_uniform(9))
            var redNegativeRandom = Int(arc4random_uniform(2))
            redRandom = redRandom * 4 + 3
            if redNegativeRandom == 0 {
                redRandom = -redRandom
            }
            
            self.blueTouchZone.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: Float(blueRandom))))
            self.redTouchZone.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: Float(redRandom))))
            
            self.countdownLabel.runAction(CCActionFadeOut(duration: 0.5))
            if (blueRandom + redRandom) == 2 {
                self.countdownLabel.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: 30)))
            }
            else {
                self.countdownLabel.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: -30)))
            }
            
            if self.memoryHandler.defaults.boolForKey(self.memoryHandler.soundsSettingKey) {
                self.audio.playEffect("spring.mp3")
            }
            
            self.delay(1) {
                
                self.adHandler.hideAds()
                
                self.redTouchZone.runAction(CCActionEaseSineIn(action: CCActionMoveBy(duration: 4, position: CGPoint(x: self.redTouchZone.position.x, y: -2000))))
                self.blueTouchZone.runAction(CCActionEaseSineIn(action: CCActionMoveBy(duration: 4, position: CGPoint(x: self.blueTouchZone.position.x, y: -2000))))
                
                for index in 0..<self.lineArray.count {
                    
                    let numberOfRowsToSkip: Int = 9 // A bit hard to explain, but, in essence, determines how fast the animation responds to the losing state occuring. This entire section is necessary in order for the animation sequence to start running at the `Line` objects that are currently on the screen as opposed to starting at the ones that the player may have already cleared and are now off the screen. If we start the animation sequence at the ones that are off the screen, it can take a while until the sequence actually has any visible effect.
                    
                    var currentLine = self.lineArray[index]
                    var delayMultiplier: Int?
                    
                    if (self.lineIndex - numberOfRowsToSkip) < numberOfRowsToSkip {
                        delayMultiplier = index
                    }
                    else {
                        if (index - (self.lineIndex - numberOfRowsToSkip)) < 0 {
                            delayMultiplier = 0
                        }
                        else {
                            delayMultiplier = index - (self.lineIndex - numberOfRowsToSkip)
                        }
                    }
                    
                    var delay = (0.06 * Double(delayMultiplier!))
                    
                    currentLine.scheduleOnce("fallDown", delay: delay)
                    
                }
                
                self.animationManager.runAnimationsForSequenceNamed("LoseSequence")
                
            }
            
        }
        
        
        
    }
    
    func getHighScore() {
        
        var topTimeString = String(format: "%.3f", memoryHandler.defaults.doubleForKey(memoryHandler.topEvilScoreKey))
        var secondTimeString = String(format: "%.3f", memoryHandler.defaults.doubleForKey(memoryHandler.secondEvilScoreKey))
        var thirdTimeString = String(format: "%.3f", memoryHandler.defaults.doubleForKey(memoryHandler.thirdEvilScoreKey))
        
        // Check if the time values are currently equal to the default time settings, and if so, simply put an em dash (not a hyphen, please!) in their place to signify that they haven't been set by the user yet.
        if topTimeString == "999.999" {
            topTimeString = "—"
        }
        if secondTimeString == "999.999" {
            secondTimeString = "—"
        }
        if thirdTimeString == "999.999" {
            thirdTimeString = "—"
        }
        
        highScoreLabel.string = "fastest times:\n" + topTimeString + "\n" + secondTimeString + "\n" + thirdTimeString
        
    }
    
    
    // MARK: Button Functions
    
    /**
    Loads a new instance of `EvilMode.ccb` to restart the game.
    */
    func playAgain() {
        
        mixpanel.track("Evil Mode Play Again Button Pressed")
        
        var gameplayScene = CCBReader.load("EvilMode") as! EvilMode
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
    }
    
    /**
    Returns the game back to the main menu by loading a new instance of `MainScene.ccb`.
    */
    func mainMenu() {
        
        mixpanel.track("Evil Mode Session Duration")
        
        var mainScene = CCBReader.load("MainScene") as! MainScene
        
        var scene = CCScene()
        scene.addChild(mainScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
    }
    
    
    // MARK: Share Button Functions
    
    func shareToTwitter() {
        SharingHandler.sharedInstance.postToTwitter(stringToPost: "I just got a time of " + String(format: "%.3f", time) + " on Evil Mode in #ReactionLine!", postWithScreenshot: true)
    }
    
    func shareToFacebook() {
        SharingHandler.sharedInstance.postToFacebook(postWithScreenshot: true)
    }
    
}
