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
    
    weak var colorNode: CCNodeColor!
    var colorType: Color = .Red
    
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
    
}