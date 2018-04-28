//
//  Setting.swift
//  youtube
//
//  Created by victor quesnel on 28/04/2018.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    let color: UIColor?
    
    init(name: String, imageName: String, color: UIColor?) {
        self.name = name
        self.imageName = imageName
        self.color = color
    }
}
