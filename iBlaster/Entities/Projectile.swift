//
//  Projectile.swift
//  EyeFighter
//
//  Created by Connor yass on 2/23/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

/* ----------------------------------------------------------------------------------------- */

class Projectile: SKShapeNode {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var damage: CGFloat!
    
    var size: CGFloat = 10.0
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    init(damage: CGFloat, color: SKColor) {

        super.init()
        self.path = CGPath(ellipseIn: CGRect(x: -size/2.0, y: -size/2.0, width: size, height: size), transform: nil)
        self.fillColor = SKColor.white
        self.lineWidth = 0.0
        
        self.zPosition = CGFloat(zOrder.projectile)
        self.position = .zero

        self.damage = damage
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: (size/2)-3)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
