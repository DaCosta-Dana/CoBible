import RealmSwift

class Shortcut: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var no: Int
    @Persisted var whatItDoes: String
    @Persisted var howToDoIt: String
    @Persisted var explanation: String
}
