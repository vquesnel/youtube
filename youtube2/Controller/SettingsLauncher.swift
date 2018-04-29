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
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 16
        cv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return cv
    }()
    
    let settings: [Setting] = {
       return [
        Setting(name: .Settings, imageName: "settings", color: nil),
        Setting(name: .Terms, imageName: "privacy", color:  UIColor.rgb(red: 239, green: 240, blue: 241)),
        Setting(name: .Feedback, imageName: "feedback", color: nil),
        Setting(name: .Help, imageName: "help",  color: UIColor.rgb(red: 239, green: 240, blue: 241)),
        Setting(name: .Switch, imageName: "switch",  color: nil),
        Setting(name: .Cancel, imageName: "cancel", color: UIColor.rgb(red: 239, green: 240, blue: 241))
        ]
    }()
    
    let cellHeight = 50
    
    var isActive = false
    
    var homeController: HomeController?
    
    @objc func showSettings() {
        guard let window = UIApplication.shared.keyWindow else { return }
        blackBlur.backgroundColor = UIColor(white: 0, alpha: 0.4)
        blackBlur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        window.addSubview(blackBlur)
        window.addSubview(collectionView)
        isActive = true
        let height: CGFloat = CGFloat(settings.count * cellHeight)
        let y = window.frame.height - height
        collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        blackBlur.frame = window.frame
        blackBlur.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackBlur.alpha = 1
            self.collectionView.frame = CGRect(x: self.collectionView.frame.minX, y: y, width: window.frame.width, height: height)
        }, completion: nil)
    }
    
    func updateSettings() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(blackBlur)
        window.addSubview(collectionView)
        let height: CGFloat = CGFloat(settings.count * cellHeight)
        let y = window.frame.height - height
        blackBlur.frame = window.frame
        blackBlur.alpha = isActive ? 1 : 0
        collectionView.frame = isActive ? CGRect(x: collectionView.frame.minX, y: y, width: window.frame.width, height: height) :CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
    }
    

    @objc func handleDismiss(setting: Setting) {
        isActive = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackBlur.alpha = 0
            guard let window = UIApplication.shared.keyWindow else { return }
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height:
                self.collectionView.frame.height)
        }) { (completion: Bool) in
            if setting.name != .Cancel {
                self.homeController?.showControllerForSetting(setting: setting)
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: "cellId")
    }
}
