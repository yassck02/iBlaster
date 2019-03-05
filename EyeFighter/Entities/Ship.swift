//
//  Ship.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

/* ----------------------------------------------------------------------------------------- */

class Ship: SKSpriteNode {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    static let maxHealth = 100.0
    
    var health: CGFloat = 100.0 {
        didSet {
            Log.info("Set to: \(health)")
            if let scene = self.scene as? GameScene {
                if(health <= 0) {
                    scene.manager.end()
                } else {
                    
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    init() {
        super.init(texture: SKTexture(imageNamed: "ship"), color: .white, size: CGSize(width: 65.0, height: 65.0))
        self.colorBlendFactor = 0.5
        self.zPosition = CGFloat(zOrder.ship)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2 - 15)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.ship
        self.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func fire() {
        Log.function()
        
        let projectile = Projectile(damage: 25.0, color: .green)
        
        let x = -cos(self.zRotation) * 400
        let y = -sin(self.zRotation) * 400
        
        if let scene = self.scene as? GameScene {
            scene.addChild(projectile)
            projectile.run(
                SKAction.sequence([
                    SKAction.move(by: CGVector(dx: x, dy: y), duration: 1.0),
                    SKAction.removeFromParent()
                ])
            )
        }
    }
    
    func rotate(to point: CGPoint) {
        self.zRotation = atan2(self.position.y - point.y, position.x - point.x)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func update(deltaTime: TimeInterval) {
        
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    
}

/* ----------------------------------------------------------------------------------------- */
