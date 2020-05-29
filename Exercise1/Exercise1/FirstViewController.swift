//
//  ViewController.swift
//  Exercise1
//
//  Created by Hung Vuong on 5/26/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var labelScreen1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
        }
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension FirstViewController: SecondViewControllerDelegate {
    func backData(text: String) {
        labelScreen1.text = text
    }
    
}


