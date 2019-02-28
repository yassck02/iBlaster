//
//  VisualComponent.swift
//  EyeFighter
//
//  Created by Connor yass on 2/23/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import GameKit

class VisualComponent: GKComponent {
    
    var node: SKSpriteNode

    init(texture: SKTexture, color: UIColor) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        node.color = color
        super.init()
    }
    
    func addGlow(radius: Float) {
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
