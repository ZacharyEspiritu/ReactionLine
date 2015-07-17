//
//  MainScene.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/8/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation
import GameKit

enum GameState {
    case Playing, GameOver
}

class MainScene: CCNode {
    
    // MARK: Constants
    
    let audio = OALSimpleAudio.sharedInstance()
    
    let mixpanel = Mixpanel.sharedInstance()

    
    // MARK: Memory Variables
    
    let memoryHandler = MemoryHandler()
    let statsHandler  = Stats()
    
    
    // MARK: Variables
    
    weak var titleLabel: CCLabelTTF!
    weak var infoLabel:  CCLabelTTF!
    
    weak var creditsLayer: CCNode!
    var isCreditsInView = false
    
    weak var timedModeButton:     CCButton!
    weak var infiniteModeButton:  CCButton!
    weak var twoPlayerModeButton: CCButton!
    weak var leaderboardButton: CCButton!
    
    weak var optionsButton: CCButton!
    weak var aboutButton:   CCButton!
    weak var shareButton:   CCButton!
    weak var statsButton:   CCButton!
    
    weak var vibrationToggleLabel:  CCLabelTTF!
    weak var soundsToggleLabel:     CCLabelTTF!
    weak var colorblindToggleLabel: CCLabelTTF!
    
    weak var statsScrollView: CCScrollView!
    
