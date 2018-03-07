import UIKit

class TicketViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var total = 0.0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketWithTicketsDetails.ticketsDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell", for: indexPath) as! TicketTableViewCell
        cell.productLabel.text = myProducts.products[Int(ticketWithTicketsDetails.ticketsDetails[indexPath.item].idproduct)! - 1].product
        cell.quantityLabel.text = ticketWithTicketsDetails.ticketsDetails[indexPath.item].quantity
        cell.priceLabel.text = myProducts.products[Int(ticketWithTicketsDetails.ticketsDetails[indexPath.item].idproduct)! - 1].price
        let subtotal = ticketWithTicketsDetails.ticketsDetails[indexPath.item].price
        cell.subtotalLabel.text = subtotal
        total = total + Double(subtotal)!
        totalLabel.text = String(total)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        total = 0.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
