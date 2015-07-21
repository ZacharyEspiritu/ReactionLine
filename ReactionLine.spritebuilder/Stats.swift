//
//  Stats.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/14/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

class Stats: CCNode {
    
    // MARK: Constants
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let gameCenterInteractor = GameCenterInteractor.sharedInstance
    
    let mixpanel = Mixpanel.sharedInstance()
    
    let tapTimeOfLastFifteenGamesArray = "tapTimeOfLastFifteenGamesArray"
    
    let averageTapTimeKey    = "averageTapTimeKey"
    let timedModeWins        = "timedModeWins"
    let timedModeLosses      = "timedModeLosses"
    let numberOfLinesCleared = "numberOfLinesCleared"
    let topScoreKey          = "topScoreKey"
    let topInfiniteScoreKey  = "topInfiniteScoreKey"
    let topEvilScoreKey      = "topEvilScoreKey"
    let evilModeWins         = "evilModeWins"
    let evilModeLosses       = "evilModeLosses"
    
    
    // MARK: Code Connections
    
    weak var tapsPerSecondLabel:        CCLabelTTF!
    weak var numberOfLinesClearedLabel: CCLabelTTF!
    weak var timedModeClearsLabel:      CCLabelTTF!
    weak var timedModeLossesLabel:      CCLabelTTF!
    weak var bestTimedLabel:            CCLabelTTF!
    weak var bestInfiniteLabel:         CCLabelTTF!
    weak var bestEvilLabel:             CCLabelTTF!
    weak var evilModeClearsLabel:       CCLabelTTF!
    weak var evilModeLossesLabel:       CCLabelTTF!
    
    // MARK: Singleton
    
    class var sharedInstance : Stats {
        struct Static {
            static let instance : Stats = Stats()
        }
        return Static.instance
    }
    
    
    // MARK: Stats Screen Loading Functions
    
    func didLoadFromCCB() {
        
        tapsPerSecondLabel.string        = String(format: "%.3f", defaults.doubleForKey(averageTapTimeKey)) + " taps"
        numberOfLinesClearedLabel.string = String(defaults.integerForKey(numberOfLinesCleared))
        timedModeClearsLabel.string      = String(defaults.integerForKey(timedModeWins))
        timedModeLossesLabel.string      = String(defaults.integerForKey(timedModeLosses))
        bestTimedLabel.string            = String(format: "%.3f", defaults.doubleForKey(topScoreKey))
        bestEvilLabel.string             = String(format: "%.3f", defaults.doubleForKey(topEvilScoreKey))
        bestInfiniteLabel.string         = String(defaults.integerForKey(topInfiniteScoreKey))
        evilModeClearsLabel.string       = String(defaults.integerForKey(evilModeWins))
        evilModeLossesLabel.string       = String(defaults.integerForKey(evilModeLosses))
        
        if tapsPerSecondLabel.string == "999.999 tps" {
            tapsPerSecondLabel.string = "—" // Em dash!
        }
        
        if bestTimedLabel.string == "999.999" {
            bestTimedLabel.string = "—" // Em dash!
        }
        
        if bestEvilLabel.string == "999.999" {
            bestEvilLabel.string = "—" // Em dash!
        }
        
        if bestInfiniteLabel.string == "0" {
            bestInfiniteLabel.string = "—" // Em dash!
        }
        
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
            
        }
        
    }
    
    /**
    Adds 1 to the amount of timed mode wins and stores that value.
    */
    func addTimedModeWin() {
        
        var currentTimedModeWins = defaults.integerForKey(timedModeWins)
        currentTimedModeWins++
        
        defaults.setInteger(currentTimedModeWins, forKey: timedModeWins)
        
        mixpanel.track("Timed Mode Wins")
        
    }
    
    /**
    Adds 1 to the amount of timed mode losses and stores that value.
    */
    func addTimedModeLoss() {
        
        var currentTimedModeLosses = defaults.integerForKey(timedModeLosses)
        currentTimedModeLosses++
        
        defaults.setInteger(currentTimedModeLosses, forKey: timedModeLosses)
        
        mixpanel.track("Timed Mode Losses")
        
    }
    
    /**
    Adds 1 to the amount of timed mode wins and stores that value.
    */
    func addEvilModeWin() {
        
        var currentEvilModeWins = defaults.integerForKey(evilModeWins)
        currentEvilModeWins++
        
        defaults.setInteger(currentEvilModeWins, forKey: evilModeWins)
        
        mixpanel.track("Evil Mode Wins")
        
    }
    
    /**
    Adds 1 to the amount of timed mode losses and stores that value.
    */
    func addEvilModeLoss() {
        
        var currentEvilModeLosses = defaults.integerForKey(evilModeLosses)
        currentEvilModeLosses++
        
        defaults.setInteger(currentEvilModeLosses, forKey: evilModeLosses)
        
        mixpanel.track("Evil Mode Losses")
        
    }
    
    /**
    Adds `numberOfLinesToAdd` to the current amount of total lines cleared and stores that value.
    
    :param: numberOfLinesToAdd  the number of lines to add to the total amount of lines ever cleared
    */
    func addMoreLinesCleared(#numberOfLinesToAdd: Int) {
        
        var currentNumberOfLinesCleared = defaults.integerForKey(numberOfLinesCleared)
        currentNumberOfLinesCleared += numberOfLinesToAdd
        
        defaults.setInteger(currentNumberOfLinesCleared, forKey: numberOfLinesCleared)
        
    }
    
}