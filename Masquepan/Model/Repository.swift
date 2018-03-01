//
//  Repository.swift
//  ListProds
//
//  Created by dam on 19/2/18.
//  Copyright © 2018 dam. All rights reserved.
//

import Foundation
import UIKit



class Repository : RepoProt{
    /*
     ¿Cuando recibimos los datos JSON junto al token y com se diferencian?
     ¿Obtenemos un diccionario?
     */
    func get() -> [Product] {
        return [
            Product("1", "0", "barra granada", "0.46", "Barra de pan en horno de piedra"),
            Product("2", "2", "napolitana", "0.86", "Bollo relleno de chocolate con las puntas mojadas en choco"),
            Product("3", "1", "chapata", "1.86", "1 kg de pan delicioso pan")
        ]
    }
    
}
