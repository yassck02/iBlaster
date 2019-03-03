//
//  AppUtility.swift
//  EyeFighter
//
//  Created by Connor yass on 2/19/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import Foundation
import UIKit

/* ----------------------------------------------------------------------------------------- */

struct PhysicsCategory {
    static let enemy      : UInt32 = 0x1 << 0
    static let ship       : UInt32 = 0x1 << 1
    static let projectile : UInt32 = 0x1 << 2
}

/* ----------------------------------------------------------------------------------------- */

struct zOrder {
    static let enemy : CGFloat = 0.0
    static let ship  : CGFloat = 1.0
    static let menu  : CGFloat = 2.0
}

/* ----------------------------------------------------------------------------------------- */

class AppUtility {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    static private var _hue: CGFloat?
    static var hue: CGFloat {
        get {
            if(_hue == nil) {
                _hue = CGFloat(UserDefaults.standard.float(forKey: "hue"))
            }
            return _hue!
        }
        set {
            _hue = newValue
            UserDefaults.standard.set(_hue, forKey: "hue")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    static var feedbackGenerator: UIImpactFeedbackGenerator?
    
    static func vibrate() {
        DispatchQueue.main.async {
            if feedbackGenerator == nil {
                feedbackGenerator = UIImpactFeedbackGenerator()
            }
            feedbackGenerator!.prepare()
            feedbackGenerator!.impactOccurred()
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */

