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
        delay(0.5) {
            self.tapsPerSecondLabel.string        = String(format: "%.3f", self.defaults.doubleForKey(self.averageTapTimeKey)) + " taps"
            self.numberOfLinesClearedLabel.string = String(self.defaults.integerForKey(self.numberOfLinesCleared))
            self.timedModeClearsLabel.string      = String(self.defaults.integerForKey(self.timedModeWins))
            self.timedModeLossesLabel.string      = String(self.defaults.integerForKey(self.timedModeLosses))
            self.bestTimedLabel.string            = String(format: "%.3f", self.defaults.doubleForKey(self.topScoreKey))
            self.bestEvilLabel.string             = String(format: "%.3f", self.defaults.doubleForKey(self.topEvilScoreKey))
            self.bestInfiniteLabel.string         = String(self.defaults.integerForKey(self.topInfiniteScoreKey))
            self.evilModeClearsLabel.string       = String(self.defaults.integerForKey(self.evilModeWins))
            self.evilModeLossesLabel.string       = String(self.defaults.integerForKey(self.evilModeLosses))
            
            if self.defaults.doubleForKey(self.averageTapTimeKey) == 0 {
                self.tapsPerSecondLabel.string = "—" // Em dash!
            }
            
            if self.defaults.doubleForKey(self.topScoreKey) == 999.999 {
                self.bestTimedLabel.string = "—" // Em dash!
            }
            
            if self.defaults.doubleForKey(self.topEvilScoreKey) == 999.999 {
                self.bestEvilLabel.string = "—" // Em dash!
            }
            
            if self.defaults.integerForKey(self.topInfiniteScoreKey) == 0 {
                self.bestInfiniteLabel.string = "—" // Em dash!
            }
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
        
        mixpanel.people.set(["Number of Lines Cleared" : currentNumberOfLinesCleared])
        
        // Check if 10,000 lines achievement was cleared.
        var tenThousandLinesClearedAchievementProgress: Double = Double(currentNumberOfLinesCleared) / Double(10000)
        tenThousandLinesClearedAchievementProgress = floor(tenThousandLinesClearedAchievementProgress * 100)
        if tenThousandLinesClearedAchievementProgress > 100 {
            tenThousandLinesClearedAchievementProgress = 100
        }
        GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "tenThousandLinesCleared", percentComplete: tenThousandLinesClearedAchievementProgress)
        
        // Check if 100,000 lines achievement was cleared.
        var oneHundredThousandLinesClearedAchievementProgress: Double = Double(currentNumberOfLinesCleared) / Double(100000)
        oneHundredThousandLinesClearedAchievementProgress = floor(oneHundredThousandLinesClearedAchievementProgress * 100)
        if oneHundredThousandLinesClearedAchievementProgress > 100 {
            oneHundredThousandLinesClearedAchievementProgress = 100
        }
        GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "oneHundredThousandLinesCleared", percentComplete: oneHundredThousandLinesClearedAchievementProgress)
        
        // Check if 250,000 lines achievement was cleared.
        var twoHundredFiftyThousandLinesClearedAchievementProgress: Double = Double(currentNumberOfLinesCleared) / Double(250000)
        twoHundredFiftyThousandLinesClearedAchievementProgress = floor(twoHundredFiftyThousandLinesClearedAchievementProgress * 100)
        if twoHundredFiftyThousandLinesClearedAchievementProgress > 100 {
            twoHundredFiftyThousandLinesClearedAchievementProgress = 100
        }
        GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "twoHundredFiftyThousandLinesCleared", percentComplete: twoHundredFiftyThousandLinesClearedAchievementProgress)
        
        // Check if 500,000 lines achievement was cleared.
        var fiveHundredThousandLinesClearedAchievementProgress: Double = Double(currentNumberOfLinesCleared) / Double(500000)
        fiveHundredThousandLinesClearedAchievementProgress = floor(fiveHundredThousandLinesClearedAchievementProgress * 100)
        if fiveHundredThousandLinesClearedAchievementProgress > 100 {
            fiveHundredThousandLinesClearedAchievementProgress = 100
        }
        GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "fiveHundredThousandLinesCleared", percentComplete: fiveHundredThousandLinesClearedAchievementProgress)
        
        // Check if 1,000,000 lines achievement was cleared.
        var oneMillionLinesClearedAchievementProgress: Double = Double(currentNumberOfLinesCleared) / Double(1000000)
        oneMillionLinesClearedAchievementProgress = floor(oneMillionLinesClearedAchievementProgress * 100)
        if oneMillionLinesClearedAchievementProgress > 100 {
            oneMillionLinesClearedAchievementProgress = 100
        }
        GameCenterInteractor.sharedInstance.saveAchievementProgress(achievementIdentifier: "oneMillionLinesCleared", percentComplete: oneMillionLinesClearedAchievementProgress)
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
}