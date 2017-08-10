//
//  ECMessageCollectionViewCell.swift
//  EduChat
//
//  Created by Michael Lema on 7/26/17.
//  Copyright © 2017 Urlinq. All rights reserved.
//

import Foundation
import UIKit

//: For each of the cell's in the UICollectionView
class ChatLogMessageCell: BaseCell {
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = UIColor.clear
        //: Issue with textview being cut off, this will resolve it
        textView.isScrollEnabled = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        //: Make the bubbleView rounded
        view.layer.cornerRadius = 15
        //: To get the cornerRadius to show, do the following line
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        // withRenderingMode(.alwaysTemplate) draws the image as a template image, ignoring its color information
        imageView.image = ChatLogMessageCell.grayBubbleImage
        //: Now that the image is rendered as a template image, the tint color can be modified
        imageView.tintColor = UIColor(white: 0.95, alpha: 1)
        return imageView
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
    
        //: Constraints for the profileImageView inside the cell
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = UIColor.white
        
        //: Add comments bubbles to textBubbleView
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
    }
}
