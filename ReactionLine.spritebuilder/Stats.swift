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
    
    let topScoreKey = "topScoreKey"
    let topInfiniteScoreKey = "topInfiniteScoreKey"
    
    
    // MARK: Code Connections
    
    weak var tapsPerSecondLabel:        CCLabelTTF!
    weak var numberOfLinesClearedLabel: CCLabelTTF!
    weak var timedModeClearsLabel:      CCLabelTTF!
    weak var timedModeLossesLabel:      CCLabelTTF!
    weak var bestTimedLabel:            CCLabelTTF!
    weak var bestInfiniteLabel:         CCLabelTTF!
    weak var totalPlaytimeLabel:        CCLabelTTF!
    
    
    // MARK: Stats Screen Loading Functions
    
    func didLoadFromCCB() {
        
        tapsPerSecondLabel.string        = String(format: "%.3f", defaults.doubleForKey(averageTapTimeKey)) + " tps"
        numberOfLinesClearedLabel.string = String(defaults.integerForKey(numberOfLinesCleared)) + " lines"
        timedModeClearsLabel.string      = String(defaults.integerForKey(timedModeWins))
        timedModeLossesLabel.string      = String(defaults.integerForKey(timedModeLosses))
        bestTimedLabel.string            = String(format: "%.3f", defaults.doubleForKey(topScoreKey))
        bestInfiniteLabel.string         = String(defaults.integerForKey(topInfiniteScoreKey))
        
    }
    
    // MARK: Statistic Handling Functions
    
    /**
    Calculates the new average tap time of the player.
    
    It stores the last 15 games of the player and combines the averages of all of those games to find a more accurate average.
    
    :param: numberOfTaps  the number of taps the player made in the last game instance
    :param: timeSpent     the amount of time the player was in the last game instance, in seconds
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
            
            averageTapTime = 1 / averageTapTime // Change the value from seconds between taps to taps per second.
            
            defaults.setDouble(averageTapTime, forKey: averageTapTimeKey)
            
            println("Average Tap Time of Last 15 Games: \(lastFifteenGames)")
            println("Calculated Average Tap Time: \(defaults.doubleForKey(averageTapTimeKey)) taps per second")
            
        }
        
    }
    
    /**
    Adds 1 to the amount of timed mode wins and stores that value.
    */
    func addTimedModeWin() {
        
        var currentTimedModeWins = defaults.integerForKey(timedModeWins)
        currentTimedModeWins++
        
        defaults.setInteger(currentTimedModeWins, forKey: timedModeWins)
        
    }
    
    /**
    Adds 1 to the amount of timed mode losses and stores that value.
    */
    func addTimedModeLoss() {
        
        var currentTimedModeLosses = defaults.integerForKey(timedModeLosses)
        currentTimedModeLosses++
        
        defaults.setInteger(currentTimedModeLosses, forKey: timedModeLosses)
        
    }
    
    /**
    Adds `numberOfLinesToAdd` to the current amount of total lines cleared and stores that value.
    
    :param: numberOfLinesToAdd  the number of lines to add to the total amount of lines ever cleared
    */
    func addMoreLinesCleared(#numberOfLinesToAdd: Int) {
        
        var currentNumberOfLinesCleared = defaults.integerForKey(numberOfLinesCleared)
        currentNumberOfLinesCleared += numberOfLinesToAdd
        
        defaults.setInteger(currentNumberOfLinesCleared, forKey: numberOfLinesCleared)
        
        println("Number of Lines Cleared (All-Time): \(defaults.integerForKey(numberOfLinesCleared))")
        
    }
    
}