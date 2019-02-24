//
//  WeaponComponent.swift
//  EyeFighter
//
//  Created by Connor yass on 2/22/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameplayKit

/* ----------------------------------------------------------------------------------------- */

class AttackComponent: GKComponent {
    
    var weapon: Weapon!
    
    init(weapon: Weapon) {
        super.init()
        self.weapon = weapon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/* ----------------------------------------------------------------------------------------- */
