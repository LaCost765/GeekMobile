//
//  RotateNavigationController.swift
//  GeekMobile
//
//  Created by Egor on 02.04.2021.
//

import UIKit

class RotateNavigationController: UINavigationController {

    private let navigationDelegate = RotateNavigationControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = navigationDelegate
    }

}
