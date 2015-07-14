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
    
    let hasAlreadyLoaded = "hasAlreadyLoaded"
    
    let topScoreKey = "topScoreKey"
    let secondScoreKey = "secondScoreKey"
    let thirdScoreKey = "thirdScoreKey"
    
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
        
        return true
    }
    
}