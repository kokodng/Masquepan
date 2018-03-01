//
//  ProdListPresenter.swift
//  ListProds
//
//  Created by dam on 19/2/18.
//  Copyright © 2018 dam. All rights reserved.
//

import Foundation
import UIKit

class ProdListPresenter: PresenterProt {
    
    var productImages : [UIImage] = []
    private let repo: Repository
    weak private var view: ProdsCollectionVC?
    var prods : [Product]
    
    init(){
        self.view = nil
        self.repo = Repository()
        self.prods = []
    }
    
    func attachView(viewC:ProdsCollectionVC){
        self.view = viewC
    }
    
    func detachView() {
        view = nil
    }
    /*
     FIXME: startLoading: ¿Servirá para todo, lo veremos?
    */
    func startLoading(urlparams: String) {
        finishLoading()
    }
    
    func finishLoading() {
        prods = repo.get()
        downloadProdsImgs()
        
    }
    
    func notifyView() {
        view?.setProds(self.prods, self.productImages)
    }
    
    func allProds() {
        var urlParams = "Products"
        let idparam = ""
        if idparam != "" {
            urlParams += "/" + idparam
        }
        
        startLoading(urlparams: urlParams)
    }
    
    func downloadProdsImgs(){
        let baseUrl = "https://ios-javierrodrigueziturriaga.c9users.io/img/"
            
            DispatchQueue.global().async {
                for product in self.prods {
                    let id = String(describing: product.id);
                    let url = "\(baseUrl)" + id + ".jpg"
                    let data = try? Data(contentsOf: URL(string: url)!)
                    DispatchQueue.main.async {
                    guard let img = UIImage(data: data!) else {
                        print("img nil")
                        return
                    }
                    self.productImages.append(img)
                    if self.prods.count == self.productImages.count{
                        self.notifyView()
                    }
                }
            }
        }
    }
    
    
}
