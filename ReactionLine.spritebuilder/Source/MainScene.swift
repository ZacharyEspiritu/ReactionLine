import Foundation

enum GameState {
    case Playing, GameOver
}

class MainScene: CCNode {
    
    // MARK: Constants
    
    let padding: CGFloat = 16
    let numberOfLines: Int = 100
    
    let audio = OALSimpleAudio.sharedInstance()
    
    
    // MARK: Memory Variables
    
    let memoryHandler = MemoryHandler()
    
    
    // MARK: Variables
    
    weak var titleLabel: CCLabelTTF!
    weak var infoLabel: CCLabelTTF!
    
    weak var creditsLayer: CCNode!
    var isCreditsInView = false
    
    weak var timedModeButton: CCControl!
    weak var infiniteModeButton: CCControl!
    weak var twoPlayerModeButton: CCControl!
    weak var challengeModeButton: CCControl!
    
    weak var optionsButton: CCControl!
    weak var aboutButton: CCControl!
    weak var shareButton: CCControl!
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        
        if !memoryHandler.defaults.boolForKey(memoryHandler.hasAlreadyLoaded) {
            
            memoryHandler.defaults.setBool(true, forKey: memoryHandler.hasAlreadyLoaded)
            
            memoryHandler.defaults.setDouble(99.999, forKey: memoryHandler.topScoreKey)
            memoryHandler.defaults.setDouble(99.999, forKey: memoryHandler.secondScoreKey)
            memoryHandler.defaults.setDouble(99.999, forKey: memoryHandler.thirdScoreKey)
            
            println("Default settings loaded.")
            
        }
        
        creditsLayer.cascadeOpacityEnabled = true
        creditsLayer.opacity = 0
        
        self.userInteractionEnabled = true
        
    }
    
    /**
    Begins Timed Mode.
    */
    func timedMode() {
        disableAllMenuButtons()
        self.animationManager.runAnimationsForSequenceNamed("TimedMode")
        
        delay(1.1) {
            
            var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
            
        }
    }
    
    /**
    Begins Infinite Mode.
    */
    func infiniteMode() {
        disableAllMenuButtons()
        self.animationManager.runAnimationsForSequenceNamed("InfiniteMode")
        
        delay(1.1) {
            
            var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
            
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
        self.animationManager.runAnimationsForSequenceNamed("TwoPlayerMode")
        
        delay(1.1) {
            
            var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
            
        }
    }
    
    /**
    Begins Challenge Mode.
    */
    func challengeMode() {
        disableAllMenuButtons()
        self.animationManager.runAnimationsForSequenceNamed("ChallengeMode")
        
        delay(1.1) {
            
            var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            CCDirector.sharedDirector().presentScene(scene)
            
        }
    }
    
    /**
    Displays an interface from which the user can change certain options for the game.
    */
    func optionsMenu() {
        println("TODO: Implement options menu.")
    }
    
    /**
    Displays the game credits.
    */
    func aboutMenu() {
        creditsLayer.runAction(CCActionFadeTo(duration: 0.5, opacity: 1))
        isCreditsInView = true
        disableAllMenuButtons()
    }
    
    /**
    Displays an interface from which the user can share the app.
    */
    func shareMenu() {
        println("TODO: Implement sharing buttons.")
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
        timedModeButton.enabled = false
        infiniteModeButton.enabled = false
        twoPlayerModeButton.enabled = false
        challengeModeButton.enabled = false
        
        optionsButton.enabled = false
        aboutButton.enabled = false
        shareButton.enabled = false
    }
    
    func enableAllMenuButtons() {
        timedModeButton.enabled = true
        infiniteModeButton.enabled = true
        twoPlayerModeButton.enabled = true
        challengeModeButton.enabled = true
        
        optionsButton.enabled = true
        aboutButton.enabled = true
        shareButton.enabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if isCreditsInView {
            creditsLayer.runAction(CCActionFadeTo(duration: 0.5, opacity: 0))
            isCreditsInView = false
            enableAllMenuButtons()
        }
    }

}
