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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let mixpanel = Mixpanel.sharedInstance()
    
    let hasAlreadyLoaded = "hasAlreadyLoaded"
    
    let topScoreKey = "topScoreKey"
    let secondScoreKey = "secondScoreKey"
    let thirdScoreKey = "thirdScoreKey"
    
    let topInfiniteScoreKey = "topInfiniteScoreKey"
    let secondInfiniteScoreKey = "secondInfiniteScoreKey"
    let thirdInfiniteScoreKey = "thirdInfiniteScoreKey"
    
    let topEvilScoreKey = "topEvilScoreKey"
    let secondEvilScoreKey = "secondEvilScoreKey"
    let thirdEvilScoreKey = "thirdEvilScoreKey"
    
    let currentGamemode = "currentGamemode"
    
    let vibrationSettingKey = "vibrationSettingKey"
    let soundsSettingKey = "soundsSettingKey"
    let colorblindSettingKey = "colorblindSettingKey"
    
    
    func checkForNewTopScore(newTime: Double) -> Bool {
        
        var scoreArray: [Double] = [newTime, defaults.doubleForKey(topScoreKey), defaults.doubleForKey(secondScoreKey), defaults.doubleForKey(thirdScoreKey)]
        
        scoreArray.sort({ $0 < $1 })
        
        defaults.setDouble(scoreArray[0], forKey: topScoreKey)
        defaults.setDouble(scoreArray[1], forKey: secondScoreKey)
        defaults.setDouble(scoreArray[2], forKey: thirdScoreKey)
        
        let truncatedHighScore: Double = Double(round(1000 * self.defaults.doubleForKey(self.topScoreKey))/1000)
        mixpanel.people.set("Timed Mode High Score", to: truncatedHighScore)
        
        return true
        
    }
    
    func checkForNewTopInfiniteScore(newTime: Int) -> Bool {
        
        var scoreArray: [Int] = [newTime, defaults.integerForKey(topInfiniteScoreKey), defaults.integerForKey(secondInfiniteScoreKey), defaults.integerForKey(thirdInfiniteScoreKey)]
        
        scoreArray.sort({ $0 > $1 })
        
        defaults.setInteger(scoreArray[0], forKey: topInfiniteScoreKey)
        defaults.setInteger(scoreArray[1], forKey: secondInfiniteScoreKey)
        defaults.setInteger(scoreArray[2], forKey: thirdInfiniteScoreKey)
        
        mixpanel.people.set("Infinite Mode High Score", to: self.defaults.integerForKey(self.topInfiniteScoreKey))
        
        return true
        
    }
    
    func checkForNewTopEvilScore(newTime: Double) -> Bool {
        
        var scoreArray: [Double] = [newTime, defaults.doubleForKey(topEvilScoreKey), defaults.doubleForKey(secondEvilScoreKey), defaults.doubleForKey(thirdEvilScoreKey)]
        
        scoreArray.sort({ $0 > $1 })
        
        defaults.setDouble(scoreArray[0], forKey: topEvilScoreKey)
        defaults.setDouble(scoreArray[1], forKey: secondEvilScoreKey)
        defaults.setDouble(scoreArray[2], forKey: thirdEvilScoreKey)
        
        return true
        
    }
    
}