//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 조혜인 on 2022/02/07.
//

import UIKit

class SeguePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
