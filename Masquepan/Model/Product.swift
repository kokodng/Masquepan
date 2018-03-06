import Foundation

class Product: Decodable {
    var id: String
    var idfamily: String
    var product: String
    var price: String
    var description: String
    
    init(){
        self.id = "";
        self.idfamily = "";
        self.product="";
        self.price = "0.0"
        self.description = ""
    }
    
    init(_ id: String, _ idfamily: String, _ product: String, _ price: String, _ description: String){
        self.id = id;
        self.idfamily = idfamily;
        self.product = product;
        self.price = price
        self.description = description
    }
    
    func loadFromDictionary(_ dict: [String: AnyObject]){
        if let id = dict["id"] as? String{
            self.id = id
        }
        if let idFamily = dict["idFamily"] as? String{
            self.idfamily = idFamily
        }
        if let product = dict["product"] as? String{
            self.product = product
        }
        if let description = dict["description"] as? String{
            self.description = description
        }
        if let price = dict["price"] as? String{
            self.price = price
        }
    }
    
    class func build(_ dict: [String: AnyObject]) -> Product{
        let product = Product()
        product.loadFromDictionary(dict)
        return product
    }
}
