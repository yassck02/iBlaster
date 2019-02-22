//
//  Logger.swift
//  EyeFighter
//
//  Created by Connor yass on 2/20/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import Foundation

/* ----------------------------------------------------------------------------------------- */

class Log {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Settings
    
    static var enabled = true
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    class func error( _ object: Any,
                      filename: String = #file,
                      funcname: String = #function) {
        
        if enabled {
            print("[EF] *ERROR* [\(sourceFileName(filePath: filename))]: \(funcname) - \(object)")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    class func info( _ object: Any,
                     filename: String = #file,
                     funcname: String = #function) {
        
        if enabled {
            print("[EF][\(sourceFileName(filePath: filename))]: \(funcname) - \(object)")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    class func verbose( _ object: Any,
                        filename: String = #file,
                        funcname: String = #function) {
        
        if enabled {
            print("[EF][\(sourceFileName(filePath: filename))]: \(funcname) - \(object)")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
