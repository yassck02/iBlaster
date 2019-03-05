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
    var enemies = [Asteroid]()
    
    var grid: SKSpriteNode!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Init
    
    override init() {
        super.init(size: UIScreen.main.bounds.size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(hue: 0.5, saturation: 0.6, brightness: 0.1, alpha: 1.0)
        
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
        
        // Add the stars
        if let stars = SKEmitterNode(fileNamed: "Stars.sks") {
            stars.position = CGPoint.zero
            stars.zPosition = 0.1
            stars.particlePositionRange = CGVector(dx: self.frame.width, dy: self.frame.height)
            stars.advanceSimulationTime(10)
            self.addChild(stars)
        } else {
            Log.error("could not load star particls file")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func cleanUp() {
        for child in children {
            if let asteroid = child as? Asteroid {
                for (i, e) in enemies.enumerated() {
                    if (asteroid == e) { enemies.remove(at: i) }
                }
                asteroid.removeFromParent()
            } else if let projectile = child as? Projectile {
                projectile.removeFromParent()
            }
        }
        ship.health = 100.0
    }

    func spawnasteroid() {
        let asteroid = Asteroid(level: 1)
        asteroid.target = ship
        
        let x = (CGFloat(drand48()) * self.frame.width) - (self.frame.width / 2)
        let y = (CGFloat(drand48()) * self.frame.height) - (self.frame.height / 2)
        
        let tmp = Int.random(in: 0...3)
        switch(tmp){
        case 0:
            asteroid.position = CGPoint(x: x, y: self.frame.height/2 + 25)
            break
        case 1:
            asteroid.position = CGPoint(x: x, y: -self.frame.height/2 - 25)
            break
        case 2:
            asteroid.position = CGPoint(x: self.frame.width/2 + 25, y: y)
            break
        case 3:
            asteroid.position = CGPoint(x: -self.frame.width/2 - 25, y: y)
            break
        default:
            Log.error("Could not spawn asteroid in valid location")
        }
        
        Log.info(asteroid.position)
        enemies.append(asteroid)
        self.addChild(asteroid)
    }
    
    func remove(_ node: SKNode) {
        if let asteroid = node as? Asteroid {
            for (i, e) in enemies.enumerated() {
                if (asteroid == e) {
                    enemies.remove(at: i)
                }
            }
        }
        node.removeFromParent()
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // Mark: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isPaused == false) {
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
        if (isPaused == false) {
            if(touches.count > 1) {
                if let point = touches.first?.location(in: self) {
                    ship.rotate(to: point)
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Update
    
    var elapsedTime = 0.0
    var previousTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        
            // spawn an asteroid
            dt = currentTime - previousTime
            elapsedTime += dt
            if(elapsedTime >= 2) {
                spawnasteroid()
                elapsedTime = 0.0
            }
            previousTime = currentTime
            
            // update the enemies on the screen
            for asteroid in enemies {
                asteroid.update(deltaTime: dt)
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
        
        if(firstBody.categoryBitMask & PhysicsCategory.asteroid != 0) {
            if let asteroid = firstBody.node as? Asteroid {
                if (secondBody.categoryBitMask & PhysicsCategory.ship != 0) {
                    ship.health -= asteroid.damage
                    self.remove(asteroid)
                } else if (secondBody.categoryBitMask & PhysicsCategory.projectile != 0) {
                    let projectile = secondBody.node as! Projectile
                    asteroid.health -= projectile.damage
                    if(asteroid.health <= 0) {
                        manager.score += asteroid.damage
                        self.remove(asteroid)
                    }
                    projectile.removeFromParent()
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
