//
//  poseInformation.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/10.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation

public class PoseInformation {
    //배열 개수
    static public var array_count : Int = 0
    
    static public var pose_timer = false
    //동작 상태 (True-운동 상태, False - 준비 상태)
    static public var pose_status = false
    static public var pose_status_sub = false
    
    //동작 각도
    static public var pose_degree : Double = 180.0
    //동작 개수
    static public var pose_count : Int  = 0
    //동작 개수 (0.5씩 카운트)
    static public var pose_count_double : Double = 0.0
    //동작 위치 배열
    static public var pose_arraylist : [String] = []
    
    static public var count_check_bool : Bool = false
    
}
