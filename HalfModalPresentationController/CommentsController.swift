//
//  PresentingViewController.swift
//  HalfModalPresentationController
//
//  Created by Michael Lema on 8/9/17.
//  Copyright © 2017 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class CommentsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let cellId = "CellId"
    var messages = [String]()
    lazy var backdropView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    let commentsView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2), collectionViewLayout: UICollectionViewFlowLayout())
    var commentsViewHeight = UIScreen.main.bounds.height / 2
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
        commentsView.delegate = self
        commentsView.dataSource = self
        commentsView.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        commentsView.backgroundColor = UIColor.init(hexString: "#EFEFEF")
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(commentsView)
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        setUpCommentsView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
        addNavBar()
        for message in 1...25 {
            messages.append("This is message number: \(message)")
        }
    }
    func setUpCommentsView() {
        commentsView.heightAnchor.constraint(equalToConstant: commentsViewHeight).isActive = true
        commentsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        commentsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        commentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func updateCommentsViewConstraints() {
        commentsViewHeight = UIScreen.main.bounds.height
        self.commentsView.heightAnchor.constraint(equalToConstant: self.commentsViewHeight).isActive = true
        self.commentsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.commentsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.commentsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    func addNavBar() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44))
        navBar.setBackgroundImage(UIImage(), for: .default)
        //navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = UIColor.clear
        self.commentsView.addSubview(navBar)
        //: Set Title
        let navItem = UINavigationItem(title: "Comments")
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.init(hexString: "#706F6F")]
        //: Set Bar Items
        let cancelImage = UIImage(named: "Cancel")?.withRenderingMode(.alwaysOriginal)
        navItem.leftBarButtonItem = UIBarButtonItem(image: cancelImage, style: .plain, target: self, action: #selector(dismissView))
        let composeButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
        composeButton.tintColor = UIColor.init(hexString: "#706F6F")
        navItem.rightBarButtonItem = composeButton
        navBar.setItems([navItem], animated: false)
    }
    //: MARK: - ACTIONS
    func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    func actionButtonTapped() {
        //: Remove all constraints from commentsView
        for constraint in self.commentsView.constraints {
            commentsView.removeConstraint(constraint)
        }
        //: This will help animate the messageInputContainerView when its bottom constraint is updated and the message list to move up
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.updateCommentsViewConstraints()
            self.view.layoutIfNeeded()
        }, completion: { (_) in
        })
    }
    //: MARK: - CollectionView properties
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        let message = messages[indexPath.row]
        cell.messageTextView.text = message
        cell.profileImageView.image = UIImage(named: "Icon")
        //: Changing the width of each cell to 250
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        //: Added 8 pixels in the x position to give the messageTextView more left spacing and 40 more pixels to show the profile image
        cell.messageTextView.frame = CGRect(x: 8 + 48, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        //: The following line sets the cell's textBubbleView frame, also added 8 pixels to the width since the messageTextView's x position has changed.
        cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
        cell.profileImageView.isHidden = false
        //: It is important to have these three lines for both outgoing and incoming messages because when the cells get recycled, it resets all its following properties.
        cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
        cell.bubbleImageView.tintColor = .white
        cell.messageTextView.textColor = UIColor.black
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        //: Now that we have the estimated frame, we can return a CGSize
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    }
}
extension CommentsController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
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
        if isPresenting {
            containerView.addSubview(toVC.view)
            commentsView.frame.origin.y += commentsViewHeight
            backdropView.alpha = 0
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.commentsView.frame.origin.y -= self.commentsViewHeight
                self.backdropView.alpha = 1
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.commentsView.frame.origin.y += self.commentsViewHeight
                self.backdropView.alpha = 0
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
