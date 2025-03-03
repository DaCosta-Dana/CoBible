//
//  Item.swift
//  CoBible
//
//  Created by Erwan Weinmann on 03/03/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
