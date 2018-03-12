import UIKit

class TicketViewController: UIViewController, UITableViewDataSource, OnHttpResponse {
    
    @IBOutlet weak var tableView: UITableView!
    var productsView : ProdsCollectionVC?
    var login: Login = Login(ok: 0, token: "",idmember: "")
    var ticketUploaded = false
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var btnComprar: UIBarButtonItem!
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subtotal = ticketWithTicketsDetails.ticketsDetails[indexPath.row].price
            total = total - Double(subtotal)!
            totalLabel.text = String(total)
            ticketWithTicketsDetails.ticketsDetails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (ticketWithTicketsDetails.ticketsDetails.count == 0) {
            btnComprar.isEnabled = false
        } else {
            btnComprar.isEnabled = true
        }
        tableView.reloadData()
        productsView = self.tabBarController?.viewControllers?.first as? ProdsCollectionVC
        self.login = (productsView?.login)!
        ticketWithTicketsDetails.ticket.idmember = login.idmember!
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
    
    @IBAction func uploadTicket(_ sender: UIBarButtonItem) {
        setTicketDate()
        let jsondata =  try? JSONEncoder().encode(ticketWithTicketsDetails.ticket)
        UIApplication.shared.isNetworkActivityIndicatorVisible
            = true
        guard let cliente = ClienteHttp(target: "tickets", authorization: "Bearer " + self.login.token,responseObject: self,
                                        "POST", jsondata!) else {
            return
        }
        cliente.request()
    }
    
    func uploadTicketDetails(){
        let ticketdetailsUp = TicketsDetails()
        ticketdetailsUp.ticketsdetails = ticketWithTicketsDetails.ticketsDetails
        let jsondata =  try? JSONEncoder().encode(ticketdetailsUp)
        
        printJson(data : jsondata!)
        print("Update details")
        guard let cliente = ClienteHttp(target: "ticketdetails", authorization: "Bearer " + self.login.token,responseObject: self,
                                        "POST",jsondata!) else {
                                            return
        }
        cliente.request()
    }
    
    func onDataReceived(data: Data) {
        checkLogin(data: data)
    }
    
    func onErrorReceivingData(message: String) {
        print("error reciving data")
    }
    
    func checkLogin(data: Data){
        do {
            let loginRec = try JSONDecoder().decode(Login.self, from: data)
            if loginRec.ok == 1 && ticketUploaded == false{
                self.login.ok = 1
                self.login.token = loginRec.token
                ticketWithTicketsDetails.ticket.id = ticketWithTicketsDetails.ticketsDetails[0].idticket
                myTickets.tickets.append(ticketWithTicketsDetails.ticket)
                uploadTicketDetails()
                ticketUploaded = true
            } else if loginRec.ok == 1 && ticketUploaded == true{
                print("Ticket completo subido ")
                UIApplication.shared.isNetworkActivityIndicatorVisible
                    = false
                print(loginRec.ok)
                ticketWithTicketsDetails = TicketWithTicketsDetails()
                ticketUploaded = false
                productsView?.showToast(msg: "Ticket guardado")
                totalLabel.text = "0.0"
                self.tabBarController?.selectedIndex = 0
            }
        } catch {
            print("Error decoding login json")
            UIApplication.shared.isNetworkActivityIndicatorVisible
                = false
        }
    }
    
    func printJson(data : Data){
        var json : Any?
        json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let json = json {
            print("Ticket JSON:\n" + String(describing: json) + "\n")
        }
    }
    
    func setTicketDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        ticketWithTicketsDetails.ticket.date = result
    }
    
}
