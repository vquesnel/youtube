//
//  TrendingCell.swift
//  youtube
//
//  Created by Victor QUESNEL on 4/30/18.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
  
    override lazy var urlString: String = {
        return "trending.json"
    }()
}
