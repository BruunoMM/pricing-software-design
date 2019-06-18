class Person: Decodable {
    var id: Int
    var name: String
    var occupation: Employment
    var pricings: [Pricing] = []
    
    static var managers: [Person] = []
    static var employees: [Person] = []
    
    enum PersonKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case occupation = "occupation"
        case pricings = "pricings"
    }
    
    init(id: Int, name: String, occupation: Employment) {
        self.id = Person.managers.count + Person.employees.count + 1
        self.name = name
        self.occupation = occupation
        addToArrays(person: self)

    }
    
    required convenience init(from: Decoder) throws {
        let container = try from.container(keyedBy: PersonKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let occupation = try container.decode(Int.self, forKey: .occupation)
        
        
        self.init(id: id, name: name, occupation: Employment(rawValue: occupation)!)
    }
    
    func addToArrays(person: Person) {
        switch person.occupation {
        case .Manager:
            Person.managers.append(self)
        default:
            Person.employees.append(self)
        }
    }
    
    func assign(pricing: Pricing) {
        pricings.append(pricing)
    }
    
    static func findBy(id: Int) -> Person? {
        let allPeople = Person.employees + Person.managers
        
        return allPeople.first { person in person.id == id}
    }
}

enum Employment: Int, Decodable {
    case Employee = 1
    case Manager = 2
}
