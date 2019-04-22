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
        
        let bkgnd = SKShapeNode(rect: CGRect(origin: CGPoint(x: -300/2, y: -600/2), size: CGSize(width: 300, height: 600)));
        bkgnd.fillShader = AppUtility.fillShader
        self.addChild(bkgnd)

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
    }

    func spawnasteroid() {
        let asteroid = Asteroid(level: 1)
        asteroid.target = ship
        asteroid.position = self.frame.insetBy(dx: -10, dy: -10).ranomPoint()
        
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
    
    var touchMoved = false
    
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
            touchMoved = true
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
            if(elapsedTime >= 1.5) {
                spawnasteroid()
                elapsedTime = 0.0
            }
        
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
                    manager.lives -= 1
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
