//
//  CollectionViewController.swift
//  Masquepan
//
//  Created by dam on 22/2/18.
//  Copyright © 2018 dam. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProdCell"

class ProdsCollectionVC: UICollectionViewController, ProdsViewProt {
    
    let presenter = ProdListPresenter()
    var products : [Product] = []
    var productImages : [UIImage] = []
    // Recive prods data as a array of Products
    func setProds(_ prods: [Product], _ prodsImgs : [UIImage]) {
        products = prods;
        productImages = prodsImgs
        collectionViewProds.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        presenter.attachView(viewC: self)
        collectionViewProds.dataSource = self
        collectionViewProds.delegate = self
        presenter.allProds()
        
        let layout = self.collectionViewProds.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewProds.contentInset = UIEdgeInsets(top: 25, left: 30, bottom: 30, right: 30)
        layout.minimumInteritemSpacing = 5

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.products.count
    }

    @IBOutlet weak var collectionViewProds: UICollectionView!
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewProds.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProdCellVC
        
        //Asigna el contenido al label de la celda
        cell.lblProduct.text = products[indexPath.item].product
        //Asigna las imagenes al imageView de la celda
        cell.imgProduct.image = productImages[indexPath.item]
        // Configure the cell
        print("cell lbl : " + String(describing: cell.lblProduct.text))
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        //Borde de selección
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        //Deseleccionar borde
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
    
}
