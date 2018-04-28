//
//  ViewController.swift
//  youtube
//
//  Created by victor quesnel on 26/04/2018.
//  Copyright © 2018 victor quesnel. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.rgb(red: 239, green: 240, blue: 241)
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        collectionView?.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "mainCellId")
        collectionView?.contentInset = UIEdgeInsets(top: 41, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 41, left: 0, bottom: 0, right: 0)
        setUpMenubar()
        setUpNavbar()
        downloadVideos()
    }
    
    let menuBar: MenuBar  = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    let settingsLauncher = SettingsLauncher()
    
    func   downloadVideos() {
        guard let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json") else { return }
        let request = URLRequest(url: url)
        RequestService.shared.get(req: request, for: [Video].self) { data in
            guard let data = data else { return }
            self.videos = data
            self.collectionView?.reloadData()
        }
    }
    
    private func setUpMenubar() {
        view.addSubview(menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 41).isActive = true
    }
    
    private func setUpNavbar() {
        let searchButtonItem = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton, searchButtonItem]
    }
    
    @objc func handleSearch() {
        print("search")
    }


    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCellId", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 32) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 8 + 44 + 12 + 36 + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.settingsLauncher.collectionView.collectionViewLayout.invalidateLayout()
            self.settingsLauncher.updateSettings()
            self.menuBar.collectionView.collectionViewLayout.invalidateLayout()
            }, completion: nil)
    }
}


