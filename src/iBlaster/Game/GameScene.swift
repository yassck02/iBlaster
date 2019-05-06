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
    var asteroids = [Asteroid]()
    
    var grid: SKSpriteNode!
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Init
    
    override init() {
        super.init(size: UIScreen.main.bounds.size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor(hue: 0.5, saturation: 0.6, brightness: 0.1, alpha: 1.0)
        
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        
        self.ship = Ship()
        ship.position = CGPoint.zero
        self.addChild(ship)
        
        if let stars = SKEmitterNode(fileNamed: "stars.sks") {
            self.addChild(stars)
        }
        
        let bkgnd = SKSpriteNode(imageNamed: "bkgnd_green")
        bkgnd.zPosition = -1
        bkgnd.size = self.size
        self.addChild(bkgnd)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func cleanUp() {
        for child in children {
            if let asteroid = child as? Asteroid {
                for (i, e) in asteroids.enumerated() {
                    if (asteroid == e) { asteroids.remove(at: i) }
                }
                asteroid.removeFromParent()
            } else if let projectile = child as? Projectile {
                projectile.removeFromParent()
            }
        }
    }

    func spawnasteroid() {
        let asteroid = Asteroid(level: 1)
        asteroid.target = ship
        asteroid.position = self.frame.insetBy(dx: -30, dy: -30).ranomPoint()
        
        //Log.info(asteroid.position)
        
        asteroids.append(asteroid)
        self.addChild(asteroid)
    }
    
    func remove(_ node: SKNode) {
        if let asteroid = node as? Asteroid {
            for (i, a) in asteroids.enumerated() {
                if (asteroid == a) {
                    asteroids.remove(at: i)
                    asteroid.run(Asteroid.destruct())
                }
            }
        } else {
            node.removeFromParent()
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // Mark: - Touches
    
    var touchMoved = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (shouldUpdate == true) {
            if(touches.count == 1) {
                ship.fire()
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Update
    
    var elapsedTime = 0.0
    var previousTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    var spawnRate: Double = 1.5    // Spawn 1 asteroid every 'spawnRate' seconds
    
    var shouldUpdate: Bool = false {
        didSet {
            Log.function()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (shouldUpdate) {
            
            // spawn an asteroid
            dt = currentTime - previousTime
            elapsedTime += dt
            if(elapsedTime >= spawnRate) {
                spawnasteroid()
                elapsedTime = 0.0
                
                spawnRate -= 0.01
                if (spawnRate <= 0.01) {
                    spawnRate = 0.01
                }
            }
        
            // update the enemies on the screen
            for asteroid in asteroids {
                asteroid.update(deltaTime: dt)
            }
            
            // Update the ship
            ship.update(deltaTime: dt)
            ship.rotate(to: manager.viewController.point)
        
            previousTime = currentTime
        }
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
                    manager.lives -= 1
                    self.remove(asteroid)
                } else if (secondBody.categoryBitMask & PhysicsCategory.projectile != 0) {
                    if let projectile = secondBody.node as? Projectile {
                        asteroid.health -= projectile.damage
                        if(asteroid.health <= 0) {
                            manager.score += 1
                            self.remove(asteroid)
                        }
                        projectile.removeFromParent()
                    }
                }
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

}

/* ----------------------------------------------------------------------------------------- */
