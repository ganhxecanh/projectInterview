//
//  SecondViewController.swift
//  Exercise1
//
//  Created by Hung Vuong on 5/26/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import UIKit

protocol SecondViewControllerDelegate {
    func backData (text: String)
}

class SecondViewController: UIViewController {

    @IBOutlet weak var textFieldScreen2: UITextField!
    
    var delegate: SecondViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.backData(text: textFieldScreen2.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
}
