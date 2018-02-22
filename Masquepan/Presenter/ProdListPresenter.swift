//
//  ProdListPresenter.swift
//  ListProds
//
//  Created by dam on 19/2/18.
//  Copyright © 2018 dam. All rights reserved.
//

import Foundation

class ProdListPresenter: PresenterProt {
    
    private let repo: Repository
    weak private var view: ProdsCollectionVC? // ¿View controller o interfaz?
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
        notifyView()
    }
    
    func notifyView() {
        view?.setProds(self.prods)
    }
    
    func allProds() {
        var urlParams = "Products"
        let idparam = ""
        if idparam != "" {
            urlParams += "/" + idparam
        }
        
        startLoading(urlparams: urlParams)
    }
    
    
}
