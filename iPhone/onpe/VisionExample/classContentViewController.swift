//
//  classContentViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/21.
//

import UIKit


class classContentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AF.delegate16 = self
        let deviceType = UIDevice().type
        let deviceModel = deviceType.rawValue
        sizetheFitsControlByDevice(deviceType: deviceModel)
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)
        navigationItem.setRightBarButtonItems([sideMenuNarBtn], animated: false)
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if unitGroupName != nil {
            self.title = unitGroupName
        }
        setSideMenuCollectionviewY = statusBarHeight
        AF.appRecordGetStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: unitList!.class_code!, unit_code: unitList!.unit_code!, url: "app/record/get_student_class_record")
        
        
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
    //--------------------------------------------------
    let scrollview1 = UIScrollView()
    let grayLine1 = UIView()//회색박스
    let periodLabel = UILabel()//기간 : 2021.05.04, 18:00
    
    let taskLabel = UILabel()//과제 여부
    let testLabel = UILabel()//평가 여부
    let classReportBtn = UIButton()//수업현황
    let messageBtn = UIButton()//메시지함
    
    let grayLine2 = UIView()
    let classContentTextview = UITextView()
    
    let grayLine3 = UIView()
    
    //---------참고자료 관련 변수들
    let referenceBtn = UIButton()//참고자료
    let referenceListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var referenceBool  = false //false -> 접힘, true -> 펼침
    var referenceListHeightvalue : CGFloat = 0// 접고 펼치기 위해 처음 컬랙션뷰의 높이를 저장하는 변수
    var referenceListHeight : NSLayoutConstraint?
    let imageview1 = UIImageView()
    let grayLine4 = UIView()
    
    
    //---------유튜브 영상 관련 변수들
    let youtubeBtn = UIButton()//유뷰트 영상
    let youtubePlayerCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var youtubeCollectionviewHeight : NSLayoutConstraint?
    var youtubeCollectionviewHeightValue : CGFloat = 0
    let pageControl = UIPageControl()
    var youtubeBool = false
    let imageview2 = UIImageView()
    let grayLine5 = UIView()
    
    
    
    //---------수업 관련 링크 관련 변수들
    let rinkwithClassBtn = UIButton()//수업 관련 링크
    let rinkwithClassListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var rinkwithBool  = false //false -> 접힘, true -> 펼침
    var rinkwithListHeightvalue : CGFloat = 0// 접고 펼치기 위해 처음 컬랙션뷰의 높이를 저장하는 변수
    var rinkwithListHeight : NSLayoutConstraint?
    let imageview3 = UIImageView()
    let grayLine6 = UIView()
    
    let confirmBtn = UIButton()//과제 시작하기
    let AF = ServerConnectionLegacy()
    
    var unitList : UnitList?{
        didSet{
            if let contentTestCheck = unitList?.content_test{
                print(contentTestCheck)
                let list = extensionClass.jsonToArray(jsonString: contentTestCheck)//평가가 잇는지 없는지 테스트하는 값
                
                for value in list{
                    if value == "1"{
                        subjectBool = true
                        break
                    }
                    
                }
                print("--")
            }
            setupText(unitList: unitList!)
        }
    }
    var attachedFileList : [String] = []
    var youtubeUrlList : [[String:String]] = [[:]] // ["https://www.youtube.com/watch?v=Qz--YquirSA&list=RDQz--YquirSA&start_radio=1","https://www.youtube.com/watch?v=0LVa7larMUE&list=RDMMrZUppxT38Zk&index=6","https://www.youtube.com/watch?v=4sswp02n0Yg"]
    var rinkUrlList : [[String : String]] = [[:]]
    var referCount : Int = 3
    var rinkCount : Int = 2
    var unitType = "0"
    var unitGroupName : String?
    var subjectBool = false //true 과제 있음 false 없음
    var recordDic : recordDic?
    var readBool1 = false
    var readBool2 = false
    var readBool3 = false   //readBool에 1~3이 전부다 true가 되어아 시작하기가 활성화된다.
    var startBool = false //시작하기 버튼을 클릭하기 위해선 readBool1~3이 모두 true가 되어야한다.
    
    var recordDicBool = false// 해당 값이 true일때만 appRecordGetStudentClassRecord Delegate에서 다음 화면으로 넘겨준다.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let scrollHeight = self.grayLine6.frame.height + self.grayLine6.frame.origin.y + referenceListHeightvalue + rinkwithListHeightvalue + youtubeCollectionviewHeightValue + self.view.frame.width * 0.25
        
        
        scrollview1.contentSize = .init(width: self.view.frame.width, height: scrollHeight)
    }
    func setcollectionviewHeight(refercneCount : CGFloat, rinkCount : CGFloat){
        referenceListHeightvalue = (self.view.frame.width * 0.09 + 7 ) * refercneCount
        rinkwithListHeightvalue = (self.view.frame.width * 0.09 + 7 ) * rinkCount
        youtubeCollectionviewHeightValue = (self.view.frame.width * 0.5625) + 30
    }
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
        
        classContentTextview.text = u.unit_class_text
        
        attachedFileList = extensionClass.jsonToArray(jsonString: u.unit_attached_file ?? "")
        if attachedFileList.count == 0 {
            
            referenceBtn.isEnabled = false
            readBool1 = true
            DispatchQueue.main.async {
                self.imageview1.image = #imageLiteral(resourceName: "grey_arrow_image")
            }
            
            
        }
        print(attachedFileList.count)
        //print(u.unit_youtube_url)
        youtubeUrlList.removeAll()
        youtubeUrlList = extensionClass.jsonToArray3(jsonString: u.unit_youtube_url ?? "")
        if youtubeUrlList[0]["result"] == "nil" {
            youtubeBtn.isEnabled = false
            readBool2 = true
            DispatchQueue.main.async {
                self.imageview2.image = #imageLiteral(resourceName: "grey_arrow_image")
            }
        }
        rinkUrlList.removeAll()
        rinkUrlList = extensionClass.jsonToArray3(jsonString: u.unit_content_url ?? "")
        print("뭐고 : ",rinkUrlList)
        if rinkUrlList[0]["result"] == "nil" {
            rinkwithClassBtn.isEnabled = false
            readBool3 = true
            DispatchQueue.main.async {
                self.imageview3.image = #imageLiteral(resourceName: "grey_arrow_image")
            }
        }
        print(rinkUrlList.count)
        setcollectionviewHeight(refercneCount: CGFloat(attachedFileList.count), rinkCount: CGFloat(rinkUrlList.count))
        
        
        
        referenceListCollectionview.reloadData()
        rinkwithClassListCollectionview.reloadData()
        youtubePlayerCollectionview.reloadData()
        
    }
    func startBoolActivate(){
        if readBool1, readBool2, readBool3{
            startBool = true
            confirmBtn.backgroundColor = mainColor._3378fd
            confirmBtn.setTitleColor(.white, for: .normal)
        }
    }
}
extension classContentViewController : unitListPageDelegate {
    func appCurriculumStudentGetCurriculum(result: Int, unitList: [UnitList]) {
        //사용안함
    }
    
