//
//  ViewController.swift
//  HalfModalPresentationController
//
//  Created by Michael Lema on 8/8/17.
//  Copyright © 2017 Michael Lema. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    

    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Present modal", for: .normal)
        button.addTarget(self, action: #selector(handleModalPresentation), for: .touchUpInside)
        
        return button
    }()
    
    func setUpButtonConstraints() {
        view.addConstraintsWithFormat(format: "V:[v0(50)]-25-|", views: button)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(button)
        setUpButtonConstraints()

    }

  
        
    func handleModalPresentation() {
        print("Yeah something should happen")
        let vc = PresentingViewController()

        
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //vc.transitioningDelegate = self
        //navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)

    
        
    }

    
    
    
    


}

