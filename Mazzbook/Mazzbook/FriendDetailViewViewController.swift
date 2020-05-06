//
//  FriendDetailViewViewController.swift
//  Mazzbook
//
//  Created by Ahmed Rezik on 12/11/19.
//  Copyright © 2019 Ahmed Rezik. All rights reserved.
//

import UIKit
struct Event {
    var name:String
    var desc:String
    var pic: UIImage
    
    init(n:String,d:String, p:UIImage) {
        self.name = n
        self.desc = d
        self.pic = p
    }
}
class FriendDetailViewViewController: UIViewController {
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    static var events:[Event] = []
    
    let ev = Event(n: "Launching Facebook", d: "Welcome back to 2004, we are going to launch a website called Faceook", p: UIImage())
    @IBOutlet weak var events: UITableView!
    @IBOutlet weak var neighbor: UILabel!
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        events.dataSource = self
        events.delegate  = self
        FriendDetailViewViewController.events.append(ev)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 

}

extension FriendDetailViewViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendDetailViewViewController.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! eventCell
        
        
        cell.img.image = UIImage(systemName: "profile")
        cell.name.text = FriendDetailViewViewController.events[indexPath.row].name
        cell.desc.text = FriendDetailViewViewController.events[indexPath.row].desc
        return cell
    }
    
    
    
}

public class eventCell: UITableViewCell{
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var img: UIImageView!
}
