//
//  Extensions.swift
//  EyeFighter
//
//  Created by Connor yass on 2/23/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import SceneKit
import SpriteKit

/* ----------------------------------------------------------------------------------------- */

extension SCNVector3 {
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
}

/* ----------------------------------------------------------------------------------------- */

func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
}

/* ----------------------------------------------------------------------------------------- */

extension Collection where Element == CGFloat, Index == Int {

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

/* ----------------------------------------------------------------------------------------- */

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

/* ----------------------------------------------------------------------------------------- */

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) +
                    pow(self.y - point.y, 2))
    }
}

/* ----------------------------------------------------------------------------------------- */

extension CGPath {
    
    class func randomCircle(points: Int, radius: CGFloat) -> CGPath {
        
        let star = CGMutablePath()
        
        var x = radius
        var y = CGFloat(0.0)
        star.move(to: CGPoint(x: x, y: y))
    
        let da = (CGFloat.pi * 2.0) / CGFloat(points)
        for angle in stride(from: da, to: CGFloat.pi * 1.9, by: da) {
            x = cos(angle) * radius * CGFloat.random(in: ClosedRange(uncheckedBounds: (lower: 0.25, upper: 1.75)))
            y = sin(angle) * radius * CGFloat.random(in: ClosedRange(uncheckedBounds: (lower: 0.25, upper: 1.75)))
            star.addLine(to: CGPoint(x: x, y: y))
        }
        star.closeSubpath()
        
        return star
    }
}

/* ----------------------------------------------------------------------------------------- */
