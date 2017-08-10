//
//  ViewController.swift
//  HalfModalPresentationController
//
//  Created by Michael Lema on 8/8/17.
//  Copyright © 2017 Michael Lema. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let presentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Present modal", for: .normal)
        button.addTarget(self, action: #selector(handleModalPresentation), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(presentButton)
        setUpButtonConstraints()
    }
    func setUpButtonConstraints() {
        view.addConstraintsWithFormat(format: "V:[v0(50)]-25-|", views: presentButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: presentButton)
    }
    func handleModalPresentation() {
        let vc = CommentsController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}

