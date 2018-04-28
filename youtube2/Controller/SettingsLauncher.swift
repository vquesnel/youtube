//
//  SettingsLauncher.swift
//  youtube
//
//  Created by victor quesnel on 28/04/2018.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackBlur = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 216, green: 216, blue: 216)
        cv.layer.cornerRadius = 16
        cv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return cv
    }()
    
    let settings: [Setting] = {
       return [
        Setting(name: "Settings", imageName: "settings"),
        Setting(name: "Terms & privacy policy", imageName: "privacy"),
        Setting(name: "Send Feedback", imageName: "feedback"),
        Setting(name: "Help", imageName: "help"),
        Setting(name: "Switch Account", imageName: "switch"),
        Setting(name: "Cancel", imageName: "cancel")
        ]
    }()
    
    let cellHeight = 50
    
    @objc func showSettings() {
        guard let window = UIApplication.shared.keyWindow else { return }
        blackBlur.backgroundColor = UIColor(white: 0, alpha: 0.4)
        blackBlur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        window.addSubview(blackBlur)
        window.addSubview(collectionView)
        
        let height: CGFloat = CGFloat(settings.count * cellHeight)
        let y = window.frame.height - height
        collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        blackBlur.frame = window.frame
        blackBlur.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackBlur.alpha = 1
            self.collectionView.frame = CGRect(x: self.collectionView.frame.minX, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: nil)
    }

    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackBlur.alpha = 0
            guard let window = UIApplication.shared.keyWindow else { return }
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: "cellId")
    }
}
