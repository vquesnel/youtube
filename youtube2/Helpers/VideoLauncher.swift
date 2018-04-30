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
    
    lazy var PausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()

    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.thumbTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    var player: AVPlayer?
    
    var isPlaying = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpPlayerView()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(loadingWheel)
        loadingWheel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingWheel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(slider)
        slider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 20).isActive = true

        controlsContainerView.addSubview(PausePlayButton)
        PausePlayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        PausePlayButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        PausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        PausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundColor = .black
    }

    
    private func setUpPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        
        guard let url = URL(string: urlString) else { return }
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.frame
//        self.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
        player?.play()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
    }
    
    @objc func handleTouch () {
        isPlaying = !isPlaying
        handlePause()
    }
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            PausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
             PausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
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
            controlsContainerView.backgroundColor = .clear
            PausePlayButton.isHidden = false
            isPlaying = true
            
            guard let duration = player?.currentItem?.duration else { return }
            let seconds = CMTimeGetSeconds(duration)
            let secondsText = Int(seconds.truncatingRemainder(dividingBy: 60))
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            videoLengthLabel.text = "\(minutesText):\(secondsText)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
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
}
