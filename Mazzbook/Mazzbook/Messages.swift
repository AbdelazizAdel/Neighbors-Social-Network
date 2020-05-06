//
//  Messages.swift
//  Mazzbook
//
//  Created by Ahmed Rezik on 12/9/19.
//  Copyright © 2019 Ahmed Rezik. All rights reserved.
//

import Foundation
import UIKit
struct message{
    var name:String
    var content:String
    var pic:UIImage
    
    init(nam:String,con:String,pic:UIImage) {
        self.name = nam
        self.content = con
        self.pic = pic
    }
}
class MessagesVC: UIViewController{
   
    static var count  = 0
    static var messages:[message] = []
    let m1 = message(nam: "Mark Zuckerberg", con: "eh ya ray2 3amel eh", pic: UIImage(systemName: "profile") ?? UIImage())
    let m2 = message(nam: "Evan Spigel", con: "Acquiring Snap", pic: UIImage(systemName: "profile") ?? UIImage())
    
    @IBOutlet weak var messagesTV: UITableView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if MessagesVC.count == 0{
        MessagesVC.messages.append(m1)
            MessagesVC.messages.append(m2)
            MessagesVC.count = 1
        }}
    
    
    
    
    
    
    
    
//        func CallApi(){
//            
//                guard let url = URL(string: "http://localhost:8081/view_my_friends/ziax") else {return}
//                   let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                   guard let dataResponse = data,
//                             error == nil else {
//                             print(error?.localizedDescription ?? "Response Error")
//                             return }
//                       do{
//                           //here dataResponse received from a network request
//                           let json = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
//                           if let dictionary = json as? [String: Any] {
//                           if let number = dictionary["recordset"] as? [Any] {
//                               // access individual value in dictionary
//                               for user in number{
//                                   
//                                  // FriendsVC.friends.append(friend(user as! [String : Any]))
//                                
//                                   
//
//                               }
//                               
//                              
//                               
//                           }
//                           
//                           
//                           
//                           }}
//                       
//                   }
//                   task.resume()
//            
//        }
    
    
    
    
    
}

extension MessagesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesVC.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageCell
        cell.senderName.text = MessagesVC.messages[indexPath.row].name
        cell.ehYasta.text = MessagesVC.messages[indexPath.row].content
        cell.img.backgroundColor = .cyan
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = MessageDetail()
        dest.name.text = MessagesVC.messages[indexPath.row].name
        dest.content.text = MessagesVC.messages[indexPath.row].content
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
  
    
    
}

public class MessageCell: UITableViewCell{
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var ehYasta: UILabel!
    
}

public class MessageDetail: UIViewController{
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var name: UILabel!
    
    
    @IBAction func sendbutton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var send: UIButton!
    
}
