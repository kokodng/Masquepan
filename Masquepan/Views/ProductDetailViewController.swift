//
//  ProductDetailViewController.swift
//  Masquepan
//
//  Created by dam on 22/02/2018.
//  Copyright © 2018 dam. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescriptionTitle: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    
//    @IBAction func fromProductCollectionViewController(_ segue: UIStoryboardSegue) {
//         unwind segue para recoger los datos
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://ios-javierrodrigueziturriaga.c9users.io/img/1.jpg")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.productImage.image = UIImage(data: data!)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
