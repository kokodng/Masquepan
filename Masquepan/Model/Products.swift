//
//  Prdoduct.swift
//  ListProds
//
//  Created by dam on 19/2/18.
//  Copyright © 2018 dam. All rights reserved.
//

import Foundation

class Product: Decodable {
    var id: String
    var idFamily: String
    var product: String
    var price: Float
    var description: String
    
    init(){
        self.id = "";
        self.idFamily = "";
        self.product="";
        self.price = 0.0
        self.description = ""
    }
    
    init(_ id: String, _ idFamily: String, _ product: String, _ price: Float, _ description: String){
        self.id = id;
        self.idFamily = idFamily;
        self.product = product;
        self.price = price
        self.description = description
    }
    
    func loadFromDictionary(_ dict: [String: AnyObject]){
        if let id = dict["id"] as? String{
            self.id = id
        }
        if let idFamily = dict["idFamily"] as? String{
            self.idFamily = idFamily
        }
        if let product = dict["product"] as? String{
            self.product = product
        }
        if let description = dict["description"] as? String{
            self.description = description
        }
        if let price = dict["price"] as? Float{
            self.price = price
        }
    }
    
    class func build(_ dict: [String: AnyObject]) -> Product{
        let product = Product()
        product.loadFromDictionary(dict)
        return product
    }
}
