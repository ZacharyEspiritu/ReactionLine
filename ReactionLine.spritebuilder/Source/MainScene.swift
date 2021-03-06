//
//  MainScene.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/8/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation
import GameKit
//import iAd

enum CurrentMenuView {
    case MainMenu, Options, Stats, Share, Credits, GoingToGameplay
}
enum GameState {
    case Playing, GameOver
}
enum ColorTheme: String {
    case Default = "Default"
    case Dark    = "Dark"
    case Light   = "Light"
}

class MainScene: CCScene {
    
    // MARK: Constants
    
    let audio = OALSimpleAudio.sharedInstance()
    
    let mixpanel = Mixpanel.sharedInstance()
    
    let sharingHandler = SharingHandler.sharedInstance

    
    // MARK: Memory Variables
    
    let memoryHandler = MemoryHandler()
    let statsHandler  = Stats()
    
    
    // MARK: Variables
    
    weak var mainTitleLabel: CCLabelTTF!
    weak var statsTitleLabel: CCLabelTTF!
    weak var optionsTitleLabel: CCLabelTTF!
    weak var shareTitleLabel: CCLabelTTF!
    
    weak var infoLabel:  CCLabelTTF!
    
    weak var creditsLayer: CCNode!
    
    weak var timedModeButton:     CCButton!
    weak var infiniteModeButton:  CCButton!
    weak var evilModeButton:      CCButton!
    weak var leaderboardButton:   CCButton!
    
    weak var optionsButton: CCButton!
    weak var aboutButton:   CCButton!
    weak var shareButton:   CCButton!
    weak var statsButton:   CCButton!
    
    weak var statsScreenToMenuButton: CCButton!
    
    weak var vibrationToggleLabel:  CCLabelTTF!
    weak var soundsToggleLabel:     CCLabelTTF!
    weak var colorblindToggleLabel: CCLabelTTF!
    
    weak var statsScrollView: CCScrollView!
    
    weak var backgroundColorNode:       CCNode!
    weak var topMenuBorderColorNode:    CCNode!
    weak var bottomMenuBorderColorNode: CCNode!
    
    weak var timedModeLabel:    CCLabelTTF!
    weak var infiniteModeLabel: CCLabelTTF!
    weak var evilModeLabel:     CCLabelTTF!
    weak var leaderboardLabel:  CCLabelTTF!
    
    weak var topDividingLine: CCNode!
    weak var bottomDividingLine: CCNode!
    
    weak var versionNumberHeader: CCLabelTTF!
    
    weak var vibrationOptionHeader: CCLabelTTF!
    weak var soundEffectsOptionHeader: CCLabelTTF!
    weak var displayLinesRemainingOptionHeader: CCLabelTTF!
    
    var currentMenuView: CurrentMenuView = .MainMenu
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        
//        iAdHandler.sharedInstance.loadAds(bannerPosition: .Top)
//        iAdHandler.sharedInstance.loadInterstitialAd()
        
