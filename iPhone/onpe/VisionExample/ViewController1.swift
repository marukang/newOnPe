//
//  ViewController.swift
//  newNavigation
//
//  Created by Ik ju Song on 2021/01/12.
//

import UIKit
import SDWebImage
import Alamofire
import Firebase

class ViewController1: UIViewController {
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
    
    lazy var settingMenueBarBtn = UIBarButtonItem(image: UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(settingMenueBarBtnAction))
    
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
    //--------------------------------------------------
    
    //UI 관련 변수
    let scrollView = UIScrollView()
    let userNameLabel = UILabel()//정재환님 안녕하세요
    let userLastJoinLabel = UILabel()//최근 운동일 2020-01-08
    
    let userProfileImgae = UIImageView()//이용자 프로필 이미지
    let hScroreLabel = UILabel()//학교명
    let userhScoreLabel1 = UILabel()//학년 ------
    let userhScoreLabel2 = UILabel()//---- 학급
    let userhScoreUnderLine = UIView()//2등급 밑에 줄
    let userTotalPercentLabel = UILabel()//상위 12%
    let todayLabel = UILabel()//2020-12-25 또래기준
    let myPageBtn = UIButton()//마이페이지
    
    let joinClassLabel = UILabel()//수업참여하기
    let classCodeInputContainerview = UIView()//수업 코드를 입력하기를 감싸서 양각으로 둘러싸여있는 뷰
    //처음 접근할때 사용되는 클래스코드 입력하기 레이아웃
    let classCodeInputTextField = UITextField()//수업 코드를 입력하세요.
    let classCodeInputBtn = UIButton()//수업 코드 입력 버튼
    
    //클래스 코드가 하나라도 더있을때 사용하는 레이아웃
    let classListRightBtn = UIButton()
    let classListLeftBtn = UIButton()
    let classListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    let pageControl = UIPageControl()
    public static var pageControlerRow : Int = 0
    public static var getsubmitAdressList : [submitAdressList] = []
    //let classList : [String] = ["이지영 영어수업","홍길동 체육수업","김태희 수학수업","놀기","수영하기"]
    
    let addNewclassBtn = UIButton()//신규수업 추가
    let addNewClasscollectionview : UICollectionView = {
        let cv = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.backgroundColor = .white
        
        return cv
    }()
    let black_view1 = UIView()
    var getWindow : UIWindow?
    var addNewClasscollectionview_height : CGFloat = 0.65
    var addNewClasscollectionview_value : CGFloat = 0
    var addNewClasscollectionviewY : CGFloat = 0
    
    
    
    let classEnterBtn = UIButton()//입장하기
    let lastClassBtn = UIButton()//지난 수업
    let communityBtn = UIButton()//커뮤니티
    
    let newsBtn = UIButton()//새소식 버튼
    let onlineClassBtn = UIButton()//온라인 체육수업(인공지능 체육수업)
    let contentsBtn = UIButton()//컨첸츠 놀이터
    var scrollviewHeight : CGFloat = 0
    var contentsBtnButtonContent : CGFloat = 420
    var sideMenuFotterContent : CGFloat = 0
    var selectClassCode : String = ""//클래스코드 리스트(Data)에서 메인화면에서 컬랙션뷰의 값에 따라서 clasCode 변경
    let AF = ServerConnectionLegacy()
    var studentClassUpdate :[[String: String]] = []
    var addStudentClassDic : [String : String] = [:]
    var firstToggle = true
    var keyboardWillHideBool = false
    var keyboardWillShowBool = false
    var updateClassCode : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        
        
        CheckUpdate.shared.showUpdate(withConfirmation: true)
        AF.delegate15 = self
        AF.delegate19 = self
        print("체크 : ",userInformationClass.student_classcodeNameList.count)
        //userInformationClass.preferences.removeObject(forKey: userInformationClass.unitListKey)
        
        
        if userInformationClass.student_classcodeList.count != 0{
            selectClassCode = userInformationClass.student_classcodeList[ViewController1.pageControlerRow]
        } else {
            firstToggle = false
        }
        
        print(selectClassCode)
        
        if selectClassCode != "" {
            //클래스별로 제출해야될 이메일 주소 서버로부터 받아오는 함수
            AF.appRecordGetClassProjectSubmitType(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: selectClassCode, url: "app/record/get_class_project_submit_type")
        }
        
        //self.navigationController?.navigationBar.barTintColor = .white //- 상단 네비게이션 바 흰색으로 바꾸기
        let deviceType = UIDevice().type
        
