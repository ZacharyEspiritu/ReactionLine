import Foundation

enum GameState {
    case Playing, GameOver
}

class MainScene: CCNode {
    
    // MARK: Constants
    
    let padding: CGFloat = 16
    let numberOfLines: Int = 100
    
    let audio = OALSimpleAudio.sharedInstance()
    
    
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
        
    }
    
    /**
    Begins the game.
    
    It is called whenever the `playButton` is tapped.
    */
    func play() {
        
        var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
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

}
