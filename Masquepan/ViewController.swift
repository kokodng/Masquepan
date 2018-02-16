//
//  ViewController.swift
//  Masquepan
//
//  Created by dam on 13/02/2018.
//  Copyright © 2018 dam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OnHttpResponse {
    
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    var response: (Any)? = nil
    
    func onDataReceived(data: Data) {
        if let resp = try? JSONSerialization.jsonObject(with: data, options: []){
            print(String(describing: resp))
            response = resp
        }
    }
    
    func onErrorReceivingData(message: String) {}
    
    func toBase64(cadena: String) -> String? {
        guard let data = cadena.data(using: .utf8) else {
            return nil
        }
        return Data(data).base64EncodedString()
    }

    @IBAction func btLogin(_ sender: UIButton) {
        guard tfUser.text != "" || tfPassword.text != "" else {
            return
        }
        let userPass = tfUser.text! + ":" + tfPassword.text!
        guard let cliente = ClienteHttp(target: "", authorization: "Basic " + toBase64(cadena: userPass)!, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

