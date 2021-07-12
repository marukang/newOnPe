//
//  jugglingViewController.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/14.
//  Copyright © 2021 Google Inc. All rights reserved.
//
import UIKit
import AVFoundation

class jugglingViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    let ballFunction = BallFunction()
    let cameraSwitchBtn = UIButton()
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    let imageView = UIImageView()
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jugglingCalueInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        prepareCamera()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        jugglingCalueInit()
    }
    
    func jugglingCalueInit(){
        BallInformation.ball_position_red = 0
        BallInformation.ball_position_blue = 0
        BallInformation.ball_count = 0
        BallInformation.ball_arraylist.removeAll()
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        captureDevice = availableDevices.first
        beginSession()
        
        
    }
    
    func beginSession () {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
            
        }catch {
            print(error.localizedDescription)
        }
        
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        //self.previewLayer = previewLayer
        //self.view.layer.addSublayer(self.previewLayer)
        
        
        //self.previewLayer.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String):NSNumber(value:kCVPixelFormatType_32BGRA)]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        
        let queue = DispatchQueue(label: "com.brianadvent.captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
        
        self.view.addSubview(imageView)
        imageView.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.contentMode = .scaleAspectFit
        
        
        
        
        
    }
    
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var imageBuffer1 : CVImageBuffer?
        var lastTimestamp = CMTime()
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let deltaTime = timestamp - lastTimestamp
        if deltaTime >= CMTimeMake(value: 1, timescale: Int32(30)) {
            lastTimestamp = timestamp
            imageBuffer1 = CMSampleBufferGetImageBuffer(sampleBuffer)
        }
        guard let  imageBuffer = imageBuffer1 else { return }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        guard let quartzImage = context?.makeImage() else { return }
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        var image = UIImage(cgImage: quartzImage)
        //print(image)
        
        image = image.sd_rotatedImage(withAngle: (.pi / 2) * 3, fitSize: true)!
        //let imageWithLaneOverlay = OpenCVWrapper().opencvPractice(image)
        let xycordiResult : String = OpenCVWrapper().opencvJugliing(image)
        //print(xycordiResult)
        detectJuggoing(opencvXY: xycordiResult, Juggling_name: "")
        
        //let image1 = image.sd_rotatedImage(withAngle: (.pi / 2) * 3, fitSize: true)
        
        DispatchQueue.main.async {
            self.imageView.image = image
            
        }
        
        
    }
    
    func detectJuggoing(opencvXY : String, Juggling_name : String){
        let opencvboth_array : [String] = opencvXY.components(separatedBy: ",")
        let TAG : String = "저글링 측정 : "
        //print(TAG, "빨간공 x,y좌표: " + opencvred)
        //print(TAG, "빨간공  x좌표: " + opencvboth_array[0])
        //print(TAG, "빨간공  y좌표: " + opencvboth_array[1])
        
        let red_x : Int = Int(opencvboth_array[0]) ?? 0
        let red_y : Int = Int(opencvboth_array[1]) ?? 0
        let blue_x : Int = Int(opencvboth_array[2]) ?? 0
        let blue_y : Int = Int(opencvboth_array[3]) ?? 0
        
        if(red_x != 0 && red_y != 0 && blue_x != 0 && blue_y != 0){
            
            print(TAG, "빨간공: 추적 가능")
            
            if(red_x>360 && red_y<240){
                print(TAG, "빨간공: 1사분면")
                print(TAG, "빨간공  x좌표: " + opencvboth_array[0])
                print(TAG, "빨간공  y좌표: " + opencvboth_array[1])
                
                BallInformation.ball_position_red = 1
                
            }else if(red_x<360 && red_y<240){
                print(TAG, "빨간공: 2사분면")
                print(TAG, "빨간공  x좌표: " + opencvboth_array[0])
                print(TAG, "빨간공  y좌표: " + opencvboth_array[1])
                
                BallInformation.ball_position_red = 2
                
            }else if(red_x<360 && red_y>240){
                print(TAG, "빨간공: 3사분면")
                print(TAG, "빨간공  x좌표: " + opencvboth_array[0])
                print(TAG, "빨간공  y좌표: " + opencvboth_array[1])
                
                BallInformation.ball_position_red = 3
                
            }else if(red_x>360 && red_y>240){
                print(TAG, "빨간공: 4사분면")
                print(TAG, "빨간공  x좌표: " + opencvboth_array[0])
                print(TAG, "빨간공  y좌표: " + opencvboth_array[1])
                
                BallInformation.ball_position_red = 4
            }
            
            
            /////////////////////////////////////////////////////////////////////////
            
            
            if(blue_x>360 && blue_y<240){
                print(TAG, "파란공: 1사분면")
                print(TAG, "파란공  x좌표: " + opencvboth_array[2])
                print(TAG, "파란공  y좌표: " + opencvboth_array[3])
                
                BallInformation.ball_position_blue = 1
                
            }else if(blue_x<360 && blue_y<240){
                print(TAG, "파란공: 2사분면")
                print(TAG, "파란공  x좌표: " + opencvboth_array[2])
                print(TAG, "파란공  y좌표: " + opencvboth_array[3])
                
                BallInformation.ball_position_blue = 2
                
            }else if(blue_x<360 && blue_y>240){
                print(TAG, "파란공: 3사분면")
                print(TAG, "파란공  x좌표: " + opencvboth_array[2])
                print(TAG, "파란공  y좌표: " + opencvboth_array[3])
                
                BallInformation.ball_position_blue = 3
                
            }else if(blue_x>360 && blue_y>240){
                print(TAG, "파란공: 4사분면")
                print(TAG, "파란공  x좌표: " + opencvboth_array[2])
                print(TAG, "파란공  y좌표: " + opencvboth_array[3])
                
                BallInformation.ball_position_blue = 4
            }
            
            
            
            /////////////////////공 1개/////////////////////////
            //저글링 1단계 (위아래)
            //ballFunction.step1()
            //저글링 2단계 (양옆)
            //ballFunction.step2()
            //저글링 3단계 (삼각형) (반시계)
            //ballFunction.step3()
            //저글링 4단계 (산모양)
            //ballFunction.step4()
            /////////////////////공 2개/////////////////////////
            //저글링 5단계 (공 2개, 나란히 위아래)
            //ballFunction.step5()
            //저글링 6단계 (공 2개, 엇갈려 위아래)
            //ballFunction.step6()
            //저글링 7단계 (공 2개, 삼각형 저글링) (반시계방향)
            //ballFunction.step7()
            //저글링 8단계 (공 2개, 삼각형 저글링) (시계방향)
            //ballFunction.step8()
            //저글링 9단계 (공 2개, 산모양 저글링)
            //ballFunction.step9()
            //저글링 10단계 (공 2개, 헛갈려 저글링 잡기1)
            //ballFunction.step10()
            //저글링 11단계 (공 2개, 헛갈려 저글링 잡기2) (반시계방향)
            //ballFunction.step11()
            //저글링 12단계 (공 2개, 헛갈려 저글링 잡기2) (시계방향)
            //ballFunction.step12()
            
            if(Juggling_name=="공던져잡기(수평)"){
                ballFunction.step5()
            }else if(Juggling_name=="공던져잡기(엇갈려)"){
                ballFunction.step6()
            }else if(Juggling_name=="공던져잡기(반시계)"){
                ballFunction.step7()
            }else if(Juggling_name=="공던져잡기(시계)"){
                ballFunction.step8()
            }else if(Juggling_name=="저글링(산모양)"){
                ballFunction.step9()
            }else if(Juggling_name=="저글링(손등치기)"){
                //공던져잡기(수평)과 동일한 알고리즘
                ballFunction.step5()
            }else if(Juggling_name=="헛갈려저글링잡기1"){
                ballFunction.step10()
            }else if(Juggling_name=="헛갈려저글링잡기2(반시계)"){
                //반시계 방향
                ballFunction.step11(ball1_x: red_x,ball1_y: red_y,ball2_x: blue_x,ball2_y: blue_y)
            }else if(Juggling_name=="헛갈려저글링잡기2(시계)"){
                //시계 방향
                ballFunction.step12(ball1_x: red_x,ball1_y: red_y,ball2_x: blue_x,ball2_y: blue_y)
            }else if(Juggling_name=="헛갈려저글링잡기3"){
                //공던져잡기(수평)과 동일한 알고리즘
                ballFunction.step5()
            }else if(Juggling_name=="한공잡기"){
                //공던져잡기(엇갈려)과 동일한 알고리즘
                ballFunction.step6()
            } else if Juggling_name == "" {
                
            } else {
                ballFunction.step1()
            }
            
            /*
             //개수 TEXTVIEW에 나타내기
             new Thread(new Runnable() {
             @Override
             public void run() {
             runOnUiThread(new Runnable(){
             @Override
             public void run() {
             print(TAG, "저글링 개수 쓰레드")
             ball_textview.setText(Juggling_name + "개수 : "+String.valueOf(BallInformation.ball_count))
             }
             })
             }
             }).start()
             */
            
            
            
        }else{
            print(TAG, "빨간공 or 파란공: 추적 불가")
            //공 포지션 0
            BallInformation.ball_position_red = 0
            //공 포지션 0
            BallInformation.ball_position_blue = 0
            //공 위치 배열 Clear
            BallInformation.ball_arraylist.removeAll()
        }
        
    }
    /*
     func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
     
     if takePhoto {
     takePhoto = false
     
     if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
     
     let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
     
     photoVC.takenPhoto = image
     
     DispatchQueue.main.async {
     self.present(photoVC, animated: true, completion: {
     self.stopCaptureSession()
     })
     
     }
     }
     
     
     }
     }
     
     
     func getImageFromSampleBuffer (buffer:CMSampleBuffer) -> UIImage? {
     if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
     let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
     let context = CIContext()
     
     let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
     
     if let image = context.createCGImage(ciImage, from: imageRect) {
     return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
     }
     
     }
     
     return nil
     }
     
     func stopCaptureSession () {
     self.captureSession.stopRunning()
     
     if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
     for input in inputs {
     self.captureSession.removeInput(input)
     }
     }
     
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

