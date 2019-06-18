import Foundation

class Store: Decodable {
    var id: Int
    var name: String
    var region: Region
    var prices: [Price]
    
    static var stores: [Store] = []
    
    enum StoreKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case region = "region"
        case prices = "prices"
    }
    
    init(id: Int, name: String, region: Region) {
        self.id = id
        self.name = name
        self.region = region
        self.prices = []
        
        Store.stores.append(self)
    }
    
    required convenience init(from: Decoder) throws {
        let container = try from.container(keyedBy: StoreKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let region = try container.decode(Int.self, forKey: .region)
        
        
        self.init(id: id, name: name, region: Region(rawValue: region)!)
    }
    
    func bind(price: Price) {
        prices.append(price)
    }
}

enum Region: Int, Decodable, CaseIterable {
    case North = 1
    case South = 2
    case West = 3
    case East = 4
    
    var description: String {
        switch self {
        case .North:
            return "North"
        case .South:
            return "South"
        case .West:
            return "West"
        case .East:
            return "East"
        }
    }
}
