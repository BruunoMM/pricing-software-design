import Cocoa

class PricingListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {


    @IBOutlet weak var productName: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var priceType: NSTextField!
    
    @IBOutlet weak var price: NSTextField!
    
    
    @IBOutlet weak var validityLabel: NSTextField!
    
    @IBOutlet weak var additionalInfoLabel: NSTextField!
    
    @IBOutlet weak var editAcceptButton: NSButton!
    @IBOutlet weak var rejectButton: NSButton!
    
    @IBOutlet weak var addButtonOutlet: NSButton!
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "newPricing", sender: self)
    }
    var pricings: [Pricing] {
        return Pricing.pricings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        if LoginService.shared.isManager() {
            addButtonOutlet.isHidden = true
        } else {
            addButtonOutlet.isHidden = false
        }
    }
    
    override func viewDidAppear() {
        tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return pricings.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView {
            cell.textField?.stringValue = pricings[row].product?.name ?? ""
            
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        loadDataFor(row)
        return true
    }
    
    func loadDataFor(_ row: Int) {
        let pricing = pricings[row]
        productName.stringValue = pricing.product?.name ?? ""
        priceType.stringValue = pricing.price?.name ?? ""
        price.stringValue = "$ \(String(format: "%.2f", pricing.price!.value))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let validityStart = pricing.price!.validityStart
        let validityEnd = pricing.price!.validityStart
        validityLabel.stringValue = "\(dateFormatter.string(from: validityStart)) - \(dateFormatter.string(from: validityEnd))"
        additionalInfoLabel.stringValue = pricing.employee?.name ?? ""
    }
}
