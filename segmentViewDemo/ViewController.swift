//
//  ViewController.swift
//  segmentViewDemo
//
//  Created by jiali on 2020/12/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        let vc = ContentViewController()
        let navigation = UINavigationController(rootViewController: vc)
        present(navigation, animated: true, completion: nil)
    }
}

