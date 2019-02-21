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

class GameScene: SKScene, GameMenuDelegate {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    var ship: SKSpriteNode!
    var enemies = [SKSpriteNode]()
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    override func didMove(to view: SKView) {
        
        // Add the ship to the scene
        ship = SKSpriteNode(color: .white, size: CGSize(width: 50.0, height: 50.0))
        ship.position.y = -self.frame.height/2 + 50
        self.addChild(ship)
        
        // Setup the environment
        self.backgroundColor = UIColor(hue: AppUtility.hue, saturation: 0.75, brightness: 0.75, alpha: 1.0)
    
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    func spawnEnemy() {
        let enemy = SKSpriteNode(color: .black, size: CGSize(width: 25.0, height: 25.0))
        enemy.position = CGPoint.zero
        enemies.append(enemy)
        self.addChild(enemy)
        enemy.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.scale(to: CGSize(width: 25, height: 25), duration: 0.5),
                SKAction.scale(to: CGSize(width: 20, height: 20), duration: 0.5)
        ])))
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            ship.position.x = touch.location(in: self).x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            ship.position.x = touch.location(in: self).x
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Menu Buttons
    
    func onPressed(button: SKNode, ID: String) {
        switch(ID) {
        case "play":
            break
        case "pause":
            break
        case "quit":
            break
        case "restart":
            break
        default:
            break
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


}

/* ----------------------------------------------------------------------------------------- */
