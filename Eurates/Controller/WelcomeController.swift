//
//  ViewController.swift
//  Eurates
//
//  Created by Daniel Frost on 17/04/2018.
//  Copyright © 2018 Daniel Frost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isToolbarHidden = true;
        ViewController.setButton(button: registerButton, radius: 5.0)
        ViewController.setButton(button: loginButton, radius: 5.0)
    }
    
    static func setButton(button: UIButton, radius: CGFloat) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = radius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

