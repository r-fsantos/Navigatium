//
//  ViewController.swift
//  Safarium
//
//  Created by Renato F. dos Santos Jr on 28/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    private func configureUI() {
        title = "Safarium"
        view.backgroundColor = .lightGray
    }
}

