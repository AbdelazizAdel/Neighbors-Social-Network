//
//  LogIn.swift
//  Mazzbook
//
//  Created by Ahmed Rezik on 12/8/19.
//  Copyright © 2019 Ahmed Rezik. All rights reserved.
//

import Foundation
import UIKit

struct member:Codable{
    var username:String
    
     init(_ dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
    }
}

class LogInVC: UIViewController{
    var members = [String]()
       
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var LogInPressed: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func LogIn(_ sender: Any) {
        let login = emailField.text ?? ""
        
        if /*members.contains(login) ||*/ login == "mark"{
            
            performSegue(withIdentifier: "Login", sender: nil)
            
        }
        else{
            errorLabel.isHidden = false
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
      
        errorLabel.isHidden = true
        
       
    }
    
   
    override func loadView() {
        super.loadView()
      //  getAllMembers()
    }
    
   
    func getAllMembers(){
        
        guard let url = URL(string: "http://localhost:8081/view_all_members") else {print("error1");return}
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
           guard let dataResponse = data,
                     error == nil else {
                     print(error?.localizedDescription ?? "Response Error")
                     return }
               do{
                   //here dataResponse received from a network request
                   let json = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
                   if let dictionary = json as? [String: Any] {
                   if let members = dictionary["recordset"] as? [Any] {
                       // access individual value in dictionary
                    
                       for user in members{
                           //print(member(user as! [String : Any]).username)
                        self.members.append(member(user as! [String : Any]).username)
                        
                        
                           

                       }
                    
                       
                      
                       
                   }
                   
                   
                   
                   }}
               
           }
           task.resume()
        
        
      
        }
}
