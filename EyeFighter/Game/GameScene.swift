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
// - Spawns and manages the objects in the scene
// - Defines the game update loop
// - Handles touch based user interactions with the scene

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    var manager: GameManager!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: -
    
    var ship: Ship!
    var enemies = [Enemy]()
    
    var grid: SKSpriteNode!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Init
    
    override init() {
        super.init(size: UIScreen.main.bounds.size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        Log.function()
        
        // Add the ship to the scene
        self.ship = Ship()
        ship.position = CGPoint.zero
        self.addChild(ship)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func cleanUp() {
        
        for child in children {
            if let _ = child as? Enemy {
                child.removeFromParent()
            } else if let _ = child as? Projectile {
                child.removeFromParent()
            }
        }
        
        enemies.removeAll()
        
        ship.health = 100.0
    }

    func spawnEnemy() {
        let enemy = Enemy(type: .A, level: 0)
        enemy.target = ship
        
        let x = (CGFloat(drand48()) * self.frame.width) - (self.frame.width / 2)
        let y = (CGFloat(drand48()) * self.frame.height) - (self.frame.height / 2)
        
        let tmp = Int.random(in: 0...3)
        switch(tmp){
        case 0:
            enemy.position = CGPoint(x: x, y: self.frame.height/2 + 25)
            break
        case 1:
            enemy.position = CGPoint(x: x, y: -self.frame.height/2 - 25)
            break
        case 2:
            enemy.position = CGPoint(x: self.frame.width/2 + 25, y: y)
            break
        case 3:
            enemy.position = CGPoint(x: -self.frame.width/2 - 25, y: y)
            break
        default:
            Log.error("Could not spawn enemy in valid location")
        }
        
        Log.info(enemy.position)
        enemies.append(enemy)
        self.addChild(enemy)
    }
    
    func remove(_ enemy: Enemy) {
        for (i, e) in enemies.enumerated() {
            if (enemy == e) {
                enemies.remove(at: i)
            }
        }
        enemy.removeFromParent()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // Mark: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused != true {
            if(touches.count > 1) {
                if let point = touches.first?.location(in: self) {
                    ship.rotate(to: point)
                }
            } else {
                ship.fire()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused != true {
            if(touches.count > 1) {
                if let point = touches.first?.location(in: self) {
                    ship.rotate(to: point)
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Update
    
    var previousTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    var elapsedTime = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        
        // spawn an enemy
        dt = currentTime - previousTime
        elapsedTime += dt
        if(elapsedTime >= 2) {
            spawnEnemy()
            elapsedTime = 0.0
        }
        previousTime = currentTime
        
        // update the enemies on the screen
        for enemy in enemies {
            enemy.update(deltaTime: dt)
        }
        ship.update(deltaTime: dt)
        previousTime = currentTime
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Physics delegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.categoryBitMask & PhysicsCategory.enemy != 0) {
            if let enemy = firstBody.node as? Enemy {
                if (secondBody.categoryBitMask & PhysicsCategory.ship != 0) {
                    ship.health -= enemy.damage
                    self.remove(enemy)
                } else if (secondBody.categoryBitMask & PhysicsCategory.projectile != 0) {
                    let projectile = secondBody.node as! Projectile
                    enemy.health -= projectile.damage
                    if(enemy.health <= 0) {
                        manager.score += enemy.health
                        self.remove(enemy)
                    }
                    projectile.removeFromParent()
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
