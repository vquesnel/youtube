//
//  SettingCell.swift
//  youtube
//
//  Created by victor quesnel on 28/04/2018.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    var color: UIColor?
    
    var setting: Setting? {
        didSet {
            guard let name = setting?.name, let imageName = setting?.imageName else { return }
            nameLabel.text = name
            IconImageView.image = UIImage(named:  imageName)?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.rgb(red: 230, green: 32, blue: 31) : color
            IconImageView.tintColor = isHighlighted ?  .white : .lightGray
            nameLabel.textColor = isHighlighted ? .white : .lightGray
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let IconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .lightGray
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(nameLabel)
        addSubview(IconImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        IconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        IconImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 14).isActive = true
        IconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        IconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        IconImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: IconImageView.trailingAnchor, constant: 14).isActive = true
    }
}
