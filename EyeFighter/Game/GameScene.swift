//
//  Scene.swift
//  EyeFighter
//
//  Created by Connor yass on 2/19/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit
import GameplayKit

/* ----------------------------------------------------------------------------------------- */

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    var ship: Ship!
    var enemies = [Enemy]()
    
    var grid: SKSpriteNode!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    override init() {
        super.init(size: UIScreen.main.bounds.size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        Log.function()
        
        // Add the ship to the scene
        self.ship = Ship()
        ship.position = CGPoint.zero
        self.add(entity: ship)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func spawnEnemy(at position: CGPoint) {
        let enemy = Enemy(type: .one, level: 0)
        enemy.position = position
        enemies.append(enemy)
        self.add(entity: enemy)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func add(entity: GKEntity) {
        if let spriteNode = entity.component(ofType: VisualComponent.self)?.node {
            self.addChild(spriteNode)
        }
    }
    
    func remove(entity: GKEntity) {
        if let spriteNode = entity.component(ofType: VisualComponent.self)?.node {
            spriteNode.removeFromParent()
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count > 1) {
            ship.shoot()
        } else {
            if let point = touches.first?.location(in: self) {
                ship.rotate(to: point)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            ship.rotate(to: point)
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func cleanUp() {
        for enemy in enemies {
            remove(entity: enemy)
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
