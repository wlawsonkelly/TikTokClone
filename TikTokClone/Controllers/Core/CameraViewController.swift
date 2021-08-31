//
//  CameraViewController.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/19/21.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var captureSession = AVCaptureSession()

    var videoCaptureDevice: AVCaptureDevice?

    var captureOutPut = AVCaptureMovieFileOutput()

    var capturePreviewLayer: AVCaptureVideoPreviewLayer?

    var recordedVideoURL: URL?

    private var previewLayer: AVPlayerLayer?

    private let recordButton = RecordButton()

    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = true
        view.addSubview(cameraView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
        setupCamera()
        view.addSubview(recordButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(
            x: (view.width - size) / 2,
            y: view.height - view.safeAreaInsets.bottom - size - 5,
            width: size,
            height: size
        )
    }

    func setupCamera() {
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }

        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }

        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutPut) {
            captureSession.addOutput(captureOutPut)
        }

        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds

        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        captureSession.startRunning()
    }

    @objc fileprivate func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }

    @objc fileprivate func didTapRecord() {
        if captureOutPut.isRecording {
            recordButton.toggle(for: .notRecording)
            captureOutPut.stopRecording()
        } else {
            guard var url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                return
            }
            url.appendPathComponent("video.mov")

            recordButton.toggle(for: .recording)

            try? FileManager.default.removeItem(at: url)

            captureOutPut.startRecording(
                to: url,
                recordingDelegate: self
            )
        }
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            return
        }

        recordedVideoURL = outputFileURL

        print("finished recording", outputFileURL.absoluteString)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))

        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        if let previewLayer = previewLayer {
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = cameraView.bounds
            cameraView.layer.addSublayer(previewLayer)
            recordButton.isHidden = true
            previewLayer.player?.play()
        }
    }

    @objc fileprivate func didTapNext() {
        guard let url = recordedVideoURL else {
            return
        }
        let vc = CaptionViewController(videoUrl: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}
