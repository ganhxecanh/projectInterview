//
//  DetailUserViewController.swift
//  Exercise3
//
//  Created by Hung Vuong on 5/27/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import UIKit

class DetailUserViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!

    var data: Users?
    
    var name: String = ""
    var email: String = ""
    var phone: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        errorLabel.text = ""
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        self.phoneTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
    }
    
    func setText() {
        nameTextField.text = data?.name
        emailTextField.text = data?.email
        phoneTextField.text = data?.phone
    }
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        guard let numberWordOfName = nameTextField.text?.count else {
            return
        }

        let dict: [String: Any?] = ["name": nameTextField.text, "phone": phoneTextField.text, "email": emailTextField.text]
        
        if validEmail(email: getTextField(textField: emailTextField)) == false {
            errorLabel.text = "Invalid email!"
        } else if phoneTextField.text?.isPhoneNumber == false  || phoneTextField.text?.isNumeric == false {
            errorLabel.text = "Invalid phone number!"
        } else if numberWordOfName < 4 || numberWordOfName > 20 {
            errorLabel.text = "Invalid name!"
        } else {
            if let data = data {
                RealmService.shared.update(data, with: dict)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        setText()
    }
    
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isNumeric: Bool {
        if self.isEmpty {
            return false
        }
        let nums: Set<Character> =  ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}


 // MARK: - Validate
extension DetailUserViewController {
    func getTextField(textField: UITextField) -> String {
        return textField.text ?? ""
    }
    
    func validEmail(email : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
