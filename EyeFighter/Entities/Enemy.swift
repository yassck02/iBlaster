//
//  Enemy.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

/* ----------------------------------------------------------------------------------------- */

enum EnemyType {
    case one
    case two
    case three
    case four
}

/* ----------------------------------------------------------------------------------------- */

class Enemy: GKEntity {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var type: EnemyType!
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

    init(type: EnemyType, level: Int) {
        super.init()
        
        self.type = type
        self.level = level
        
        let visalComponent = VisualComponent(texture: SKTexture(imageNamed: "enemy"), color: .lightGray)
        addComponent(visalComponent)
        
        let attachComponent = AttackComponent(weapon: Weapon(type: .I))
        addComponent(attachComponent)
        
        self.position = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func attach() {
        
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
