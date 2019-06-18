import Cocoa

class PricingViewController: NSViewController {
    @IBOutlet weak var productPopUp: NSPopUpButtonCell!
    @IBOutlet weak var segmentsPriceType: NSSegmentedControl!
    @IBOutlet weak var priceField: NSTextField!
    
    @IBOutlet weak var competitorRegionField: NSPopUpButton!
    @IBOutlet weak var competitorRegionLabel: NSTextField!
    
    @IBOutlet weak var dateStart: NSDatePicker!
    @IBOutlet weak var dateEnd: NSDatePicker!
    
    var pricings: [Pricing]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        JSONReader.removeUserDefaults()
        JSONReader.readMockData()
        populateProductPopUp()
        adjustDateWidgets()
        setSegmentPriceTypeMenu()
        
    }
    
    @IBAction func sendForApproval(_ sender: Any) {
        let productName = productPopUp.selectedItem?.title
        guard let product = (Product.products.first { product -> Bool in product.name == productName }) else { return }
        let priceType = segmentsPriceType.selectedSegment
        
        let validityStart = dateStart.dateValue
        let validityEnd = dateEnd.dateValue
        
        let priceValue = priceField.doubleValue
        
        switch priceType {
        case 0:
            let price = Price(id: Price.prices.count+1, product: product, value: priceValue, validityStart: validityStart, validityEnd: validityEnd)
            let pricing = Pricing(price: price)
            pricing.bind(manager: Person.managers[0])
            pricing.bind(employee: Person.employees[0])
            pricings.append(pricing)
            JSONReader.savePricings(pricings)
            
        default:
            return
        }
    }
    
    @IBAction func switchPriceType(_ sender: AnyObject) {
        if let segmentControl = sender as? NSSegmentedControl {
            let selectedSegment = segmentControl.selectedSegment
            
            switch selectedSegment {
            case 1: // Competition
                fillOptionsWithCompetitors()
            case 2: // Regional
                fillOptionsWithRegions()
            default: // Promotional/Regular
                competitorRegionField.isHidden = true
                competitorRegionLabel.isHidden = true
            }
            
        }
    }
    
    @IBAction func exitClicked(_ sender: Any) {
        dismiss(self)
    }
    
    func adjustDateWidgets() {
        dateStart.minDate = Date()
        dateEnd.minDate = Date()
    }
    
    func fillOptionsWithCompetitors() {
        competitorRegionLabel.isHidden = false
        competitorRegionLabel.stringValue = "Select the competitor store"
        competitorRegionField.removeAllItems()
        competitorRegionField.isHidden = false
        competitorRegionField.addItems(withTitles: Store.stores.map { $0.name })
        competitorRegionField.selectItem(at: 0)
    }
    
    func fillOptionsWithRegions() {
        competitorRegionLabel.isHidden = false
        competitorRegionLabel.stringValue = "Select the region"
        competitorRegionField.removeAllItems()
        competitorRegionField.isHidden = false
        competitorRegionField.addItems(withTitles: Region.allCases.map{ $0.description })
        competitorRegionField.selectItem(at: 0)
    }
    
    func setSegmentPriceTypeMenu() {
        let segmentTitles = ["Regular", "Competition", "Regional", "Promotional"]
        competitorRegionField.isHidden = true
        competitorRegionLabel.isHidden = true

        segmentsPriceType.segmentCount = 4
        segmentsPriceType.selectedSegment = 0
        
        for i in 0...3 {
            segmentsPriceType.setLabel(segmentTitles[i], forSegment: i)
            segmentsPriceType.setWidth(100, forSegment: i)
        }
    }
    
    func populateProductPopUp() {
        productPopUp.removeAllItems()
        productPopUp.addItems(withTitles: getAvailableProducts().map { $0.name })
        productPopUp.selectItem(at: 0)
    }
    
    func getAvailableProducts() -> [Product] {
        return Product.products
    }
    
    func getAvailableStores() -> [Store] {
        return Store.stores
    }
    
    func getPriceTypes() -> [Price.Type] {
        return Price.priceTypes
    }
    
    func validateProduct(with id: Int) -> Bool {
        return Product.products.contains(where: { product -> Bool in product.id == id })
    }
    
    func getPendingPrices() -> [Pricing] {
        return pricings.filter({ pricing -> Bool in pricing.status == Status.pending })
    }
    
    func getApprovedPrices() -> [Pricing] {
        return pricings.filter({ pricing -> Bool in pricing.status == Status.approved })
    }
    
    func getRejectedPrices() -> [Pricing] {
        return pricings.filter({ pricing -> Bool in pricing.status == Status.rejected })
    }
    
    func approvePrice(pricing: Pricing) {
        pricing.approve()
    }
    
    func rejectPrice(pricing: Pricing) {
        pricing.reject()
    }
}

