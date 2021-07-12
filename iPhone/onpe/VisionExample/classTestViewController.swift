//
//  classTestViewController.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/03.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
//입장하기 -> x차시 선택하기 페이지 -> 참고자료 및 영상 페이지 -> 해당페이지
//해당 페이지에서 실습, 과제, 평가 등을 선택하여 운동을 실시한다.
class classTestViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        print(grayLine1)
        AF.delegate17 = self
        AF.delegate16 = self
        let deviceType = UIDevice().type
        
        let deviceModel = deviceType.rawValue
        sizetheFitsControlByDevice(deviceType: deviceModel)
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)
        navigationItem.setRightBarButtonItems([sideMenuNarBtn], animated: false)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        //수업현황을 업데이트 하기 위해서 사용하는 함수
        AF.appRecordGetStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: unitList!.class_code!, unit_code: unitList!.unit_code!, url: "app/record/get_student_class_record")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if userInformationClass.recordCheckBool {
            userInformationClass.recordCheckBool = false
            classReportBtnActionBool = true
            AF.appRecordGetStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: unitList!.class_code!, unit_code: unitList!.unit_code!, url: "app/record/get_student_class_record")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        classPracticeCount = 0
        taskPracticeCount = 0
        evaluationPracticeCount = 0
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    //----------satus bar height
    let statusBarHeight: CGFloat = {
        var heightToReturn: CGFloat = 0.0
             for window in UIApplication.shared.windows {
                 if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                     heightToReturn = height
                 }
             }
        return heightToReturn
    }()

    lazy var sideMenuNarBtn = UIBarButtonItem(image: UIImage(systemName: "list.dash")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(sideMenuToggle))
    //---------------------------사이드 네비게이션 관련 변수---------
    lazy var black_view = UIView()
    
    lazy var sideMenuCollectionview : UICollectionView = {
        let cv = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.backgroundColor = .white
        return cv
    }()
    
    var getCollectionviewWidth : CGFloat? // 사이드 메뉴의 가로 너비 값
    var getCollectionviewHeight : CGFloat?
    var setSideMenuCollectionviewWidth : CGFloat =  0.2// 사이드 메뉴의 가로 너비 비율
    var setSideMenuCollectionviewX : CGFloat?//사이드 메뉴의 x좌표 -> 해당 값으로 사이드 메뉴의 드래그 범위를 지정한다.
    var setSideMenuCollectionviewY : CGFloat = 0
    var sideMenuFotterContent : CGFloat = 0
    let grayLine1 = UIView()//회색박스
    let periodLabel = UILabel()//기간 : 2021.05.04, 18:00
    
    let taskLabel = UILabel()//과제 여부
    let testLabel = UILabel()//평가 여부
    let classReportBtn = UIButton()//수업현황
    let messageBtn = UIButton()//메시지함
    let grayLine2 = UIView()
    let resultBtn = UIButton()//결과보기 <- 수업현황이랑 똑같음
    let submitBtn = UIButton()//최종제출
    let grayLine3 = UIView()
    
    let classTestCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let AF = ServerConnectionLegacy()
    var unitGroupName : String?// 그룹 이름
    var unitType : String = "0"
    var subjectTitle : String = ""
    var subjectIndex : String = "0"
    var subjectType : String?
    var contentTitleList : [String] = []
    var contentNameList : [String] = []
    var contentCodeList : [String] = []
    var recordDic : recordDic?
    var submitType = 0 // 0 -> 제출 가능, 1 -> 제출불가능, 2 -> 제출완료
    var unitList : UnitList?{
        didSet{
            if let unitList = self.unitList{
                self.setupText(unitList : unitList)
                activateSubmitButton()
            }
        }
    }
    
    var classPracticeCount = 0
    var taskPracticeCount = 0
    var evaluationPracticeCount = 0
    var teskCompleteAlert = UIAlertController()
    var classReportBtnActionBool = false
    
    
    //차시별 첫 체크리스트늬 바텀 시트 변수모음
    let black_view1 = UIView()
    let unitlistCheckListCollectionview : UICollectionView = {
        let cv = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.backgroundColor = .white
        
        return cv
    }()
    var unitlistCheckListCollectionview_height : CGFloat = 0.3
    var unitlistCheckListCollectionview_value : CGFloat = 0
    var unitlistCheckListCollectionviewY : CGFloat = 0
    //-----------------------------------------------------------------
    var getExerciseContentStr : String?//해야할 운동리스트 json 값으로 받는 변수
    
    func setupText(unitList : UnitList){
        let u = unitList
        
        if let startTime = u.unit_start_date ,let deadTime = u.unit_end_date {
            periodLabel.text = "• 기간 : " + extensionClass.DateToString(date: startTime, type: 1)  + " ~ " + extensionClass.DateToString(date: deadTime, type: 1) + "까지"
        }

        let resultHomeWork = extensionClass.jsonToArray(jsonString: u.content_home_work ?? "[]")
        for value in resultHomeWork{
            if value == "1"{
                taskLabel.text = "과제 ○"
                break
            } else {
                taskLabel.text = "과제 ✕"
            }
        }

        let resultTest = extensionClass.jsonToArray(jsonString: u.content_test ?? "[]")
        for value in resultTest{
            if value == "1"{
                testLabel.text = "평가 ○"
                break
            } else {
                testLabel.text = "평가 ✕"
            }
        }


        contentNameList.removeAll()
        contentCodeList.removeAll()
        
        if let data = u.content_code_list?.data(using: .utf8){
            do {
                let getResult = try JSONDecoder().decode([unitContent].self, from: data)
                print("수업 이름(전부) : ",getResult)
                for value in getResult{
                    if let name = value.content_name, let code = value.content_code, let title = value.content_title{
                        print("수업 이름 : ",name)
                        contentNameList.append(name)
                        contentCodeList.append(code)
                        contentTitleList.append(title)
                    }
                    
                    //print(contentCodeList)
                }
                
            } catch let error {
                print(error)
            }
        }
        
        
        classTestCollectionview.reloadData()
    }
    
    func activateSubmitButton(){
        if let recordDic = recordDic {
            print(recordDic.student_practice)
            if recordDic.student_practice != "1" {
                if recordDic.evaluation_practice != nil {
                    //제출가능
                    for value in extensionClass.jsonToArray4(jsonString: recordDic.evaluation_practice!){
                        for index in value{
                            if index.count < 2 {
                                //운동 기록을 다체우지 않았을때
                                self.submitType = 1
                                submitBtn.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
                                submitBtn.setTitleColor(mainColor._404040, for: .normal)
                                break
                            } else {
                                //다채웟을때 운동 보내기 가능
                                self.submitType = 0
                                submitBtn.backgroundColor = mainColor._3378fd
                                submitBtn.setTitleColor(.white, for: .normal)
                            }
                        }
                    }
                    
                } else {
                    //제출불가능(운동안함)
                    self.submitType = 1
                    submitBtn.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
                    submitBtn.setTitleColor(mainColor._404040, for: .normal)
                }
                
            } else {
                //제출완료
                self.submitType = 2
                submitBtn.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
                submitBtn.setTitleColor(mainColor._404040, for: .normal)
                
                
            }
            
        }
    }
    func exerciseEnter(exerciseContentStr : String?){
        self.getExerciseContentStr = exerciseContentStr
        var joinUnitList : [String]? = userInformationClass.preferences.object(forKey: userInformationClass.unitListKey) as? [String]
        print(joinUnitList)
        var unitCodeBool = false // 해당 값이 false면 이미 체크리스트 작성, true라면 체크리스트 미작성
        if let unitList = joinUnitList{
            for value in unitList {
                if self.unitList?.unit_code == value {
                    print("이미 들음 바로 입장")
                    unitCodeBool = true
                    break
                }
            }
        }
        
        if unitCodeBool {
            var i = 0
            var subejectTitleStr : String?
            for value in subjectTitle {
                if -1 < i, i < 4 {
                    if i == 0 {
                        subejectTitleStr = String(value)
                    } else {
                        subejectTitleStr = subejectTitleStr! + String(value)
                    }
                    
                }
                i += 1
            }
            subjectTitle = subejectTitleStr ?? "실습수업"
            print(subjectTitle)
            if subjectTitle == "실습수업"{
                let vc = CameraViewController()
                
                if subjectType == "평가"{
                    vc.subjectListTotal = self.evaluationPracticeCount
                } else if subjectType == "실습" {
                    vc.subjectListTotal = self.classPracticeCount
                } else {
                    vc.subjectListTotal = self.taskPracticeCount
                }
                vc.unitGroupName = self.unitGroupName
                vc.unitList = unitList
                vc.subjectTitle = self.subjectTitle
                vc.subjectIndex = self.subjectIndex//몇번째 평가인지 인지한다.
                print(self.subjectIndex)
                vc.subjectType = self.subjectType
                vc.getRecordDic = self.recordDic// 해당 자료에서 content_code, 그리고 평가 종목의 리스트를 저장한다.
                
                vc.exerciseContentStr = exerciseContentStr
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else if subjectTitle == "이론수업"{
                //터치하면 다음화면 안넘어가기
                extensionClass.showToast(view: view, message: "이론 수업 완료", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            } else {
                let vc = CameraView2Controller()
                
                if subjectType == "평가"{
                    vc.subjectListTotal = self.evaluationPracticeCount
                } else if subjectType == "실습" {
                    vc.subjectListTotal = self.classPracticeCount
                } else {//실습
                    vc.subjectListTotal = self.taskPracticeCount
                }
                vc.unitGroupName = unitGroupName
                vc.unitList = unitList
                vc.subjectTitle = self.subjectTitle
                vc.subjectIndex = self.subjectIndex//몇번째 평가인지 인지한다.
                print(self.subjectIndex)
                vc.subjectType = self.subjectType
                vc.getRecordDic = self.recordDic// 해당 자료에서 content_code, 그리고 평가 종목의 리스트를 저장한다.
                
                vc.exerciseContentStr = exerciseContentStr
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } else {
            //첫차시일때 바텀리스트 생성
            unitListCheckListAction()
        }
        
    }
    
}
//MARK: - sideMenu Funtion
extension classTestViewController : sideMenuCellDelegate {
    
    func sizetheFitsControlByDevice(deviceType : String)
    {
        if deviceType == "iPhone 8" || deviceType == "iPhone 7" || deviceType == "iPhone 6" || deviceType == "iPhone 6S"
        {
            unitlistCheckListCollectionview_height = 0.2
            sideMenuFotterContent = self.view.frame.width * 0.05
            
        } else if deviceType == "iPhone 11" || deviceType == "iPhone XR"  {
            
            unitlistCheckListCollectionview_height = 0.35
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else if deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6S Plus" || deviceType == "iPhone 7 Plus" || deviceType == "iPhone 8 Plus" {
            
            unitlistCheckListCollectionview_height = 0.2
            sideMenuFotterContent = self.view.frame.width * 0.05
        } else if deviceType == "iPhone 11 Pro Max" || deviceType == "iPhone XS Max" {
            
            unitlistCheckListCollectionview_height = 0.35
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else if deviceType == "iPhone 11 Pro" || deviceType == "iPhone X" || deviceType == "iPhone XS"  {
            
            unitlistCheckListCollectionview_height = 0.35
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else {
            let device : String = UIDevice.current.name
            print(device)
            if device == "iPhone 12 Pro" || device == "iPhone 12" || device == "iPhone 12 Pro Max" || deviceType == "iPhone 12 mini"{
            
                unitlistCheckListCollectionview_height = 0.35
                sideMenuFotterContent = self.view.frame.width * 0.5
            } else {
            
                unitlistCheckListCollectionview_height = 0.2
                sideMenuFotterContent = self.view.frame.width * 0.5
            }
        }
    }
    
    //사이드좌표
    func selectSideMenu(pagePosition: Int) {
        /**
         각 값에 따라서 페이지로 이동
         1. 뒤로가기
         2. 알람메뉴
         3. 메세지함
         4. 전체수업보기
         5. 마이페이지
         6. self체육수업
         7. 방과 후 활동
         8. 커뮤니티
         9. 환경설정
         10. 자주 묻는 질문
         */
        NotificationCenter.default.removeObserver(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view.alpha = 0
            //print("black_view 끝")
            
            self.sideMenuCollectionview.frame = CGRect(
                x: self.view.frame.width,
                y: self.setSideMenuCollectionviewY,
                width: self.getCollectionviewWidth!,
                height: self.getCollectionviewHeight!
            )
            
            
        }, completion: { _ in
            var vc : UIViewController?
            var defaultBool = false
            switch pagePosition {
            case 10:
                vc = faqListViewController()
                vc?.view.backgroundColor = .white
                vc?.title = "자주 묻는 질문"
            case 9:
                vc = settingMenuViewController()
                vc?.view.backgroundColor = .white
                vc?.title = "환경설정"
            case 8:
                vc = communityViewController()
                vc?.view.backgroundColor = .white
                vc?.title = "커뮤니티"
            case 6:
                vc = ViewController1()
            case 5:
                vc = myPageViewController()
            case 4:
                vc = ViewController1()
            case 3:
                vc = messageListViewController()
                vc?.title = "학급 메세지"
                vc?.view.backgroundColor = .white
            case 7:
                vc = contentsViewController()
                vc?.title = "방과 후 활동"
                vc?.view.backgroundColor = .white
            default:
                defaultBool = true
                print("숫자 : ","\(pagePosition)")
            }
            
            if !defaultBool {
                
                let navController = UINavigationController(rootViewController: vc!)
                if pagePosition == 6 || pagePosition == 4 {
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true, completion: nil)
                } else {
                    self.present(navController, animated: true, completion: nil)
                }
                
              
                
                
            } else {
                if pagePosition != 1{
                    defaultBool = false
                    extensionClass.showToast(view: self.view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                }
                
            }
            
        })//animate
        
        //print("pagePosition : ",pagePosition)
    }
    
    func _blackView(window : UIWindow)
    {
        window.addSubview(black_view)
        black_view.translatesAutoresizingMaskIntoConstraints = false
        black_view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        black_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(wasTaped(gestureRecognizer:))))
        black_view.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        black_view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        black_view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        black_view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        black_view.alpha = 0
    }
    
    
    
    func _sideMenuCollectionview(window : UIWindow){
        sideMenuCollectionview.isScrollEnabled = false
        sideMenuCollectionview.backgroundColor = .white
        sideMenuCollectionview.layer.cornerRadius = 20
        sideMenuCollectionview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        sideMenuCollectionview.translatesAutoresizingMaskIntoConstraints = false
        sideMenuCollectionview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:))))
        window.addSubview(sideMenuCollectionview)
        
        sideMenuCollectionview.register(sideMenuCell.self, forCellWithReuseIdentifier: "sideMenuCell")
        sideMenuCollectionview.delegate = self
        sideMenuCollectionview.dataSource = self
        
        sideMenuCollectionview.frame = CGRect(
            x: self.view.frame.width,
            y: self.setSideMenuCollectionviewY,
            width: 0,
            height: window.frame.height - setSideMenuCollectionviewY
        )
    }
    
    @objc
    func sideMenuToggle(){
        if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        {
            //printInfo(window)
            _blackView(window: window)//검은색 뒷배경 설정 함수
            _sideMenuCollectionview(window : window)//컬랙션뷰 설정
            self.sideMenuCollectionview.reloadData()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.setSideMenuCollectionviewX = window.frame.width * self.setSideMenuCollectionviewWidth//sideMenu 너비 결정 x좌표 결정 (wasDrag 함수에서 사용)
                
                self.getCollectionviewWidth = window.frame.width * (1 - self.setSideMenuCollectionviewWidth)//sideMenu 너비 결정
                self.getCollectionviewHeight = window.frame.height - self.setSideMenuCollectionviewY//sideMenu 높이 결정

                self.black_view.alpha = 1
                
                self.sideMenuCollectionview.frame = CGRect(
                    x: self.setSideMenuCollectionviewX!,
                    y: self.setSideMenuCollectionviewY,
                    width:  self.getCollectionviewWidth!,
                    height: self.getCollectionviewHeight!
                )
                
                
                
                
            }, completion: nil)//animate
            
        }
    }
    @objc
    func wasTaped(gestureRecognizer: UITapGestureRecognizer){
        //옆의 검은색 화면을 탭하였을때
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view.alpha = 0
            //print("black_view 끝")
            
            self.sideMenuCollectionview.frame = CGRect(
                x: self.view.frame.width,
                y: self.setSideMenuCollectionviewY,
                width: self.getCollectionviewWidth!,
                height: self.getCollectionviewHeight!
            )
            
            
        }, completion: nil)//animate
    }
    @objc
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {//슬라이드해서 메뉴 조절하기
        
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            
            let translation = gestureRecognizer.translation(in: self.view)//collectionview를 탭하고 이동시키는 값
            
            
            //이동하는 값이 화면의 0.5 이상이면 화면은 움직이지 않는다.
            
            if translation.x + setSideMenuCollectionviewX! > setSideMenuCollectionviewX! {
                sideMenuCollectionview.frame.origin.x = setSideMenuCollectionviewX! + translation.x
            }
        
        }//네비게이션 화면을 움직이는 중일때
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            
            //화면을 움직인 값이 컬랙션뷰의 화면 전체 너비의 0.3 넘게 이동했으면 화면을 자동으로 없어지게한다.
            if (setSideMenuCollectionviewX! * 1.3) < self.sideMenuCollectionview.frame.origin.x {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.black_view.alpha = 0
                    //print("drag 끝")
                    self.sideMenuCollectionview.frame = CGRect(
                        x: self.view.frame.width,
                        y: self.setSideMenuCollectionviewY,
                        width: self.getCollectionviewWidth!,
                        height: self.getCollectionviewHeight!
                    )
                    
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.sideMenuCollectionview.frame.origin.x = self.setSideMenuCollectionviewX!
                }, completion: nil)
            }
        }
    }//wasDragged
    
    
    
    
}
//MARK: - 차시별 수업 들을때 첫 수업일경우 실행되는 바텀 다이얼로그
extension classTestViewController : unitlistCheckListCellDelegate {
    func confirmAction(type: Bool) {
        if type {
            //유닛리스트 값 쉐어드 저장후 camera이동
            UIView.animate(withDuration: 0.3, animations: {
                self.black_view1.alpha = 0
                
                self.unitlistCheckListCollectionview.frame = CGRect(x: 0, y: self.unitlistCheckListCollectionviewY, width: self.view.frame.width, height: self.unitlistCheckListCollectionview_value)
                //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
            }, completion: {done in
                if done {
                    self.unitlistCheckListCollectionview.removeFromSuperview()
                    self.black_view1.removeFromSuperview()
                    
                    self.exerciseEnter(exerciseContentStr: self.getExerciseContentStr)
                    
                    
                }
            })
            
        } else {
            //aler코드 실행하기
            let alert = UIAlertController(title: "온체육", message: "체크리스트를 모두 체크해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func blackView1(window : UIWindow)
    {
        black_view1.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        black_view1.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        black_view1.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        black_view1.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
    }
    @objc
    func closeBottomSheet(gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view1.alpha = 0
            
            self.unitlistCheckListCollectionview.frame = CGRect(x: 0, y: self.unitlistCheckListCollectionviewY, width: self.view.frame.width, height: self.unitlistCheckListCollectionview_value)
            //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
        }, completion: {done in
            if done {
                self.unitlistCheckListCollectionview.removeFromSuperview()
                self.black_view1.removeFromSuperview()
            }
        })
    }
    
    func unitListCheckListAction()
    {
        
        if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) {
            
            black_view1.translatesAutoresizingMaskIntoConstraints = false
            black_view1.backgroundColor = UIColor(white: 0, alpha: 0.5)
            black_view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBottomSheet(gestureRecognizer:))))
            
            unitlistCheckListCollectionview.delegate = self
            unitlistCheckListCollectionview.dataSource = self
            window.addSubview(black_view1)
            unitlistCheckListCollectionview.backgroundColor = .white
            unitlistCheckListCollectionview.isScrollEnabled = false
            unitlistCheckListCollectionview.translatesAutoresizingMaskIntoConstraints = false
            
            unitlistCheckListCollectionview.layer.cornerRadius = 20
            unitlistCheckListCollectionview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            window.addSubview(unitlistCheckListCollectionview)
            
            unitlistCheckListCollectionview.register(unitlistCheckListCell.self, forCellWithReuseIdentifier: "unitlistCheckListCell")
            blackView1(window: window)//검은색 뒷배경 설정 함수
            
            unitlistCheckListCollectionview.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 0)
            
            black_view1.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //let window_height : CGFloat = 0.7
                self.unitlistCheckListCollectionview_value =  window.frame.height * (1 - self.unitlistCheckListCollectionview_height)
                
                self.unitlistCheckListCollectionviewY = window.frame.height
                
                self.black_view1.alpha = 1
                self.unitlistCheckListCollectionview.frame = CGRect(x: 0, y: (window.frame.height * self.unitlistCheckListCollectionview_height), width: window.frame.width, height: self.unitlistCheckListCollectionview_value)
                
                self.unitlistCheckListCollectionview.reloadData()
            }, completion: nil)
            
        }
    }
}
//MARK: - collectionview Delegate
extension classTestViewController : exerciseTestPageDelegate, unitListPageDelegate {
    func appCurriculumStudentUpdateSubmitTask(result: Int) {
        if result == 0 {
            teskCompleteAlert.dismiss(animated: true, completion: nil)
            extensionClass.showToast(view: view, message: "제출이 완료 되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            //제출후 버튼 비활성화
            self.submitType = 2
            submitBtn.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
            submitBtn.setTitleColor(mainColor._404040, for: .normal)
        } else if result == 1{
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appCurriculumStudentGetCurriculum(result: Int, unitList: [UnitList]) {
        //사용안함
    }
    
    func appRecordGetStudentClassRecord(result: Int, recordDic: recordDic?) {
        //수업현황 기록 받아오기 위해서 사용
        if result == 0 {
            self.recordDic = recordDic
            activateSubmitButton()
            //해당 조건문을 사용한 이유는 항상 viewWillAppear에서 appRecordGetStudentClassRecord함수가 실행되는데 "조건문을 통과할 경우는 이용자가 '수업현황'을 눌렀을경우 최신 수업현황을 받아오고 해당 조건문을 통과하기 위해서이다."
            if classReportBtnActionBool{
                classReportBtnActionBool = !classReportBtnActionBool
                let vc = classStatusViewController()
                vc.title = "\(title!)"// 입력
                vc.getRecordDic = self.recordDic
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    

    //exerciseContentStr -> 운동의 content Code
    func appClassGetContentList(result: Int, exerciseContentStr: String?) {
        if result == 0 {
            //print(exerciseContentStr)
            exerciseEnter(exerciseContentStr: exerciseContentStr)
            //print(subjectTitle)
            
            
            
        } else if result == 1{
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        //print(exerciseContent)
    }
    
    
}
//MARK: - @objc
extension classTestViewController {
    @objc
    func messageBtnAction(){
        let vc = messageListViewController()
        vc.title = "학급 메세지"
        vc.view.backgroundColor = .white
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    @objc
    func submitBtnAction(){
        //submitType = 0 // 0 -> 제출 가능, 1 -> 제출불가능, 2 -> 제출완료
        if submitType == 0 {
            
            teskCompleteAlert = UIAlertController(title: "온체육", message: "정말 평가기록을 제출 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                if let classCode = self.unitList?.class_code, let unitCode = self.unitList?.unit_code {
                    self.AF.appCurriculumStudentUpdateSubmitTask(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, unit_code: unitCode, student_number: userInformationClass.student_number, unit_class_type: self.unitType, unit_group_name: self.unitGroupName ?? "", url: "app/curriculum/student_update_submit_task")
                }
                
                
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            teskCompleteAlert.addAction(okAction)
            teskCompleteAlert.addAction(cancelAction)
            present(teskCompleteAlert, animated: true, completion: nil)
        } else if submitType == 1 {
            let alert = UIAlertController(title: "온체육", message: "최종 제출을 위해 운동 모두 완료해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else if submitType == 2 {
            let alert = UIAlertController(title: "온체육", message: "최종 제출 하셨습니다.\n(선생님이 요청한 방법으로 운동영상을 전송해주세요.)", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    @objc
    func classReportBtnAction(){
        //x차시 공다루기 수업의 수업현황 이동함수
        if !classReportBtnActionBool {
            classReportBtnActionBool = !classReportBtnActionBool
            AF.appRecordGetStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: unitList!.class_code!, unit_code: unitList!.unit_code!, url: "app/record/get_student_class_record")
        }
        
    }
    @objc
    func resultBtnAction(){
        let vc = classStatusViewController()
        vc.title = "\(title!)"// 입력
        vc.getRecordDic = self.recordDic
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension classTestViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, classTestCellDelegate {
    
    
    func classTestCellClick(submitType : Int, subjectTitle : String, subjectType: String, subjectIndex: String, contentCode: String, practiceBool: Bool) {
        self.subjectTitle = subjectTitle
        self.subjectType = subjectType
        self.subjectIndex = subjectIndex//리스트에서 저장해야할 위치
        if submitType != 2 {
            if subjectType == "평가"{
                
                let alert = UIAlertController(title: "온체육", message: "평가를 시작하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    self.AF.appClassGetContentList(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, content_code: contentCode, url: "app/class/get_content_list")
                    alert.dismiss(animated: true, completion: nil)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                
            } else if subjectType == "실습" || subjectType == "이론"{
                if subjectTitle == "이론수업"{
                    extensionClass.showToast(view: view, message: "이론 수업 완료", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                } else {
                    let alert = UIAlertController(title: "온체육", message: "운동을 시작하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                        self.AF.appClassGetContentList(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, content_code: contentCode, url: "app/class/get_content_list")
                        alert.dismiss(animated: true, completion: nil)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                }
                
                
            }
        } else {
            let alert = UIAlertController(title: "온체육", message: "최종 제출 하셨습니다.\n(선생님이 요청한 방법으로 운동영상을 전송해주세요.)", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        
        
        //print("컨텐츠 코드 : ",contentCode)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sideMenuCollectionview{
            return 1
        } else {
            return contentNameList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sideMenuCollectionview || collectionView == unitlistCheckListCollectionview {
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.width / 4.1)
        }
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sideMenuCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sideMenuCell", for: indexPath) as! sideMenuCell
            cell.delegate = self
            
            cell.sideMenuFotterContent = self.sideMenuFotterContent
            return cell
        } else if collectionView == unitlistCheckListCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unitlistCheckListCell", for: indexPath) as! unitlistCheckListCell
            if let unitCode = unitList?.unit_code{
                cell.getUnitCode = unitCode
            }
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classTestCell", for: indexPath) as! classTestCell
            
            cell.delegate = self
            cell.getRecordDic = self.recordDic
            cell.contentCode = contentCodeList[indexPath.row]
            
            cell.contentTitle = contentTitleList[indexPath.row]
            switch getTitle(title: contentNameList[indexPath.row]) {
            case "실습":
                cell.subjectIndex = String(self.classPracticeCount)
                self.classPracticeCount += 1
                break
            case "평가":
                cell.subjectIndex = String(self.evaluationPracticeCount)
                self.evaluationPracticeCount += 1
                break
            case "이론":
                cell.subjectIndex = String(self.taskPracticeCount)
                self.taskPracticeCount += 1
                break
            default:
                print("오류")
            }
            cell.contentNameText = contentNameList[indexPath.row]
            cell.submitType = submitType
                
            
            return cell
        }
    }
    func getTitle(title : String) -> String{
        var result = ""
        var i = 0
        for value in title {
            if -1 < i, i < 2 {
                result = result + String(value)
            } else {
                break
            }
            i += 1
                
        }
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sideMenuCollectionview || collectionView == unitlistCheckListCollectionview {
            return 0
        } else {
            return 10
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sideMenuCollectionview || collectionView == unitlistCheckListCollectionview {
            return 0
        } else {
            return 0
        }
    }
    
}
extension classTestViewController {
    func setupLayout(){
        _grayLine1(uiview: grayLine1)//회색박스
        _periodLabel (label: periodLabel)//기간 : 2021.05.04, 18:00
        
        _taskLabel(label: taskLabel)//과제 여부
        _testLabel(label: testLabel)//평가 여부
        _messageBtn(button: messageBtn)//메시지함
        _classReportBtn(button: classReportBtn)//수업현황
        _grayLine2(uiview: grayLine2)
        
        //_submitBtn(button : submitBtn)
        _resultBtn(button : resultBtn)
        _grayLine3(grayLine: grayLine3)
        _classTestCollectionview(collectioniew: classTestCollectionview)
        
    }
    
    func _grayLine1(uiview : UIView){
        view.addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive  = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.15).isActive = true
        
        
        
    }//회색박스
    func _periodLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "• 기간 : 2021.05.04, 18:00(까지)"
        label.textColor = .red
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        label.centerYAnchor.constraint(equalTo: self.grayLine1.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.grayLine1.leadingAnchor,constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.grayLine1.trailingAnchor,constant: -20).isActive = true
        
    }//기간 : 2021.05.04, 18:00
    
    func _taskLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = mainColor._3378fd
        label.text = "과제 ○"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        
        
        
        label.topAnchor.constraint(equalTo: self.grayLine1.bottomAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 58).isActive = true
        label.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }//과제 여부
    func _testLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = mainColor._3378fd
        label.text = "평가 ○"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        
        
        
        label.topAnchor.constraint(equalTo: self.grayLine1.bottomAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.taskLabel.trailingAnchor, constant: 6).isActive = true
        label.widthAnchor.constraint(equalToConstant: 58).isActive = true
        label.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }//평가 여부
    func _messageBtn(button : UIButton){
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" 메시지함", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
        button.setImage(#imageLiteral(resourceName: "messag_image"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        //button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
        button.addTarget(self, action: #selector(messageBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.grayLine1.bottomAnchor, constant: 10).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 88).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }//메시지함
    func _classReportBtn(button : UIButton){
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" 수업현황", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
        button.setImage(#imageLiteral(resourceName: "asdfasdg"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        //button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
        button.addTarget(self, action: #selector(classReportBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.grayLine1.bottomAnchor, constant: 10).isActive = true
        button.trailingAnchor.constraint(equalTo: self.messageBtn.leadingAnchor, constant: -6).isActive = true
        button.widthAnchor.constraint(equalToConstant: 88).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }//수업현황
    func _grayLine2(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.messageBtn.bottomAnchor , constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        
    }
    
    func _submitBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("최종 제출", for: .normal)
        
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.layer.cornerRadius = 8
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.setTitleColor(mainColor._404040, for: .normal)
        button.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -27).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }//최종제출
    func _resultBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("결과보기", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(resultBtnAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -27).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }//결과보기 <- 수업현황이랑 똑같음
    func _grayLine3(grayLine : UIView){
        view.addSubview(grayLine)
        
        grayLine.translatesAutoresizingMaskIntoConstraints = false
        grayLine.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        grayLine.bottomAnchor.constraint(equalTo: self.resultBtn.topAnchor, constant: -20).isActive = true
        grayLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        grayLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        grayLine.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    func _classTestCollectionview(collectioniew : UICollectionView){
        view.addSubview(collectioniew)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectioniew.backgroundColor = .white
        collectioniew.collectionViewLayout = layout
        
        collectioniew.translatesAutoresizingMaskIntoConstraints = false
        collectioniew.register(classTestCell.self, forCellWithReuseIdentifier: "classTestCell")
        
        collectioniew.delegate = self
        collectioniew.dataSource = self
        
        
        collectioniew.topAnchor.constraint(equalTo: self.grayLine2.bottomAnchor, constant: 10).isActive = true
        collectioniew.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        collectioniew.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        collectioniew.bottomAnchor.constraint(equalTo: self.grayLine3.topAnchor, constant: -10).isActive = true
    }
}