    weak var gameCenterViewController: GameCenterViewController!
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        
        if !memoryHandler.defaults.boolForKey(memoryHandler.hasAlreadyLoaded) {
            
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.hasAlreadyLoaded)
            
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.vibrationSettingKey)
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.soundsSettingKey)
            memoryHandler.defaults.setBool(false, forKey: memoryHandler.colorblindSettingKey)
            
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.topScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.secondScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.thirdScoreKey)
            
            memoryHandler.defaults.setInteger(0, forKey: memoryHandler.topInfiniteScoreKey)
            memoryHandler.defaults.setInteger(0, forKey: memoryHandler.secondInfiniteScoreKey)
            memoryHandler.defaults.setInteger(0, forKey: memoryHandler.thirdInfiniteScoreKey)
            
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.topEvilScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.secondEvilScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.thirdEvilScoreKey)
            
            statsHandler.defaults.setDouble(999.999, forKey: statsHandler.averageTapTimeKey)
            statsHandler.defaults.setObject([], forKey: statsHandler.tapTimeOfLastFifteenGamesArray)
            
            println("Default settings loaded.")
            
            
            
        }
                
        updateOptionsButtonText()
        
        timedModeButton.zoomWhenHighlighted     = true
        infiniteModeButton.zoomWhenHighlighted  = true
        twoPlayerModeButton.zoomWhenHighlighted = true
        leaderboardButton.zoomWhenHighlighted   = false
        
        creditsLayer.cascadeOpacityEnabled = true
        creditsLayer.opacity = 0
        
        self.userInteractionEnabled = true
        
        setupGameCenter()
    }
    
    func setupGameCenter() {
        
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
        
    }
    
    /**
    Begins Timed Mode.
    */
    func timedMode() {
        
        mixpanel.timeEvent("Timed Mode Session Duration")
        
        disableAllMenuButtons()
        timedModeButton.highlighted = false
        
        self.animationManager.runAnimationsForSequenceNamed("TimedMode")
                
        delay(1.1) {
            
            var gameplayScene = CCBReader.load("TimedMode") as! TimedMode
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
            
        }
    }
    
    /**
    Begins Infinite Mode.
    */
    func infiniteMode() {
        
        mixpanel.timeEvent("Infinite Mode Session Duration")
        
        disableAllMenuButtons()
        infiniteModeButton.highlighted = false
        
        self.animationManager.runAnimationsForSequenceNamed("InfiniteMode")
        
        delay(1.1) {
            
            var gameplayScene = CCBReader.load("InfiniteMode") as! InfiniteMode
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
            
        }
    }
    
    /**
    Begins Two Player Mode.
    */
    func twoPlayerMode() {
        disableAllMenuButtons()
        twoPlayerModeButton.highlighted = false
        
        self.animationManager.runAnimationsForSequenceNamed("TwoPlayerMode")
        
        delay(1.1) {
            
            var gameplayScene = CCBReader.load("EvilMode") as! EvilMode
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
            
        }
    }
    
    /**
    Begins Challenge Mode.
    */
    func leaderboardMode() {
        leaderboardButton.highlighted = false
        
        showLeaderboard()
        
        
//        self.animationManager.runAnimationsForSequenceNamed("LeaderboardMode")
        
        
    }
    
    
    // MARK: Bottom Navigation Bar Functions
    
    /**
    Displays an interface from which the user can change certain options for the game.
    */
    func optionsMenu() {
        println("TODO: Implement options menu.")
        
        self.animationManager.runAnimationsForSequenceNamed("MenuToOptionsScreen")
        disableAllMenuButtons()
    }
    
    func optionsScreenToMenu() {
        self.animationManager.runAnimationsForSequenceNamed("OptionsScreenToMenu")
        enableAllMenuButtons()
    }
    
    func updateOptionsButtonText() {
        
        println("Vibration:  \(memoryHandler.defaults.boolForKey(memoryHandler.vibrationSettingKey))")
        println("Sounds:     \(memoryHandler.defaults.boolForKey(memoryHandler.soundsSettingKey))")
        println("Colorblind: \(memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey))")
        
        if !memoryHandler.defaults.boolForKey(memoryHandler.vibrationSettingKey) {
            vibrationToggleLabel.color = CCColor(red: 213/255, green: 35/255, blue: 0/255)
            vibrationToggleLabel.string = "OFF"
        }
        else {
            vibrationToggleLabel.color = CCColor(red: 0/255, green: 128/255, blue: 0/255)
            vibrationToggleLabel.string = "ON"
        }
        
        if !memoryHandler.defaults.boolForKey(memoryHandler.soundsSettingKey) {
            soundsToggleLabel.color = CCColor(red: 213/255, green: 35/255, blue: 0/255)
            soundsToggleLabel.string = "OFF"
        }
        else {
            soundsToggleLabel.color = CCColor(red: 0/255, green: 128/255, blue: 0/255)
            soundsToggleLabel.string = "ON"
        }
        
        if !memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey) {
            colorblindToggleLabel.color = CCColor(red: 213/255, green: 35/255, blue: 0/255)
            colorblindToggleLabel.string = "OFF"
        }
        else {
            colorblindToggleLabel.color = CCColor(red: 0/255, green: 128/255, blue: 0/255)
            colorblindToggleLabel.string = "ON"
        }
    }
    
    func toggleVibrationSetting() {
        if memoryHandler.defaults.boolForKey(memoryHandler.vibrationSettingKey) {
            memoryHandler.defaults.setBool(false, forKey: memoryHandler.vibrationSettingKey)
            vibrationToggleLabel.color = CCColor(red: 213/255, green: 35/255, blue: 0/255)
            vibrationToggleLabel.string = "OFF"
        }
        else {
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.vibrationSettingKey)
            vibrationToggleLabel.color = CCColor(red: 0/255, green: 128/255, blue: 0/255)
            vibrationToggleLabel.string = "ON"
        }
    }
    
    func toggleSoundsSetting() {
        if memoryHandler.defaults.boolForKey(memoryHandler.soundsSettingKey) {
            memoryHandler.defaults.setBool(false, forKey: memoryHandler.soundsSettingKey)
            soundsToggleLabel.color = CCColor(red: 213/255, green: 35/255, blue: 0/255)
            soundsToggleLabel.string = "OFF"
        }
        else {
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.soundsSettingKey)
            soundsToggleLabel.color = CCColor(red: 0/255, green: 128/255, blue: 0/255)
            soundsToggleLabel.string = "ON"
        }
    }
    
    func toggleColorblindSetting() {
        if memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey) {
            memoryHandler.defaults.setBool(false, forKey: memoryHandler.colorblindSettingKey)
            colorblindToggleLabel.color = CCColor(red: 213/255, green: 35/255, blue: 0/255)
            colorblindToggleLabel.string = "OFF"
        }
        else {
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.colorblindSettingKey)
            colorblindToggleLabel.color = CCColor(red: 0/255, green: 128/255, blue: 0/255)
            colorblindToggleLabel.string = "ON"
        }
    }
    
    /**
    Displays the game credits.
    */
    func aboutMenu() {
        mixpanel.track("Viewed About Screen")
        creditsLayer.runAction(CCActionFadeTo(duration: 0.5, opacity: 1))
        isCreditsInView = true
        disableAllMenuButtons()
    }
    
    /**
    Displays an interface from which the user can share the app.
    */
    func shareMenu() {
        mixpanel.track("Viewed Share Screen")
        self.animationManager.runAnimationsForSequenceNamed("MenuToShareScreen")
        disableAllMenuButtons()
    }
    
    func shareScreenToMenu() {
        self.animationManager.runAnimationsForSequenceNamed("ShareScreenToMenu")
        enableAllMenuButtons()
    }
    
    func statsMenu() {
        mixpanel.track("Viewed Stats Screen")
        self.animationManager.runAnimationsForSequenceNamed("MenuToStatsScreen")
        disableAllMenuButtons()
    }
    
    func statsScreenToMenu() {
        self.animationManager.runAnimationsForSequenceNamed("StatsScreenToMenu")
        statsScrollView.setScrollPosition(CGPoint(x: 0, y: 0), animated: true) // Reset the scroll position to 0 to prevent the tip of it from staying on the screen.
        enableAllMenuButtons()
    }
    
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
    
    func disableAllMenuButtons() {
        timedModeButton.enabled     = false
        infiniteModeButton.enabled  = false
        twoPlayerModeButton.enabled = false
        leaderboardButton.enabled = false
        
        optionsButton.enabled = false
        aboutButton.enabled   = false
        shareButton.enabled   = false
        statsButton.enabled   = false
    }
    
    func enableAllMenuButtons() {
        timedModeButton.enabled     = true
        infiniteModeButton.enabled  = true
        twoPlayerModeButton.enabled = true
        leaderboardButton.enabled = true
        
        optionsButton.enabled = true
        aboutButton.enabled   = true
        shareButton.enabled   = true
        statsButton.enabled   = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if isCreditsInView {
            creditsLayer.runAction(CCActionFadeTo(duration: 0.5, opacity: 0))
            isCreditsInView = false
            enableAllMenuButtons()
        }
    }

}

extension MainScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
        
    }
    
    //Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
