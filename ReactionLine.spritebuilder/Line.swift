//
//  Line.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum Color {
    case Red, Blue
}

class Line: CCNode {
    
    // MARK: Variables
    
    weak var colorNode: CCNodeColor!
    
    var colorType: Color = .Red
    
    
    // MARK: Functions
    
    /**
    Sets each line to a randomly chosen color.
    */
    func setRandomColor() {
        
        let redColor = CCColor(red: 255/255, green: 102/255, blue: 102/255)
        let blueColor = CCColor(red: 54/255, green: 166/255, blue: 222/255)
        
        var randomNumber = CCRANDOM_0_1()
        
        if randomNumber < 0.50 {
            
            colorNode.color = redColor
            colorType = .Red
            
        }
        else {
            
            colorNode.color = blueColor
            colorType = .Blue
            
        }
        
    }
    
    /**
    Function used in the losing state end-game animation sequence to achieve a "cascading" effect with the lines. See `gameOver()` in `Gameplay.swift` for more information.
    */
    func fallDown() {
        
        self.runAction(CCActionEaseSineIn(action: CCActionMoveBy(duration: 4, position: CGPoint(x: self.position.x, y: -2000))))
        
    }
    
}