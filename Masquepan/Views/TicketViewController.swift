import UIKit

class TicketViewController: UIViewController, UITableViewDataSource, OnHttpResponse {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total: UILabel!
    var login: Login = Login(ok: 0, token: "",idmember: "")
    var ticketUploaded = false
        
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
        let quantity = ticketWithTicketsDetails.ticketsDetails[indexPath.item].quantity
        let price = ticketWithTicketsDetails.ticketsDetails[indexPath.item].price
        cell.quantityLabel.text = quantity
        cell.priceLabel.text = price
        cell.subtotalLabel.text = String(Double(quantity)! * Double(price)!)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let productsView = self.tabBarController?.viewControllers?.first as! ProdsCollectionVC
        self.login = productsView.login
        ticketWithTicketsDetails.ticket.idmember = login.idmember!
        tableView.reloadData()
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
        print("ok" + login.token)
        let jsondata =  try? JSONEncoder().encode(ticketWithTicketsDetails.ticket)
        printJson(data : jsondata!)
        guard let cliente = ClienteHttp(target: "tickets", authorization: "Bearer " + self.login.token,responseObject: self,
                                        "POST", jsondata!) else {
            return
        }
        cliente.request()
    }
    
    func uploadTicketDetails(){
        var ticketdetailsUp = TicketsDetails()
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
                print(login.token)
                uploadTicketDetails()
                ticketUploaded = true
            } else if loginRec.ok == 1 && ticketUploaded == true{
                print("Ticket completo subido ")
                print(loginRec.ok)
                ticketUploaded = false
            }
        } catch {
            print("Error decoding login json")
        }
    }
    
    func printJson(data : Data){
        var json : Any?
        json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let json = json {
            print("Ticket JSON:\n" + String(describing: json) + "\n")
        }

    }
    
}
