//
//  SignUp.swift
//  Mazzbook
//
//  Created by Ahmed Rezik on 12/9/19.
//  Copyright © 2019 Ahmed Rezik. All rights reserved.
//

import Foundation
import UIKit


class SignUPVC: UIViewController{
    var hoods:[String] = ["Spandau","Tegel","Mitte","Kreuzberg","Wedding","Mariendorf","Friedrichshain","Charlottenburg","Pankow","Zoologischer Garten"]
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var neighbborhood: UIPickerView!
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.isHidden = true
        
    }
    
}
extension SignUPVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hoods.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hoods[row]
    }
    
    
    
}
