//
//  Extensions.swift
//  EyeFighter
//
//  Created by Connor yass on 2/23/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SceneKit
import SpriteKit

extension SCNVector3 {
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
}

func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
}

extension Collection where Element == CGFloat, Index == Int {
    /// Return the mean of a list of CGFloat. Used with `recentVirtualObjectDistances`.
    var average: CGFloat? {
        guard !isEmpty else {
            return nil
        }
        
        let sum = reduce(CGFloat(0)) { current, next -> CGFloat in
            return current + next
        }
        
        return sum / CGFloat(count)
    }
}

extension SKSpriteNode {
    
    public func tile(image: UIImage, size: CGSize) {
        let textureSize = CGRect(origin: .zero, size: image.size)
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            context.draw(image.cgImage!, in: textureSize, byTiling: true)
            if let tiledBackground = UIGraphicsGetImageFromCurrentImageContext() {
                self.texture = SKTexture(image: tiledBackground)
                self.size = size
            }
            UIGraphicsEndImageContext()
        }
    }
}
