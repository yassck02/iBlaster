//
//  Weapon.swift
//  EyeFighter
//
//  Created by Connor yass on 2/22/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

enum WeaponType {
    case A
    case B
    case C
    case D
    case E
    
    static let allValues = [A, B, C, D, E]
}

/* ----------------------------------------------------------------------------------------- */

class Weapon {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var type: WeaponType!
    var level: Int!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    init(type: WeaponType) {
        self.type = type
        self.level = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var projectile: Projectile {
        return Projectile(damage: 25, color: SKColor.green)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
