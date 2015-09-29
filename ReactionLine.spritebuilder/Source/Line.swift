//
//  Line.swift
//  ReactionLine
//
//  Created by Zachary Espiritu on 7/8/15.
//  Copyright (c) 2015 Zachary Espiritu. All rights reserved.
//

import Foundation

enum Color {
    case Red, Blue
}

class Line: CCNode {
    
    // MARK: Constants
    
    let memoryHandler = MemoryHandler()
    
    
    // MARK: Variables
    
    weak var colorNode: CCNodeColor!
    
    var colorType: Color = .Red {
        didSet {
            if colorType == .Red {
                if memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey) {
                    colorNode.color = CCColor(red: 255/255, green: 255/255, blue: 255/255)
                }
                else {
                    colorNode.color = CCColor(red: 255/255, green: 102/255, blue: 102/255)
                }
            }
            else {
                if memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey) {
                    colorNode.color = CCColor(red: 0/255, green: 0/255, blue: 0/255)
                }
                else {
                    colorNode.color = CCColor(red: 54/255, green: 166/255, blue: 222/255)
                    
                }
            }
        }
    }
    
    
    // MARK: Functions
    
    /**
    Sets each line to a randomly chosen color.
    */
    func setRandomColor() {
        let randomNumber = CCRANDOM_0_1()
        
        if randomNumber < 0.50 {
            colorType = .Red
        }
        else {
            colorType = .Blue
        }
    }
    
    /**
    Swaps the color of the `Line`.
    
    For use in Evil Mode.
    */
    func swapColors() {
        
        let redColor = CCColor(red: 255/255, green: 102/255, blue: 102/255)
        let blueColor = CCColor(red: 54/255, green: 166/255, blue: 222/255)
        
        let whiteColor = CCColor(red: 255/255, green: 255/255, blue: 255/255)
        let blackColor = CCColor(red: 0/255, green: 0/255, blue: 0/255)
        
        if colorType == .Red {
            if memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey) {
                colorNode.color = blackColor
            }
            else {
                colorNode.color = blueColor
                
            }
            colorType = .Blue
        }
        else if colorType == .Blue {
            if memoryHandler.defaults.boolForKey(memoryHandler.colorblindSettingKey) {
                colorNode.color = whiteColor
            }
            else {
                colorNode.color = redColor
            }
            colorType = .Red
        }
    }
    
    /**
    Function used in the losing state end-game animation sequence to achieve a "cascading" effect with the lines. See `gameOver()` in `Gameplay.swift` for more information.
    */
    func fallDown() {
        
        self.runAction(CCActionEaseSineIn(action: CCActionMoveBy(duration: 4, position: CGPoint(x: self.position.x, y: -2000))))
        
        if self.rotation <= 0 {
            self.runAction(CCActionEaseSineIn(action: CCActionRotateBy(duration: 4, angle: -40)))
        }
        else {
            self.runAction(CCActionEaseSineIn(action: CCActionRotateBy(duration: 4, angle: 40)))
        }
        
    }
    
}