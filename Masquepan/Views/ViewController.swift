import UIKit

struct Login: Codable {
    let ok: Int
    let token: String
    let idmember: String
}

class Products: Codable {
    var products = [Product]()
}

class Tickets: Codable {
    var tickets = [Ticket]()
}

class TicketsDetails: Codable {
    var ticketsdetails = [TicketDetail]()
}

class Members: Codable {
    var members = [Member]()
}

var myTickets = Tickets()
var myTicketsDetails = TicketsDetails()
var ticketWithTicketsDetails = TicketWithTicketsDetails()
var myProducts: Products = Products()
var myMembers: Members = Members()

class ViewController: UIViewController, OnHttpResponse {
    
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lbMessage: UILabel!
    
    var response: [String:Any] = [:]
    var state: String = "login";
    var productImages: [UIImage] = []
    var login: Login = Login(ok: 0, token: "",idmember: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ticketWithTicketsDetails.ticket.id = String(myTickets.tickets.count + 1)
        ticketWithTicketsDetails.ticket.idmember = self.login.idmember
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toBase64(cadena: String) -> String? {
        guard let data = cadena.data(using: .utf8) else {
            return nil
        }
        return Data(data).base64EncodedString()
    }
    
    @IBAction func btLogin(_ sender: UIButton) {
        guard tfUser.text != "" || tfPassword.text != "" else {
            lbMessage.text = "Credenciales no válidos"
            return
        }
        let credentials = tfUser.text! + ":" + tfPassword.text!
        guard let cliente = ClienteHttp(target: "login", authorization: "Basic " + toBase64(cadena: credentials)!, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func onDataReceived(data: Data) {
        switch(self.state){
        case "login":
            self.checkLogin(data: data)
            if self.state == "products" {
                downloadProducts()
            }
            break
        case "products":
            saveProducts(data)
            downloadProdsImgs()
            break
        case "tickets":
            saveTickets(data)
            self.state = "ticketsdetails"
            downloadTicketsDetails()
            break
        case "ticketsdetails":
            saveTicketsDetails(data)
            self.state = "members"
            downloadMembers()
            break
        case "members":
            saveMembers(data)
            performSegue(withIdentifier: "SegueLoginToHome", sender: self)
            break
        default:
            print("Switch case default")
        }
    }
    
    func onErrorReceivingData(message: String) {
        print("Error receiving data")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UITabBarController{
            if let destinationViewController = destination.viewControllers![0] as? ProdsCollectionVC {
                destinationViewController.products = myProducts.products
                destinationViewController.productImages = self.productImages
            }
        }
    }
    
    func downloadProdsImgs(){
        let baseUrl = "https://ios-javierrodrigueziturriaga.c9users.io/img/"
        
        DispatchQueue.global().async {
            for product in myProducts.products {
                let id = String(describing: product.id);
                let url = "\(baseUrl)" + id + ".jpg"
                let data = try? Data(contentsOf: URL(string: url)!)
                DispatchQueue.main.async {
                    guard let img = UIImage(data: data!) else {
                        print("img nil")
                        return
                    }
                    self.productImages.append(img)
                    if myProducts.products.count == self.productImages.count{
                        self.state = "tickets"
                        self.downloadTickets()
                    }
                }
            }
        }
    }
    
    func checkLogin(data: Data){
        do {
            login = try JSONDecoder().decode(Login.self, from: data)
            if login.ok == 1 {
                self.state = "products"
            }
        } catch {
            lbMessage.text = "Credenciales no válidos"
            print("Error decoding login json")
        }
    }
    
    func downloadProducts(){
        guard let cliente = ClienteHttp(target: "products", authorization: "Bearer " + self.login.token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func saveProducts(_ data: Data){
        do {
            myProducts = try JSONDecoder().decode(Products.self, from: data)
        } catch {
            print("Error decoding products json")
        }
    }
    
    func downloadTickets(){
        guard let cliente = ClienteHttp(target: "tickets", authorization: "Bearer " + self.login.token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func saveTickets(_ data: Data){
        do {
            myTickets = try JSONDecoder().decode(Tickets.self, from: data)
        } catch {
            print("Error decoding tickets json")
        }
    }
    
    func downloadTicketsDetails(){
        guard let cliente = ClienteHttp(target: "ticketsdetails", authorization: "Bearer " + self.login.token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func saveTicketsDetails(_ data: Data){
        do {
            myTicketsDetails = try JSONDecoder().decode(TicketsDetails.self, from: data)
        } catch {
            print("Error decoding ticketsdetails json")
        }
    }
    
    func downloadMembers() {
        guard let cliente = ClienteHttp(target: "members", authorization: "Bearer " + self.login.token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func saveMembers(_ data: Data) {
        do {
            myMembers = try JSONDecoder().decode(Members.self, from: data)
        } catch {
            print("Error decoding members json")
        }
    }
    
}
