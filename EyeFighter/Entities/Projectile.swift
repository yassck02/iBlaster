//
//  Projectile.swift
//  EyeFighter
//
//  Created by Connor yass on 2/23/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

/* ----------------------------------------------------------------------------------------- */

class Projectile: GKEntity {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var level: Int!
    
    var position: CGPoint {
        get {
            return component(ofType: VisualComponent.self)!.node.position
        }
        set {
            component(ofType: VisualComponent.self)!.node.position = newValue
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    init(level: Int) {
        super.init()
        self.level = level
        self.position = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
