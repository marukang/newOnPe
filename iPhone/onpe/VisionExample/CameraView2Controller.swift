 //  Copyright (c) 2018 Google Inc.
 //
 //  Licensed under the Apache License, Version 2.0 (the "License")
 //  you may not use this file except in compliance with the License.
 //  You may obtain a copy of the License at
 //
 //  http://www.apache.org/licenses/LICENSE-2.0
 //
 //  Unless required by applicable law or agreed to in writing, software
 //  distributed under the License is distributed on an "AS IS" BASIS,
 //  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 //  See the License for the specific language governing permissions and
 //  limitations under the License.
 //
 
 import AVFoundation
 import CoreVideo
 import MLKit
 import SDWebImage
 import Photos
 
 class CameraView2Controller: UIViewController {
    
    
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
    private let detectors: [Detector] = [
        .pose,
        .poseAccurate,
    ]
    var sessionBool = false
    
    private enum _CaptureState {
        case idle, start, capturing, end
    }
    private var _captureState = _CaptureState.idle
    
    private var _assetWriter: AVAssetWriter?
    private var _assetWriterInput: AVAssetWriterInput?
    private var _adpater: AVAssetWriterInputPixelBufferAdaptor?
    private var _filename = ""
    private var _time: Double = 0
    
    
    
    var captureDevice:AVCaptureDevice!
    var output : AVCaptureVideoDataOutput!
    private var currentDetector: Detector = .poseAccurate
    private var isUsingFrontCamera = true
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let captureSession = AVCaptureSession()
    
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?
    
    
    private let previewOverlayView2 : UIImageView = UIImageView()//풀화면 나오는 뷰
    private var previewSizeBool = false
    
    
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        annotationOverlayView.contentMode = .scaleAspectFill
        return annotationOverlayView
    }()
    
    /// Initialized when one of the pose detector rows are chosen. Reset to `nil` when neither are.
    private var poseDetector: PoseDetector? = nil
    
    /// The detector mode with which detection was most recently run. Only used on the video output
    /// queue. Useful for inferring when to reset detector instances which use a conventional
    /// lifecyle paradigm.
    private var lastDetector: Detector?
    
    // MARK: - IBOutlets
    
    private let cameraView: UIView = {
        //precondition(isViewLoaded)
        let cameraView = UIView(frame: .zero)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.contentMode = .scaleAspectFill
        return cameraView
    }()
    var captureDeviceInput : AVCaptureDeviceInput!
    var movieOutput = AVCaptureMovieFileOutput()
    var recordBool = false
    
    var frontView : UIWindow?
    
    var userImageContainer : UIImage?
    var userImageContainerBool : Bool = false// 사용자 얼굴 촬영을 한번만 하기 위해 사용되는 변수
    let grayBox = UIView()
    let exerciseTitleLabel = UILabel()
    let timeImgeview = UIImageView()
    let timeLabel = UILabel()
    let countLabel = UILabel()
    
    var recognitionSetupBool = false
    let recognitionImageView = UIImageView()// 추척중이면 초록색 아니면 빨간색
    let recognitionLabel = UILabel()//이식상태
    var recognitionBool = false//false - >인식상태 빨간색, true -> 인식상태 초록색
    let exerciseCountCollectionview = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    let exerciseTypeLabel = UILabel()//과제, 실습, 평가 적음
    let retryBtn = UIButton()//다시하기
    let endBtn = UIButton()
    let titleLabel = UILabel()
    
    var unitGroupName : String?
    var unitList : UnitList?{
        didSet{
            print(unitList)
            print()
        }
    }//클래스 정보 유닛코드가 들어가있는 변수
    var exerciseContentStr : String?{//운동정보 들어가잇는 json object
        didSet{
            print(exerciseContentStr)
            setupExercise()
        }
    }
    var contentCode : String?
    var setupLayoutBool = false
    
    var setPose : setPoseList?
    var mDrawPoint : [CGFloat] = []
    
    //측정해야할 동작 관련 array
    private let AF = ServerConnectionLegacy()
    private var serverBool = false//서버에 값을 한번만 보내기 위해서 사용하는 변수
    private var content_url_array : [String] = []
    private var content_name_array : [String] = []//
    private var content_category_array : [String] = []
    private var posename_array : [String] = []
    private var posecount_array : [Int] = []
    private var posetime_array : [Int] = []
    
    private var totalRecordList : [[[String : String]]] = [[[:]]]
    private var recordList : [[String : String]] = [[:]]
    private var poseRecordDic : [String : String] = [:]
    //각각의 운동 이름,개수, 제한시간
    private var pose_url : String = ""
    private var pose_name : String = ""
    private var pose_count : Int = 0
    private var pose_time : Int = 0
    
    var startTimerBool = true//처음에 운동시작할때 사람이 인식되면 타이머가 한번만 실행될수 있게 해주는 변수
    var deadlineFinishBool = false //해당 변수가 true가 되면 다음 동작으로 넘어간다
    var mTimer = Timer()
    var number : Int = 0//default 0으로 세팅
    
    var minute : Int = 5// 5분 세팅
    var second : Int = 0//초 세팅
    var totalTimeSec : Int = 0
    var subjectListTotal : Int = 0//해당 값으로 getRecordDic에서 평가기록이 없을때(nil) totalRecordList의 길이를 결정한다.
    var subjectTitle : String?//평가(실습형)
    var subjectIndex : String?//평가가 중복될시 예) 0,1 로 저장해야할 배열 구분
    var subjectType : String?{//평가
        didSet{
            exerciseTypeLabel.text = subjectType
            //print(subjectType)
        }
    }//실습, 과제, 평가 구별하는 변수
    var getRecordDic : recordDic?{
        didSet{
            self.recordList.removeAll()
            self.totalRecordList.removeAll()
            if let getRecordDic = self.getRecordDic {
                switch subjectType {
                case "실습":
                    if getRecordDic.class_practice != nil{
                        
                        totalRecordList = extensionClass.jsonToArray4(jsonString: getRecordDic.class_practice!)
                    } else {
                        for _ in 0..<subjectListTotal {
                            totalRecordList.append([[:]])
                        }
                    }
                    break
                case "평가":
                    if getRecordDic.evaluation_practice != nil{
                        totalRecordList = extensionClass.jsonToArray4(jsonString: getRecordDic.evaluation_practice!)
                    } else {
                        for _ in 0..<subjectListTotal {
                            totalRecordList.append([[:]])
                        }
                    }
                    break
                case "이론":
                    if getRecordDic.task_practice != nil{
                        totalRecordList = extensionClass.jsonToArray4(jsonString: getRecordDic.task_practice!)
                    } else {
                        for _ in 0..<subjectListTotal {
                            totalRecordList.append([[:]])
                        }
                    }
                    break
                default:
                    print("오류")
                }
            }
            print("업데이트 위치 : ",subjectIndex)
            print("중복개수 : ", subjectListTotal)
            print("리스트 값 : ",totalRecordList)
            print("---")
            
        }
    }
    
    let posemeasurefunction : PoseMeasureFunction = PoseMeasureFunction()
    
    
    
    
    //운동 횟수 카운터 관련 ui변수
    var fadeViewInThenOutBool = false
    let countEffectLabel = UILabel()//운동 횟수 카운트
    //------------------------------------------------------------------------------
    
    let backgroundView = UIView()
    
    //운동 완료후 실행되는 ui 변수
    let exerciseCompleteBtn = UIButton()//완료하기
    let recordCheckBtn = UIButton()//기록확인
    let retryAginBtn = UIButton()// 처음부터
    var finishBool = false //해당 값이 true가 되면 모든 운동이 끝나고 서버에 값을 저장한뒤 동영상을 디바이스에 저장하고 이전화면으로 돌아간다.
    //------------------------------------------------------------------------------
    
    
    //운동 처음 시작하기 버튼, 카운트, 첫 운동명 나오게 하는 ui 변수 모음
    let firstBtn = UIButton()
    let firstTimerLabel = UILabel()//숫자 카운터와 운동 종목 입력
    var firstTimer = Timer()
    var firstBool = false
    var number3 = 0
    //------------------------------------------------------------------------------
    
    var totalTimer = Timer()
    var number4 = 0
    var totalTimerBool = false
    
    private var skeletonViewBool = false // 해당 값이 false이면 홈트레이닝 종목을 할때이고 true이면 홈트레이닝 이외의 종목을 할때이다.
    var player: AVAudioPlayer?
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
    }
    public func setposeRecordStruct(type : String, value : String){
        self.poseRecordDic.updateValue(value, forKey: type)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frontView =  UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        /*
         posename_array.append("스쿼트")
         
         posecount_array.append(4)
         
         posetime_array.append(300)
         */
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.startSession()
            self.setUpcameraView()
            
        }
        
    }
    override func viewWillLayoutSubviews() {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            
            if !self.setupLayoutBool {
                //self.setupLayoutBool = true
                self.setupLayout()
            }
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    public func removeFrontViews(){
        
        grayBox.removeFromSuperview()
        exerciseTitleLabel.removeFromSuperview()
        countLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
        timeImgeview.removeFromSuperview()
        
        recognitionImageView.removeFromSuperview()
        recognitionLabel.removeFromSuperview()
        exerciseCountCollectionview.removeFromSuperview()
        exerciseTypeLabel.removeFromSuperview()
        retryBtn.removeFromSuperview()
        endBtn.removeFromSuperview()
        titleLabel.removeFromSuperview()
        
        recordCheckBtn.removeFromSuperview()
        retryAginBtn.removeFromSuperview()
        exerciseCompleteBtn.removeFromSuperview()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        mTimer.invalidate()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopSession()
        PoseInformation.array_count = 0
        PoseInformation.pose_status = false
        PoseInformation.pose_status_sub = false
        PoseInformation.pose_count = 0
        PoseInformation.pose_count_double = 0.0
        //PoseInformation.pose_score = "--"
        PoseInformation.pose_arraylist.removeAll()
        
        PoseInformation.pose_degree = 180
        
        //화면 전환시, 넘겨받은 배열 데이터 초기화
        content_category_array.removeAll()
        posename_array.removeAll()
        posecount_array.removeAll()
        posetime_array.removeAll()
        recordList.removeAll()
        
        
    }
    //GIF이미지를 바꿔주는 함수 type은 돌아가기해서 이전 운동을 할것인지, false은 일반적으로 다음 운동을 하게 되면 설정한다.
    
    //처음 이 화면으로 이동했을때 운동리스트를 세팅 하는 함수
    func setupExercise(){
        
        if let data = exerciseContentStr?.data(using: .utf8){
            do {
                let getResult = try JSONDecoder().decode(exerciseContent.self, from: data)
                if let content_name_list = getResult.content_name_list, let content_category_list = getResult.content_cateogry_list, let content_detail_name_list = getResult.content_detail_name_list, let count_list = getResult.content_count_list, let content_time_list = getResult.content_time, let content_url_array = getResult.content_url, let contentCode = getResult.content_code {
                    self.contentCode = contentCode
                    self.content_url_array = extensionClass.jsonToArray(jsonString: content_url_array)
                    print(content_url_array)
                    SDImageCache.shared.clearMemory()
                    SDImageCache.shared.clearDisk()
                    self.pose_url = self.content_url_array[PoseInformation.array_count]
                    print(pose_url)
                    
                    self.startTimerBool = false// 타이머 시작
                    
                    
                    
                    self.content_name_array = extensionClass.jsonToArray(jsonString: content_name_list)
                    print(self.content_name_array)
                    self.content_category_array = extensionClass.jsonToArray(jsonString: content_category_list)
                    self.posename_array = extensionClass.jsonToArray(jsonString: content_detail_name_list)
                    
                    let countList = extensionClass.jsonToArray2(jsonString: count_list)
                    posecount_array = countList
                    
                    let timeList = extensionClass.jsonToArray2(jsonString: content_time_list)
                    posetime_array = timeList
                    
                    
                    print(content_name_array)
                    print(content_category_array)
                    print(posename_array)
                    print(posecount_array)
                    print(posetime_array)
                    print("완료")
                    exerciseCountCollectionview.reloadData()
                    
                    
                    
                }
                
                
                
            } catch let error {
                print(error)
            }
        }
        
    }
    func fadeViewInThenOut(view : UILabel, delay: TimeInterval) {
        
        let animationDuration = 0.25
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseOut, animations: { () -> Void in
                view.alpha = 0
            },
            completion: { _ in
                self.fadeViewInThenOutBool = false
            })
        }
    }
    
    
    // MARK: On-Device Detections
    
    private func detectPose(in image: VisionImage, width: CGFloat, height: CGFloat) {
        if let poseDetector = self.poseDetector {
            var poses: [Pose]
            do {
                poses = try poseDetector.results(in: image)
            } catch let error {
                if !recognitionBool{
                    recognitionBool = true
                    DispatchQueue.main.sync {
                        self.recognitionImageView.backgroundColor = .red
                    }
                }
                print("Failed to detect poses with error: \(error.localizedDescription).")
                return
            }
            weak var weakSelf = self
            DispatchQueue.main.sync {
                guard let strongSelf = weakSelf else {
                    print("Self is nil!")
                    return
                }
                
                strongSelf.updatePreviewOverlayView()
                strongSelf.removeDetectionAnnotations()
            }
            guard !poses.isEmpty else {
                if !recognitionBool{
                    recognitionBool = true
                    DispatchQueue.main.async {
                        self.recognitionImageView.backgroundColor = .red
                    }
                    
                }
                print("Pose detector returned no results.")
                return
            }
            guard firstBool else {
                print("운동 시작전")
                return
            }
            
            DispatchQueue.main.sync {
                
                
                // Pose detected. Currently, only single person detection is supported.
                
                mDrawPoint.removeAll()
                if !recordBool{
                    recordBool = true
                    _captureState = .start
                    
                    
                }
                mDrawPoint = setPose?.translatePoseList(poses: poses, width: width, height: height) ?? []
                
                
                if !totalTimerBool {//운동 페이지에 있는 전체 시간 타이머 시작
                    totalTimerBool = true
                    startTimer4()
                }
                
                if !startTimerBool {//타이머 한번만 실행하기 위해서 사용
                    startTimerBool = true
                    setLimitTime()
                    startTimer()
                }
                
                DispatchQueue.main.async {
                    self.recognitionImageView.backgroundColor = mainColor.hexStringToUIColor(hex: "#33fd7d")
                }
                print(mDrawPoint)
                
                if(PoseInformation.array_count == -1){
                    
                    //array_count가 -1일 경우 카메라 중지
                    //preview.stop()
                }else if(posename_array.count == PoseInformation.array_count) {
                    //전체 운동 완료 서버로 값 전송
                    
                    
                    if !serverBool {
                        serverBool = true
                        self.recordList.append(self.poseRecordDic)
                        print("저장전 : ",totalRecordList)
                        print("저장 위치 : ",subjectIndex)
                        if let position = Int(subjectIndex ?? "0"){
                            totalRecordList[position] = recordList
                        }
                        //print("운동 한번 끝 : ",totalRecordList)
                        print("--------")
                        _captureState = .end
                        mTimer.invalidate()
                        
                        setupLayoutBool = true
                        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            
                            
                            self.exerciseCompleteBtn.isHidden = false
                            self.recordCheckBtn.isHidden = false
                            self.backgroundView.isHidden = false
                            self.retryAginBtn.isHidden = false
                            
                            self.exerciseCompleteBtn.alpha = 1
                            self.retryAginBtn.alpha = 1
                            self.recordCheckBtn.alpha = 1
                            self.backgroundView.alpha = 0.8 //원래 0.8 나머지는 1
                            
                        }, completion: nil)
                        
                        
                    }
                    
                    //개수 -1로 변경 (1번만 작동하도록)
                    //PoseInformation.array_count = -1
                    //동작을 다 실행한 경우 액티비티 이동
                    print("동작 실행 완료", "동작 " + ("\(posename_array.count)") + "개 실행 완료")
                    /*
                     Intent intent = new Intent(PoseActivity.this, GetDataActivity.class)
                     startActivity(intent)
                     finish()
                     */
                }else if(posename_array.count > PoseInformation.array_count && 0 <= PoseInformation.array_count){
                    //실행할 동작이 남은 경우
                    
                    //동작 설정
                    pose_name = posename_array[PoseInformation.array_count]
                    //개수 설정
                    pose_count = posecount_array[PoseInformation.array_count]
                    //시간 설정
                    pose_time = posetime_array[PoseInformation.array_count]
                    
                    
                    
                    print("지속시간 : ",totalTimeSec)
                    print("포즈배열-posename_array",pose_name)
                    print("포즈배열-posecount_array", pose_count)
                    print("포즈배열-posetime_array", pose_time)
                    print("포즈배열-PoseInformation.array_count", PoseInformation.array_count)
                    //print("타이머-",timeLeftFormatted)
                    
                    if pose_count >= PoseInformation.pose_count {
                        setposeRecordStruct(type: "content_title", value: self.subjectTitle ?? "")
                        setposeRecordStruct(type: "content_code", value: self.contentCode ?? "")
                        setposeRecordStruct(type: "content_name", value: "\(content_name_array[PoseInformation.array_count])")
                        setposeRecordStruct(type: "content_category", value: "\(content_category_array[PoseInformation.array_count])")
                        setposeRecordStruct(type: "content_detail_name", value: pose_name)
                        let content_average_score : Int = Int(CGFloat(PoseInformation.pose_count / pose_count * 100))
                        setposeRecordStruct(type: "content_average_score", value: "\(content_average_score)")
                        setposeRecordStruct(type: "content_count", value: "\(PoseInformation.pose_count)")//총 운동개수
                        setposeRecordStruct(type: "content_time", value: "\(totalTimeSec)")//총 운동시간
                        
                        exerciseTitleLabel.text = pose_name
                        
                        countLabel.text = "・ \(PoseInformation.pose_count) / \(posecount_array[PoseInformation.array_count])회"
                        titleLabel.text = "\(content_name_array[PoseInformation.array_count]) / \(pose_name)"
                        if content_name_array[PoseInformation.array_count] != "홈트레이닝"{
                            //스켈레톤 이미지 off
                            skeletonViewBool = true
                        } else {
                            //스켈레톤 이미지 on
                            skeletonViewBool = false
                        }
                        print("content_count(횟수증가) : ",PoseInformation.pose_count)
                        
                        //기록효과
                        if PoseInformation.count_check_bool{
                            PoseInformation.count_check_bool = false
                            fadeViewInThenOutBool = true
                            countEffectLabel.text = "\(PoseInformation.pose_count)"
                            //fadeViewInThenOut(view: countEffectImageview, delay: 0.5)
                            fadeViewInThenOut(view: countEffectLabel, delay: 0.5)
                            //운동 성공시 효과음 재생
                            DispatchQueue.main.async {
                                guard let url = Bundle.main.url(forResource: "succes", withExtension: "mp3") else { return }

                                    do {
                                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                                        try AVAudioSession.sharedInstance().setActive(true)

                                        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                                        self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                                        /* iOS 10 and earlier require the following line:
                                        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                                        guard let player = self.player else { return }

                                        player.play()

                                    } catch let error {
                                        print(error.localizedDescription)
                                    }
                            }
                        }
                        
                    }
                    
                    // VIEW 설정 (동작 이름, 동작 개수, 동작 스코어, 스코어 리스트)
                    
                    
                    
                    
                    
                    
                    
                    
                    // 해당 동작(한동작)의 개수를 모두 완료했을 경우나 시간이 초과 됬을때
                    if(PoseInformation.pose_count == posecount_array[PoseInformation.array_count] || self.deadlineFinishBool){
                        
                        
                        if !userImageContainerBool {
                            userImageContainerBool = true
                            if let classCode = unitList?.class_code, let unitCode = unitList?.unit_code {
                                //서버로 운동한 사람의 얼굴을 보여주는 함수
                                AF.appRecordUpdateStudentRecordImageConfirmation(student_id: UserInformation.student_id, student_token: UserInformation.access_token, class_code: classCode, unit_code: unitCode, image_file_name: unitCode + UserInformation.student_name + UserInformation.student_id , file: userImageContainer!, url: "app/record/update_student_record_image_confirmation")
                            }
                            
                        }
                        deadlineFinishBool = false
                        
                        let content_average_score : Int = Int(CGFloat(PoseInformation.pose_count / pose_count * 100))
                        setposeRecordStruct(type: "content_average_score", value: "\(content_average_score)")
                        setposeRecordStruct(type: "content_count", value: "\(PoseInformation.pose_count)")//운동한 개수
                        print("content_count :",PoseInformation.pose_count)
                        setposeRecordStruct(type: "content_time", value: "\(totalTimeSec)")//총 운동시간
                        
                        
                        
                        
                        
                        
                        
                        totalTimeSec = 0
                        
                        
                        
                        //setposeRecordStruct(type: "초기화", value: "초기화")//총 운동시간
                        
                        
                        
                        print("동작 변경", "개수 완료 or 시간 종료")
                        // 해당 동작의 개수를 모두 완료했거나, 타이머의 시간이 종료되었을 경우 -> 다음 동작으로 이동
                        PoseInformation.array_count = PoseInformation.array_count + 1
                        print("포즈변경 : 배열 인덱스 ", PoseInformation.array_count)
                        
                        //포즈 상태, 개수, 스코어, 각도, 리스트 초기화
                        PoseInformation.pose_status = false
                        PoseInformation.pose_count = 0
                        PoseInformation.pose_arraylist.removeAll()
                        PoseInformation.pose_degree = 180
                        PoseInformation.pose_count_double = 0.0
                        
                        exerciseCountCollectionview.reloadData()
                        
                        /*
                         한 운동의 측정값을 저장하는 코드가 있는곳은
                         timer2callback함수와, puaseAndStartBtnAction 함수안에 작성되어있음.
                        */
                        if self.posename_array.count > PoseInformation.array_count{
                            self.recordList.append(self.poseRecordDic)
                            mTimer.invalidate()
                            setLimitTime()
                            startTimer()
                            //운동 리스트의 마지막에는 다음화면이 무엇인지 말해주는 화면을 실행시키지 않기위해 사용된 조건문 사용
                           
                        }
                        
                    }// 해당 동작(한동작)의 개수를 모두 완료했을 경우나 시간이 초과 됬을때
                    
                    
                    
                    
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    
                    print("PoseGraphic으로부터의 return값", mDrawPoint)
                    let leftShoulder_x = (mDrawPoint[0])
                    let leftShoulder_y = (mDrawPoint[1])
                    let rightShoulder_x = (mDrawPoint[2])
                    let rightShoulder_y = (mDrawPoint[3])
                    let leftElbow_x = (mDrawPoint[4])
                    let leftElbow_y = (mDrawPoint[5])
                    let rightElbow_x = (mDrawPoint[6])
                    let rightElbow_y = (mDrawPoint[7])
                    let leftWrist_x = (mDrawPoint[8])
                    let leftWrist_y = (mDrawPoint[9])
                    let rightWrist_x = (mDrawPoint[10])
                    let rightWrist_y = (mDrawPoint[11])
                    let leftHip_x = (mDrawPoint[12])
                    let leftHip_y = (mDrawPoint[13])
                    let rightHip_x = (mDrawPoint[14])
                    let rightHip_y = (mDrawPoint[15])
                    let leftKnee_x = (mDrawPoint[16])
                    let leftKnee_y = (mDrawPoint[17])
                    let rightKnee_x = (mDrawPoint[18])
                    let rightKnee_y = (mDrawPoint[19])
                    let leftAnkle_x = (mDrawPoint[20])
                    let leftAnkle_y = (mDrawPoint[21])
                    let rightAnkle_x = (mDrawPoint[22])
                    let rightAnkle_y = (mDrawPoint[23])
                    let leftPinky_x = (mDrawPoint[24])
                    let leftPinky_y = (mDrawPoint[25])
                    let rightPinky_x = (mDrawPoint[26])
                    let rightPinky_y = (mDrawPoint[27])
                    let leftIndex_x = (mDrawPoint[28])
                    let leftIndex_y = (mDrawPoint[29])
                    let rightIndex_x = (mDrawPoint[30])
                    let rightIndex_y = (mDrawPoint[31])
                    let leftThumb_x = (mDrawPoint[32])
                    let leftThumb_y = (mDrawPoint[33])
                    let rightThumb_x = (mDrawPoint[34])
                    let rightThumb_y = (mDrawPoint[35])
                    let leftHeel_x = (mDrawPoint[36])
                    let leftHeel_y = (mDrawPoint[37])
                    let rightHeel_x = (mDrawPoint[38])
                    let rightHeel_y = (mDrawPoint[39])
                    let leftFootIndex_x = (mDrawPoint[40])
                    let leftFootIndex_y = (mDrawPoint[41])
                    let rightFootIndex_x = (mDrawPoint[42])
                    let rightFootIndex_y = (mDrawPoint[43])
                    let leftEar_x = (mDrawPoint[44])
                    let leftEar_y = (mDrawPoint[45])
                    let rightEar_x = (mDrawPoint[46])
                    let rightEar_y = (mDrawPoint[47])
                    
                    
                    if(leftShoulder_x > self.view.frame.width || leftShoulder_y > self.view.frame.height || rightShoulder_x > self.view.frame.width || rightShoulder_y > self.view.frame.height ||
                        leftElbow_x > self.view.frame.width || leftElbow_y > self.view.frame.height || rightElbow_x > self.view.frame.width || rightElbow_y > self.view.frame.height ||
                        leftWrist_x > self.view.frame.width || leftWrist_y > self.view.frame.height || rightWrist_x > self.view.frame.width || rightWrist_y > self.view.frame.height ||
                        leftHip_x > self.view.frame.width || leftHip_y > self.view.frame.height || rightHip_x > self.view.frame.width || rightHip_y > self.view.frame.height ||
                        leftKnee_x > self.view.frame.width || leftKnee_y > self.view.frame.height || rightKnee_x > self.view.frame.width || rightKnee_y > self.view.frame.height ||
                        leftAnkle_x > self.view.frame.width || leftAnkle_y > self.view.frame.height || rightAnkle_x > self.view.frame.width || rightAnkle_y > self.view.frame.height ||
                        leftPinky_x > self.view.frame.width || leftPinky_y > self.view.frame.height || rightPinky_x > self.view.frame.width || rightPinky_y > self.view.frame.height ||
                        leftIndex_x > self.view.frame.width || leftIndex_y > self.view.frame.height || rightIndex_x > self.view.frame.width || rightIndex_y > self.view.frame.height ||
                        leftThumb_x > self.view.frame.width || leftThumb_y > self.view.frame.height || rightThumb_x > self.view.frame.width || rightThumb_y > self.view.frame.height ||
                        leftHeel_x > self.view.frame.width || leftHeel_y > self.view.frame.height || rightHeel_x > self.view.frame.width || rightHeel_y > self.view.frame.height ||
                        leftFootIndex_x > self.view.frame.width ||  leftFootIndex_y > self.view.frame.height || rightFootIndex_x > self.view.frame.width || rightFootIndex_y > self.view.frame.height){
                        //모든 좌표가 (0,0) ~ (720,480) 사이에 있어야 한다
                        print("동작인식 범위 이탈: ", "좌표 범위 이탈로 인한 자세 미측정")
                        
                    }else if(abs(leftEar_x-rightEar_x) > 60 || abs(leftEar_y-rightEar_y) > 60){
                        // 양쪽 귀간의 거리가 70이상일 경우 -> 얼굴 비중이 높으므로 측정 X
                        
                        print("동작인식 범위 이탈: ", "얼굴 과비중으로 인한 자세 미측정")
                        
                    }else{
                        
                        print("동작인식 범위 포함: ", "측정 가능 범위 도달")
                        
                        
                        
                        if(pose_name == "스쿼트"){
                            // 스쿼트일 경우 - 각도1(엉덩이, 무릎, 발목)
                            // 각도1 (100~110 -> BAD, 90~100 -> NORMAL, 90 이하 -> GOOD)
                            posemeasurefunction.squat_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftHip_x), a2: Double(leftHip_y), b1: Double(leftKnee_x), b2: Double(leftKnee_y), c1: Double(leftAnkle_x), c2: Double(leftAnkle_y), d1: Double(leftEar_x), d2: Double(leftEar_y), e1: Double(leftHip_x), e2: Double(leftHip_y), f1: Double(leftAnkle_x), f2: Double(leftAnkle_y), g1: Double(leftWrist_x), g2: Double(leftWrist_y), h1: Double(leftShoulder_x), h2: Double(leftShoulder_y), i1: Double(leftAnkle_x), i2: Double(leftAnkle_y), j1: Double(leftShoulder_x), j2: Double(leftShoulder_y), k1: Double(rightShoulder_x), k2: Double(rightShoulder_y), l1: Double(leftKnee_x), l2: Double(leftKnee_y), m1: Double(rightKnee_x), m2: Double(rightKnee_y), n1: Double(leftAnkle_x), n2: Double(leftAnkle_y), o1: Double(rightAnkle_x), o2: Double(rightAnkle_y))
                            print("동작인식: ", "스쿼트 측정 중")
                        } else if(pose_name == "점핑스쿼트"){
                            // 스쿼트와 함수가 동일하다
                            // 점핑스쿼트일 경우 - 각도1(엉덩이, 무릎, 발목)
                            // 각도1 (100~110 -> BAD, 90~100 -> NORMAL, 90 이하 -> GOOD)
                            //posemeasurefunction.squat_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftHip_x), a2: Double(leftHip_y), b1: Double(leftKnee_x), b2: Double(leftKnee_y), c1: Double(leftAnkle_x), c2: Double(leftAnkle_y))
                            print("동작인식: ", "점핑스쿼트 측정 중")
                        }else if(pose_name == "팔굽혀펴기"){
                            // 푸쉬업일 경우 - 각도1(어깨, 팔꿈치, 손목) & 각도2(엉덩이,무릎,발목)
                            // 각도1 (90~100 -> BAD, 75~90 -> NORMAL, 75 이하 -> GOOD)
                            // 각도2 (150도 이상일 경우에만 측정, 150도이하일 경우 측정 X) -> 몸이 1자인지 파악하기 위한 각도
                            posemeasurefunction.pushup_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftShoulder_x), a2: Double(leftShoulder_y), b1: Double(leftElbow_x), b2: Double(leftElbow_y), c1: Double(leftWrist_x), c2: Double(leftWrist_y), d1: Double(leftHip_x), d2: Double(leftHip_y), e1: Double(leftKnee_x), e2: Double(leftKnee_y), f1: Double(leftAnkle_x), f2: Double(leftAnkle_y),g1: Double(leftHip_x) ,g2: Double(leftHip_y),h1: Double(leftKnee_x), h2 : Double(leftKnee_y), i1: Double(leftAnkle_x), i2 : Double(leftAnkle_y))
                            print("동작인식: ", "푸쉬업 측정 중")
                        }else if(pose_name == "무릎대고팔굽혀펴기"){
                            // 무릎푸쉬업일 경우 - 각도1(어깨, 팔꿈치, 손목) & 각도2(엉덩이,무릎,발목)
                            // 각도1 (90~100 -> BAD, 75~90 -> NORMAL, 75 이하 -> GOOD)
                            // 각도2 (120도 이하일 경우에만 측정, 120도이상일 경우 측정 X) -> 무릎을 바닥에 대었는지 파악하기 위한 각도
                            posemeasurefunction.knee_pushup_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftShoulder_x), a2: Double(leftShoulder_y), b1: Double(leftElbow_x), b2: Double(leftElbow_y), c1: Double(leftWrist_x), c2: Double(leftWrist_y), d1: Double(leftEar_x), d2: Double(leftEar_y), e1: Double(leftHip_x), e2: Double(leftHip_y), f1: Double(leftAnkle_x), f2: Double(leftAnkle_y), g1: Double(leftHip_x), g2: Double(leftHip_y), h1: Double(leftKnee_x), h2: Double(leftKnee_y), i1: Double(leftAnkle_x), i2: Double(leftAnkle_y))
                            print("동작인식: ", "무릎푸쉬업 측정 중")
                        } else if(pose_name == "크런치"){
                            // 크런치일 경우 - 각도1(머리, 엉덩이, 무릎)
                            // 각도1 (120~130 -> BAD, 105~120 -> NORMAL, 105 이하 -> GOOD)
                            posemeasurefunction.crunch_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftEar_x), a2: Double(leftEar_y), b1: Double(leftHip_x), b2: Double(leftHip_y), c1: Double(leftKnee_x), c2: Double(leftKnee_y), d1: Double(leftHip_x), d2: Double(leftHip_y), e1: Double(leftKnee_x), e2: Double(leftKnee_y),f1: Double(leftAnkle_x), f2: Double(leftAnkle_y), g1: Double(leftWrist_x), g2: Double(leftWrist_y), h1: Double(leftKnee_x), h2: Double(leftKnee_y))
                            print("동작인식: ", "크런치 측정 중")
                        }else if(pose_name == "브이업"){
                            // 브이업일 경우 - 각도1(어깨, 엉덩이, 발목)
                            // 각도1 (100~110 -> BAD, 90~100 -> NORMAL, 90 이하 -> GOOD)
                            posemeasurefunction.vup_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftShoulder_x), a2: Double(leftShoulder_y), b1: Double(leftHip_x), b2: Double(leftHip_y), c1: Double(leftAnkle_x), c2: Double(leftAnkle_y),d1: Double(leftHip_x), d2: Double(leftHip_y), e1: Double(leftShoulder_x), e2: Double(leftShoulder_y), f1: Double(leftWrist_x), f2: Double(leftWrist_y), g1: Double(leftAnkle_x), g2: Double(leftAnkle_y), h1: Double(leftShoulder_x), h2: Double(leftShoulder_y))
                            print("동작인식: ", "브이업 측정 중")
                        }else if(pose_name == "버피테스트"){
                            // 버피일 경우 각도1(머리,엉덩이,발목) / 각도2 (머리, 팔꿈치, 발목)
                            // 각도1 (엎드린 동작이 확인되었을 경우, 해당 동작에서 머리,엉덩이,발목의 각도가 수평일 수록 점수가 높다)
                            // 각도1 (80~120 -> BAD, 120~140 -> NORMAL, 140 이상 -> GOOD)
                            // 각도2 (서있는 동작과, 엎드린 동작을 구분하는 각도)
                            posemeasurefunction.burpee_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, pose_status_sub: PoseInformation.pose_status_sub, a1: Double(leftEar_x), a2: Double(leftEar_y), b1: Double(leftHip_x), b2: Double(leftHip_y), c1: Double(leftAnkle_x), c2: Double(leftAnkle_y), d1: Double(leftEar_x), d2: Double(leftEar_y), e1: Double(leftElbow_x), e2: Double(leftElbow_y), f1: Double(leftAnkle_x), f2: Double(leftAnkle_y))
                            print("동작인식: ", "버피 측정 중")
                        }else if(pose_name == "접었다폈다복근"){
                            // 접었다폈다복근일 경우 각도1(엉덩이, 무릎, 발목) / 각도2 (엉덩이, 어깨, 팔꿈치)
                            // 각도1 (100~110 -> BAD, 90~100 -> NORMAL, 90 이하 -> GOOD)
                            // 각도2 (20도~70도일 경우에만 측정, 그 외의 경우 측정 X) -> 손을 바닥에 올바른 각도로 짚었는지 측정
                            posemeasurefunction.kneeup_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftHip_x), a2: Double(leftHip_y), b1: Double(leftKnee_x), b2: Double(leftKnee_y), c1: Double(leftAnkle_x), c2: Double(leftAnkle_y), d1: Double(leftHip_x), d2: Double(leftHip_y), e1: Double(leftShoulder_x), e2: Double(leftShoulder_y), f1: Double(leftElbow_x), f2: Double(leftElbow_y))
                            print("동작인식: ", "접었다폈다복근 측정 중")
                        }else if(pose_name == "위아래지그재그복근"){
                            // 위아래지그재그복근일 경우 각도1(왼쪽발목, 엉덩이, 오른쪽발목)
                            // 각도1 (20~25 -> BAD, 25~30 -> NORMAL, 35 이상 -> GOOD)
                            // 양쪽 발목이 교차할때마다 0.5씩 카운트
                            posemeasurefunction.ankleupdown_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftAnkle_x), a2: Double(leftAnkle_y), b1: Double(leftHip_x), b2: Double(leftHip_y), c1: Double(rightAnkle_x), c2: Double(rightAnkle_y),d1: Double(leftHip_x), d2 : Double(leftHip_y), e1: Double(leftShoulder_x), e2: Double(leftShoulder_y), f1: Double(leftElbow_x), f2: Double(leftElbow_y), g1: Double(leftShoulder_x), g2: Double(leftShoulder_y), h1: Double(rightShoulder_x), h2: Double(rightShoulder_y))
                            print("동작인식: ", "위아래지그재그복근 측정 중")
                        }else if(pose_name == "런지"){
                            // 런지일 경우 각도1(왼쪽발목, 왼쪽무릎, 엉덩이) / 각도2(오른쪽발목, 오른쪽무릎, 엉덩이) / 각도3 (왼쪽발목, 엉덩이, 오른쪽발목)
                            // 각도1 or 각도2 (100~110 -> BAD, 90~100 -> NORMAL, 90 이하 -> GOOD)
                            // 각도3 - 런지 시작자세인지 파악
                            posemeasurefunction.lunge_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftAnkle_x), a2: Double(leftAnkle_y), b1: Double(leftKnee_x), b2: Double(leftKnee_y), c1: Double(leftHip_x), c2: Double(leftHip_y), d1: Double(rightAnkle_x), d2: Double(rightAnkle_y), e1: Double(rightKnee_x), e2: Double(rightKnee_y), f1: Double(rightHip_x), f2: Double(rightHip_y))
                            print("동작인식: ", "런지 측정 중")
                        }else if(pose_name == "굿모닝"){
                            // 굿모닝일 경우 - 각도1(어깨, 엉덩이, 발목)
                            // 각도1 (110~120 -> BAD, 100~110 -> NORMAL, 100 이하 -> GOOD)
                            posemeasurefunction.goodmorning_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftShoulder_x), a2: Double(leftShoulder_y), b1: Double(leftHip_x), b2: Double(leftHip_y), c1: Double(leftAnkle_x), c2: Double(leftAnkle_y),d1: Double(leftWrist_x), d2: Double(leftWrist_y), e1: Double(leftShoulder_x), e2: Double(leftShoulder_y), f1: Double(rightWrist_x),f2: Double(rightWrist_y), g1: Double(rightShoulder_x), g2: Double(rightShoulder_y), h1: Double(leftAnkle_x), h2: Double(leftAnkle_y), i1: Double(leftHip_x), i2 : Double(leftHip_y), j1: Double(rightAnkle_x), j2 : Double(rightAnkle_y), k1: Double(leftHip_x), k2 : Double(leftHip_y), l1: Double(leftKnee_x), l2: Double(leftKnee_y), m1: Double(leftAnkle_x), m2: Double(leftAnkle_y))
                            print("동작인식: ", "굿모닝 측정 중")
                        }else if(pose_name == "덤벨프레스"){
                            // 덤벨숄더프레스일 경우 - 각도1(어깨, 팔꿈치, 손목)
                            // 각도1  (130~145 -> BAD, 145~160 -> NORMAL, 160 이상 -> GOOD)
                            posemeasurefunction.dumbbellshoulder_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftShoulder_x), a2: Double(leftShoulder_y), b1: Double(leftElbow_x), b2: Double(leftElbow_y), c1: Double(leftWrist_x), c2: Double(leftWrist_y),d1: Double(rightShoulder_x), d2 : Double(rightShoulder_x), e1: Double(rightElbow_x), e2 : Double(rightElbow_y),f1: Double(rightWrist_x), f2 : Double(rightWrist_y), g1: Double(leftHip_x), g2 : Double(leftHip_y), h1: Double(leftKnee_x), h2 : Double(leftKnee_y), i1: Double(leftAnkle_x), i2 : Double(leftAnkle_y), j1: Double(rightHip_x), j2: Double(rightHip_y), k1: Double(rightKnee_x), k2: Double(rightKnee_y), l1: Double(rightAnkle_x), l2 : Double(rightAnkle_y))
                            print("동작인식: ", "덤벨숄더프레스 측정 중")
                        }else if(pose_name == "덤벨로우"){
                            // 덤벨로우일 경우 - 각도1(어깨, 팔꿈치, 손목) / 각도2 (머리, 엉덩이, 발목)
                            // 각도 1 (100~110-> BAD, 90~100 -> NORMAL, 90 이하 -> GOOD)
                            // 각도 2 - 덤벨로우 준비자세
                            /*
                            posemeasurefunction.dumbbelllow_data(pose_count: PoseInformation.pose_count, pose_status: PoseInformation.pose_status, a1: Double(leftShoulder_x), a2: Double(leftShoulder_y), b1: Double(leftElbow_x), b2: Double(leftElbow_y), c1: Double(leftWrist_x), c2: Double(leftWrist_y), d1: Double(leftEar_x), d2: Double(leftEar_y), e1: Double(leftHip_x), e2: Double(leftHip_y), f1: Double(leftAnkle_x), f2: Double(leftAnkle_y))
                            */
                            print("동작인식: ", "덤벨로우 측정 중")
                        }
                    }
                }
                
            }
            
            if !skeletonViewBool{
                DispatchQueue.main.async {
                    poses.forEach { pose in
                        
                        for (startLandmarkType, endLandmarkTypesArray) in PoseUtilities.poseConnections() {
                            
                            
                            let startLandmark = pose.landmark(ofType: startLandmarkType)
                            
                            for endLandmarkType in endLandmarkTypesArray {
                                let endLandmark = pose.landmark(ofType: endLandmarkType)
                                let startLandmarkPoint = self.normalizedPoint(
                                    fromVisionPoint: startLandmark.position, width: width, height: height)
                                let endLandmarkPoint = self.normalizedPoint(
                                    fromVisionPoint: endLandmark.position, width: width, height: height)
                                
                                PoseUtilities.addLineSegment(
                                    fromPoint: startLandmarkPoint,
                                    toPoint: endLandmarkPoint,
                                    inView: self.annotationOverlayView,
                                    color: UIColor.green,
                                    width: Constant.lineWidth
                                )
                            }
                        }
                        
                        
                        for landmark in pose.landmarks {
                            
                            let landmarkPoint = self.normalizedPoint(
                                fromVisionPoint: landmark.position, width: width, height: height)
                            //print(landmarkPoint)
                            
                            if String(landmark.type.rawValue) == "RightWrist"{
                                print("landmarkPoint2 :  ",landmarkPoint)
                            }
                        }
                        
                    }
                }
            }
            
            
             
            
        }
    }
    // MARK: - Private
    
    private func setUpCaptureSessionOutput() {
        
        sessionQueue.async {
            
            self.captureSession.beginConfiguration()
            // When performing latency tests to determine ideal capture settings,
            // run the app in 'release' mode to get accurate performance metrics
            self.captureSession.sessionPreset = AVCaptureSession.Preset.low
            
            self.output = AVCaptureVideoDataOutput()
            self.output.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
            ]
            self.output.alwaysDiscardsLateVideoFrames = true
            
            
            if self.captureSession.canAddOutput(self.output) {
                self.captureSession.addOutput(self.output)
            }
            
            self.captureSession.commitConfiguration()
            //strongSelf.captureSession.addOutput(output)
            
            let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
            self.output.setSampleBufferDelegate(self, queue: outputQueue)
            
            
            
        }
    }
    
    private func setUpCaptureSessionInput() {
        
        sessionQueue.async {
            let cameraPosition: AVCaptureDevice.Position = self.isUsingFrontCamera ? .front : .back
            
            let device = self.captureDevice(forPosition: cameraPosition)
            
            do {
                
                self.captureSession.beginConfiguration()
                let currentInputs = self.captureSession.inputs
                
                for input in currentInputs {
                    self.captureSession.removeInput(input)
                }
                
                if let device = device {
                    let input = try AVCaptureDeviceInput(device: device)
                    self.captureSession.canAddInput(input)
                    self.captureSession.addInput(input)
                    self.captureDeviceInput = input
                    
                    self.captureSession.commitConfiguration()
                }
                
            } catch {
                print("Failed to create capture device input: \(error.localizedDescription)")
            }
        }
    }
    
    private func startSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        sessionQueue.async {
            DispatchQueue.main.async {
                
                self.captureSession.stopRunning()
                if let inputs = self.captureSession.inputs as? [AVCaptureDeviceInput] {
                    for input in inputs {
                        self.captureSession.removeInput(input)
                    }
                }
                
            }
        }
    }
    
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
    }
    
    private func presentDetectorsAlertController() {
        let alertController = UIAlertController(
            title: Constant.alertControllerTitle,
            message: Constant.alertControllerMessage,
            preferredStyle: .alert
        )
        weak var weakSelf = self
        detectors.forEach { detectorType in
            let action = UIAlertAction(title: detectorType.rawValue, style: .default) {
                [unowned self] (action) in
                guard let value = action.title else { return }
                guard let detector = Detector(rawValue: value) else { return }
                guard let strongSelf = weakSelf else {
                    print("Self is nil!")
                    return
                }
                strongSelf.currentDetector = detector
                strongSelf.removeDetectionAnnotations()
            }
            if detectorType.rawValue == self.currentDetector.rawValue { action.isEnabled = false }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: Constant.cancelActionTitleText, style: .cancel))
        present(alertController, animated: true)
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    private func updatePreviewOverlayView() {
        guard let lastFrame = lastFrame,
              let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
        else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let rotatedImage = UIImage(cgImage: cgImage, scale: Constant.originalScale, orientation: .leftMirrored)
        
        
        if isUsingFrontCamera {
            
            guard let rotatedCGImage = rotatedImage.cgImage else {
                return
            }
            
            let mirroredImage = UIImage(
                cgImage: rotatedCGImage, scale: Constant.originalScale, orientation: .leftMirrored)
            
            //let image = OpenCVWrapper().opencvPractice(mirroredImage)
            
            let image = mirroredImage.sd_rotatedImage(withAngle: .pi / 2, fitSize: true)
            if !userImageContainerBool{
                userImageContainer = image
            }
            
            
                previewOverlayView2.image = image
            
            
        } else {
            //let image = OpenCVWrapper().opencvPractice(rotatedImage)
            
            let image = rotatedImage
            previewOverlayView2.image = image
        }
    }
    
    private func convertedPoints(
        from points: [NSValue]?,
        width: CGFloat,
        height: CGFloat
    ) -> [NSValue]? {
        return points?.map {
            let cgPointValue = $0.cgPointValue
            let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
            let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
            let value = NSValue(cgPoint: cgPoint)
            
            return value
        }
    }
    
    private func normalizedPoint(
        fromVisionPoint point: VisionPoint,
        width: CGFloat,
        height: CGFloat
    ) -> CGPoint {
        let cgPoint = CGPoint(x: point.x, y: point.y)
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
    }
    
    
    
    /// Resets any detector instances which use a conventional lifecycle paradigm. This method is
    /// expected to be invoked on the AVCaptureOutput queue - the same queue on which detection is
    /// run.
    private func resetManagedLifecycleDetectors(activeDetector: Detector) {
        if activeDetector == self.lastDetector {
            // Same row as before, no need to reset any detectors.
            return
        }
        // Clear the old detector, if applicable.
        switch self.lastDetector {
        case .pose, .poseAccurate:
            self.poseDetector = nil
            break
        default:
            break
        }
        // Initialize the new detector, if applicable.
        switch activeDetector {
        case .pose, .poseAccurate:
            let options = activeDetector == .pose ? PoseDetectorOptions() : AccuratePoseDetectorOptions()
            options.detectorMode = .stream
            self.poseDetector = PoseDetector.poseDetector(options: options)
            break
        default:
            print("error")
            break
        }
        self.lastDetector = activeDetector
    }
 }
 //MARK: - 녹화 전용 함수
 extension CameraView2Controller{
    
    
    public func recordVideo(sampleBuffer: CMSampleBuffer){
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds
        switch _captureState {
        case .start:
            print("????")
            // Set up recorder
            _filename = UUID().uuidString
            
            let videoPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(_filename).mov")
            print("save 파일 이름 : ",videoPath)
            let writer = try! AVAssetWriter(outputURL: videoPath, fileType: .mov)
            let settings = self.output!.recommendedVideoSettingsForAssetWriter(writingTo: .mov)
            let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings) // [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: 1920, AVVideoHeightKey: 1080])
            input.mediaTimeScale = CMTimeScale(bitPattern: 600)
            input.expectsMediaDataInRealTime = true
            input.transform = CGAffineTransform(rotationAngle: .pi)
            let adapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: nil)
            if writer.canAdd(input) {
                writer.add(input)
            }
            writer.startWriting()
            writer.startSession(atSourceTime: .zero)
            _assetWriter = writer
            _assetWriterInput = input
            _adpater = adapter
            _captureState = .capturing
            _time = timestamp
        case .capturing:
            if _assetWriterInput?.isReadyForMoreMediaData == true {
                let time = CMTime(seconds: timestamp - _time, preferredTimescale: CMTimeScale(600))
                _adpater?.append(CMSampleBufferGetImageBuffer(sampleBuffer)!, withPresentationTime: time)
            }
            break
        case .end:
            print("여기 실행행행")
            if finishBool {
                print(_assetWriterInput?.isReadyForMoreMediaData)
                print(_assetWriter!.status)
                //guard _assetWriterInput?.isReadyForMoreMediaData == true, _assetWriter!.status != .failed else { break }
                guard _assetWriterInput?.isReadyForMoreMediaData == true else { break }
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(_filename).mov")
                print("save 저장 파일 : ",url)
                _assetWriterInput?.markAsFinished()
                
                
                _assetWriter?.finishWriting { [weak self] in
                    let weakSelf = self
                    self?._captureState = .idle
                    self?._assetWriter = nil
                    self?._assetWriterInput = nil
                    PHPhotoLibrary.shared().performChanges({
                        
                        //add video to PhotoLibrary here
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url.absoluteURL)
                    }) { completed, error in
                        DispatchQueue.main.sync {
                            guard let strongSelf = weakSelf else {
                                print("Self is nil!")
                                return
                            }
                            if completed {
                                print("save complete! path : " + url.absoluteString)
                                
                                strongSelf.saveComplete()
                                
                            }else{
                                strongSelf.warngingCapacity()
                                print("save failed : ", error)
                            }
                        }
                        
                    }
                    
                }
            }
            
            
            
        default:
            break
        }
    }
    func saveComplete(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.recordCheckBtn.isHidden = true
            self.backgroundView.isHidden = true
            self.retryAginBtn.isHidden = true
            self.exerciseCompleteBtn.isHidden = true
            
            self.exerciseCompleteBtn.alpha = 0
            self.retryAginBtn.alpha = 0
            self.recordCheckBtn.alpha = 0
            self.backgroundView.alpha = 0 //원래 0.8 나머지는 1
            
        }, completion: {_ in
            self.stopSession()
            self.setupLayoutBool = true
            self.removeFrontViews()
            
            
            self.mTimer.invalidate()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                self.dismiss(animated: true, completion: {
                    print("운동끝")
                })
            }
        })
        
        
    }
    func warngingCapacity(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.recordCheckBtn.isHidden = true
            self.backgroundView.isHidden = true
            self.retryAginBtn.isHidden = true
            self.exerciseCompleteBtn.isHidden = false
            
            self.exerciseCompleteBtn.alpha = 1
            self.retryAginBtn.alpha = 0
            self.recordCheckBtn.alpha = 0
            self.backgroundView.alpha = 0 //원래 0.8 나머지는 1
            
        }, completion: {_ in
            let alert = UIAlertController(title: "온체육", message: "휴대폰 용량이 부족하여 운동영상 저장실패\n파일을 정리한후 다시 실행해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                self.stopSession()
                self.setupLayoutBool = true
                self.removeFrontViews()
                
                
                self.mTimer.invalidate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    self.dismiss(animated: true, completion: {
                        print("운동끝")
                    })
                }
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
        
    }
 }
 // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
 extension CameraView2Controller: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        // Evaluate `self.currentDetector` once to ensure consistency throughout this method since it
        // can be concurrently modified from the main thread.
        let activeDetector = self.currentDetector
        resetManagedLifecycleDetectors(activeDetector: activeDetector)
        
        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let orientation = PoseUtilities.imageOrientation(
            fromDevicePosition: isUsingFrontCamera ? .front : .back
        )
        
        visionImage.orientation = orientation
        
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        //var shouldEnableClassification = false
        //var shouldEnableMultipleObjects = false
        
        switch activeDetector {
        case .pose, .poseAccurate:
            detectPose(in: visionImage, width: imageWidth, height: imageHeight)
        }
        
        recordVideo(sampleBuffer: sampleBuffer)
    }
 }
 //MARK: - collectionview Delegate
 extension CameraView2Controller :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posename_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCountCell", for: indexPath) as! exerciseCountCell
        //cell.delegate = self
        cell.labelStr = "동작\(indexPath.row + 1)"
        cell.indexpathRow = indexPath.row
        cell.exercisePosition = PoseInformation.array_count
        print(indexPath.row)
        print(PoseInformation.array_count)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(posename_array.count), height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
 }
 //MARK: - @objc
 extension CameraView2Controller {
    @objc
    func endBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "정말로 운동을 종료하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.stopSession()
            self.setupLayoutBool = true
            self.removeFrontViews()
            
            
            self.mTimer.invalidate()
            self.dismiss(animated: true, completion: nil)
            
            
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @objc
    func firstBtnAction(){
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.firstBtn.alpha = 0
            
            
        }, completion: {_ in
            self.startTimer3()
            self.firstTimerLabel.isHidden = false
            self.firstTimerLabel.alpha = 1
            self.firstBtn.isHidden = true
        })
    }
    @objc
    func recordCheckBtnAction(){
        let practice : String = extensionClass.arrayToJsonString(from: totalRecordList) ?? ""
        UserInformation.recordCheckBool = true
        print("practice : ",practice)
        if let classCode = unitList?.class_code, let unit_code = unitList?.unit_code, let subjectType = subjectType {
            finishBool = true
            totalTimer.invalidate()
            AF.appRecordUpdateStudentRecord(student_id: UserInformation.student_id, student_token: UserInformation.access_token, class_code: classCode, unit_code: unit_code, practice: practice, subjectType: subjectType, content_use_time: "\(number4)", unit_group_name: self.unitGroupName)
            
        }
    }
    @objc
    func exerciseCompleteBtnAction(){
        let practice : String = extensionClass.arrayToJsonString(from: totalRecordList) ?? ""
        
        print("practice : ",practice)
        if let classCode = unitList?.class_code, let unit_code = unitList?.unit_code, let subjectType = subjectType {
            finishBool = true
            totalTimer.invalidate()
            AF.appRecordUpdateStudentRecord(student_id: UserInformation.student_id, student_token: UserInformation.access_token, class_code: classCode, unit_code: unit_code, practice: practice, subjectType: subjectType, content_use_time: "\(number4)",unit_group_name: self.unitGroupName)
            
        }
    }
    
    
    
    @objc
    func retryBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "정말로 운동을 다시하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            PoseInformation.array_count = 0
            PoseInformation.pose_status = false
            PoseInformation.pose_status_sub = false
            PoseInformation.pose_count = 0
            PoseInformation.pose_count_double = 0.0
            PoseInformation.pose_degree = 180
            PoseInformation.pose_arraylist.removeAll()
            
            self.setupExercise()
            
            
            
            
            self.recordList.removeAll()
            
            
            self.mTimer.invalidate()
            self.startTimerBool = false
            self.recordBool = false
            self.serverBool = false
            
            
            //처음부터 눌렀을때 ui화면 사라지게 해주는 코드
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.recordCheckBtn.isHidden = true
                self.backgroundView.isHidden = true
                self.retryAginBtn.isHidden = true
                self.exerciseCompleteBtn.isHidden = true
                
                self.exerciseCompleteBtn.alpha = 0
                self.retryAginBtn.alpha = 0
                self.recordCheckBtn.alpha = 0
                self.backgroundView.alpha = 0 //원래 0.8 나머지는 1
                
            }, completion: nil)
            
            
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    public func setLimitTime(){
        timeLabel.textColor = mainColor._3378fd
        mTimer.invalidate()
        number = 0
        if posetime_array.count > PoseInformation.array_count {
            pose_time = posetime_array[PoseInformation.array_count]
            let totalTime : Int = Int(pose_time)
            print(totalTime)
            self.minute = totalTime / 60
            
            self.second = totalTime % 60
            if second == 0 {
                self.second = 60
                self.minute = self.minute - 1
            }
        }
        
    }
    
    func startTimer(){
        deadlineFinishBool = false
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    func startTimer4(){
        totalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback4), userInfo: nil, repeats: true)
    }
    
    @objc
    func timerCallback4(){
        number4 += 1
    }
    @objc
    func timerCallback(){
        //인증번호 입력하기 까지 제한시간 콜백함수
        
        totalTimeSec += 1
        number += 1
        print("timerCallback : ",totalTimeSec)
        print("number : ",number)
        
        let second = self.second - number
        print("테스트 self.second : ",self.second)
        print("테스트 second : ",second)
        if second == 0 {
            self.second = 60
            number = 0
            minute -= 1
            if minute < 0{
                mTimer.invalidate()
            }
        }
        if second < 10{
            if minute == -1 {
                timeLabel.text = String("00:00")
                timeLabel.textColor = .red
                extensionClass.showToast(view: self.view, message: "제한시간을 초과 하셨습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                
                self.deadlineFinishBool = true
                
                
            } else {
                
                timeLabel.text = String("0\(minute):0\(second)")
            }
            
        } else {
            if minute > 10 {
                timeLabel.text = String("\(minute):\(second)")
            } else {
                timeLabel.text = String("0\(minute):\(second)")
            }
            
        }
        
    }
    
    func startTimer3(){
        firstTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback3), userInfo: nil, repeats: true)
    }
    @objc
    func timerCallback3(){
        number3 += 1
        let second = 11 - number3
        print(recordList)
        firstTimerLabel.text = "\(second)"
        if second == 0 {
            self.firstTimer.invalidate()
            self.firstTimerLabel.text = "\(posename_array[0])"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.firstTimerLabel.alpha = 0
                    self.backgroundView.alpha = 0
                    
                    self.firstTimerLabel.isHidden = true
                    self.backgroundView.isHidden = true
                    self.firstBool = true
                    
                }, completion: nil)
            }
            
            
            
        }
        
        
        
    }
    
   
 }
 //MARK: - setupLayout
 extension CameraView2Controller {
    
    func setupLayout(){
        
        
        setUpPreviewOverlayView2(preview: previewOverlayView2)
        
        setUpAnnotationOverlayView()
        if !sessionBool{
            sessionBool = true
            setUpCaptureSessionInput()
        }
        setUpCaptureSessionOutput()
        
        
        
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .landscapeRight
        previewLayer.frame = self.cameraView.frame
        
        self.setPose = setPoseList(view: previewLayer)
        
        if !recognitionSetupBool{
            recognitionSetupBool = true
            
            _grayBox(box: grayBox)
            _exerciseTitleLabel(label: exerciseTitleLabel)
            _countLabel(label : countLabel)
            _timeLabel(label: timeLabel)
            _timeImgeview(imageview: timeImgeview)
            
            _recognitionLabel(label : recognitionLabel)
            _recognitionImageView(imageview : recognitionImageView)
            _exerciseCountCollectionview(collectionview : exerciseCountCollectionview)
            _exerciseTypeLabel(label : exerciseTypeLabel)//과제, 실습, 평가 적음
            _retryBtn(button : retryBtn)//다시하기
            _endBtn(button: endBtn)
            _titleLabel(label : titleLabel)
            //_countEffectImageview(imageview : countEffectImageview)
            _countEffectLabel(label: countEffectLabel)
            
            
            
            
            _backgroundView(view : backgroundView)
            
            
            _exerciseCompleteBtn(button : exerciseCompleteBtn)
            _recrodCheckBtn(button : recordCheckBtn)
            _retryAginBtn(button : retryAginBtn)
            
            _firstBtn(button : firstBtn)
            _firstTimerLabel(label : firstTimerLabel)
            
            //startTimer2()
        }
        
        
        
        
    }
    private func setUpcameraView(){
        view.addSubview(cameraView)
        
        //cameraView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func setUpPreviewOverlayView2(preview : UIImageView){
        cameraView.addSubview(preview)
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.contentMode = .scaleAspectFill
        
        //preview.isHidden = true
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: cameraView.topAnchor),
            preview.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            preview.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
        ])
        
    }
    private func setUpPreviewOverlayView(preview : UIImageView) {
        cameraView.addSubview(preview)
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.contentMode = .scaleAspectFill
        preview.alpha = 0.7
        preview.clipsToBounds = true
        preview.layer.masksToBounds = true
        preview.layer.borderWidth = 10
        preview.layer.borderColor = mainColor._3378fd.cgColor
        //preview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setUpPreviewOverlayViewGesture(gestureRecognizer:))))
        
        preview.topAnchor.constraint(equalTo: cameraView.topAnchor, constant: view.frame.height * 0.58).isActive = true
        preview.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor, constant: view.frame.height * 1.15).isActive = true
        
        preview.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor, constant: view.frame.height * 0.07 * -1).isActive = true
        preview.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor, constant:  view.frame.height * 0.1 * -1).isActive = true
        
    }
    
    private func setUpAnnotationOverlayView() {
        cameraView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
        ])
    }
    
    
    
    
    
    private func _grayBox(box : UIView){
        frontView?.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.alpha = 0.92
        box.backgroundColor = mainColor.hexStringToUIColor(hex: "#ffffff")
        box.layer.cornerRadius = 21
        box.layer.masksToBounds = true
        box.clipsToBounds = true
        
        box.topAnchor.constraint(equalTo: frontView!.topAnchor, constant: 13).isActive = true
        box.leadingAnchor.constraint(equalTo: frontView!.leadingAnchor, constant: view.frame.width * 0.225).isActive = true
        box.trailingAnchor.constraint(equalTo: frontView!.trailingAnchor, constant: view.frame.width * 0.225 * -1).isActive = true
        box.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    func _exerciseTitleLabel(label : UILabel){
        if let view = frontView{
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "-"
            label.textColor = mainColor._3378fd
            label.font = UIFont.NotoSansCJKkr(type: .normal, size: 20)
            
            label.centerYAnchor.constraint(equalTo: grayBox.centerYAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: grayBox.leadingAnchor, constant: 20).isActive = true
            label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        }
    }
    
    
    func _countLabel(label : UILabel){
        if let view = frontView {
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "・ -"
            label.font = UIFont.NotoSansCJKkr(type: .normal, size: 20)
            label.textAlignment = .right
            label.textColor = mainColor._3378fd
            
            label.centerYAnchor.constraint(equalTo: grayBox.centerYAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: grayBox.trailingAnchor, constant: -20).isActive = true
            label.widthAnchor.constraint(equalToConstant: view.frame.width * 0.14).isActive = true
            
        }
    }
    
    func _timeLabel(label : UILabel){
        if let view = frontView {
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "-:-"
            label.textAlignment = .center
            label.font = UIFont.NotoSansCJKkr(type: .normal, size: 20)
            label.textColor = mainColor._3378fd
            
            label.centerYAnchor.constraint(equalTo: grayBox.centerYAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -5).isActive = true
            label.widthAnchor.constraint(equalToConstant: 55).isActive = true
        }
    }
    
    func _timeImgeview(imageview : UIImageView){
        if let view = frontView {
            view.addSubview(imageview)
            imageview.translatesAutoresizingMaskIntoConstraints = false
            imageview.image = #imageLiteral(resourceName: "train_time")
            imageview.contentMode = .scaleAspectFit
            
            imageview.centerYAnchor.constraint(equalTo: grayBox.centerYAnchor).isActive = true
            imageview.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -10).isActive = true
            imageview.widthAnchor.constraint(equalToConstant: 25).isActive = true
            imageview.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
    }
    
    
    
    func _recognitionImageView(imageview : UIImageView){
        if let view = frontView{
            view.addSubview(imageview)
            imageview.translatesAutoresizingMaskIntoConstraints = false
            imageview.backgroundColor = .red
            let radius : CGFloat = 17
            imageview.layer.cornerRadius = radius * 0.5
            imageview.clipsToBounds = true
            imageview.layer.masksToBounds = true
            
            imageview.centerYAnchor.constraint(equalTo: recognitionLabel.centerYAnchor).isActive = true
            imageview.leadingAnchor.constraint(equalTo: recognitionLabel.leadingAnchor, constant: 7).isActive =  true
            imageview.widthAnchor.constraint(equalToConstant: radius).isActive = true
            imageview.heightAnchor.constraint(equalToConstant: radius).isActive = true
            
            
        }
    }
    
    func _recognitionLabel(label : UILabel){
        if let view = frontView{
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "      인식상태"
            label.textColor = mainColor._3378fd
            label.textAlignment = .center
            label.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
            label.backgroundColor = mainColor.hexStringToUIColor(hex: "#ffffff")
            label.alpha = 0.92
            label.layer.cornerRadius = 21
            label.layer.masksToBounds = true
            label.clipsToBounds = true
            
            
            label.topAnchor.constraint(equalTo: grayBox.topAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: grayBox.leadingAnchor, constant: -20).isActive = true
            label.widthAnchor.constraint(equalToConstant: 85).isActive = true
            label.heightAnchor.constraint(equalToConstant: 42).isActive = true
        }
    }
    
    func _exerciseCountCollectionview(collectionview : UICollectionView){
        if let view = frontView {
            view.addSubview(collectionview)
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            collectionview.backgroundColor = .clear
            collectionview.collectionViewLayout = layout
            collectionview.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
            
            collectionview.translatesAutoresizingMaskIntoConstraints = false
            collectionview.register(exerciseCountCell.self, forCellWithReuseIdentifier: "exerciseCountCell")
            
            collectionview.delegate = self
            collectionview.dataSource = self
            
            
            collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.frame.height * 0.07 ).isActive = true
            collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: view.frame.height * 0.07 * -1).isActive = true
            collectionview.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
    }
    
    func _exerciseTypeLabel(label : UILabel){
        if let view = frontView{
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = mainColor._3378fd
            label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
            //label.text = "과제"
            label.textAlignment = .center
            label.textColor = .white
            label.layer.cornerRadius = 4
            label.layer.masksToBounds = true
            label.clipsToBounds = true
            
            label.bottomAnchor.constraint(equalTo: exerciseCountCollectionview.topAnchor,constant:  -5).isActive = true
            label.leadingAnchor.constraint(equalTo: exerciseCountCollectionview.leadingAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 50).isActive = true
            label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        
    }
    
    func _retryBtn(button : UIButton){
        if let view = frontView{
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("다시하기", for: .normal)
            button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
            button.setTitleColor(mainColor._404040, for: .normal)
            button.backgroundColor = mainColor.hexStringToUIColor(hex: "#ffffff")
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(retryBtnAction), for: .touchUpInside)
            button.bottomAnchor.constraint(equalTo: exerciseCountCollectionview.topAnchor,constant:  -5).isActive = true
            button.leadingAnchor.constraint(equalTo: exerciseTypeLabel.trailingAnchor,constant:  7).isActive = true
            button.widthAnchor.constraint(equalToConstant: 70).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        }
    }
    func _endBtn(button : UIButton){
        if let view = frontView{
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("뒤로가기 / 운동 종료", for: .normal)
            button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
            button.setTitleColor(mainColor._404040, for: .normal)
            button.backgroundColor = mainColor.hexStringToUIColor(hex: "#ffffff")
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(endBtnAction), for: .touchUpInside)
            button.bottomAnchor.constraint(equalTo: exerciseCountCollectionview.topAnchor,constant:  -5).isActive = true
            button.leadingAnchor.constraint(equalTo: retryBtn.trailingAnchor,constant:  7).isActive = true
            button.widthAnchor.constraint(equalToConstant: 140).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        }
    }
    func _titleLabel(label : UILabel){
        if let view = frontView {
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            //label.text = "체육단원/요가/스트레칭 자세평가"
            label.textAlignment = .left
            label.textColor = .white//mainColor.hexStringToUIColor(hex: "#ffffff")
            label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
            
            label.topAnchor.constraint(equalTo: exerciseTypeLabel.bottomAnchor, constant: 10).isActive = true
            label.leadingAnchor.constraint(equalTo: exerciseTypeLabel.leadingAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: view.frame.width * 0.5).isActive = true
        }
        
    }
    func _countEffectImageview(imageview : UIImageView){
        if let view = frontView {
            
            view.addSubview(imageview)
            imageview.translatesAutoresizingMaskIntoConstraints = false
            imageview.alpha = 0
            imageview.image = #imageLiteral(resourceName: "good_symbol")
            imageview.contentMode = .scaleAspectFit
            
            imageview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageview.widthAnchor.constraint(equalToConstant: 300).isActive = true
            imageview.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
    }
    func _countEffectLabel(label : UILabel){
        if let view = frontView{
            view.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = mainColor.hexStringToUIColor(hex: "#00a749")
            label.textAlignment = .center
            label.font = UIFont.NotoSansCJKkr(type: .bold, size: 200)
            label.text = "1"
            label.alpha = 0
            
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 300).isActive = true
            label.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
    }
    
    
    
    func _backgroundView(view : UIView){
        if let view1 = frontView {
            view1.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .black
            view.alpha = 0.8
            view.isHidden = false
            
            
            
            view.topAnchor.constraint(equalTo: view1.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: view1.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: view1.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: view1.bottomAnchor).isActive = true
            
        }
    }
    func _nextExerciseLabel(label : UILabel){
        if let view = frontView {
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "다음 동작명"
            label.textColor = .red
            label.font = UIFont.NotoSansCJKkr(type: .bold, size: 80)
            label.textAlignment = .center
            label.alpha = 0
            label.isHidden = true
            
            label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: view.frame.width * 0.25).isActive = true
        }
    }
    
    
    
    
    func _exerciseCompleteBtn(button : UIButton){
        if let view = frontView {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("완료하기", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 20)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 20
            button.layer.borderColor = mainColor._3378fd.cgColor
            button.backgroundColor = mainColor._3378fd
            button.alpha = 0
            button.addTarget(self, action: #selector(exerciseCompleteBtnAction), for: .touchUpInside)
            button.isHidden = true
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height * -0.15).isActive = true
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.frame.height * 0.2).isActive = true
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: view.frame.height * -0.2).isActive = true
            
            button.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2).isActive = true
        }
    }
    
    func _recrodCheckBtn(button : UIButton){
        if let view = frontView {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("기록확인", for: .normal)
            button.setTitleColor(mainColor._3378fd, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 20)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 20
            button.layer.borderColor = mainColor._3378fd.cgColor
            button.backgroundColor = .white
            button.alpha = 0
            button.addTarget(self, action: #selector(recordCheckBtnAction), for: .touchUpInside)
            button.isHidden = true
            
            button.topAnchor.constraint(equalTo: self.exerciseCompleteBtn.bottomAnchor, constant: 10).isActive = true
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.frame.height * 0.2).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.frame.width * -0.51).isActive = true
            button.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2).isActive = true
        }
    }
    func _retryAginBtn(button : UIButton){
        if let view = frontView {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("처음부터", for: .normal)
            button.setTitleColor(mainColor._3378fd, for: .normal)
            
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 20)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 20
            button.layer.borderColor = mainColor._3378fd.cgColor
            button.backgroundColor = .white
            button.alpha = 0
            button.addTarget(self, action: #selector(retryBtnAction), for: .touchUpInside)
            button.isHidden = true
            
            button.topAnchor.constraint(equalTo: self.exerciseCompleteBtn.bottomAnchor, constant: 10).isActive = true
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.frame.width * 0.51).isActive = true
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: view.frame.height * -0.2).isActive = true
            
            button.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2).isActive = true
        }
    }
    func _firstBtn(button : UIButton){
        if let view = frontView {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("시작하기", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 20)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 20
            button.layer.borderColor = mainColor._3378fd.cgColor
            button.backgroundColor = mainColor._3378fd
            button.alpha = 1
            button.addTarget(self, action: #selector(firstBtnAction), for: .touchUpInside)
            button.isHidden = false
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.frame.height * 0.2).isActive = true
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: view.frame.height * -0.2).isActive = true
            
            button.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2).isActive = true
        }
    }
    func _firstTimerLabel(label : UILabel){
        if let view = frontView {
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .red
            label.textAlignment = .center
            label.font = UIFont.NotoSansCJKkr(type: .medium, size: 80)
            label.text = "10"
            label.alpha = 0
            label.isHidden = true
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            label.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        }
    }
 }
 
 
 
 
 
 
 private enum Constant {
    static let alertControllerTitle = "Vision Detectors"
    static let alertControllerMessage = "Select a detector"
    static let cancelActionTitleText = "Cancel"
    static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
    static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
    static let noResultsMessage = "No Results"
    static let localModelFile = (name: "bird", type: "tflite")
    static let labelConfidenceThreshold = 0.75
    static let smallDotRadius: CGFloat = 10.0
    static let lineWidth: CGFloat = 3.0
    static let originalScale: CGFloat = 1.0
    static let padding: CGFloat = 10.0
    static let resultsLabelHeight: CGFloat = 200.0
    static let resultsLabelLines = 5
    static let imageLabelResultFrameX = 0.4
    static let imageLabelResultFrameY = 0.1
    static let imageLabelResultFrameWidth = 0.5
    static let imageLabelResultFrameHeight = 0.8
 }

