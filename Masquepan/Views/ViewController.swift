import UIKit

struct Login: Decodable {
    let ok: Int
    let token: String
    let idmember: String
}

struct Products: Decodable {
    var products: [Product]
}

struct Tickets: Decodable {
    var tickets: [Ticket]
}

class ViewController: UIViewController, OnHttpResponse {
    
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lbMessage: UILabel!
    
    var response: [String:Any] = [:]
    var state : String = "login";
    var login : Login = Login(ok: 0, token: "",idmember: "")
    var products : [Product] = []
    var productImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            downloadProducts()
            break
        case "products":
            saveProducts(data)
            self.state = "tickets"
            downloadTickets()
            break
        case "tickets":
            saveTickets(data)
            break
        default:
            print("Error at switch")
        }
        performSegue(withIdentifier: "SegueLoginToHome", sender: self)
        
    }
    
    func onErrorReceivingData(message: String) {
        print("Error receiving data")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = 
    }
    
    func downloadProdsImgs(){
        let baseUrl = "https://ios-javierrodrigueziturriaga.c9users.io/img/"
        
        DispatchQueue.global().async {
            for product in self.products {
                let id = String(describing: product.id);
                let url = "\(baseUrl)" + id + ".jpg"
                let data = try? Data(contentsOf: URL(string: url)!)
                DispatchQueue.main.async {
                    guard let img = UIImage(data: data!) else {
                        print("img nil")
                        return
                    }
                    self.productImages.append(img)
                    if self.products.count == self.productImages.count{
                        
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
                print("login ok!")
            } else {
                lbMessage.text = "Credenciales no válidos"
                print("Invalid login")
            }
        } catch {
            lbMessage.text = "Credenciales no válidos"
            print("Error login")
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
            let products = try JSONDecoder().decode(Products.self, from: data)
            print(products)
        } catch {
            print("Error products")
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
            let tickets = try JSONDecoder().decode(Tickets.self, from: data)
            print(tickets)
        } catch {
            print("Error tickets")
        }
    }
    
}
