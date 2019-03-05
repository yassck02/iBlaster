//
//  Asteroid.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

/* ----------------------------------------------------------------------------------------- */

class Asteroid: SKShapeNode {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    static func rotateAction(speed: CGFloat) -> SKAction {
        return SKAction.repeatForever(
            SKAction.rotate(byAngle: 2.0 * CGFloat.pi, duration: 8.0)
        )
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var level: Int!
    
    var damage: CGFloat! {
        get {
            return (CGFloat(level) * 25.0 + 50.0)
        }
    }
    
    var maxHealth: CGFloat! {
        get {
            return (CGFloat(level) * 50.0 + 100.0)
        }
    }
    
    var target: SKNode?
    
    var health: CGFloat! {
        didSet {
            if(health <= 0) {
                if let scene = self.scene as? GameScene {
                    scene.remove(self)
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    init(level: Int) {
        super.init()
        
        self.path = CGPath.randomCircle(points: 6, radius: 25.0)
        self.strokeColor = AppUtility.color
        self.fillColor = AppUtility.color.withAlphaComponent(0.5)
        self.lineWidth = 3.0
        
        self.zPosition = CGFloat(zOrder.asteroid)
        
        self.level = level
        self.health = CGFloat(level) * 100.0

        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ship & PhysicsCategory.projectile
        self.physicsBody?.collisionBitMask = 0
        
        self.run(Asteroid.rotateAction(speed: 1.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func update(deltaTime: TimeInterval) {
        if(target != nil) {
            let dx = self.position.x - target!.position.x
            let dy = self.position.y - target!.position.y
            let angle = atan2(dy, dx)
            self.position.x -= cos(angle) * speed
            self.position.y -= sin(angle) * speed
        } else {
            Log.info("target is nill")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
