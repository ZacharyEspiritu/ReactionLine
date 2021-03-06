//
//  MemoryHandler.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/12/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

enum Gamemode {
    case Timed, Infinite
}

class MemoryHandler {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let mixpanel = Mixpanel.sharedInstance()
    
    let hasAlreadyLoaded = "hasAlreadyLoaded"
    
    let topScoreKey    = "topScoreKey"
    let secondScoreKey = "secondScoreKey"
    let thirdScoreKey  = "thirdScoreKey"
    
    let topInfiniteScoreKey    = "topInfiniteScoreKey"
    let secondInfiniteScoreKey = "secondInfiniteScoreKey"
    let thirdInfiniteScoreKey  = "thirdInfiniteScoreKey"
    
    let topEvilScoreKey    = "topEvilScoreKey"
    let secondEvilScoreKey = "secondEvilScoreKey"
    let thirdEvilScoreKey  = "thirdEvilScoreKey"
    
    let currentGamemode = "currentGamemode"
    
    let vibrationSettingKey  = "vibrationSettingKey"
    let soundsSettingKey     = "soundsSettingKey"
    let colorblindSettingKey = "colorblindSettingKey"
    let displayLineCounter   = "displayLineCounterKey"
    
    
    // MARK: Functions
    
    /**
    Checks for a new top Timed Mode score.
    
    - parameter newTime:  the time to check to see if there is a new high score
    */
    func checkForNewTopTimedScore(newTime: Double) -> Bool {
        
        var scoreArray: [Double] = [newTime, defaults.doubleForKey(topScoreKey), defaults.doubleForKey(secondScoreKey), defaults.doubleForKey(thirdScoreKey)]
        
        scoreArray.sortInPlace({ $0 < $1 })
        
        defaults.setDouble(scoreArray[0], forKey: topScoreKey)
        defaults.setDouble(scoreArray[1], forKey: secondScoreKey)
        defaults.setDouble(scoreArray[2], forKey: thirdScoreKey)
        
        let truncatedHighScore: Double = Double(round(1000 * self.defaults.doubleForKey(self.topScoreKey))/1000)
        mixpanel.people.set("Timed Mode High Score", to: truncatedHighScore)
        
        GameCenterInteractor.sharedInstance.saveHighScore("Timed", score: truncatedHighScore)
        
        if truncatedHighScore < 10 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "timedModeSub10", percentComplete: 100)
        }
        if truncatedHighScore < 15 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "timedModeSub15", percentComplete: 100)
        }
        if truncatedHighScore < 20 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "timedModeSub20", percentComplete: 100)
        }
        if truncatedHighScore < 25 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "timedModeSub25", percentComplete: 100)
        }
        if truncatedHighScore < 30 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "timedModeSub30", percentComplete: 100)
        }
        
        return true
    }
    
    /**
    Checks for a new top Infinite Mode score.
    
    - parameter newScore:  the score to check to see if there is a new high score
    */
    func checkForNewTopInfiniteScore(newScore: Int) -> Bool {
        
        var scoreArray: [Int] = [newScore, defaults.integerForKey(topInfiniteScoreKey), defaults.integerForKey(secondInfiniteScoreKey), defaults.integerForKey(thirdInfiniteScoreKey)]
        
        scoreArray.sortInPlace({ $0 > $1 })
        
        defaults.setInteger(scoreArray[0], forKey: topInfiniteScoreKey)
        defaults.setInteger(scoreArray[1], forKey: secondInfiniteScoreKey)
        defaults.setInteger(scoreArray[2], forKey: thirdInfiniteScoreKey)
        
        mixpanel.people.set("Infinite Mode High Score", to: self.defaults.integerForKey(self.topInfiniteScoreKey))
        
        GameCenterInteractor.sharedInstance.saveHighScore("Infinite", score: Double(self.defaults.integerForKey(self.topInfiniteScoreKey)))
        
        if Double(self.defaults.integerForKey(self.topInfiniteScoreKey)) >= 1000 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "infiniteMode1000Lines", percentComplete: 100)
        }
        if Double(self.defaults.integerForKey(self.topInfiniteScoreKey)) >= 750 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "infiniteMode750Lines", percentComplete: 100)
        }
        if Double(self.defaults.integerForKey(self.topInfiniteScoreKey)) >= 500 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "infiniteMode500Lines", percentComplete: 100)
        }
        if Double(self.defaults.integerForKey(self.topInfiniteScoreKey)) >= 250 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "infiniteMode250Lines", percentComplete: 100)
        }
        if Double(self.defaults.integerForKey(self.topInfiniteScoreKey)) >= 100 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "infiniteMode100Lines", percentComplete: 100)
        }
        
        return true
    }
    
    /**
    Checks for a new top Evil Mode score.
    
    - parameter newTime:  the time to check to see if there is a new high score
    */
    func checkForNewTopEvilScore(newTime: Double) -> Bool {
        
        var scoreArray: [Double] = [newTime, defaults.doubleForKey(topEvilScoreKey), defaults.doubleForKey(secondEvilScoreKey), defaults.doubleForKey(thirdEvilScoreKey)]
        
        scoreArray.sortInPlace({ $0 < $1 })
        
        defaults.setDouble(scoreArray[0], forKey: topEvilScoreKey)
        defaults.setDouble(scoreArray[1], forKey: secondEvilScoreKey)
        defaults.setDouble(scoreArray[2], forKey: thirdEvilScoreKey)
        
        let truncatedHighScore: Double = Double(round(1000 * self.defaults.doubleForKey(self.topEvilScoreKey))/1000)
        mixpanel.people.set("Evil Mode High Score", to: truncatedHighScore)
        
        GameCenterInteractor.sharedInstance.saveHighScore("Evil", score: truncatedHighScore)
        
        if truncatedHighScore < 25 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "evilModeSub25", percentComplete: 100)
        }
        if truncatedHighScore < 30 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "evilModeSub30", percentComplete: 100)
        }
        if truncatedHighScore < 35 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "evilModeSub35", percentComplete: 100)
        }
        if truncatedHighScore < 40 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "evilModeSub40", percentComplete: 100)
        }
        if truncatedHighScore < 45 {
            GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "evilModeSub45", percentComplete: 100)
        }
        
        return true
    }
}