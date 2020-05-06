//
//  MarketVC.swift
//  Mazzbook
//
//  Created by Ahmed Rezik on 12/9/19.
//  Copyright © 2019 Ahmed Rezik. All rights reserved.
//

import Foundation
import UIKit

struct Items{
    var name:String
    var price: String
    
    init(name:String,price:String) {
        self.name = name
        self.price = price
        
    }
}
class MarketVC: UIViewController{
    
    static var count:Int = 0
   
    @IBOutlet weak var market: UITableView!
    
    let fota = Items(name: "fota", price: "10")
    let sandal = Items(name: "Sandal", price: "15")
    let Kanabba = Items(name: "Kanaba used Spandau", price: "30")
    let toilet = Items(name: "Unused Toilet paper", price: "100")
    static var MarketItems:[Items] = []
    
     var queue = DispatchQueue(label: "Json",qos: .utility)
    
    override func viewWillAppear(_ animated: Bool) {
        if MarketVC.count == 0 {
            MarketVC.MarketItems.append(fota)
            MarketVC.MarketItems.append(sandal)
            MarketVC.MarketItems.append(Kanabba)
            MarketVC.MarketItems.append(toilet)
            MarketVC.count = MarketVC.count + 1
        }

        
        
      
        
    }
    override func viewDidLoad() {
        
    }

    
    
}

extension MarketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MarketVC.MarketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! ItemCell
        
        cell.nameLabel.text = MarketVC.MarketItems[indexPath.row].name
       // cell.priceLabel.text = String( MarketVC.MarketItems[indexPath.row].price)
        cell.img.image = UIImage(systemName: "profile")
        
      
      
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
   
        

        
        
    
    
    
}


class ItemCell: UITableViewCell{
  
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
}


public class popVC: UIViewController{
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBAction func SavePressed(_ sender: Any) {
        let itemnew = Items(name: name.text ?? "", price: price.text ?? "")
        MarketVC.MarketItems.append(itemnew)
        //MarketVC.market.reloadData()
        self.dismiss(animated: true)
        
        
    }
    
}
