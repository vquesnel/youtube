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
    
    var videoLauncherView: UIView?
    
    let loadingWheel: UIActivityIndicatorView = {
        let lw = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        lw.translatesAutoresizingMaskIntoConstraints = false
        lw.startAnimating()
        return lw
    }()
    
    var checker = true
    var isPlaying = false
    
    lazy var ExitButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "arrow")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ButtonDown)))
        return button
    }()
    
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
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.rgb(red: 30, green: 30, blue: 30).cgColor]
        gradientLayer.locations = [0.8, 1.4]
        return gradientLayer
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
    
    init(frame: CGRect, view: UIView) {
        videoLauncherView = view
        super.init(frame: frame)
        
        setUpPlayerView()
        
        controlsContainerView.frame = frame
        controlsContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTouch)))
        
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
        
        controlsContainerView.addSubview(ExitButton)
        ExitButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        ExitButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        ExitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        ExitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        let intervalDisplay = CMTime(value: 10, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: intervalDisplay, queue: DispatchQueue.main, using: { (progressTime) in
            if (!self.slider.isHidden) {
                self.gradientLayer.removeFromSuperlayer()
                self.slider.isHidden = !self.slider.isHidden
                self.videoStatusView.isHidden = !self.videoStatusView.isHidden
                self.self.PausePlayButton.isHidden = !self.PausePlayButton.isHidden
                self.self.currentTimeLabel.isHidden = !self.currentTimeLabel.isHidden
                self.self.videoLengthLabel.isHidden = !self.videoLengthLabel.isHidden
                self.ExitButton.isHidden = !self.ExitButton.isHidden
            }
        })
    }
    
    @objc func handlePause() {
        controlsContainerView.backgroundColor = .clear
        if isPlaying {
            player?.pause()
            PausePlayButton.isHidden = false
            PausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            videoStatusView.setImage(UIImage(named: "play"), for: .normal)
            ExitButton.isHidden = false
        } else {
            player?.play()
            videoStatusView.setImage(UIImage(named: "pause"), for: .normal)
            PausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            slider.isHidden = true
            videoStatusView.isHidden = true
            PausePlayButton.isHidden = true
            currentTimeLabel.isHidden = true
            videoLengthLabel.isHidden = true
            ExitButton.isHidden = true
        }
        
        isPlaying = !isPlaying
    }
    
    @objc func handleTouch() {
        if (slider.isHidden) {
            controlsContainerView.layer.addSublayer(gradientLayer)
        }
        else {
            gradientLayer.removeFromSuperlayer()
        }
        slider.isHidden = !slider.isHidden
        videoStatusView.isHidden = !videoStatusView.isHidden
        PausePlayButton.isHidden = !PausePlayButton.isHidden
        currentTimeLabel.isHidden = !currentTimeLabel.isHidden
        videoLengthLabel.isHidden = !videoLengthLabel.isHidden
        ExitButton.isHidden = !ExitButton.isHidden
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
    
    var initialCenter = CGPoint()
    
    @objc func ButtonDown(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        let translation = gestureRecognizer.translation(in: videoLauncherView?.superview)
        if gestureRecognizer.state == .began {
            self.initialCenter = (videoLauncherView?.center)!
        }
        if gestureRecognizer.state != .cancelled {
            if translation.y > keyWindow.frame.height / 2 {
                slider.removeFromSuperview()
                videoStatusView.removeFromSuperview()
                PausePlayButton.removeFromSuperview()
                currentTimeLabel.removeFromSuperview()
                videoLengthLabel.removeFromSuperview()
                player?.seek(to: CMTimeMake(0, 1))
                player?.pause()
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.videoLauncherView?.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
                }, completion: { _ in
                    self.videoLauncherView?.removeFromSuperview()
                })
            }
        }

    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
        controlsContainerView.setNeedsLayout()
        self.layer.setNeedsLayout()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            loadingWheel.stopAnimating()
            if(checker) {
                PausePlayButton.isHidden = false
                checker = false
            }
            if (isPlaying) {
                PausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            }
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
    
    var homeController: HomeController?
    var view: UIView?
    var videoPlayer: VideoPlayerView?
    
    func showVideoPlayer(){
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        view = UIView(frame: keyWindow.frame)
        
        guard let view = view else { return }
        view.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
        view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
        
        var height = keyWindow.frame.height
        if (height > keyWindow.frame.width) {
            height = keyWindow.frame.width * 9 / 16
        }
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
        videoPlayer = VideoPlayerView(frame: videoPlayerFrame, view: view)
        
        guard let videoPlayer = videoPlayer else { return }
        view.addSubview(videoPlayer)
        keyWindow.addSubview(view)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view?.frame = keyWindow.frame
        }, completion: { _ in
            UIApplication.shared.isStatusBarHidden = true
        })
    }

    func updateSettings() {
        guard let view = view  else { return }
        if (view.superview != nil) {
            print("sdfsdfsdF")
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            guard let player = videoPlayer else { return }
            view.frame = keyWindow.frame
            view.backgroundColor = UIColor.rgb(red: 36, green: 36, blue: 36)
            view.frame = view.superview != nil ? CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height)
            : CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            var height = keyWindow.frame.height - 10
            if keyWindow.frame.width < keyWindow.frame.height {
                height = keyWindow.frame.width * 9 / 16
            }
            view.frame = keyWindow.frame
            videoPlayer?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            videoPlayer?.setNeedsLayout()
            view.addSubview(player)
            keyWindow.addSubview(view)
        }
    }
}
