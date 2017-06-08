//
//  Queue.swift
//  Quran
//
//  Created by Mohamed Afifi on 4/30/16.
//
//  Quran for iOS is a Quran reading application for iOS.
//  Copyright (C) 2017  Quran.com
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import Foundation

public struct QSQueue {

    let queue: DispatchQueue

    public static let main = QSQueue(queue: DispatchQueue.main)
    public static let background = QSQueue(queue: DispatchQueue.global())

    public func async(_ block: @escaping () -> Void) {
        queue.async(execute: block)
    }

    public func after(_ timerInterval: TimeInterval, block: @escaping () -> Void) {
        queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(timerInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
    
}
