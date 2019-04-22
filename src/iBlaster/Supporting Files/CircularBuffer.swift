//
//  CircularBuffer.swift
//  iBlaster
//
//  Created by Connor yass on 4/12/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import UIKit

/* ----------------------------------------------------------------------------------------- */

class CircularBuffer {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    private var elements: [CGPoint]!
    
    private var i: Int = 0 {
        didSet {
            i = i % elements.count
        }
    }
    
    var size: Int {
        return elements.count
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    init(size: Int, initialElement: CGPoint) {
        elements = Array.init(repeating: initialElement, count: size)
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func push(element: CGPoint) {
        elements[i] = element
        i += 1
        recalculate = true
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    private var recalculate = true
    
    private var _average: CGPoint?
    var average: CGPoint {
        get {
            if (recalculate || _average == nil) {
                recalculate = false
                
                var sum: CGPoint = CGPoint.zero
                
                for element in elements {
                    sum.x += element.x
                    sum.y += element.y
                }
                
                _average = sum / CGFloat(elements.count)
            }
            return _average!
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
