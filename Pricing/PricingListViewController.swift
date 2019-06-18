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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        JSONReader.readMockData()
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView {
            cell.textField?.stringValue = Product.products[row].name
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        
        return true
    }
}
