import UIKit

struct Resp: Decodable {
    let ok: Int
    let token: String
    let id: String
}

class ViewController: UIViewController, OnHttpResponse {
    
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lbMessage: UILabel!
    
    var response: [String:Any] = [:]
    
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
        do {
            let resp = try JSONDecoder().decode(Resp.self, from: data)
            if resp.ok == 1 {
                // perform segue
                print("ok = 1")
            } else {
                lbMessage.text = "Credenciales no válidos"
                print("ok != 1")
            }
        } catch {
            lbMessage.text = "Credenciales no válidos"
            print("ok != 1")
        }
    }
    
    func onErrorReceivingData(message: String) {
        print("Error receiving data")
    }
    
}
