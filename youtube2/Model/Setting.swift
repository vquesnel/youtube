//
//  Setting.swift
//  youtube
//
//  Created by victor quesnel on 28/04/2018.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: NameSetting
    let imageName: String
    let color: UIColor?
    
    init(name: NameSetting, imageName: String, color: UIColor?) {
        self.name = name
        self.imageName = imageName
        self.color = color
    }
}

enum NameSetting: String {
    case Cancel = "Cancel"
    case Terms = "Terms & privacy policy"
    case Feedback = "Send Feedback"
    case Help = "Help"
    case Switch = "Switch Account"
    case Settings = "Settings"
}
