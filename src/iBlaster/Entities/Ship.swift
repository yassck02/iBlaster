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
    
    static let flash = SKAction.sequence([
        SKAction.repeat(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.25, duration: 0.1),
            SKAction.fadeAlpha(to: 1.00, duration: 0.1)
        ]), count: 4),
    ])
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    init() {
        super.init(texture: SKTexture(imageNamed: "ship"), color: .white, size: CGSize(width: 50.0, height: 50.0))
        self.colorBlendFactor = 0.5
        self.zPosition = CGFloat(zOrder.ship)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size.applying(CGAffineTransform.init(scaleX: 0.65, y: 0.65)))
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
        let projectile = Projectile(damage: 35.0, color: .green)
        
        let x = -cos(self.zRotation - CGFloat.pi/2.0) * 400
        let y = -sin(self.zRotation - CGFloat.pi/2.0) * 400
        
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
        self.zRotation = atan2(self.position.y - point.y, position.x - point.x) + CGFloat.pi/2
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func update(deltaTime: TimeInterval) {
        
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    
}

/* ----------------------------------------------------------------------------------------- */
