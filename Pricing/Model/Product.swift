import Foundation

class Product: Codable {
    var id: Int
    var name: String
    var description: String
    var prices: [Price]
    
    static var products: [Product] = []
    
    enum ProductKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case prices = "prices"
    }
    
    init(id: Int, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
        self.prices = []
        
        Product.products.append(self)
    }
    
    required convenience init(from: Decoder) throws {
        let container = try from.container(keyedBy: ProductKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        
        
        self.init(id: id, name: name, description: description)
    }
    
    func bind(price: Price) {
        prices.append(price)
    }
    
    static func findBy(id: Int) -> Product? {
        return Product.products.first { product in product.id == id }
    }
}
