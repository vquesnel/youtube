//
//  SettingCell.swift
//  youtube
//
//  Created by victor quesnel on 28/04/2018.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    var setting: Setting? {
        didSet {
            guard let name = setting?.name, let imageName = setting?.imageName else { return }
            nameLabel.text = name
            IconImageView.image = UIImage(named:  imageName)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray :  UIColor.rgb(red: 216, green: 216, blue: 216)
            IconImageView.tintColor = isHighlighted ?  UIColor.rgb(red: 216, green: 216, blue: 216) : .darkGray
            nameLabel.textColor = isHighlighted ? UIColor.rgb(red: 216, green: 216, blue: 216) : .darkGray
        }
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let IconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .darkGray
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(nameLabel)
        addSubview(IconImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        IconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        IconImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        IconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        IconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        IconImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: IconImageView.trailingAnchor, constant: 8).isActive = true
    }
}
