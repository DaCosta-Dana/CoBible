import Foundation
import SwiftData

@Model
final class Favorite {
    var id: UUID
    var name: String
    var timestamp: Date

    init(name: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.timestamp = timestamp
    }
}