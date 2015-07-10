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
    weak var winLabel: CCLabelTTF!
    
    weak var playButton: CCControl!
    weak var optionsButton: CCControl!
    weak var aboutButton: CCControl!
    
    weak var buttonNode: CCNode!
    weak var headerNode: CCNode!
    
    weak var blueTouchZone: CCNode!
    weak var redTouchZone: CCNode!
    
    weak var lineGroupingNode: CCNode!
    
    var lineArray: [Line] = []
    
    var lineIndex = 0
    
    var gameState: GameState = .Playing
    
    
    // MARK: Functions
    
    func didLoadFromCCB() {
        
        for index in 0..<numberOfLines {
            
            var line = CCBReader.load("Line") as! Line
            line.setRandomColor()
            
            var lineHeight = (line.contentSizeInPoints.height + padding) * CGFloat(index)
            line.position = CGPoint(x: 0, y: lineHeight)
            
            lineGroupingNode.addChild(line)
            lineArray.append(line)
            
        }
        
        lineGroupingNode.cascadeOpacityEnabled = true
        lineGroupingNode.opacity = 0
        
        audio.preloadEffect("slide.wav")
        
    }
    
    func play() {
        
        var gameplayScene = CCBReader.load("Gameplay") as! Gameplay
        
        var scene = CCScene()
        scene.addChild(gameplayScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
        
    }
    
    func options() {
        
    }
    
    func about() {
        
    }

}
