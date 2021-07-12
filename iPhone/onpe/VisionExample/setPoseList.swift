//
//  setPoseList.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/10.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation
import AVFoundation
import CoreVideo
import MLKit


public class setPoseList {
    var view : AVCaptureVideoPreviewLayer
    
    
    init(view : AVCaptureVideoPreviewLayer) {
        self.view = view
    }
    
    
    public func translatePoseList(poses : [Pose], width : CGFloat, height : CGFloat) -> [CGFloat]{
        var result : [CGFloat] = []
        for a in poses{
            let leftShoulder = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftShoulder).position, width: width, height: height)
            let rightShoulder = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightShoulder).position, width: width, height: height)
            let leftElbow = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftElbow).position, width: width, height: height)
            let rightElbow = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightElbow).position, width: width, height: height)
            let leftWrist = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftWrist).position, width: width, height: height)
            let rightWrist = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightWrist).position, width: width, height: height)
            let leftHip = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftHip).position, width: width, height: height)
            let rightHip = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightHip).position, width: width, height: height)
            let leftKnee = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftKnee).position, width: width, height: height)
            let rightKnee = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightKnee).position, width: width, height: height)
            let leftAnkle = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftAnkle).position, width: width, height: height)
            let rightAnkle = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightAnkle).position, width: width, height: height)
            let leftPinkyFinger = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftPinkyFinger).position, width: width, height: height)
            let rightPinkyFinger = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightPinkyFinger).position, width: width, height: height)
            let leftIndexFinger = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftIndexFinger).position, width: width, height: height)
            let rightIndexFinger = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightIndexFinger).position, width: width, height: height)
            let leftThumb = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftThumb).position, width: width, height: height)
            let rightThumb = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightThumb).position, width: width, height: height)
            let leftHeel = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftHeel).position, width: width, height: height)
            let rightHeel = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightHeel).position, width: width, height: height)
            let leftToe = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftToe).position, width: width, height: height)
            let rightToe = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightToe).position, width: width, height: height)
            let leftEar = normalizedPoint(fromVisionPoint: a.landmark(ofType: .leftEar).position, width: width, height: height)
            let rightEar = normalizedPoint(fromVisionPoint: a.landmark(ofType: .rightEar).position, width: width, height: height)
            
            result.append(leftShoulder.x)
            result.append(leftShoulder.y)
            result.append(rightShoulder.x)
            result.append(rightShoulder.y)
            result.append(leftElbow.x)
            result.append(leftElbow.y)
            result.append(rightElbow.x)
            result.append(rightElbow.y)
            result.append(leftWrist.x)
            result.append(leftWrist.y)
            result.append(rightWrist.x)
            result.append(rightWrist.y)
            result.append(leftHip.x)
            result.append(leftHip.y)
            result.append(rightHip.x)
            result.append(rightHip.y)
            result.append(leftKnee.x)
            result.append(leftKnee.y)
            result.append(rightKnee.x)
            result.append(rightKnee.y)
            result.append(leftAnkle.x)
            result.append(leftAnkle.y)
            result.append(rightAnkle.x)
            result.append(rightAnkle.y)
            result.append(leftPinkyFinger.x)
            result.append(leftPinkyFinger.y)
            result.append(rightPinkyFinger.x)
            result.append(rightPinkyFinger.y)
            result.append(leftIndexFinger.x)
            result.append(leftIndexFinger.y)
            result.append(rightIndexFinger.x)
            result.append(rightIndexFinger.y)
            result.append(leftThumb.x)
            result.append(leftThumb.y)
            result.append(rightThumb.x)
            result.append(rightThumb.y)
            result.append(leftHeel.x)
            result.append(leftHeel.y)
            result.append(rightHeel.x)
            result.append(rightHeel.y)
            result.append(leftToe.x)
            result.append(leftToe.y)
            result.append(rightToe.x)
            result.append(rightToe.y)
            result.append(leftEar.x)
            result.append(leftEar.y)
            result.append(rightEar.x)
            result.append(rightEar.y)
            
        }
        return result
    }
    
    
    private func normalizedPoint(
        fromVisionPoint point: VisionPoint,
        width: CGFloat,
        height: CGFloat
    ) -> CGPoint {
        let cgPoint = CGPoint(x: point.x, y: point.y)
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        normalizedPoint = view.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
    }
}
