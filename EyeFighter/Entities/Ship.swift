//
//  Ship.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

/* ----------------------------------------------------------------------------------------- */

class Ship: GKEntity {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

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

    override init() {
        super.init()
        let visualComponent = VisualComponent(texture: SKTexture(imageNamed: "ship"), color: .white)
        visualComponent.addGlow(radius: 25)
        addComponent(visualComponent)
        
        let attackComponent = AttackComponent(weapon: Weapon(type: .I))
        addComponent(attackComponent)
        
        self.position = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func shoot() {
        Log.function()
        component(ofType: AttackComponent.self)!.weapon.launch()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
