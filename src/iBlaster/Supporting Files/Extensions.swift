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

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) +
                    pow(self.y - point.y, 2))
    }
}

func + (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}

func / (l: CGPoint, r: CGFloat) -> CGPoint {
    return CGPoint(x: l.x / r, y: l.y / r)
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

extension CGRect {
    
    func ranomPoint() -> CGPoint {
    
        let x = CGFloat(drand48()) * self.width
        let y = CGFloat(drand48()) * self.height
        
        let tmp = Int.random(in: 0...3)
        switch(tmp){
        case 0:
            return CGPoint(x: x, y: self.minY)
        case 1:
            return CGPoint(x: x, y: self.maxY)
        case 2:
            return CGPoint(x: self.minX, y: y)
        case 3:
            return CGPoint(x: self.maxX, y: y)
        default:
            return self.origin
        }
    }
}

/* ----------------------------------------------------------------------------------------- */

extension SKAttributeValue {
    
    public convenience init(size: CGSize) {
        let size = vector_float2(Float(size.width), Float(size.height))
        self.init(vectorFloat2: size)
    }
}

/* ----------------------------------------------------------------------------------------- */

extension SKShader {
    
    convenience init(fromFile filename: String, uniforms: [SKUniform]? = nil, attributes: [SKAttribute]? = nil) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "fsh") else {
            fatalError("Unable to find shader \(filename).fsh in bundle")
        }
        
        guard let source = try? String(contentsOfFile: path) else {
            fatalError("Unable to load shader \(filename).fsh")
        }
        
        if let uniforms = uniforms {
            self.init(source: source as String, uniforms: uniforms)
        } else {
            self.init(source: source as String)
        }
        
        if let attributes = attributes {
            self.attributes = attributes
        }
    }
}

/* ----------------------------------------------------------------------------------------- */

extension SKUniform {
    
    public convenience init(name: String, color: SKColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let colors = vector_float4([Float(r), Float(g), Float(b), Float(a)])
        
        self.init(name: name, vectorFloat4: colors)
    }
    
    public convenience init(name: String, size: CGSize) {
        let size = vector_float2(Float(size.width), Float(size.height))
        self.init(name: name, vectorFloat2: size)
    }
    
    public convenience init(name: String, point: CGPoint) {
        let point = vector_float2(Float(point.x), Float(point.y))
        self.init(name: name, vectorFloat2: point)
    }
}

/* ----------------------------------------------------------------------------------------- */

extension SKShapeNode {
    
    func addShadow(color: UIColor, alpha: CGFloat, radius: CGFloat) {
        
        var shadow: SKShapeNode?
        
        if let path = self.path {
            shadow = SKShapeNode(path: path)
        }
        if let texture = self.fillTexture {
            shadow?.fillTexture = texture
        }
        
        if shadow != nil {
            shadow!.lineWidth = self.lineWidth
            shadow!.lineCap = self.lineCap
            shadow!.lineJoin = self.lineJoin
            
            shadow!.blendMode = .alpha
            shadow!.strokeColor = color
            shadow!.alpha = alpha
            shadow!.zPosition = -1
            
            let blur = SKEffectNode()
            blur.addChild(shadow!)
            blur.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
            blur.shouldRasterize = true
            
            self.addChild(blur)
        }
    }
}


extension SKSpriteNode {
    
    func addShadow(color: UIColor, alpha: CGFloat, radius: CGFloat) {
        
        var shadow: SKShapeNode?
        
        if let texture = self.texture {
            shadow?.fillTexture = texture
        }
        
        if shadow != nil {
            
            shadow!.blendMode = .alpha
            shadow!.strokeColor = color
            shadow!.alpha = alpha
            shadow!.zPosition = -1
            
            let blur = SKEffectNode()
            blur.addChild(shadow!)
            blur.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
            blur.shouldRasterize = true
            
            self.addChild(blur)
        }
    }
}

/* ----------------------------------------------------------------------------------------- */

extension SKLabelNode {
    func addShadow(color: UIColor, alpha: CGFloat, radius: CGFloat) {
        
        let shadow = SKLabelNode(fontNamed: self.fontName)
        shadow.text = self.text
        shadow.fontSize = self.fontSize
        shadow.verticalAlignmentMode = self.verticalAlignmentMode
        shadow.horizontalAlignmentMode = self.horizontalAlignmentMode
        
        shadow.blendMode = .alpha
        shadow.colorBlendFactor = 1
        shadow.color = color
        shadow.alpha = alpha
        shadow.zPosition = 0
        
        let blur = SKEffectNode()
        blur.addChild(shadow)
        blur.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
        blur.shouldRasterize = true
        
        self.addChild(blur)
    }
}

/* ----------------------------------------------------------------------------------------- */