        let deviceModel = deviceType.rawValue
        sizetheFitsControlByDevice(deviceType: deviceModel)
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)
        self.title = "온체육"
        settingMenueBarBtn.imageInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
        navigationItem.setRightBarButtonItems([sideMenuNarBtn,settingMenueBarBtn], animated: false)
        //구현 안된 레이어 숨기기
        
        setLayoutHide(bool: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSideMenuCollectionviewY = statusBarHeight
        setupLayout()
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        getWindow = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        if userInformationClass.student_sex == "" {
            let vc = join2ViewController()
            present(vc, animated: true, completion: nil)
        }
        */
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func sizetheFitsControlByDevice(deviceType : String)
    {
        
        if deviceType == "iPhone 8" || deviceType == "iPhone 7" || deviceType == "iPhone 6" || deviceType == "iPhone 6S"
        {
            
            scrollviewHeight = 1.2
            sideMenuFotterContent = self.view.frame.width * 0.05
            
        } else if deviceType == "iPhone 11" || deviceType == "iPhone XR"  {
            
            scrollviewHeight = 1
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else if deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6S Plus" || deviceType == "iPhone 7 Plus" || deviceType == "iPhone 8 Plus" {
            
            scrollviewHeight = 1.2
            sideMenuFotterContent = self.view.frame.width * 0.05
        } else if deviceType == "iPhone 11 Pro Max" || deviceType == "iPhone XS Max" {
            
            scrollviewHeight = 1
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else if deviceType == "iPhone 11 Pro" || deviceType == "iPhone X" || deviceType == "iPhone XS"  {
            
            scrollviewHeight = 1
            sideMenuFotterContent = self.view.frame.width * 0.5
        } else {
            let device : String = UIDevice.current.name
            print(device)
            if device == "iPhone 12 Pro" || device == "iPhone 12" || device == "iPhone 12 Pro Max" || deviceType == "iPhone 12 mini"{
            
                scrollviewHeight = 1
                sideMenuFotterContent = self.view.frame.width * 0.5
            } else {
            
                scrollviewHeight  = 1.2
                sideMenuFotterContent = self.view.frame.width * 0.5
            }
        }
    }

    
    
    
    
    



}
//MARK: - 일반 함수
extension ViewController1 {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {//이용자 이미지 드레그 해서 넘길때 위치 동그라미로 표시할때 사용되는 메서드
        if scrollView == classListCollectionview{
            pageControl.currentPage = Int(classListCollectionview.contentOffset.x) / Int(classListCollectionview.frame.width)
            selectClassCode = userInformationClass.student_classcodeList[pageControl.currentPage]
            //클래스별로 제출해야될 이메일 주소 서버로부터 받아오는 함수
            AF.appRecordGetClassProjectSubmitType(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: selectClassCode, url: "app/record/get_class_project_submit_type")
            
            print("지금 위치 : ",userInformationClass.student_classcodeList[pageControl.currentPage])
            ViewController1.pageControlerRow = Int(pageControl.currentPage)
            //
        }
        
        
    }
    func setLayoutHide(bool : Bool){
        lastClassBtn.isHidden = bool
        onlineClassBtn.isHidden = bool
    }
    func textFieldDoneBtnMake(text_field : UITextField)
    {
        //텍스트 입력할시 키보드 위에 done 기능 구현
        let ViewForDoneButtonOnKeyboard = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        ViewForDoneButtonOnKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    @objc
    func doneBtnFromKeyboardClicked(sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
        
        self.view.endEditing(true)
    }
}
//MARK: - 신규 클래스 추가 관련 함수들
extension ViewController1 : addClassCellDelegate {
    
    //신규 클래스코드 추가 버튼을 누르면 활성화되는 함수
    func btnAction(classCode: String) {
        var duplicateBool = true//해당 값이 true가 되어야 클래스 코드를 추가해준다.
        for value in userInformationClass.student_classcode{
            for (key, _) in value {
                if key == classCode{
                    duplicateBool = false
                }
            }
        }
        
        if duplicateBool {
            let splitClassCode = classCode.components(separatedBy: "_")
            if splitClassCode.count > 1 {
                var schoolName = splitClassCode[0]
                userInformationClass.student_name = schoolName//클래스 추가하면 학교 이름추가
                var i = 0
                var groupNumber : String = ""
                for value in splitClassCode[1]{
                    if i == 0 {
                        schoolName = schoolName + "\(value)학년"
                    } else if i == 1 {
                        groupNumber = "\(value)"
                        
                    } else if i == 2 {
                        groupNumber = groupNumber + "\(value)"
                        schoolName = schoolName + "\(groupNumber)반"
                    } else if i == 3 {
                        schoolName = schoolName + "\(value)학기"
                    }
                    
                    i += 1
                }
                studentClassUpdate.removeAll()
                addStudentClassDic.removeAll()
                
                studentClassUpdate = userInformationClass.student_classcode
                
                addStudentClassDic.updateValue(schoolName, forKey: classCode)
                studentClassUpdate.append(addStudentClassDic)
                
                
                do {

                    //Convert to Data
                    let jsonData = try JSONSerialization.data(withJSONObject: studentClassUpdate, options: JSONSerialization.WritingOptions.prettyPrinted)

                    //Convert back to string. Usually only do this for debugging
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        AF.appClassStudentClassUpdate(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, student_classcode: JSONString, url: "app/class/student_class_update")
                    }
                    
                   

                } catch let error {
                    print(error)
                }
                //print(schoolName)
            } else {
                let alert = UIAlertController(title: "온체육", message: "올바른 클래스 코드를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
                
            }
        } else {
            let alert = UIAlertController(title: "온체육", message: "이미 가입한 클래스 코드입니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        
        
        
        
        
        /*
        
        print("추가 신규 클래스 코드 : ",classCode)
        */
        //서버 갔다와서 있으면 추가 아니면 토스트 띄워주기
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view1.alpha = 0
            
            self.addNewClasscollectionview.frame = CGRect(x: 0, y: self.addNewClasscollectionviewY, width: self.view.frame.width, height: self.addNewClasscollectionview_value)
            //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
        }, completion: {done in
            if done {
                self.addNewClasscollectionview.removeFromSuperview()
                self.black_view1.removeFromSuperview()
            }
        })
    }
    @objc
    func keyboardWillShow(sender: NSNotification) {
        if !keyboardWillShowBool {
            keyboardWillShowBool = true
            let userInfo = sender.userInfo!
            let keyboardSize: CGSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey as NSObject]! as AnyObject).cgRectValue.size
            
            
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                //print("키보드 ani1 : ",self.scrollView.frame.origin.y)
                self.getWindow!.frame.origin.y -= keyboardSize.height
                //print("키보드 ani2 : ",self.scrollView.frame.origin.y)
                
            })
        }
        keyboardWillHideBool = true
        
        
    }

    @objc
    func keyboardWillHide(sender: NSNotification) {
        //print("키보드 ani3 : ",self.scrollView.frame.origin.y)
        if keyboardWillHideBool {
            keyboardWillHideBool = false
            keyboardWillShowBool = false
            self.getWindow!.frame.origin.y = 0
        }
        
        //print("키보드 ani4 : ",self.scrollView.frame.origin.y)
        
        
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
            
            self.addNewClasscollectionview.frame = CGRect(x: 0, y: self.addNewClasscollectionviewY, width: self.view.frame.width, height: self.addNewClasscollectionview_value)
            //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
        }, completion: {done in
            if done {
                self.addNewClasscollectionview.removeFromSuperview()
                self.black_view1.removeFromSuperview()
            }
        })
    }
    @objc
    func addNewclassBtnAction()
    {
        //신규 수업 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let window = getWindow {
            
            black_view1.translatesAutoresizingMaskIntoConstraints = false
            black_view1.backgroundColor = UIColor(white: 0, alpha: 0.5)
            black_view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBottomSheet(gestureRecognizer:))))
            
            addNewClasscollectionview.delegate = self
            addNewClasscollectionview.dataSource = self
            window.addSubview(black_view1)
            addNewClasscollectionview.backgroundColor = .white
            addNewClasscollectionview.isScrollEnabled = false
            addNewClasscollectionview.translatesAutoresizingMaskIntoConstraints = false
            
            addNewClasscollectionview.layer.cornerRadius = 20
            addNewClasscollectionview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            window.addSubview(addNewClasscollectionview)
            
            addNewClasscollectionview.register(addClassCell.self, forCellWithReuseIdentifier: "addClassCell")
            blackView1(window: window)//검은색 뒷배경 설정 함수
            
            addNewClasscollectionview.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 0)
            
            black_view1.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //let window_height : CGFloat = 0.7
                self.addNewClasscollectionview_value =  window.frame.height * (1 - self.addNewClasscollectionview_height)
                
                self.addNewClasscollectionviewY = window.frame.height
                
                self.black_view1.alpha = 1
                self.addNewClasscollectionview.frame = CGRect(x: 0, y: (window.frame.height * self.addNewClasscollectionview_height), width: window.frame.width, height: self.addNewClasscollectionview_value)
                
                self.addNewClasscollectionview.reloadData()
            }, completion: nil)
            
        }
    }
    
    
}
//MARK: - SideMenu Function ,SideMenuCellDelegate
extension ViewController1 : sideMenuCellDelegate {
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
    
