//
//  HealthBar.swift
//  EyeFighter
//
//  Created by Connor yass on 3/4/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SpriteKit

/* ----------------------------------------------------------------------------------------- */

class HealthBar: SKShapeNode {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    var background: SKShapeNode!
    var bar: SKShapeNode!
    
    var color: SKColor = .white {
        didSet {
            background.fillColor = color.withAlphaComponent(0.25)
            background.strokeColor = color
            bar.fillColor = color
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    init(size: CGSize, color: SKColor) {
        super.init()
        
        background = SKShapeNode(rect: CGRect(origin: CGPoint(x: size.width/2, y: size.height/2), size: size))
        
        bar = SKShapeNode(rect: CGRect(origin: CGPoint(x: size.width/2, y: size.height/2), size: size))
        bar.zPosition = 1.0
        background.addChild(bar)
        
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
