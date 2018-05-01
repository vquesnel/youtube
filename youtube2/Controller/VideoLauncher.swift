//
//  VideoLauncher.swift
//  youtube
//
//  Created by Victor QUESNEL on 4/30/18.
//  Copyright © 2018 Victor QUESNEL. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let loadingWheel: UIActivityIndicatorView = {
        let lw = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        lw.translatesAutoresizingMaskIntoConstraints = false
        lw.startAnimating()
        return lw
    }()
    
    var checker = true
    var isPlaying = false
    
    lazy var PausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
        return view
    }()
    
    let videoStatusView: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "stop")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()

    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        slider.maximumTrackTintColor = .white
        slider.thumbTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpPlayerView()
        
        setUpGradientLayer()
        
        controlsContainerView.frame = frame
        
        addSubview(controlsContainerView)
        controlsContainerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        controlsContainerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        controlsContainerView.addSubview(loadingWheel)
        loadingWheel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingWheel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        controlsContainerView.addSubview(videoStatusView)
        videoStatusView.leftAnchor.constraint(equalTo: leftAnchor, constant: 6).isActive = true
        videoStatusView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        videoStatusView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        videoStatusView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: videoStatusView.rightAnchor, constant: 6).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(slider)
        slider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        controlsContainerView.addSubview(PausePlayButton)
        PausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        PausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        PausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        PausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
    }

    
    private func setUpPlayerView() {
        let urlString = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        
        guard let url = URL(string: urlString) else { return }
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.frame
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        //progress tracker
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            self.currentTimeLabel.text = "\(minutesText):\(secondsText)"
            guard let duration = self.player?.currentItem?.duration else { return }
            let durationSeconds = CMTimeGetSeconds(duration)
            self.slider.value = Float(seconds / durationSeconds)
        })
    }
    
    private func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.rgb(red: 30, green: 30, blue: 30)]
        gradientLayer.locations = [0.6, 1.2]
        
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    @objc func handlePause() {
        controlsContainerView.backgroundColor = .clear
        if isPlaying {
            player?.pause()
            PausePlayButton.isHidden = false
            PausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            videoStatusView.setImage(UIImage(named: "play"), for: .normal)
        } else {
            print("handlePause")
            player?.play()
            PausePlayButton.isHidden = true
            videoStatusView.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
    @objc func handleSliderChange() {
        guard let duration = player?.currentItem?.duration else { return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let value = Float64(slider.value) * totalSeconds
        let seekTime = CMTime(value: Int64(value), timescale: 1)
        player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            //do stuff
            
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            loadingWheel.stopAnimating()
            if(checker) {
                PausePlayButton.isHidden = false
                checker = false
            }
            PausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            guard let duration = player?.currentItem?.duration else {
                return
            }
            let seconds = CMTimeGetSeconds(duration)
            let secondsText = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            videoLengthLabel.text = "\(minutesText):\(secondsText)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoLauncher: NSObject {
    
    var isDisplay = false

    func showVideoPlayer(){
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        
        let view = UIView(frame: keyWindow.frame)
        
        view.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
        view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
        let height = keyWindow.frame.width * 9 / 16
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
        let videoPlayer = VideoPlayerView(frame: videoPlayerFrame)
        
        view.addSubview(videoPlayer)
        keyWindow.addSubview(view)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.frame = keyWindow.frame
        }, completion: { _ in
            UIApplication.shared.isStatusBarHidden = true
        })
        
    }
//
//    func updateSettings() {
//        guard let keyWindow = UIApplication.shared.keyWindow else { return }
//
//        view.frame = keyWindow.frame
//        view.backgroundColor = .blue// UIColor.rgb(red: 36, green: 36, blue: 36)
//        view.frame = isDisplay ? CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height)
//            : CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
//        var height = keyWindow.frame.height - 10
//        if keyWindow.frame.width < keyWindow.frame.height {
//
//            height = keyWindow.frame.width * 9 / 16
//        }
//        videoPlayer.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
//        view.addSubview(self.videoPlayer)
//        keyWindow.addSubview(self.view)
//    }
}
