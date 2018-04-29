//
//  BaseCell.swift
//  youtube
//
//  Created by victor quesnel on 29/04/2018.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
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
