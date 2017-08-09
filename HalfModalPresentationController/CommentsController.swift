//
//  PresentingViewController.swift
//  HalfModalPresentationController
//
//  Created by Michael Lema on 8/9/17.
//  Copyright © 2017 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class PresentingViewController: UIViewController {
    
    var popButtonIsShowing = false
    
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Pop", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    let menuView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2), collectionViewLayout: UICollectionViewFlowLayout())
    var menuHeight = UIScreen.main.bounds.height / 2
    var isPresenting = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        view.addSubview(button)
        
        setUpViews()
        menuView.backgroundColor = EC
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
        
        addNavBar()
        
        
        
    }
    
    func addNavBar() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44))
        
        //: Hide navBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = UIColor.clear
        
        self.menuView.addSubview(navBar)
        let navItem = UINavigationItem(title: "Comments")
        let cancelImage = UIImage(named: "Cancel")?.withRenderingMode(.alwaysOriginal)
        navItem.leftBarButtonItem = UIBarButtonItem(image: cancelImage, style: .plain, target: self, action: #selector(dismissView))
        navBar.setItems([navItem], animated: false)
        
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpViews() {
        view.addConstraintsWithFormat(format: "V:[v0(50)]-25-|", views: button)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: button)
        
        
    }
    
    func dismissView() {
        print("Dismiss")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func buttonTapped() {
        

        
        menuHeight = UIScreen.main.bounds.height
        
        for constraint in self.menuView.constraints {
            constraint.isActive = false
        }
        //: This will help animate the messageInputContainerView when its bottom constraint is updated and the message list to move up
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.menuView.heightAnchor.constraint(equalToConstant: self.menuHeight).isActive = true
            self.menuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.menuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.menuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            
            self.view.layoutIfNeeded()
            
            
        }, completion: { (completed) in
            
            
            
        })
        
        
    }
    
    
}


extension PresentingViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
