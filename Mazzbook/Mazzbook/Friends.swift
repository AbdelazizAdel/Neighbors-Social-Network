//
//  Friends.swift
//  Mazzbook
//
//  Created by Ahmed Rezik on 12/8/19.
//  Copyright © 2019 Ahmed Rezik. All rights reserved.
//

import Foundation
import UIKit

//struct record:Codable {
//    var dic:Dictionary<String, Any>
//
//    init(_ dictionary: [String: Any]) throws {
//        self.dic = dictionary["dic"] as! Dictionary<String, Any>
//    }
//}
struct friend:Codable {
      var house_number: Int
      var isBad: Int
      var login_password: String
      var memberID: Int
    var member_name: String
    var neighborhood: String
    var street_name: String
    var username:String
init(_ dictionary: [String: Any]) {
      self.house_number = dictionary["house_number"] as? Int ?? 0
      self.isBad = dictionary["isBad"] as? Int ?? 0
      self.login_password = dictionary["login_password"] as? String ?? ""
      self.memberID = dictionary["memberID"] as? Int ?? 0
    self.member_name = dictionary["member_name"] as? String ?? ""
    self.neighborhood = dictionary["neighborhood"] as? String ?? ""
    self.street_name = dictionary["street_name"] as? String ?? ""
    self.username = dictionary["username"] as? String ?? ""

    }
}

class FriendsVC: UIViewController{
   
  let user = ""
    
    static var count = 0
    @IBOutlet weak var FriendsView: UITableView!
    
    var friends:[friend] = []{
        didSet{
            FriendsView.reloadData()
            
        }
    }
    var queue = DispatchQueue(label: "Json",qos: .utility)
    
    
    override func viewDidLoad() {
        if FriendsVC.count < 1 {
            
                guard let url = URL(string: "http://localhost:8081/view_my_friends/ziax") else {return}
                   let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                   guard let dataResponse = data,
                             error == nil else {
                             print(error?.localizedDescription ?? "Response Error")
                             return }
                       do{
                           //here dataResponse received from a network request
                           let json = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
                           if let dictionary = json as? [String: Any] {
                           if let number = dictionary["recordset"] as? [Any] {
                               // access individual value in dictionary
                               for user in number{
                                   
                                   self.friends.append(friend(user as! [String : Any]))
                                
                                   

                               }
                               
                              
                               
                           }
                           
                           
                           
                           }}
                       
                   }
                   task.resume()
            
            FriendsVC.count = 1
        }
        
        
   
        self.FriendsView.reloadData()
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
          self.FriendsView.reloadData()
    }
    

    
    
    
    
    
}

extension FriendsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendCell
        cell.nameLabel.text = self.friends[indexPath.row].member_name
        //cell.backgroundColor = .black
        cell.profilepic.image = UIImage(systemName: "profile")
        cell.profilepic.contentMode = .scaleToFill
        cell.profilepic.layer.borderWidth = 1
        cell.profilepic.layer.masksToBounds = false
        cell.profilepic.layer.borderColor = UIColor.black.cgColor
        cell.profilepic.layer.cornerRadius = cell.profilepic.frame.height/2
        cell.profilepic.clipsToBounds = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friend", sender: nil)
    }
    
    
}

public class FriendCell: UITableViewCell{
    
    //@IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profilepic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
}
