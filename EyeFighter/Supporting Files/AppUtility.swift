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
    
    static var feedbackGenerator: UINotificationFeedbackGenerator?
    
    static func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            if feedbackGenerator == nil {
                feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator!.prepare()
            }
            feedbackGenerator!.notificationOccurred(type)
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */

