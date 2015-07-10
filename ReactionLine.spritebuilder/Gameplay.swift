//
//  Gameplay.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

extension Double {
    
    var roundTo2:Double {
        let converter = NSNumberFormatter()
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.NoStyle
        formatter.minimumFractionDigits = 2
        formatter.roundingMode = .RoundDown
        formatter.maximumFractionDigits = 2
        if let stringFromDouble =  formatter.stringFromNumber(self) {
            if let doubleFromString = converter.numberFromString( stringFromDouble ) as? Double {
                return doubleFromString
            }
        }
        return 0
    }
    
}

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
    
    weak var againButton: CCControl!
    
    weak var countdownLabel: CCLabelTTF!
    var countdown: String = "" {
        didSet {
            countdownLabel.string = countdown
        }
    }
    var time: Double = 0.4 {
        didSet {
            countdownLabel.string = "\(time.roundTo2)"
        }
    }
    
    var lineArray: [Line] = []
    
    var lineIndex = 0
    
    var gameState: GameState = .Playing
    
    weak var startingColorNode: CCNodeColor!
    
    
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
        
        self.countdown = "READY?"
        delay(1.2) {
            self.countdown = "3"
            self.delay(1) {
                self.countdown = "2"
                self.delay(1) {
                    self.countdown = "1"
                    self.delay(1) {
                        self.countdownLabel.position = CGPoint(x: 0.5, y: 0.65)
                        self.countdownLabel.runAction(CCActionFadeIn(duration: 1))
                        self.startingColorNode.visible = false
                        self.userInteractionEnabled = true
                        self.multipleTouchEnabled = true
                        self.schedule("timer", interval: 0.01)
                        return
                    }
                }
            }
        }
    }
    
    
    // MARK: Timing Functions
    
    func timer() {
        time += 0.01
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
        
        winLabel.visible = true
        winLabel.runAction(CCActionEaseElasticOut(action: CCActionMoveTo(duration: 1.5, position: CGPoint(x: 0.5, y: 0.5))))
        
        redTouchZone.runAction(CCActionFadeOut(duration: 0.5))
        blueTouchZone.runAction(CCActionFadeOut(duration: 0.5))
        
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
                
                println(random)
                
            }
            
            self.delay(1) {
                
                for index in 0..<self.lineArray.count {
                    
                    var currentLine = self.lineArray[index]
                    
                    currentLine.runAction(CCActionEaseRate(action: CCActionMoveBy(duration: 5, position: CGPoint(x: currentLine.position.x, y: -2000)), rate: Float(5)))
                    
                }
                
                self.countdown = "GAME\nOVER"
                self.countdownLabel.visible = true
                
                self.countdownLabel.runAction(CCActionFadeIn(duration: 1.5))
                
                self.againButton.visible = true
                self.againButton.runAction(CCActionFadeIn(duration: 1.5))
                
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
    
}
