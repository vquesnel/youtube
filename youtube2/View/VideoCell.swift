//
//  VideoCell.swift
//  youtube
//
//  Created by victor quesnel on 26/04/2018.
//  Copyright © 2018 victor quesnel. All rights reserved.
//

import UIKit

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            guard let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews else { return }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            subtitleTextView.text = "\(channelName) - \(numberFormatter.string(from: NSNumber(value: numberOfViews))!) views - 2 years ago"
            guard let profileImageName = video?.channel?.profileImageName else { return }
            RequestService.shared.imageDownloader(url: profileImageName) { image in
                self.userProfileImageView.image = image
            }
            subtitleTextView.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
            
            guard let thumbnailImageUrl = video?.thumbnailImageName else { return }
            loadingWheel.startAnimating()
            RequestService.shared.imageDownloader(url: thumbnailImageUrl) { image in
                self.loadingWheel.stopAnimating()
                self.thumbNailImageView.image = image
            }
    
            guard let title = video?.title else { return }
            titleLabel.text = title
            titleLabel.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
            let size = CGSize(width: frame.width - 84, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [.font : UIFont.systemFont(ofSize: 14)], context: nil)
            titleHeightConstant?.constant = estimatedRect.size.height > 20 ? 44 : 20
        }
    }
    
    var titleHeightConstant: NSLayoutConstraint?
    
    let loadingWheel: UIActivityIndicatorView = {
        let lw = UIActivityIndicatorView()
        lw.hidesWhenStopped = true
        lw.color = .black
        return lw
    }()
    
    let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
        return imageView
    }()
    
    var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
        return textView
    }()
    
    let separtorView : UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.rgb(red: 30, green: 30, blue: 30)
        return view
    }()
    
    override func setUpViews() {
        addSubview(thumbNailImageView)
        addSubview(separtorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        addSubview(loadingWheel)
        
        
        thumbNailImageView.translatesAutoresizingMaskIntoConstraints = false
        separtorView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleTextView.translatesAutoresizingMaskIntoConstraints = false
        loadingWheel.translatesAutoresizingMaskIntoConstraints = false
        
        thumbNailImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        thumbNailImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        thumbNailImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 26).isActive = true
        thumbNailImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -102).isActive = true
        
        loadingWheel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadingWheel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        loadingWheel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        loadingWheel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
        
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 14).isActive = true
        userProfileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        titleHeightConstant = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        titleHeightConstant?.isActive = true
        subtitleTextView.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        subtitleTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        separtorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separtorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separtorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -1).isActive = true
    }
}

