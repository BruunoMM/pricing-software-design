import Foundation

class Price: Codable {
    var name: String {
        return "Regular Price"
    }
    
    static var prices: [Price] = []
    
    var id: Int
    var product: Product?
    var value: Double
    var validityStart: Date
    var validityEnd: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case product = "productId"
        case value
        case validityStart
        case validityEnd
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(product?.id, forKey: .product)
        try container.encode(value, forKey: .value)
        try container.encode(validityStart, forKey: .validityStart)
        try container.encode(validityEnd, forKey: .validityEnd)

    }
    
    static let priceTypes = [RegionalPrice.self, PromotionalPrice.self, CompetitorPrice.self, Price.self]
    
    init(id: Int, product: Product, value: Double, validityStart: Date, validityEnd: Date) {
        self.id = Price.prices.count + 1
        self.product = product
        self.value = value
        self.validityStart = validityStart
        self.validityEnd = validityEnd
        product.bind(price: self)
        
        Price.prices.append(self)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        let productId = try values.decode(Int.self, forKey: .product)
        product = Product.findBy(id: productId)
        value = try values.decode(Double.self, forKey: .value)
        validityStart = try values.decode(Date.self, forKey: .validityStart)
        validityEnd = try values.decode(Date.self, forKey: .validityEnd)
        
        Price.prices.append(self)
    }
    
    static func findBy(id: Int) -> Price? {
        return Price.prices.first { price in price.id == id}
    }
}

class RegionalPrice: Price {
    override var name: String {
        return "Regional Price"
    }
    
    var region: Region!
    
    init(id: Int, product: Product, value: Double, validityStart: Date, validityEnd: Date, region: Region) {
        super.init(id: id, product: product, value: value, validityStart: validityStart, validityEnd: validityEnd)
        self.region = region
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class PromotionalPrice: Price {
    override var name: String {
        return "Promotional Price"
    }
    
    var promotionalValue: Double!
    
    init(id: Int, product: Product, value: Double, validityStart: Date, validityEnd: Date, promoValue: Double) {
        super.init(id: id, product: product, value: value, validityStart: validityStart, validityEnd: validityEnd)
        self.promotionalValue = promoValue
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class CompetitorPrice: Price {
    override var name: String {
        return "Competitor Price"
    }
    
    var competitorStore: Store!
    
    init(id: Int, product: Product, value: Double, validityStart: Date, validityEnd: Date, competitor: Store) {
        super.init(id: id, product: product, value: value, validityStart: validityStart, validityEnd: validityEnd)
        self.competitorStore = competitor
        competitor.bind(price: self)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
