//
//  ViewController.swift
//  ReplayKitDemo
//
//  Created by luoxiao on 2021/10/21.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {

    var previewController: RPPreviewViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initUI()
        initConfig()
        initNotifcation()
    }

        
    lazy var startButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("开始", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .black
        b.layer.cornerRadius = 5
        b.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        return b
    }()
    
    
    lazy var exitButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("停止", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .black
        b.layer.cornerRadius = 5
        b.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        return b
    }()
    
    
    lazy var player: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        let player = AVPlayer()
        layer.player = player
        if let path = Bundle.main.path(forResource: "testDemo", ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            let item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
        }
        return layer
    }()
    
    
    func initUI() {
        view.backgroundColor = .white
        
        view.layer.addSublayer(player)
        player.frame = view.bounds
        player.player?.play()
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(150)
        }
        
        
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.size.centerX.equalTo(startButton)
            make.top.equalTo(startButton.snp.bottom).offset(80)
        }
        
        
    }
    
    
    func initConfig() {
        RPScreenRecorder.shared().delegate = self
        RPScreenRecorder.shared().isMicrophoneEnabled = true
    }
    
    func initNotifcation() {
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}



extension ViewController {
    
    @objc func startAction() {

//        RPScreenRecorder.shared().startCapture { buffer, bufferType, error in
//            if let er = error {
//                debugPrint(er)
//            }
//            else {
//                debugPrint(bufferType)
//                debugPrint(buffer)
//            }
//
//        } completionHandler: { error in
//            if let er = error {
//                debugPrint(er)
//            }
//        }
        
        RPScreenRecorder.shared().startRecording { error in
            debugPrint(error)
        }

    }
    
    @objc func exitAction() {
//        RPScreenRecorder.shared().stopCapture { error in
//            debugPrint(error)
//        }
        
        
        RPScreenRecorder.shared().stopRecording { previewCtr, error in
            if let ctr = previewCtr {
                self.previewController = ctr
                self.previewController?.previewControllerDelegate = self
                self.present(ctr, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func didPlayToEndTime() {
        player.player?.seek(to: .zero)
        player.player?.play()
    }
}


extension ViewController: RPScreenRecorderDelegate {
    
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        
        
    }
}



extension ViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        
        previewController.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        
        previewController.dismiss(animated: true) {
        
        }
        
        debugPrint(activityTypes)
        if activityTypes.contains("com.apple.UIKit.activity.SaveToCameraRoll") {
            Toast(text: "成功保存到相册").show()
        }
    }
}