    func moveViewConroller(position : Int){
        
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

extension ViewController1 : mainPageDelegate, appRecordGetClassProjectSubmitType {
    
    
    func appRecordGetClassProjectSubmitType(result: Int, getTypeList: [submitAdressList]?) {
        if result == 0 {
            ViewController1.getsubmitAdressList.removeAll()
            if let getTypeList = getTypeList{
                ViewController1.getsubmitAdressList = getTypeList
                print("link : ",ViewController1.getsubmitAdressList)
            }
            
        }
    }
    
   
    
    func appClassGetClassUnitList(result: Int, ClassListStr: String, fail : String?) {
        if result == 0 {
            if let data = ClassListStr.data(using: .utf8) {
                do {
                    let getResult = try JSONDecoder().decode([ClassList].self, from: data)
//                    Analytics.logEvent("userStream", parameters: [
//                        "이동페이지" : "수업참여페이지",
//                        "이름": "\(userInformationClass.student_id)",
//
//                        "입장시간": "\(extensionClass.nowTimw())",
//
//                    ])
                    
                    print("차시별 : ",getResult)
                    let vc = classListViewController()
                    vc.getClassList = getResult
                    vc.getClassCode = selectClassCode
                    vc.view.backgroundColor = .white
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    self.navigationItem.backBarButtonItem = backItem
                    self.navigationController?.pushViewController(vc, animated: true, completion:{
                        self.classEnterBtn.isEnabled = true
                    })
                    
                    
                    
                } catch let error {
                    print(error)
                }
            }
        } else if result == 1{
            self.classEnterBtn.isEnabled = true
            if let fail = fail {
                //print("실패 : ",fail)
                if fail == "none_class_unit_list" {
                    let alert = UIAlertController(title: "온체육", message: "수업 준비중입니다.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
                }
            } else {
                extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
        } else {
            self.classEnterBtn.isEnabled = true
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
    
    func appClassStudentClassUpdate(result: Int) {
        
        if result == 0 {
            /*
            studentClassUpdate
            addStudentClassDic
            */
            userInformationClass.student_classcode = studentClassUpdate
            for (key, value) in addStudentClassDic {
                userInformationClass.student_classcodeList.reverse()
                userInformationClass.student_classcodeNameList.reverse()
                userInformationClass.student_classcodeList.append(key)
                userInformationClass.student_classcodeNameList.append(value)

            }
            userInformationClass.student_classcodeList.reverse()
            userInformationClass.student_classcodeNameList.reverse()
            if !firstToggle{
                NotificationCenter.default.removeObserver(self)
                let vc = ViewController1()
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } else {
                //기록
                DispatchQueue.main.async {
                    self.pageControl.numberOfPages = userInformationClass.student_classcodeList.count
                    self.loadViewIfNeeded()
                }
                
                self.selectClassCode = userInformationClass.student_classcodeList[0]
                //self.selectClassCode = updateClassCode
                print(selectClassCode)
                AF.appRecordGetClassProjectSubmitType(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: selectClassCode, url: "app/record/get_class_project_submit_type")
                
                classListCollectionview.reloadData()
                extensionClass.showToast(view: view, message: "클래스 코드가 추가되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                
            }
            
        
        } else if result == 1 {
            let alert = UIAlertController(title: "온체육", message: "클래스 코드를 다시 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "온체육", message: extensionClass.connectErrorText, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}
//MARK: @objc 모음
extension ViewController1{
    @objc
    func newsBtnAction(){
        let vc = newsViewController()
        vc.view.backgroundColor = .white
        vc.title = "새소식"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func classCodeInputBtnAction(){
        //아무 클래스 코드 없을때 클래스코드 입력하고 버튼 누르는 함수 홍춘초등학교_121444
        
        if let classCode = classCodeInputTextField.text {
            print(classCode)
            updateClassCode = classCode
            
            let splitClassCode = classCode.components(separatedBy: "_")
            var groupNumber : String = ""
            if splitClassCode.count > 1 {
                var schoolName = splitClassCode[0]
                var i = 0
                for value in splitClassCode[1]{
                    if i == 0 {
                        schoolName = schoolName + "\(value)학년"
                    } else if i == 1 {
                        groupNumber = "\(value)"
                        
                    } else if i == 2 {
                        groupNumber = groupNumber + "\(value)"
                        schoolName = schoolName + "\(groupNumber)반"
                    } else if i == 3 {
                        schoolName = schoolName + "\(value)학기"
                    }
                    
                    i += 1
                }
                studentClassUpdate.removeAll()
                addStudentClassDic.removeAll()
                
                
                
                addStudentClassDic.updateValue(schoolName, forKey: classCode)
                studentClassUpdate.append(addStudentClassDic)
                
                userInformationClass.student_classcode = studentClassUpdate 
                print(studentClassUpdate)
                do {
                    
                    //Convert to Data
                    let jsonData = try JSONSerialization.data(withJSONObject: studentClassUpdate, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    //Convert back to string. Usually only do this for debugging
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        
                        AF.appClassStudentClassUpdate(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, student_classcode: JSONString, url: "app/class/student_class_update")
                    }
                    
                    
                    
                } catch let error {
                    print(error)
                }
            } else {
                let alert = UIAlertController(title: "온체육", message: "올바른 클래스 코드를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            print(updateClassCode)
        }
        
        
    }
    @objc
    func contentsBtnAction(){
        
        let vc = contentsViewController()
        vc.view.backgroundColor = .white
        vc.title = "방과 후 활동"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc
    func communityBtnAction(){
        
        let vc = communityViewController()
        vc.view.backgroundColor = .white
        vc.title = "커뮤니케이션"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func onlineClassBtnAction(){
        let vc = selfClassViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func settingMenueBarBtnAction(){
        
        let vc = settingMenuViewController()
        vc.title = "환경설정"
        vc.view.backgroundColor = .white
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @objc
    func classListRightBtnAction(){
        
        pageControl.currentPage = classListCollectionview.scrollToNextItem(total: userInformationClass.student_classcodeList.count)
    }
    
    @objc
    func classListLeftBtnAction(){
        pageControl.currentPage = classListCollectionview.scrollToPreviousItem(total: pageControl.currentPage)
    }
    
    @objc
    func classEnterBtnAction(){
        print(selectClassCode)
        print(userInformationClass.access_token)
        if userInformationClass.student_number == ""{
            
            let alert = UIAlertController(title: "온체육", message: "마이페이지에서 학급 번호를 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) {
                _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    let vc = myPageViewController()
                    vc.setUserManageArea = true
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    self.navigationItem.backBarButtonItem = backItem
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            
            classEnterBtn.isEnabled = false
            AF.appClassGetClassUnitList(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: selectClassCode, url: "app/class/get_class_unit_list")
        }
        
        
        
        
    }
    
    @objc
    func myPageBtnAction(){
        let vc = myPageViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController1 : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classListCollectionview{
            return userInformationClass.student_classcodeList.count
        } else if collectionView == addNewClasscollectionview {
            return 1
        }  else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == classListCollectionview{
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == addNewClasscollectionview {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
                
        } else {
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == classListCollectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SideMenuClassCell", for: indexPath) as! SideMenuClassCell
            cell.classNameLabel.text = userInformationClass.student_classcodeNameList[indexPath.row]
            cell.classNameLabel.backgroundColor = mainColor._3378fd
            cell.classNameLabel.textColor = .white
            cell.classNameLabel.textAlignment = .center
            cell.classNameLabel.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
            cell.classJoinBtn.isHidden = true
            return cell
        } else if collectionView == addNewClasscollectionview {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addClassCell", for: indexPath) as! addClassCell
            cell.delegate = self
            cell.parentView = self.view
            print(sideMenuFotterContent)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sideMenuCell", for: indexPath) as! sideMenuCell
            cell.delegate = self
            print(sideMenuFotterContent)
            
            cell.sideMenuFotterContent = self.sideMenuFotterContent
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}

//MARK: - 레이아웃 함수 모음
extension ViewController1{
    func setupLayout(){
        _scrollView()
        _userNameLabel()
        _userLastJoinLabel()
        
        _userProfileImgae()
        
        _hScroreLabel()
        
        _userhScoreLabel1(label: userhScoreLabel1)
        _userhScoreLabel2(label: userhScoreLabel2)
        _userhScoreUnderLine(view1 : userhScoreUnderLine)
        _userTotalPercentLabel(label : userTotalPercentLabel)
        _todayLabel(label : todayLabel)
        _myPageBtn(button : myPageBtn)
        
        //_joinClassLabel(label : joinClassLabel)
        
        
        _classCodeInputContainerview(view1: classCodeInputContainerview)
        // 수업을 참혀한적이 있다면 밑의 3개의 레이아웃은 보이지 않는다.
        print(firstToggle)
        if firstToggle {
            
            _classListCollectionview()
            _pageControl()
            _classListRightBtn(button: classListRightBtn)
            _classListLeftBtn(button: classListLeftBtn)
            
            _classEnterBtn(button: classEnterBtn)
            _addNewclassBtn(button: addNewclassBtn)
            _lastClassBtn(button: lastClassBtn)
            _communityBtn(button: communityBtn)
            //_contentsBtn(button: contentsBtn)
            _newsBtn(button: newsBtn)
        } else {
            
            _classCodeInputTextField(textField: classCodeInputTextField)
            _classCodeInputBtn(button: classCodeInputBtn)
        }
        
        
        
        print("하이")
        //_onlineClassBtn(button: onlineClassBtn)
        //
        
        
    }
    func _scrollView(){
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollView.contentSize = .init(width: self.view.frame.width, height: self.view.frame.height * scrollviewHeight)
        
        
    }
    func _userNameLabel(){
        
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.NotoSansCJKkr(type: .medium, size: 25)
        userNameLabel.textColor = mainColor._404040
        userNameLabel.text = "\(userInformationClass.student_name)님 안녕하세요"
        
        scrollView.addSubview(userNameLabel)
        
        userNameLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.65).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.08).isActive = true
    }
    func _userLastJoinLabel(){
        
        
        userLastJoinLabel.translatesAutoresizingMaskIntoConstraints = false
        userLastJoinLabel.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        userLastJoinLabel.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        userLastJoinLabel.text = "최근 운동일 \(extensionClass.DateToString(date: (userInformationClass.student_recent_exercise_date), type: 0))"
        
        scrollView.addSubview(userLastJoinLabel)
        
        userLastJoinLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        userLastJoinLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        userLastJoinLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.6).isActive = true
        userLastJoinLabel.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.08).isActive = true
    }
    
    func _userProfileImgae(){
        
        scrollView.addSubview(userProfileImgae)
        userProfileImgae.translatesAutoresizingMaskIntoConstraints = false
        
        userProfileImgae.contentMode = .scaleAspectFill
        userProfileImgae.clipsToBounds = true
        userProfileImgae.layer.masksToBounds = true
        
        userProfileImgae.backgroundColor = .systemGray4
        userProfileImgae.layer.cornerRadius = 20
        userProfileImgae.layer.shadowColor = UIColor.black.cgColor
        userProfileImgae.layer.shadowOpacity = 1
        //userProfileImgae.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.systemGray2, radius: 2.0, opacity: 0.35)
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        if userInformationClass.student_image_url != "" {
            print(userInformationClass.student_image_url)
            self.userProfileImgae.sd_setImage(with: URL(string: userInformationClass.student_image_url), completed: nil)
        } else {
            self.userProfileImgae.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        }
        
        
        
        userProfileImgae.topAnchor.constraint(equalTo: self.userLastJoinLabel.bottomAnchor, constant: 10).isActive = true
        userProfileImgae.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        userProfileImgae.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.4).isActive = true
        userProfileImgae.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.4).isActive = true
    }
    func _hScroreLabel(){
        scrollView.addSubview(hScroreLabel)
        
        hScroreLabel.translatesAutoresizingMaskIntoConstraints = false
        hScroreLabel.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
        hScroreLabel.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        if userInformationClass.student_school == "" {
            hScroreLabel.text = "- 학교"
        } else {
            hScroreLabel.text = "\(userInformationClass.student_school)"
        }
        
        
        hScroreLabel.topAnchor.constraint(equalTo: self.userProfileImgae.topAnchor, constant: 0).isActive = true
        hScroreLabel.leadingAnchor.constraint(equalTo: self.userProfileImgae.trailingAnchor, constant: 30).isActive = true
        hScroreLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.5).isActive = true
        hScroreLabel.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.05).isActive = true
    }
    func _userhScoreLabel1(label : UILabel){
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 20)
        label.textColor = mainColor._3378fd
        if userInformationClass.student_level == "" {
            label.text = "- 학년 "
        } else {
            label.text = "\(userInformationClass.student_level)학년 "
        }
        
        
        scrollView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.hScroreLabel.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.hScroreLabel.leadingAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalToConstant: 55).isActive = true
        label.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.08).isActive = true
                
    }
    func _userhScoreLabel2(label : UILabel){
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 20)
        label.textColor = mainColor._3378fd
        if userInformationClass.student_class == "" {
            label.text = "- 반"
        } else {
            label.text = "\(userInformationClass.student_class)반"
        }
        
        
        scrollView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.hScroreLabel.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.userhScoreLabel1.trailingAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.08).isActive = true
    }
    func _userhScoreUnderLine(view1 : UIView){
        
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = mainColor.hexStringToUIColor(hex: "#e0e0e0")
        
        self.scrollView.addSubview(view1)
        
        view1.topAnchor.constraint(equalTo: self.userhScoreLabel1.bottomAnchor, constant: 5).isActive = true
        view1.leadingAnchor.constraint(equalTo: self.userhScoreLabel1.leadingAnchor, constant: 2).isActive = true
        view1.trailingAnchor.constraint(equalTo: self.userhScoreLabel1.trailingAnchor, constant: -5).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func _userTotalPercentLabel(label : UILabel){
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textColor = mainColor._3378fd
        label.text = "좌우명"
        
        scrollView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.userhScoreUnderLine.bottomAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.hScroreLabel.leadingAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.5).isActive = true
        label.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.05).isActive = true
    }
    func _todayLabel(label : UILabel){
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
        label.textColor = mainColor.hexStringToUIColor(hex: "#3f3f3f")
        if userInformationClass.student_content == "" {
            label.text = "-"
        } else {
            label.text = userInformationClass.student_content
        }
        
        //label.text = "\(extensionClass.DateToString(date: (extensionClass.nowTimw2()), type: 0)) ・ 또래 기준"
        
        scrollView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.userTotalPercentLabel.bottomAnchor, constant: 2.5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.hScroreLabel.leadingAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.35).isActive = true
        label.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.05).isActive = true
    }
    func _myPageBtn(button : UIButton){
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("마이페이지", for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#3f3f3f"), for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        //let bordercustomColor : UIColor =
        button.layer.borderColor = UIColor.systemGray5.cgColor
        // = mainColor.hexStringToUIColor(hex: "ffffff").cgColor
        button.addTarget(self, action: #selector(myPageBtnAction), for: .touchUpInside)
        scrollView.addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.todayLabel.bottomAnchor, constant: 9).isActive = true
        button.leadingAnchor.constraint(equalTo: self.todayLabel.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: self.todayLabel.trailingAnchor, constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: self.userProfileImgae.bottomAnchor, constant: -2).isActive = true
    }
    
    func _joinClassLabel(label : UILabel){
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        label.textColor = mainColor._404040
        label.text = "수업 참여하기"
        
        scrollView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.userProfileImgae.bottomAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.5).isActive = true
        label.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.08).isActive = true
    }
    
    func _classCodeInputContainerview(view1 : UIView){
        
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = .white
        view1.layer.shadowColor = UIColor.black.cgColor
        view1.layer.cornerRadius = 10
        view1.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.systemGray3, radius: 4.0, opacity: 0.35)
        
        scrollView.addSubview(view1)
        /*
        view1.topAnchor.constraint(equalTo: self.joinClassLabel.bottomAnchor, constant: 15).isActive = true
        */
        
        view1.topAnchor.constraint(equalTo: self.userProfileImgae.bottomAnchor, constant: 15).isActive = true
        view1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        view1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        view1.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.25).isActive = true
    }
    func _classListCollectionview(){
        self.scrollView.addSubview(classListCollectionview)
        classListCollectionview.translatesAutoresizingMaskIntoConstraints = false
        classListCollectionview.backgroundColor = mainColor._3378fd
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        classListCollectionview.layer.cornerRadius = 8
        classListCollectionview.collectionViewLayout = layout
        classListCollectionview.isPagingEnabled = true
        classListCollectionview.showsHorizontalScrollIndicator = false
        classListCollectionview.delegate = self
        classListCollectionview.dataSource = self
        classListCollectionview.register(SideMenuClassCell.self, forCellWithReuseIdentifier: "SideMenuClassCell")
        
        
        classListCollectionview.topAnchor.constraint(equalTo: self.classCodeInputContainerview.topAnchor, constant: 23).isActive = true
        classListCollectionview.leadingAnchor.constraint(equalTo: self.classCodeInputContainerview.leadingAnchor, constant: 50).isActive = true
        classListCollectionview.trailingAnchor.constraint(equalTo: self.classCodeInputContainerview.trailingAnchor, constant: -50).isActive = true
        classListCollectionview.bottomAnchor.constraint(equalTo: self.classCodeInputContainerview.bottomAnchor, constant: -23).isActive = true
        
    }
    func _classListRightBtn(button : UIButton){
        scrollView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "blue_left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(classListRightBtnAction), for: .touchUpInside)
        
        button.centerYAnchor.constraint(equalTo: classListCollectionview.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.classListCollectionview.trailingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.classCodeInputContainerview.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _classListLeftBtn(button : UIButton){
        scrollView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "blue_right"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(classListLeftBtnAction), for: .touchUpInside)
        
        button.centerYAnchor.constraint(equalTo: classListCollectionview.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.classCodeInputContainerview.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.classListCollectionview.leadingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _pageControl(){
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.currentPageIndicatorTintColor = mainColor._3378fd
        self.pageControl.pageIndicatorTintColor = .systemGray4
        self.pageControl.numberOfPages = userInformationClass.student_classcodeList.count
        self.pageControl.transform = .init(scaleX: 0.8, y: 0.8)
        self.pageControl.currentPage = ViewController1.pageControlerRow
        scrollView.addSubview(pageControl)
        
        //self.page_control.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.topAnchor.constraint(equalTo: self.classListCollectionview.bottomAnchor, constant: 0).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.bottomAnchor.constraint(equalTo: self.classCodeInputContainerview.bottomAnchor).isActive = true
        //self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    
    func _classEnterBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#3378fd")
        
        
        button.setTitle("수업 참여", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#ffffff"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_ionic_ios_arrow_round_back"), for: .normal)
        let imageinset : CGFloat = 17.5
        button.imageEdgeInsets = .init(top: imageinset, left: imageinset + 10, bottom: imageinset, right: imageinset)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.semanticContentAttribute = .forceRightToLeft
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(classEnterBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: classCodeInputContainerview.bottomAnchor, constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    func _addNewclassBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.setImage(#imageLiteral(resourceName: "gray_plus"), for: .normal)
        let imageinset : CGFloat = 17.5
        button.imageEdgeInsets = .init(top: imageinset, left: imageinset, bottom: imageinset, right: imageinset)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.setTitle(" 신규 수업 추가", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#595959"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        //addNewclassBtn.contentHorizontalAlignment = .left
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(addNewclassBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: classEnterBtn.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2 - 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func _lastClassBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.setImage(#imageLiteral(resourceName: "icon_awesome_pan"), for: .normal)
        let imageinset : CGFloat = 17.5
        button.imageEdgeInsets = .init(top: imageinset, left: imageinset, bottom: imageinset, right: imageinset)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.setTitle(" 지난 수업", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#595959"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        //addNewclassBtn.contentHorizontalAlignment = .left
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        
        
        button.topAnchor.constraint(equalTo: classEnterBtn.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2 - 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func _communityBtn(button : UIButton){
        
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        
        
        button.setTitle(" 커뮤니케이션", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#595959"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_awesome_clipboard_list"), for: .normal)
        let imageinset : CGFloat = 16
        button.imageEdgeInsets = .init(top: imageinset, left: imageinset, bottom: imageinset, right: imageinset)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        //button.semanticContentAttribute = .forceRightToLeft
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(communityBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: classEnterBtn.bottomAnchor, constant: 10).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2 - 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func _classCodeInputTextField(textField : UITextField){
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "클래스 코드를 입력하세요."
        textField.tintColor = mainColor.hexStringToUIColor(hex: "#999999")
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        textField.setLeftPaddingPoints(15)
        textField.setRightPaddingPoints(15)
        textField.layer.cornerRadius = 4
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#f6f6f6")
        textFieldDoneBtnMake(text_field: textField)
        scrollView.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: self.classCodeInputContainerview.topAnchor, constant: 25).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.classCodeInputContainerview.leadingAnchor,constant: 15).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.classCodeInputContainerview.bottomAnchor,constant: -25).isActive = true
        
        textField.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.7).isActive = true
        
        
    }
    func _classCodeInputBtn(button : UIButton){
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor._3378fd
        button.setImage(#imageLiteral(resourceName: "arrow_right_box"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(classCodeInputBtnAction), for: .touchUpInside)
        //button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        scrollView.addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.classCodeInputTextField.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.classCodeInputTextField.trailingAnchor, constant: 5).isActive = true
        button.trailingAnchor.constraint(equalTo: self.classCodeInputContainerview.trailingAnchor,constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: self.classCodeInputTextField.bottomAnchor).isActive = true
    }
    func _contentsBtn(button : UIButton){
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("방과 후 활동", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(contentsBtnAction), for: .touchUpInside)
        
        scrollView.addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.communityBtn.bottomAnchor, constant: 100).isActive = true
        
        //button.topAnchor.constraint(equalTo: self.joinClassLabel.bottomAnchor, constant: contentsBtnButtonContent).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.15).isActive = true
        
    }
    
    
    func _newsBtn(button : UIButton){
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("새소식", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(newsBtnAction), for: .touchUpInside)
        scrollView.addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.communityBtn.bottomAnchor, constant: 100).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.15).isActive = true
    }
}

