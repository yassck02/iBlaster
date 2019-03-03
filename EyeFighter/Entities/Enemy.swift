//
//  Enemy.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

/* ----------------------------------------------------------------------------------------- */

enum EnemyType: Int {
    case A = 0
    case B = 1
    case C = 2
    
    static let allValues = [A, B, C]
    
    func health(for level: Int) -> CGFloat {
        return CGFloat((rawValue * 100) + 100)
    }
    
    func speed(for level: Int) -> CGFloat {
        return CGFloat((rawValue * 1) + 1)
    }
}

/* ----------------------------------------------------------------------------------------- */

class Enemy: SKSpriteNode {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    static let maxLevel = 6
    static let maxSpeed = 10
    
    static func rotateAction(speed: CGFloat) -> SKAction {
        return SKAction.repeatForever(
            SKAction.rotate(byAngle: 2.0 * CGFloat.pi, duration: 8.0)
        )
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var type: EnemyType!
    
    var level: Int!
    
    var damage: CGFloat!
    
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

    init(type: EnemyType, level: Int) {
        super.init(texture: SKTexture(imageNamed: "enemy"), color: SKColor.red, size: CGSize(width: 50.0, height: 50.0))
        self.zPosition = CGFloat(zOrder.enemy)
        self.xScale = 1.0 + CGFloat(3 * level / Enemy.maxLevel)
        self.xScale = 1.0 + CGFloat(3 * level / Enemy.maxLevel)
        self.colorBlendFactor = 1.0
        self.type = type
        self.level = level
        
        self.health = type.health(for: level)
        self.speed = type.speed(for: level)
        self.damage = 10.0
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width/2 - 5)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ship & PhysicsCategory.projectile
        self.physicsBody?.collisionBitMask = 0
        
        self.run(Enemy.rotateAction(speed: 1.0))
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
