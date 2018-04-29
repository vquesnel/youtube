//
//  ViewController.swift
//  youtube
//
//  Created by victor quesnel on 26/04/2018.
//  Copyright © 2018 victor quesnel. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    var scrollPosition: CGFloat = {
        return 0
    }()
    
    lazy var menuBar: MenuBar  = {
        let mb = MenuBar()
        mb.homeController = self
        mb.layer.cornerRadius = 16
        mb.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        mb.clipsToBounds = true
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    var scrollX: CGFloat = {
        return 0
    }()
    
    var scrollWillEndingX: CGFloat = {
        return 0
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.rgb(red: 192, green: 192, blue: 193)
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        navigationItem.titleView = titleLabel
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 192, green: 192, blue: 193)
        setUpCollectionView()
        setUpMenubar()
        setUpNavbar()
     }
    
    func setUpCollectionView() {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        collectionView?.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 41, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 41, left: 0, bottom: 0, right: 0)
        collectionView?.isPagingEnabled = true
    }
    
    private func setUpMenubar() {
        navigationController?.hidesBarsOnSwipe = true
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addSubview(menuBar)
        
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50).isActive = true
        redView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        redView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 41).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func setUpNavbar() {
        let searchButtonItem = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton, searchButtonItem]
    }
    
    @objc func handleSearch() {
        print("search")
    }

    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        scrollWillEndingX = CGFloat(menuIndex)
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true )
        changeTitle(index: menuIndex)
    }
    
    func showControllerForSetting(setting: Setting) {
        let settingsControllerView = UIViewController()
        settingsControllerView.view.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
        settingsControllerView.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 192, green: 192, blue: 193)]
        navigationController?.navigationBar.tintColor = UIColor.rgb(red: 192, green: 192, blue: 193)
        navigationController?.pushViewController(settingsControllerView, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollX = scrollView.contentOffset.x / 4
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollX 
    }
    
    private func changeTitle(index: Int) {
        guard let titleLabel = navigationItem.titleView as? UILabel else { return }
        titleLabel.text = "  \(titles[index])"
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollWillEndingX = CGFloat(targetContentOffset.pointee.x)
        let index = scrollWillEndingX / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        changeTitle(index: Int(index))
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 41)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        let x = self.scrollX / self.view.frame.width
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.collectionViewLayout.collectionView?.collectionViewLayout.invalidateLayout()
            self.settingsLauncher.collectionView.collectionViewLayout.invalidateLayout()
            self.settingsLauncher.updateSettings()
            self.menuBar.collectionView.collectionViewLayout.invalidateLayout()
            self.menuBar.updateConstraints(x: x)
        }) { (completion: UIViewControllerTransitionCoordinatorContext) in
            self.scrollX = x * self.view.frame.width
        }
    }
}


