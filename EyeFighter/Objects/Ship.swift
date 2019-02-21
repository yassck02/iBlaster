//
//  Ship.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

class Ship: GKEntity {
    
    static var action_fire: SKAction {
        return SKAction.sequence([
            SKAction.moveTo(x: 0.0, duration: 0.1)
        ])
    }
    
}
