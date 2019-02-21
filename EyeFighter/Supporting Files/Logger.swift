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
    // MARK: - Date, time
    
    static var enabled = false
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Enums
    
    enum LogEvent: String {
        case error      = "[error]"
        case info       = "[info]"
        case debug      = "[debug]"
        case verbose    = "[verbose]"
        case warning    = "[warning]"
        case fatal      = "[fatal]"
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    // MARK: - Helper functions
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    class func error( _ object: Any,
                      filename: String = #file,
                      funcname: String = #function) {
        
        if enabled {
            print("[EF]\(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]: \(funcname) -> \(object)")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    class func info( _ object: Any,
                     filename: String = #file,
                     funcname: String = #function) {
        
        if enabled {
            print("[EF]\(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]: \(funcname) -> \(object)")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    class func debug( _ object: Any,
                      filename: String = #file,
                      funcname: String = #function) {
        
        if enabled {
            print("[EF]\(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]: \(funcname) -> \(object)")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    class func verbose( _ object: Any,
                        filename: String = #file,
                        funcname: String = #function) {
        
        if enabled {
            print("[EF]\(LogEvent.verbose.rawValue)[\(sourceFileName(filePath: filename))]: \(funcname) -> \(object)")
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
