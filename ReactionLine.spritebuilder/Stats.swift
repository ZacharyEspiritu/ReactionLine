//
//  Stats.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Stats: CCNode {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let averageTapTimeKey = "averageTapTimeKey"
    let tapTimeOfLastTenGamesKey = "tapTimeOfLastTenGamesKey"
    
    let timedModeWins = "timedModeWins"
    let timedModeLosses = "timedModeLosses"
    
    var numberOfLinesCleared: Int = 0
    var totalPlaytime: Int = 0
    
    func didLoadFromCCB() {
        
        
        
        
    }
    
    func calculateNewAverageTapTime(#numberOfTaps: Int, timeSpent: Double) {
        
        var averageTapTime: Double = 0
        var averageTapTimeOfThisGame = timeSpent / Double(numberOfTaps)
        
        averageTapTime = (averageTapTimeOfThisGame + defaults.doubleForKey(averageTapTimeKey))
        
        defaults.setDouble(averageTapTime, forKey: averageTapTimeKey)
        
    }
    
    func addTimedModeWin() {
        
        var currentTimedModeWins = defaults.integerForKey(timedModeWins)
        currentTimedModeWins++
        
        defaults.setInteger(currentTimedModeWins, forKey: timedModeWins)
        
    }
    func addTimedModeLoss() {
        
        var currentTimedModeLosses = defaults.integerForKey(timedModeLosses)
        currentTimedModeLosses++
        
        defaults.setInteger(currentTimedModeLosses, forKey: timedModeLosses)
        
    }
    
}