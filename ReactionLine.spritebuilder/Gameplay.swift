//
//  Gameplay.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Gameplay: CCNode {
    
    // MARK: Constants
    
    let padding: CGFloat = 16
    let numberOfLines: Int = 100
    let animationRowDelay = 0.15
    let animationLinesDownDelay = 0.1
    
    let audio = OALSimpleAudio.sharedInstance()
    
    
    // MARK: Variables
    
    weak var winLabel: CCLabelTTF!
    
    weak var blueTouchZone: CCNode!
    weak var redTouchZone: CCNode!
    
    weak var lineGroupingNode: CCNode!
    weak var startingColorNode: CCNodeColor!
    
    weak var againButton: CCControl!
    weak var mainMenuButton: CCControl!
    
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
    
    var lineArray: [Line] = []
    var lineIndex = 0
    
    var gameState: GameState = .Playing
    
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
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
    
    func didLoadFromCCB() {
        
        for index in 0..<numberOfLines {
            
            var line = CCBReader.load("Line") as! Line
            line.setRandomColor()
            
            var lineHeight = (line.contentSizeInPoints.height + padding) * CGFloat(index)
            line.position = CGPoint(x: 0, y: lineHeight)
            
            lineGroupingNode.addChild(line)
            lineArray.append(line)
            
        }
        
        audio.preloadEffect("slide.wav")
        
        countdownBeforeGameBegins()
        
    }
    
    func countdownBeforeGameBegins() {
        countdownLabel.visible = true
        
        self.countdown = "ready?"
        delay(1.2) {
            self.countdown = "3"
            self.delay(0.5) {
                self.countdown = "2"
                self.delay(0.5) {
                    self.countdown = "1"
                    self.delay(0.5) {
                        self.countdownLabel.position = CGPoint(x: 0.5, y: 0.65)
                        self.countdownLabel.runAction(CCActionFadeIn(duration: 1))
                        self.startingColorNode.visible = false
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
    
    func timer() {
        time += 0.001
    }
    
    
    // MARK: In-Game Functions
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
        if gameState == .Playing {
            
            let xPos = touch.locationInWorld().x
            let width = CCDirector.sharedDirector().viewSize().width
            
            if xPos < (width / 2) {
                checkIfRightTap(tapSide: .Blue)
            }
            else {
                checkIfRightTap(tapSide: .Red)
            }
            
        }
        
    }
    
    func checkIfRightTap(#tapSide: Color) {
        
        var currentLine = lineArray[lineIndex]
        var lineColor = currentLine.colorType
        
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
        
        if lineIndex == lineArray.count {
            win(lineArray[lineIndex - 1])
        }
        
    }
    
    // MARK: Animation Functions
    
    func moveStackDown(#sideAnimation: Color) {
        
        println("Try Stack")
        
        var currentLine = lineArray[lineIndex]
        
        var flyOutAction: CCActionMoveTo? = nil
        
        if sideAnimation == .Blue {
            flyOutAction = CCActionMoveTo(duration: animationRowDelay, position: CGPoint(x: -200, y: currentLine.position.y))
        }
        else {
            flyOutAction = CCActionMoveTo(duration: animationRowDelay, position: CGPoint(x: 200, y: currentLine.position.y))
        }
        
        currentLine.runAction(flyOutAction!)
        
        audio.playEffect("slide.wav")
        
        var moveLinesDown = CCActionMoveBy(duration: animationLinesDownDelay, position: CGPoint(x: 0, y: -(currentLine.contentSize.height + padding)))
        lineGroupingNode.runAction(moveLinesDown)
        
        lineIndex++
        
    }
    
    
    // MARK: End-Game Functions
    
    func win(line: Line) {
        
        self.unschedule("timer")
        println("win!")
        
        audio.playEffect("tada.wav")
        
        gameState = .GameOver
        
        lineGroupingNode.runAction(CCActionEaseElasticOut(action: CCActionMoveBy(duration: 1.5, position: CGPoint(x: 0, y: (Double(line.contentSize.height + padding) * Double(numberOfLines - 20))))))
        
        redTouchZone.runAction(CCActionFadeOut(duration: 0.5))
        blueTouchZone.runAction(CCActionFadeOut(duration: 0.5))
        
        self.animationManager.runAnimationsForSequenceNamed("WinSequence")
        
        againButton.visible = true
    }
    
    func gameOver() {
        
        self.unschedule("timer")
        self.userInteractionEnabled = false

        println("GAMEOVER")
        
        var currentLine = lineArray[lineIndex]
        
        if currentLine.colorType == .Blue {
            currentLine.runAction(CCActionEaseElasticOut(action: CCActionMoveBy(duration: animationRowDelay * 2.5, position: CGPoint(x: 100, y: 0))))
        }
        else {
            currentLine.runAction(CCActionEaseElasticOut(action: CCActionMoveBy(duration: animationRowDelay * 2.5, position: CGPoint(x: -100, y: 0))))
        }
        
        delay(1.5) {
            
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
            
            self.blueTouchZone.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: Float(blueRandom))))
            
            // Randomize "broken" position of the `redTouchZone`.
            var redRandom = Int(arc4random_uniform(9))
            var redNegativeRandom = Int(arc4random_uniform(2))
            redRandom = redRandom * 4 + 3
            if redNegativeRandom == 0 {
                redRandom = -redRandom
            }
            
            self.redTouchZone.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: Float(redRandom))))
            
            self.countdownLabel.runAction(CCActionFadeOut(duration: 0.5))
            
            if (blueRandom + redRandom) == 2 {
                self.countdownLabel.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: 30)))
            }
            else {
                self.countdownLabel.runAction(CCActionEaseElasticOut(action: CCActionRotateBy(duration: 0.5, angle: -30)))
            }
            
            self.delay(1) {
                
                self.redTouchZone.runAction(CCActionEaseSineIn(action: CCActionMoveBy(duration: 4, position: CGPoint(x: self.redTouchZone.position.x, y: -2000))))
                self.blueTouchZone.runAction(CCActionEaseSineIn(action: CCActionMoveBy(duration: 4, position: CGPoint(x: self.blueTouchZone.position.x, y: -2000))))
                
                for index in 0..<self.lineArray.count {
                    
                    var currentLine = self.lineArray[index]
                    
                    currentLine.scheduleOnce("fallDown", delay: (0.06 * Double(index)))
                    
                }
                
                self.animationManager.runAnimationsForSequenceNamed("LoseSequence")
                
            }
            
        }
        
        
        
    }
    
    
    // MARK: Button Functions
    
    func playAgain() {
        
        var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
    }
    
    func mainMenu() {
        
        var mainScene = CCBReader.load("MainScene") as! MainScene
        
        var scene = CCScene()
        scene.addChild(mainScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
    }
    
}
