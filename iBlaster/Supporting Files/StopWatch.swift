//
//  StopWatch.swift
//  EyeFighter
//
//  Created by Connor yass on 3/1/19.
//  Copyright © 2019 HSY Technologies. All rights reserved.
//

import Foundation

/* ----------------------------------------------------------------------------------------- */

class StopWatch {
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    private var isRunning: Bool = false
    
    private var _startTime: Double = 0
    var startTime: Double {
        get {
            return _startTime
        }
    }
    
    private var _endTime: Double = 0
    var endTime: Double {
        get {
            return _endTime
        }
    }
    
    var elapsed: Double {
        get {
            if(isRunning) {
                return CFAbsoluteTimeGetCurrent() - _startTime
            } else {
                return _endTime - _startTime
            }
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
    func start() {
        if (isRunning) {
            Log.error("timer is already running")
        } else {
            _startTime = CFAbsoluteTimeGetCurrent()
            self.isRunning = true
        }
    }
    
    func stop() {
        if (isRunning == false) {
            Log.error("start() must be called first")
        } else {
            _endTime = CFAbsoluteTimeGetCurrent()
            self.isRunning = false
        }
    }
    
    func reset() {
        if (isRunning) {
            Log.error("stop() must be called first")
        } else {
            _startTime = 0
        }
    }
    
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    
}

/* ----------------------------------------------------------------------------------------- */
