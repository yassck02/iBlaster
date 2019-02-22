//
//  Enemy.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

// -----------------------------------------------------------

class Enemy: GKEntity {
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    static var action_pulsate: SKAction {
        return SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(by: 10,  duration: 0.5),
            SKAction.scale(by: -10, duration: 0.5)
        ]))
    }
    
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
}

// -----------------------------------------------------------
