//
//  Stats.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Stats: CCNode {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let averageTapTimeKey = "averageTapTimeKey"
    let tapTimeOfLastFifteenGamesArray = "tapTimeOfLastFifteenGamesArray"
    
    let timedModeWins = "timedModeWins"
    let timedModeLosses = "timedModeLosses"
    
    let numberOfLinesCleared = "numberOfLinesCleared"
    let totalPlaytime = "totalPlaytime"
    
    
    // MARK: Functions
    
    /**
    Calculates the new average tap time of the player.
    
    It stores the last 10 games of the player and combines the averages of all of those to find a more accurate average.
    */
    func calculateNewAverageTapTime(#numberOfTaps: Int, timeSpent: Double) {
    
        if numberOfTaps > 0 {
            
            var averageTapTimeOfThisGame = timeSpent / Double(numberOfTaps)
            
            var lastFifteenGames: [Double] = defaults.arrayForKey(tapTimeOfLastFifteenGamesArray) as! [Double]
            lastFifteenGames.append(averageTapTimeOfThisGame)
            
            if lastFifteenGames.count > 15 {
                lastFifteenGames.removeAtIndex(0)
            }
            
            defaults.setObject(lastFifteenGames, forKey: tapTimeOfLastFifteenGamesArray)
            
            var totalTapTime: Double = 0
            for averageTapTime in lastFifteenGames {
                totalTapTime += averageTapTime
            }
            
            var averageTapTime: Double = totalTapTime / Double(lastFifteenGames.count)
            
            defaults.setDouble(averageTapTime, forKey: averageTapTimeKey)
            
            println(lastFifteenGames)
            println(defaults.doubleForKey(averageTapTimeKey))
            
        }
        
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
    
    func addMoreLinesCleared(#numberOfLinesToAdd: Int) {
        
        var currentNumberOfLinesCleared = defaults.integerForKey(numberOfLinesCleared)
        currentNumberOfLinesCleared += numberOfLinesToAdd
        
        defaults.setInteger(currentNumberOfLinesCleared, forKey: numberOfLinesCleared)
        
        println("Number of Lines Cleared (All-Time): \(defaults.integerForKey(numberOfLinesCleared))")
        
    }
    
}