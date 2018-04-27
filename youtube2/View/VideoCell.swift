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
    
    var video: Video? {
        didSet {
            if let title = video?.title {
                titleLabel.text = title
            }
            if let thumbnailImageUrl = video?.thumbnailImageName {
                loadingWheel.startAnimating()
                RequestService.shared.imageDownloader(url: thumbnailImageUrl) { image in
                    self.loadingWheel.stopAnimating()
                    self.thumbNailImageView.image = image
                }
            }
            if let profileImageName = video?.channel?.profileImageName {
                RequestService.shared.imageDownloader(url: profileImageName) { image in
                    self.userProfileImageView.image = image
                }
            }
            if let channelName = video?.channel?.name, let numberOfViews = video?.numberOfViews {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let subtitleText = "\(channelName) - \(numberFormatter.string(from: NSNumber(value: numberOfViews))!) views - 2 years ago"
                subtitleTextView.text = subtitleText
            }
            if let title = video?.title {
                let size = CGSize(width: frame.width - 84, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [.font : UIFont.systemFont(ofSize: 14)], context: nil)
                titleHeightConstant = estimatedRect.size.height > 20 ? 44 : 20
            }
        }
    }
    
    var titleHeightConstant: CGFloat?
    
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
        return imageView
    }()
    
    var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        textView.isEditable = false
        return textView
    }()
    
    let separtorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
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
        thumbNailImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        thumbNailImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
        
        loadingWheel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadingWheel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        loadingWheel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        loadingWheel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 8).isActive = true
        userProfileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        if let value = titleHeightConstant {
            titleLabel.heightAnchor.constraint(equalToConstant: value).isActive = true
        }
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

