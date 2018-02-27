//
//  File.swift
//  ListProds
//
//  Created by dam on 19/2/18.
//  Copyright © 2018 dam. All rights reserved.
//

import Foundation


protocol PresenterProt {
    func startLoading(urlparams: String)
    func finishLoading()
    func notifyView()
    func allProds()
    
}