        if !memoryHandler.defaults.boolForKey(memoryHandler.hasAlreadyLoaded) {
            
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.hasAlreadyLoaded)
            
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.vibrationSettingKey)
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.soundsSettingKey)
            memoryHandler.defaults.setBool(false, forKey: memoryHandler.colorblindSettingKey) // Not toggleable yet, but fully implemented
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.displayLineCounter)
            
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.topScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.secondScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.thirdScoreKey)
            
            memoryHandler.defaults.setInteger(0, forKey: memoryHandler.topInfiniteScoreKey)
            memoryHandler.defaults.setInteger(0, forKey: memoryHandler.secondInfiniteScoreKey)
            memoryHandler.defaults.setInteger(0, forKey: memoryHandler.thirdInfiniteScoreKey)
            
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.topEvilScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.secondEvilScoreKey)
            memoryHandler.defaults.setDouble(999.999, forKey: memoryHandler.thirdEvilScoreKey)
            
            statsHandler.defaults.setDouble(0, forKey: statsHandler.averageTapTimeKey)
            statsHandler.defaults.setObject([] as [Double], forKey: statsHandler.tapTimeOfLastFifteenGamesArray)
            
            print("Default settings loaded.")
        }
        
        updateOptionsButtonText()
        
        creditsLayer.cascadeOpacityEnabled = true
        creditsLayer.opacity = 0
        
        self.userInteractionEnabled = true
        
        setupGameCenter()
        
        loadColorScheme()
        
        delay(1.1) {
            self.setupGestures()
        }
    }
    
    func setupGameCenter() {
        
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
        
    }
    
    /**
    Begins Timed Mode.
    */
    func timedMode() {
        currentMenuView = .GoingToGameplay
        removeGestureRecognizers()
        
        topMenuBorderColorNode.visible = false
        bottomMenuBorderColorNode.visible = false
        
        mixpanel.timeEvent("Timed Mode Session Duration")
        
        disableAllMenuButtons()
        timedModeButton.highlighted = false
        
        self.animationManager.runAnimationsForSequenceNamed("TimedMode")
                
        delay(1.1) {
            let gameplayScene = CCBReader.load("TimedMode") as! TimedMode
            
            let scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
        }
    }
    
    /**
    Begins Infinite Mode.
    */
    func infiniteMode() {
        currentMenuView = .GoingToGameplay
        removeGestureRecognizers()
        
        topMenuBorderColorNode.visible = false
        bottomMenuBorderColorNode.visible = false
        
        mixpanel.timeEvent("Infinite Mode Session Duration")
        
        disableAllMenuButtons()
        infiniteModeButton.highlighted = false
        
        self.animationManager.runAnimationsForSequenceNamed("InfiniteMode")
        
        delay(1.1) {
            let gameplayScene = CCBReader.load("InfiniteMode") as! InfiniteMode
            
            let scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
        }
    }
    
    /**
    Begins Evil Mode.
    */
    func evilMode() {
        currentMenuView = .GoingToGameplay
        removeGestureRecognizers()
        
        topMenuBorderColorNode.visible = false
        bottomMenuBorderColorNode.visible = false
        
        mixpanel.timeEvent("Evil Mode Session Duration")
        
        disableAllMenuButtons()
        evilModeButton.highlighted = false
        
        self.animationManager.runAnimationsForSequenceNamed("EvilMode")
        
        delay(1.1) {
            let gameplayScene = CCBReader.load("EvilMode") as! EvilMode
            
            let scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
        }
    }
    
    /**
    Opens up the Game Center leaderboard.
    */
    func leaderboardMode() {
        leaderboardButton.highlighted = false
        showLeaderboard()
        mixpanel.track("Viewed Game Center Leaderboard")
    }
    
    
    // MARK: Options Menu Functions
    
    /**
    Displays an interface from which the user can change certain options for the game.
    */
    func optionsMenu() {
        currentMenuView = .Options
        self.animationManager.runAnimationsForSequenceNamed("MenuToOptionsScreen")
        disableAllMenuButtons()
    }
    
    func optionsScreenToMenu() {
        currentMenuView = .MainMenu
        self.animationManager.runAnimationsForSequenceNamed("OptionsScreenToMenu")
        enableAllMenuButtons()
    }
    
    func updateOptionsButtonText() {
        print("Vibration:  \(memoryHandler.defaults.boolForKey(memoryHandler.vibrationSettingKey))")
        print("Sounds:     \(memoryHandler.defaults.boolForKey(memoryHandler.soundsSettingKey))")
        print("Line Count: \(memoryHandler.defaults.boolForKey(memoryHandler.displayLineCounter))")
        
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
        
        if !memoryHandler.defaults.boolForKey(memoryHandler.displayLineCounter) {
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
    
    func toggleDisplayLineCounter() {
        if memoryHandler.defaults.boolForKey(memoryHandler.displayLineCounter) {
            memoryHandler.defaults.setBool(false, forKey: memoryHandler.displayLineCounter)
            colorblindToggleLabel.color = CCColor(red: 213/255, green: 35/255, blue: 0/255)
            colorblindToggleLabel.string = "OFF"
        }
        else {
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.displayLineCounter)
            colorblindToggleLabel.color = CCColor(red: 0/255, green: 128/255, blue: 0/255)
            colorblindToggleLabel.string = "ON"
        }
    }
    
    
    // MARK: About Screen Functions
    
    /**
    Displays the game credits.
    */
    func aboutMenu() {
        currentMenuView = .Credits
        mixpanel.track("Viewed About Screen")
        creditsLayer.runAction(CCActionFadeTo(duration: 0.5, opacity: 1))
        disableAllMenuButtons()
    }
    
    
    // MARK: Share Screen Functions
    
    /**
    Displays an interface from which the user can share the app.
    */
    func shareMenu() {
        currentMenuView = .Share
        mixpanel.track("Viewed Share Screen")
        self.animationManager.runAnimationsForSequenceNamed("MenuToShareScreen")
        disableAllMenuButtons()
    }
    
    func shareToFacebook() {
        sharingHandler.postToFacebook(postWithScreenshot: false)
    }
    
    func shareToTwitter() {
        sharingHandler.postToTwitter(stringToPost: "#ReactionLine is the best iPhone game in the world! Download it here:", postWithScreenshot: false)
    }
    
    func openSupportURL() {
        let supportURL: NSURL = NSURL(string: "https://docs.google.com/forms/d/1bDA5FjejM2KjPmpLzY6jroQv6nhhl6kDzOLa0mUUUP4/viewform")!
        
        if !UIApplication.sharedApplication().openURL(supportURL) {
            NSLog("Support Button: Failed to open url")
        }
    }
    
    func shareScreenToMenu() {
        currentMenuView = .MainMenu
        self.animationManager.runAnimationsForSequenceNamed("ShareScreenToMenu")
        enableAllMenuButtons()
    }
    
    
    // MARK: Stats Screen Functions
    
    /**
    Displays the stats view.
    */
    func statsMenu() {
        currentMenuView = .Stats
        mixpanel.track("Viewed Stats Screen")
        self.animationManager.runAnimationsForSequenceNamed("MenuToStatsScreen")
        disableAllMenuButtons()
    }
    
    func statsScreenToMenu() {
        currentMenuView = .MainMenu
        self.animationManager.runAnimationsForSequenceNamed("StatsScreenToMenu")
        statsScrollView.setScrollPosition(CGPoint(x: 0, y: 0), animated: true) // Reset the scroll position to 0 to prevent the tip of it from staying on the screen.
        enableAllMenuButtons()
        
        statsScreenToMenuButton.enabled = false
        delay(0.5) {
            self.statsScreenToMenuButton.enabled = true
        }
    }
    
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    
    - parameter delay:  how long, in milliseconds, to wait until the program should run the code in the closure statement
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
        timedModeButton.enabled    = false
        infiniteModeButton.enabled = false
        evilModeButton.enabled     = false
        leaderboardButton.enabled  = false
        
        optionsButton.enabled = false
        aboutButton.enabled   = false
        shareButton.enabled   = false
        statsButton.enabled   = false
    }
    
    func enableAllMenuButtons() {
        timedModeButton.enabled    = true
        infiniteModeButton.enabled = true
        evilModeButton.enabled     = true
        leaderboardButton.enabled  = true
        
        optionsButton.enabled = true
        aboutButton.enabled   = true
        shareButton.enabled   = true
        statsButton.enabled   = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if currentMenuView == .Credits {
            creditsLayer.runAction(CCActionFadeTo(duration: 0.5, opacity: 0))
            enableAllMenuButtons()
            delay(0.4) {
                self.currentMenuView = .MainMenu
            }
        }
    }
    
    // MARK: Swipe Gesture Handling
    
    func setupGestures() {
//        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
//        swipeLeft.direction = .Left
//        CCDirector.sharedDirector().view.addGestureRecognizer(swipeLeft)
//        
//        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight")
//        swipeRight.direction = .Right
//        CCDirector.sharedDirector().view.addGestureRecognizer(swipeRight)
//        
//        var swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeUp")
//        swipeUp.direction = .Up
//        CCDirector.sharedDirector().view.addGestureRecognizer(swipeUp)
//        
//        var swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDown")
//        swipeDown.direction = .Down
//        CCDirector.sharedDirector().view.addGestureRecognizer(swipeDown)
    }
    
    func removeGestureRecognizers() {
        if let recognizers = CCDirector.sharedDirector().view.gestureRecognizers {
            for recognizer in recognizers {
                CCDirector.sharedDirector().view.removeGestureRecognizer(recognizer )
            }
        }
    }
    
