import Foundation

class JSONReader {
    
    private static func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
    
    static func removeUserDefaults() {
        do {
            try FileManager.default.removeItem(at: getDocumentsURL().appendingPathComponent("Pricings.json"))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func savePricings(_ pricings: [Pricing]) {
        let url = getDocumentsURL().appendingPathComponent("Pricings.json")
        savePrices(pricings.map { pricing in pricing.price! })
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(pricings)
            try data.write(to: url, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private static func savePrices(_ prices: [Price]) {
        let pricesURL = getDocumentsURL().appendingPathComponent("Prices.json")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(prices)
            try data.write(to: pricesURL, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private static func readPricings() {
        let url = getDocumentsURL().appendingPathComponent("Pricings.json")
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let _ = try decoder.decode([Pricing].self, from: data)
        } catch {
            print("error:\(error)")
        }
    }

    private static func readPersons() {
        if let url = Bundle.main.url(forResource: "Persons", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let _ = try decoder.decode([Person].self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    private static func readStores() {
        if let url = Bundle.main.url(forResource: "Stores", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let _ = try decoder.decode([Store].self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    private static func readProducts() {
        if let url = Bundle.main.url(forResource: "Products", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let _ = try decoder.decode([Product].self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    static func readMockData() {
        readPersons()
        readStores()
        readProducts()
        readPricings()
    }
}
