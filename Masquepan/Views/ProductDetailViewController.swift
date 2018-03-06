import UIKit

let ticketDetail = TicketDetail()

class ProductDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var productseg = Product()
    var prodImg =  UIImage()
    var productQuantity : Int = 0
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.image = prodImg
        productName.text = productseg.product
        productDescription.text = productseg.description
        productPrice.text = productseg.price
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // How many individual segments there are
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Describes how many rows each segment has
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    // Provides the title for each row in each segment
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        productQuantity = row + 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func add(_ sender: UIButton) {
        ticketDetail.id = String(myTicketsDetails.ticketsdetails.count + 1)
        ticketDetail.idticket = String(myTickets.tickets.count + 1)
        ticketDetail.idproduct = productseg.id
        ticketDetail.quantity = String(productQuantity)
        ticketDetail.price = productseg.price
    }
}
