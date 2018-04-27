//
//  MenuBar.swift
//  youtube
//
//  Created by victor quesnel on 26/04/2018.
//  Copyright © 2018 victor quesnel. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let cellId = "cellId"
    let imageNames = ["home", "trending", "subscriptions", "account"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "cellId")
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MenuCell
        
        cell.ImageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 41, green: 43, blue: 54)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    
    let ImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            ImageView.tintColor = isHighlighted ? UIColor.rgb(red: 239, green: 240, blue: 241) : UIColor.rgb(red: 41, green: 43, blue: 54)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            ImageView.tintColor = isSelected ? UIColor.rgb(red: 239, green: 240, blue: 241) : UIColor.rgb(red: 41, green: 43, blue: 54)
        }
    }
    
    override func setUpViews() {
        addSubview(ImageView)
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        ImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        ImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
}

