import Foundation

class Pricing: Codable {
    var id: Int?
    var manager: Person?
    var employee: Person?
    var price: Price?
    var attributionDate: Date?
    private (set) var status: Status
    
    static var pricings: [Pricing] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case manager = "managerId"
        case employee = "employeeId"
        case price = "priceId"
        case attributionDate
        case status
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(manager?.id, forKey: .manager)
        try container.encode(employee?.id, forKey: .employee)
        try container.encode(price?.id, forKey: .price)
        try container.encode(attributionDate, forKey: .attributionDate)
        try container.encode(status, forKey: .status)
        
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        
        let managerId = try values.decode(Int.self, forKey: .manager)
        manager = Person.findBy(id: managerId)
        
        let employeeId = try values.decode(Int.self, forKey: .employee)
        employee = Person.findBy(id: employeeId)
        
        let priceId = try values.decode(Int.self, forKey: .price)
        price = Price.findBy(id: priceId)
        
        attributionDate = try values.decode(Date.self, forKey: .attributionDate)
        status = try values.decode(Status.self, forKey: .status)
        
        Pricing.pricings.append(self)
    }
    
    init(price: Price) {
        self.id = Pricing.pricings.count + 1
        self.price = price
        self.attributionDate = Date()
        self.status = .pending
    }
    
    var product: Product? {
        return price?.product
    }
    
    func bind(manager: Person) {
        self.manager = manager
        manager.assign(pricing: self)
    }
    
    func bind(employee: Person) {
        self.employee = employee
        employee.assign(pricing: self)
    }
    
    func approve() {
        status = .approved
    }
    
    func reject() {
        status = .rejected
    }
}

public enum Status: Int, Codable {
    case pending
    case approved
    case rejected
}