    func appRecordGetStudentClassRecord(result: Int, recordDic: recordDic?) {
        //수업현황 기록 받아오기 위해서 사용
        if result == 0 {
            
            self.recordDic = recordDic
            if recordDicBool {
                
                self.recordDicBool = false
                let vc = classTestViewController()
                vc.unitGroupName = unitGroupName//그룹 이름 전달
                vc.unitType = self.unitType
                vc.title = self.title// 입력
                vc.view.backgroundColor = .white
                vc.recordDic = recordDic
                vc.unitList = unitList
                let backItem = UIBarButtonItem()
                backItem.title = ""
                
                self.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    
}
//MARK: - sideMenu Funtion
extension classContentViewController : sideMenuCellDelegate {
    func sizetheFitsControlByDevice(deviceType : String)
    {
        
        if deviceType == "iPhone 8" || deviceType == "iPhone 7" || deviceType == "iPhone 6" || deviceType == "iPhone 6S"
        {
            
            
            sideMenuFotterContent = self.view.frame.width * 0.05
            
        } else if deviceType == "iPhone 11" || deviceType == "iPhone XR"  {
            
            
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else if deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6S Plus" || deviceType == "iPhone 7 Plus" || deviceType == "iPhone 8 Plus" {
            
            
            sideMenuFotterContent = self.view.frame.width * 0.05
        } else if deviceType == "iPhone 11 Pro Max" || deviceType == "iPhone XS Max" {
            
            
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else if deviceType == "iPhone 11 Pro" || deviceType == "iPhone X" || deviceType == "iPhone XS"  {
            
            
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else {
            let device : String = UIDevice.current.name
            print(device)
            if device == "iPhone 12 Pro" || device == "iPhone 12" || device == "iPhone 12 Pro Max" || deviceType == "iPhone 12 mini"{
                
                
                sideMenuFotterContent = self.view.frame.width * 0.5
            } else {
                
                
                sideMenuFotterContent = self.view.frame.width * 0.5
            }
        }
    }
    
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


//MARK: - @objc 함수
extension classContentViewController {
    @objc
    func messageBtnAction(){
        
        let vc = messageListViewController()
        vc.title = "학급 메세지"
        vc.view.backgroundColor = .white
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    @objc
    func classReportBtnAction(){
        if recordDic != nil {
            classReportBtn.isEnabled = false
            //x차시 공다루기 수업의 수업현황 이동함수
            let vc = classStatusViewController()
            vc.title = "\(title!)"// 입력
            vc.getRecordDic = recordDic
            vc.unitGroupName = unitGroupName ?? title!//그룹 이름 전달
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true, completion: {
                self.classReportBtn.isEnabled = true
            })
        } else {
            
            
            extensionClass.showToast(view: view, message: "수업에 먼저 참석해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
    }
    @objc
    func confirmButtonAction(){
        
        if startBool {
            //시작하기 버튼을 누르면 수업에 참여했다고 DB에 저장한다.
            if let classCode = unitList?.class_code, let unitCode = unitList?.unit_code {
                print(unitType)
                print(unitGroupName)
                AF.appCurriculumStudentUpdateParticipation(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, unit_code: unitCode, student_number: userInformationClass.student_number, unit_class_type: unitType, unit_group_name: unitGroupName ?? title!, url: "app/curriculum/student_update_participation")
                
                
                AF.appRecordCreateStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, unit_code: unitCode, student_name: userInformationClass.student_name, student_grade: userInformationClass.student_level, student_group: userInformationClass.student_class, student_number: userInformationClass.student_number, student_participation: "1", student_practice: self.subjectBool ? "0" : "-", url: "app/record/create_student_class_record")
                
                
                    
            }
            var nameBool = false // 수업 이론 컨텐츠 코드에 포함되어있다면 다음화면으로 넘겨주지 않는다.
            print(unitList?.content_code_list)
            if let data = unitList?.content_code_list?.data(using: .utf8){
                do {
                    let getResult = try JSONDecoder().decode([unitContent].self, from: data)
                    for value in getResult{
                        if let name = value.content_name {
                            if name == "이론수업", getResult.count == 1 {
                                nameBool = true
                            }
                            
                        }
                        
                        
                    }
                } catch let error {
                    print(error)
                }
            }
            
            if !nameBool{
                if recordDic == nil {
                    recordDicBool = true
                    AF.appRecordGetStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: unitList!.class_code!, unit_code: unitList!.unit_code!, url: "app/record/get_student_class_record")
                } else {
                    let vc = classTestViewController()
                    vc.unitGroupName = unitGroupName ?? title//그룹 이름 전달
                    vc.unitType = self.unitType
                    vc.title = self.title// 입력
                    vc.view.backgroundColor = .white
                    vc.recordDic = recordDic
                    vc.unitList = unitList
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    
                    self.navigationItem.backBarButtonItem = backItem
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            } else {
                //컨탠츠 리스트에 수업(이론)만 잇을경우
                AF.appRecordGetStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: unitList!.class_code!, unit_code: unitList!.unit_code!, url: "app/record/get_student_class_record")
                extensionClass.showToast(view: view, message: "수업참석 완료", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
        } else {
            extensionClass.showToast(view: view, message: "수업 관련 자료를 확인해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
        
    }
    @objc
    func referenceBtnAction(){
        readBool1 = true
        if referenceBool{
            UIView.animate(withDuration: 0.5, animations: {
                self.imageview1.transform = .init(rotationAngle: .pi * 2)
                self.referenceBool = false
                self.referenceListHeight?.constant = 0 - self.referenceListHeightvalue
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.imageview1.transform = .init(rotationAngle: .pi)
                self.referenceBool = true
                self.referenceListHeight?.constant = self.referenceListHeightvalue
            }, completion: nil)
        }
        startBoolActivate()
        
    }
    
    @objc
    func youtubeBtnAction(){
        readBool2 = true
        if youtubeBool{
            UIView.animate(withDuration: 0.5, animations: {
                self.imageview2.transform = .init(rotationAngle: .pi * 2)
                self.youtubeBool = false
                self.youtubePlayerCollectionview.isHidden = true
                self.pageControl.isHidden = true
                self.youtubeCollectionviewHeight?.constant = 0 - self.youtubeCollectionviewHeightValue
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.imageview2.transform = .init(rotationAngle: .pi)
                self.youtubeBool = true
                self.youtubePlayerCollectionview.isHidden = false
                self.pageControl.isHidden = false
                self.youtubeCollectionviewHeight?.constant = 0
            }, completion: nil)
        }
        startBoolActivate()
    }
    
    @objc
    func rinkwithClassBtnAction(){
        readBool3 = true
        if rinkwithBool{
            UIView.animate(withDuration: 0.5, animations: {
                self.imageview3.transform = .init(rotationAngle: .pi * 2)
                self.rinkwithBool = false
                self.rinkwithListHeight?.constant = 0 - self.rinkwithListHeightvalue
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.imageview3.transform = .init(rotationAngle: .pi)
                self.rinkwithBool = true
                self.rinkwithListHeight?.constant = self.rinkwithListHeightvalue
            }, completion: nil)
        }
        startBoolActivate()
    }
}
extension classContentViewController {
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {//이용자 이미지 드레그 해서 넘길때 위치 동그라미로 표시할때 사용되는 메서드
        if scrollView == youtubePlayerCollectionview{
            pageControl.currentPage = Int(youtubePlayerCollectionview.contentOffset.x) / Int(youtubePlayerCollectionview.frame.width)
        }
        
        
    }
    
}
extension classContentViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, rinkCellDelegate, referenceCellDelegate  {
    //참고자료 터치하면 실행되는 함수
    func referenceCellClick(getReferUrl: String) {
        
        UIApplication.shared.open(URL(string: getReferUrl)!)
        print(getReferUrl)
    }
    
    
    //수업관련링크 터치하면 실행되는 함수
    func rinkCellClick(getRinkUrl: String) {
        
        UIApplication.shared.open(URL(string: getRinkUrl)!)
        print(getRinkUrl)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sideMenuCollectionview {
            return 1
        } else if collectionView == referenceListCollectionview {
            return attachedFileList.count
        } else if collectionView == youtubePlayerCollectionview {
            return youtubeUrlList.count
        } else {
            //print(attachedFileList)
            return rinkUrlList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sideMenuCollectionview {
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == referenceListCollectionview {
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.09)
        } else if collectionView == youtubePlayerCollectionview {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.09)
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sideMenuCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sideMenuCell", for: indexPath) as! sideMenuCell
            cell.delegate = self
            
            cell.sideMenuFotterContent = self.sideMenuFotterContent
            return cell
        } else if collectionView == referenceListCollectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "referenceCell", for: indexPath) as! referenceCell
            cell.delegate = self
            cell.indexrow = indexPath.row
            print(attachedFileList.count)
            print(indexPath.row)
            print()
            cell.getReferUrl = attachedFileList[indexPath.row]
            
            return cell
        } else if collectionView == youtubePlayerCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "youtubeListCell", for: indexPath) as! youtubeListCell
            let url : [String : String] = youtubeUrlList[indexPath.row]
            
            cell.getUrl = url["link"]
            
            
            //cell.delegate = self
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rinkCell", for: indexPath) as! rinkCell
            cell.delegate = self
            
            let dic : [String:String] = rinkUrlList[indexPath.row]
            print(dic)
            cell.RinkTitle = dic["title"]
            cell.getRinkUrl = dic["link"]
            cell.indexrow = indexPath.row
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sideMenuCollectionview {
            return 0
        } else if collectionView == referenceListCollectionview {
            return 7
        } else if collectionView == youtubePlayerCollectionview {
            return 0
        } else {
            return 7
        }
        

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    
}


extension classContentViewController {
    func setupLayout(){
        _scrollview1(scrollview: scrollview1)
        _grayLine1(uiview: grayLine1)//회색박스
        _periodLabel (label: periodLabel)//기간 : 2021.05.04, 18:00
        
        _taskLabel(label: taskLabel)//과제 여부
        _testLabel(label: testLabel)//평가 여부
        _messageBtn(button: messageBtn)//메시지함
        _classReportBtn(button: classReportBtn)//수업현황
        
        
        _grayLine2(uiview: grayLine2)
        _classContentTextview(textview: classContentTextview)
        
        _grayLine3 (uiview: grayLine3)
        _referenceBtn(button: referenceBtn
                       , uiview: grayLine3, text: "참고자료")//참고자료
        _referenceListCollectionview(collectionview : referenceListCollectionview)
        _grayLine4(uiview: grayLine4)
        
        
        
        _youtubeBtn(button: youtubeBtn, uiview: grayLine4, text: "유튜브 영상")//유뷰트 영상
        _youtbuePlayerCollectionview(collectionview : youtubePlayerCollectionview)
        _pageControl(pageControl: pageControl)
        _grayLine5(uiview: grayLine5)
        
        _rinkwithClassBtn(button: rinkwithClassBtn, uiview: grayLine5, text: "수업 관련 링크")//수업 관련 링크
        _rinkwithClassListCollectionview(collectionview: rinkwithClassListCollectionview)
        
        
        _grayLine6(uiview: grayLine6)
        setArrowImage(imageview: imageview1, button: referenceBtn)
        setArrowImage(imageview: imageview2, button: youtubeBtn)
        setArrowImage(imageview: imageview3, button: rinkwithClassBtn)
        
        _confirmBtn(button: confirmBtn)
        
    }
    func _scrollview1(scrollview : UIScrollView){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
    }
    func _grayLine1(uiview : UIView){
        scrollview1.addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.scrollview1.topAnchor).isActive  = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.15).isActive = true
        
        
        
    }//회색박스
    func _periodLabel(label : UILabel){
        scrollview1.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "• 기간 : 2021.05.04, 18:00(까지)"
        label.textColor = .red
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        label.centerYAnchor.constraint(equalTo: self.grayLine1.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.grayLine1.leadingAnchor,constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.grayLine1.trailingAnchor,constant: -20).isActive = true
        
    }//기간 : 2021.05.04, 18:00
    
    func _taskLabel(label : UILabel){
        scrollview1.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = mainColor._3378fd
        //label.text = "과제 ○"
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
        scrollview1.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = mainColor._3378fd
        //label.text = "평가 ○"
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
        scrollview1.addSubview(button)
        
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
        scrollview1.addSubview(button)
        
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
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.messageBtn.bottomAnchor , constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        
    }
    func _classContentTextview(textview : UITextView){
        scrollview1.addSubview(textview)
        
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = mainColor._404040
        textview.font = UIFont.NotoSansCJKkr(type: .normal, size: 17)
        textview.textAlignment = .left
        textview.isScrollEnabled = true
        //textview.text = "여러분^^ 이번 수업 농구고요 과제\n과제 꼭 제출해주세요.\n1.학습목표\n2.준비물:농구공 없을 경우학교에 요청\n3.\n4.\n5.\n6"
        textview.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 20).isActive = true
        textview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        textview.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.5).isActive = true
        
    }
    func _grayLine3 (uiview : UIView){
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.classContentTextview.bottomAnchor , constant: 20).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _referenceBtn(button : UIButton, uiview : UIView ,text : String){
        scrollview1.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(referenceBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }//참고자료
    func _referenceListCollectionview(collectionview : UICollectionView){
        scrollview1.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(referenceCell.self, forCellWithReuseIdentifier: "referenceCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        collectionview.topAnchor.constraint(equalTo: self.referenceBtn.bottomAnchor, constant: 0).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        referenceListHeight = collectionview.heightAnchor.constraint(equalToConstant: 0)
        referenceListHeight?.isActive = true
        
    }
    func _grayLine4(uiview : UIView){
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.referenceListCollectionview.bottomAnchor).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _youtubeBtn(button : UIButton, uiview : UIView ,text : String){
        scrollview1.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(youtubeBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }//유뷰트 영상
    
    
    func _youtbuePlayerCollectionview(collectionview : UICollectionView){
        
        
        scrollview1.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        collectionview.isPagingEnabled = true
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(youtubeListCell.self, forCellWithReuseIdentifier: "youtubeListCell")
        collectionview.isHidden = true
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        collectionview.topAnchor.constraint(equalTo: self.youtubeBtn.bottomAnchor).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionview.heightAnchor.constraint(equalToConstant: view.frame.width * 0.5625).isActive = true
        
        
    }
    func _pageControl(pageControl : UIPageControl){
        
        scrollview1.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = mainColor._3378fd
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.numberOfPages = youtubeUrlList.count
        pageControl.transform = .init(scaleX: 1, y: 1)
        pageControl.currentPage = 0
        pageControl.isHidden = true
        
        //self.page_control.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: self.youtubePlayerCollectionview.bottomAnchor, constant: 0).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.youtubePlayerCollectionview.bottomAnchor, constant: 30).isActive = true
        //self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    func _grayLine5(uiview : UIView){
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        youtubeCollectionviewHeight = uiview.topAnchor.constraint(equalTo: self.pageControl.bottomAnchor, constant: (view.frame.width * -0.5625) - 30)
        youtubeCollectionviewHeight?.isActive = true
        
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _rinkwithClassBtn(button : UIButton, uiview : UIView ,text : String){
        scrollview1.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(rinkwithClassBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }//수업 관련 링크
    func _rinkwithClassListCollectionview(collectionview : UICollectionView){
        scrollview1.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(rinkCell.self, forCellWithReuseIdentifier: "rinkCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        collectionview.topAnchor.constraint(equalTo: self.rinkwithClassBtn.bottomAnchor, constant: 0).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        rinkwithListHeight = collectionview.heightAnchor.constraint(equalToConstant: 0)
        rinkwithListHeight?.isActive = true
        
    }
    func _grayLine6(uiview : UIView){
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.rinkwithClassListCollectionview.bottomAnchor ).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func setArrowImage(imageview : UIImageView, button : UIButton){
        scrollview1.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "arrow_bottom_box")
        imageview.contentMode = .scaleAspectFit
        
        imageview.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func _confirmBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작하기", for: .normal)
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
        
    }
}
