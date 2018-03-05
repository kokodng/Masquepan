//
//  ProductDetailViewController.swift
//  Masquepan
//
//  Created by dam on 22/02/2018.
//  Copyright © 2018 dam. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var productseg = Product()
    var prodImg =  UIImage()
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
        productImage.image = prodImg
        print("\(productseg.product)")
        productName.text = productseg.product
        productDescription.text = productseg.description
        productPrice.text = productseg.price
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
