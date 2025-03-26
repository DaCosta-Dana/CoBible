//
//  Item.swift
//  CoBible
//
//  Created by Erwan Weinmann on 03/03/2025.
//

import Foundation
import SwiftData
import MongoSwift

@Model
final class Item {
    var timestamp: Date
    var id: BSONObjectID? // MongoDB ObjectID

    init(timestamp: Date, id: BSONObjectID? = nil) {
        self.timestamp = timestamp
        self.id = id
    }
}
