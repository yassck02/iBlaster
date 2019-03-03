//
//  Projectile.swift
//  EyeFighter
//
//  Created by Connor yass on 2/23/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

/* ----------------------------------------------------------------------------------------- */

class Projectile: SKSpriteNode {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var damage: CGFloat!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    init(damage: CGFloat, color: SKColor) {
        super.init(texture: SKTexture(imageNamed: "projectile"), color: color, size: CGSize(width: 25.0, height: 25.0))
        self.colorBlendFactor = 1.0
        
        self.damage = damage
        self.position = .zero
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
