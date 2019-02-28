//
//  Weapon.swift
//  EyeFighter
//
//  Created by Connor yass on 2/22/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

enum WeaponType {
    case I
    case II
    case III
    case IV
    case V
    
    static let allValues = [I, II, III, IV, V]
}

/* ----------------------------------------------------------------------------------------- */

class Weapon: GKEntity {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var type: WeaponType!
    var level: Int!
    
    var position: CGPoint {
        get {
            return component(ofType: VisualComponent.self)!.node.position
        }
        set {
            component(ofType: VisualComponent.self)!.node.position = newValue
        }
    }
    
    var rotation: CGFloat {
        get {
            return component(ofType: VisualComponent.self)!.node.zRotation
        }
        set {
            component(ofType: VisualComponent.self)!.node.zRotation = newValue
        }
    }
    
    func rotate(to point: CGPoint) {
        rotation = atan2(position.y - point.y, position.x - point.x)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    init(type: WeaponType) {
        super.init()
        self.type = type
        self.level = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func launch() {
        Log.function()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
