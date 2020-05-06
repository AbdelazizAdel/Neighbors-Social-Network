//
//  profile.swift
//  Mazzbook
//
//  Created by Ahmed Rezik on 12/9/19.
//  Copyright © 2019 Ahmed Rezik. All rights reserved.
//

import Foundation
import UIKit
class profileVC: UIViewController{
    
    
    
    @IBOutlet weak var profileimg: UIImageView!
    
    @IBOutlet weak var Neighborhoodinfo: UILabel!
    
    @IBOutlet weak var friendsCount: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var eventTableView: UITableView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
}

extension profileVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = eventCell()
//        cell.name.text = "Facebook launch"
//        cell.desc.text = "Welcome bacl to '04"
//        return cell
        return UITableViewCell()
    }
    
    
    
}