//    func swipeLeft() {
//        if currentMenuView == .MainMenu {
//            shareMenu()
//        }
//        else if currentMenuView == .Options {
//            optionsScreenToMenu()
//        }
//    }
//    
//    func swipeRight() {
//        if currentMenuView == .MainMenu {
//            optionsMenu()
//        }
//        else if currentMenuView == .Share {
//            shareScreenToMenu()
//        }
//    }
//    
//    func swipeUp() {
//        if currentMenuView == .MainMenu {
//            statsMenu()
//        }
//    }
//    
//    func swipeDown() {
//        if currentMenuView == .Stats {
//            statsScreenToMenu()
//        }
//    }
    
    
    // MARK: Color Option Handling
    
    func loadColorScheme() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject("Default", forKey: "colorScheme")
        
        if let colorThemeRawValue = defaults.stringForKey("colorScheme") {
            let colorTheme: ColorTheme = ColorTheme(rawValue: colorThemeRawValue)!
            
            if colorTheme == .Default {
                // Default color scheme
            }
            else if colorTheme == .Dark {
                
                let backgroundColor: CCColor = CCColor(red: 26/255, green: 23/255, blue: 23/255)
                let textColor: CCColor = CCColor(red: 246/255, green: 246/255, blue: 246/255)
                let detailColor: CCColor = CCColor(red: 150/255, green: 150/255, blue: 150/255)
                
                backgroundColorNode.color = backgroundColor
                topMenuBorderColorNode.color = backgroundColor
                bottomMenuBorderColorNode.color = backgroundColor
                
                mainTitleLabel.color = textColor
                statsTitleLabel.color = textColor
                shareTitleLabel.color = textColor
                optionsTitleLabel.color = textColor
                
                timedModeLabel.color = textColor
                infiniteModeLabel.color = textColor
                evilModeLabel.color = textColor
                leaderboardLabel.color = textColor
                
                versionNumberHeader.color = textColor
                vibrationOptionHeader.color = textColor
                soundEffectsOptionHeader.color = textColor
                displayLinesRemainingOptionHeader.color = textColor
                
                topDividingLine.color = detailColor
                bottomDividingLine.color = detailColor
            }
            else if colorTheme == .Light {
                
            }
        }
        else {
            let defaultColorTheme = ColorTheme(rawValue: "Default")!
            defaults.setObject(defaultColorTheme.rawValue, forKey: "colorScheme")
        }
    }
}

// MARK: Game Center Handling

extension MainScene: GKGameCenterControllerDelegate {
    
    func showLeaderboard() {
        let viewController = CCDirector.sharedDirector().parentViewController!
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}