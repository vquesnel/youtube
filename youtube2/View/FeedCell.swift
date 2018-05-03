//
//  FeedClass.swift
//  youtube
//
//  Created by victor quesnel on 29/04/2018.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

class FeedCell : BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
    
    let cellId = "cellId"
    
    lazy var width: CGFloat = {
        return frame.width
    }()
    
    var baseUrl: String = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    lazy var urlString: String = "home.json"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func setUpViews() {
        super.setUpViews()
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        downloadVideos(urlString: self.urlString)
    }
    
    func   downloadVideos(urlString: String) {
        guard let url = URL(string: "\(baseUrl)\(urlString)") else { return }
        let request = URLRequest(url: url)
        RequestService.shared.get(req: request, for: [Video].self) { data in
            guard let data = data else { return }
            self.videos = data
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (self.width - 32) * 9 / 16
        return CGSize(width: self.width, height: height + 16 + 8 + 44 + 12 + 36 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func layoutSubviews() {
        print("tototo")
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
    }
}
