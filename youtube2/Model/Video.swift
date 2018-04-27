//
//  Video.swift
//  youtube2
//
//  Created by Victor QUESNEL on 4/27/18.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import Foundation

class Video: NSObject, Decodable {
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: Int?
    var duration: Int?
    var uploadDate: Date?
    var channel: Channel?
    
    private enum CodingKeys : String, CodingKey {
        case title, duration, channel, uploadDate
        case thumbnailImageName = "thumbnail_image_name"
        case numberOfViews = "number_of_views"
    }
}

class Channel: NSObject, Decodable {
    var name: String?
    var profileImageName: String?
    private enum CodingKeys : String, CodingKey {
        case name
        case profileImageName = "profile_image_name"
    }
}
