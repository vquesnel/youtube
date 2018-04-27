//
//  VideoCell.swift
//  youtube
//
//  Created by victor quesnel on 26/04/2018.
//  Copyright © 2018 victor quesnel. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init hasn't bee implemented ")
    }
    
}
class VideoCell: BaseCell {
    let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IMG_3126")
        imageView.layer.cornerRadius = 22
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "First Swift app - ZdpC0rp"
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        textView.isEditable = false
        return textView
    }()
    
    let separtorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setUpViews() {
        addSubview(thumbNailImageView)
        addSubview(separtorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        thumbNailImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        thumbNailImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        thumbNailImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        thumbNailImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
        
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 8).isActive = true
        userProfileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        subtitleTextView.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        subtitleTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        separtorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        separtorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        separtorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separtorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -1).isActive = true
    }
}
