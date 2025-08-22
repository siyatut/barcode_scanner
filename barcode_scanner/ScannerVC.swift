//
//  ScannerVC.swift
//  barcode_scanner
//
//  Created by Anastasia Tyutinova on 22/8/2568 BE.
//

import UIKit
import AVFoundation

enum CameraError: String {
    case invalidDeviceInput = "Something went wrong while creating the video input. We are unable to scan barcodes"
    case invalidScanValue = "The value scanned is not valid. This app scans EAN-8 and EAN-13."
}

protocol ScannerVCDelegate: AnyObject {
    
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    private let sessionQueue = DispatchQueue(label: "scanner.session.queue")
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }
            
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }
            
            let metaDataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddOutput(metaDataOutput) {
                captureSession.addOutput(metaDataOutput)
                
                metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
                metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
            } else {
                DispatchQueue.main.async {
                    self.scannerDelegate?.didSurface(error: .invalidDeviceInput)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer?.videoGravity = .resizeAspectFill
                if let previewLayer = self.previewLayer {
                    self.view.layer.addSublayer(previewLayer)
                    previewLayer.frame = self.view.layer.bounds
                }
            }
            
            captureSession.startRunning()
            
        }
    }
}


extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScanValue)
            return
        }
        
        guard let machineReadableCodeObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScanValue)
            return
        }
        
        guard let barcode = machineReadableCodeObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScanValue)
            return
        }
        
        scannerDelegate?.didFind(barcode: barcode)
        
    }
}



