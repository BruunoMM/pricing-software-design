import Cocoa

class LoginViewController: NSViewController {
    
    var selectedPosition = 0
    
    @IBOutlet weak var positionControl: NSSegmentedControl!
    
    @IBOutlet weak var personPopUp: NSPopUpButton!
    @IBOutlet weak var enterButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        JSONReader.readMockData()
        positionControl.selectedSegment = 0
        fillOptionsWithManagers()
    }
    
    
    @IBAction func switchPosition(_ sender: Any) {
        if let segmentControl = sender as? NSSegmentedControl {
            selectedPosition = segmentControl.selectedSegment
            
            switch selectedPosition {
            case 0:
                fillOptionsWithManagers()
            default:
                fillOptionsWithEmployees()
            }
        }
    }
    
    private func fillOptionsWithEmployees() {
        personPopUp.removeAllItems()
        personPopUp.addItems(withTitles: Person.employees.map { $0.name })
        personPopUp.selectItem(at: 0)
    }
    
    private func fillOptionsWithManagers() {
        personPopUp.removeAllItems()
        personPopUp.addItems(withTitles: Person.managers.map { $0.name })
        personPopUp.selectItem(at: 0)
    }
    
    @IBAction func enterClicked(_ sender: Any) {
        let user = personPopUp.selectedItem?.title
        
        switch selectedPosition {
        case 0:
            LoginService.shared.loggedUser = Person.managers.first { $0.name == user }
        default:
            LoginService.shared.loggedUser = Person.employees.first { $0.name == user }
        }
        
        performSegue(withIdentifier: "loginToPricing", sender: self)
    }
    
}
