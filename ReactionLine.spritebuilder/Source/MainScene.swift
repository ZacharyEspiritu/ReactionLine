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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let hasAlreadyLoaded = "hasAlreadyLoaded"
    let highScoreKey = "highScoreKey"
    
    
    // MARK: Variables
    
    weak var titleLabel: CCLabelTTF!
    weak var infoLabel: CCLabelTTF!
    
    weak var playButton: CCControl!
    weak var optionsButton: CCControl!
    weak var aboutButton: CCControl!
    
    weak var buttonNode: CCNode!
    weak var headerNode: CCNode!
    
    var gameState: GameState = .Playing
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        
        if !defaults.boolForKey(hasAlreadyLoaded) {
            
            defaults.setBool(true, forKey: hasAlreadyLoaded)
            defaults.setDouble(99.999, forKey: highScoreKey)
            
        }
        
    }
    
    /**
    Begins the game.
    
    It is called whenever the `playButton` is tapped.
    */
    func play() {
        
        self.animationManager.runAnimationsForSequenceNamed("FlyOutToGameplay")
        
        delay(0.9) {
            
            var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
            
            var scene = CCScene()
            scene.addChild(gameplayScene)
            
            var transition = CCTransition(fadeWithDuration: 0.1)
            
            CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
            
        }
        
    }
    
    /**
    Displays the options menu.
    
    It is called whenever the `optionsButton` is tapped.
    */
    func options() {
        
    }
    
    /**
    Displays the credits scene.
    
    It is called whenever the `aboutButton` is tapped.
    */
    func about() {
        
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
