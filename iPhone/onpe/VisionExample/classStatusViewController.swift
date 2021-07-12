//
//  classStatusViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/21.
//

import UIKit

class classStatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        AF.delegate16 = self
        btnList = [self.classStatusBtn, self.testStatusBtn,self.evaluationBtn]
        let deviceType = UIDevice().type
        let deviceModel = deviceType.rawValue
        sizetheFitsControlByDevice(deviceType: deviceModel)
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)
        navigationItem.setRightBarButtonItems([sideMenuNarBtn], animated: false)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSideMenuCollectionviewY = statusBarHeight
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let scrollHeight = self.classStatusCollectionview1.frame.origin.y + self.classStatusCollectionview1.frame.height + 50
        scrollView.contentSize = .init(width: self.view.frame.width, height: scrollHeight)
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
    let scrollView = UIScrollView()
    let topLabel = UILabel()//차시별 수업 현황
    let gray_line = UIView()
    
    let classStatusCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())//차시별 수업 현황 컬랙션뷰
    let gray_line1 = UIView()
    
    let positionStatusLabel = UILabel()
    let gray_line2 = UIView()
    let classStatusBtn = UIButton()
    let testStatusBtn = UIButton()
    let evaluationBtn = UIButton()
    var btnList : [UIButton]?
    var recordType  = 0 // 0 -> 수업기록, 1 -> 과제 기록, 2 -> 평가 기록
    let classStatusCollectionview1 = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())//수업실습 각 값을 다르게 relaod해준다.
    var unitGroupName : String = ""
    let confirmBtn = UIButton()
    var exercisTotalCount = 0
    var setRecordList : [[recordList]]?
    var setUnitList : [UnitList]?
    let AF = ServerConnectionLegacy()
    
    var getRecordDic : recordDic?{
        
        didSet{
            print(getRecordDic)
            if let classCode = getRecordDic?.class_code, let unitCode = getRecordDic?.unit_code{
                do {
                    print(classCode)
                    print(unitCode)
                        
                    AF.appCurriculumStudentGetCurriculum(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, unit_code: unitCode, url: "app/curriculum/student_get_curriculum")
                    
                    
                } catch let error {
                    print(error)
                }
                
            }
            
            if let data = getRecordDic?.class_practice?.data(using: .utf8){
                do {
                    let getResult = try JSONDecoder().decode([[recordList]].self, from:  data)
                    setRecordList = getResult
                    print(setRecordList)
                    
                    
                    var i = 0
                    var removeNumber : [Int] = []
                    removeNumber.removeAll()
                    for value in setRecordList!{
                        for index in value {
                            if index.content_name == nil{
                                removeNumber.append(i)
                            }
                        }
                        i += 1
                    }
                    for value in removeNumber {
                        setRecordList?.remove(at: value)
                    }
                    
                    let count = setRecordList?.count
                    let count2 = setRecordList?[0].count
                    
                    exercisTotalCount = (count ?? 0) * (count2 ?? 0)
                    classStatusCollectionview1.reloadData()
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
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

}
//MARK: - sideMenu Funtion
extension classStatusViewController : sideMenuCellDelegate {
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

//MARK: - @objc
extension classStatusViewController {
    @objc
    func confirmBtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func classStatusBtnAction(sender : UIButton){
        //print(sender)
        for btn in btnList!{
            if sender == btn {
                btn.setTitleColor(mainColor._3378fd, for: .normal)
            } else {
                btn.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
                
            }
        }
        
        
        if let data = getRecordDic?.class_practice?.data(using: .utf8){
            do {
                let getResult = try JSONDecoder().decode([[recordList]].self, from:  data)
                setRecordList = getResult
                var i = 0
                var removeNumber : [Int] = []
                removeNumber.removeAll()
                for value in setRecordList!{
                    for index in value {
                        if index.content_name == nil{
                            removeNumber.append(i)
                        }
                    }
                    i += 1
                }
                for value in removeNumber {
                    setRecordList?.remove(at: value)
                }
                let count = setRecordList?.count
                let count2 = setRecordList?[0].count
                exercisTotalCount = (count ?? 0) * (count2 ?? 0)
            } catch let error {
                print(error)
            }
        } else {
            setRecordList = nil
        }
        classStatusCollectionview1.reloadData()
        
    }
    
    @objc
    func testStatusBtnAction(sender : UIButton){
        for btn in btnList!{
            if sender == btn {
                btn.setTitleColor(mainColor._3378fd, for: .normal)
            } else {
                btn.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
                
            }
        }
        if let data = getRecordDic?.task_practice?.data(using: .utf8){
            do {
                let getResult = try JSONDecoder().decode([[recordList]].self, from:  data)
                setRecordList = getResult
                var i = 0
                var removeNumber : [Int] = []
                removeNumber.removeAll()
                for value in setRecordList!{
                    for index in value {
                        if index.content_name == nil{
                            removeNumber.append(i)
                        }
                    }
                    i += 1
                }
                for value in removeNumber {
                    setRecordList?.remove(at: value)
                }
                let count = setRecordList?.count
                let count2 = setRecordList?[0].count
                exercisTotalCount = (count ?? 0) * (count2 ?? 0)
                
            } catch let error {
                print(error)
            }
        } else {
            setRecordList = nil
        }
        classStatusCollectionview1.reloadData()
        
    }
    
    
    
    @objc
    func evaluationBtnAction(sender : UIButton){
        for btn in btnList!{
            if sender == btn {
                btn.setTitleColor(mainColor._3378fd, for: .normal)
            } else {
                btn.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
                
            }
        }
        
        if let data = getRecordDic?.evaluation_practice?.data(using: .utf8){
            do {
                let getResult = try JSONDecoder().decode([[recordList]].self, from:  data)
                setRecordList = getResult
                var i = 0
                var removeNumber : [Int] = []
                removeNumber.removeAll()
                for value in setRecordList!{
                    for index in value {
                        if index.content_name == nil{
                            removeNumber.append(i)
                        }
                    }
                    i += 1
                }
                for value in removeNumber {
                    setRecordList?.remove(at: value)
                }
                let count = setRecordList?.count
                let count2 = setRecordList?[0].count
                exercisTotalCount = (count ?? 0) * (count2 ?? 0)
                
            } catch let error {
                print(error)
            }
        } else {
            setRecordList = nil
        }
        classStatusCollectionview1.reloadData()
        
    }
    
}
extension classStatusViewController : unitListPageDelegate {
    func appCurriculumStudentGetCurriculum(result: Int, unitList: [UnitList]) {
        self.setUnitList = unitList
        classStatusCollectionview.reloadData()
        print(unitList)
        print("----")
    }
    
    func appRecordGetStudentClassRecord(result: Int, recordDic: recordDic?) {
        print("사용안함")
    }
    
    
}
extension classStatusViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == classStatusCollectionview1 {
            if 0 < setRecordList?.count ?? 0 {
                if let count = setRecordList?[0].count {
                    if count > 1 {
                        print(setRecordList?.count)
                        return setRecordList?.count ?? 0
                    } else {
                        return 0
                    }
                } else {
                    return 0
                }
            } else {
                return 0
            }
            
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sideMenuCollectionview{
            return 1
        } else if collectionView == classStatusCollectionview {
            return 1
        } else {
            
            if let count = setRecordList?[section].count {
                
                if count > 1 {
                    print(count)
                    //return (7 * (count + 1))
                    print(6 * (count + 1))
                    return (6 * (count + 1))
                } else {
                    return 0
                }
                
            } else {
                return (6 * 0)
            }
            
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == classStatusCollectionview1 {
            return CGSize(width: collectionView.frame.width, height: 40)
        } else {
            return CGSize.init(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sideMenuCollectionview {
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == classStatusCollectionview {
            
            
            return  CGSize(width: collectionView.frame.width, height: collectionView.frame.height )
            
        } else {
            print(collectionView.frame.width )
            print(collectionView.frame.width / 6)
            let width : CGFloat = collectionView.frame.width / 6
            let height : CGFloat = collectionView.frame.width / 6
            
            if -1 < indexPath.row, indexPath.row < 6 {
                
                return CGSize(width: width , height: height * 0.8)
            } else {
                print(indexPath.row)
                return CGSize(width: width, height: height * 1.3)
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == classStatusCollectionview1{
            if kind == UICollectionView.elementKindSectionHeader {
                
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "classStatus1Header", for: indexPath) as! classStatus1Header
                if let index = setRecordList {
                    if let text =
                        index[indexPath.section][0].content_title{
                        let replaceText = text
                        /*
                        replaceText = replaceText.replacingOccurrences(of: "& #40;", with: "(")
                        replaceText = replaceText.replacingOccurrences(of: "& #41;", with: ")")
                        */
                        header.label.text = replaceText
                        //print(text)
                        
                        return header
                    } else {
                        return header
                    }
                    
                } else {
                    return header
                }
                
            } else {
                return UICollectionReusableView()
            }
        } else {
            return UICollectionReusableView()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sideMenuCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sideMenuCell", for: indexPath) as! sideMenuCell
            cell.delegate = self
            
            cell.sideMenuFotterContent = self.sideMenuFotterContent
            return cell
        } else if collectionView == classStatusCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classStatusCell", for: indexPath) as! classStatusCell
            
            cell.setUnitList = self.setUnitList
            print(setUnitList)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classStatusCell1", for: indexPath) as! classStatusCell1
            if -1 < indexPath.row, indexPath.row < 6 {
                //print(<#T##items: Any...##Any#>)
                cell.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
            } else {
                cell.backgroundColor = .white
            }
            
            cell.indexpath = indexPath.row
            if let index = setRecordList {
                if (indexPath.row / 6) == 0 {
                    cell.setLabelText(number: indexPath.row, getRecordList: index[0][0])
                } else {
                    print(index[0][(indexPath.row / 6) - 1])
                    cell.setLabelText(number: indexPath.row, getRecordList: index[indexPath.section][(indexPath.row / 6) - 1])
                }
            }
            
            
            
            
            
            return cell
        }
            
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sideMenuCollectionview {
            return 0
        } else if collectionView == classStatusCollectionview {
            return 0
        } else {
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sideMenuCollectionview {
            return 0
        } else if collectionView == classStatusCollectionview {
            return 0
        } else {
            return 0
        }
    }
    
    
    
}

extension classStatusViewController {
    func setupLayout(){
        _scrollView()
        _topLabel()
        grayLine()
        _classStatusCollectionview(collectionview : classStatusCollectionview)
        _grayLine1(uiview: gray_line1)
        _positionStatusLabel(label: positionStatusLabel)
        
        _evaluationBtn(button : evaluationBtn)
        //_testStatusBtn(button : testStatusBtn)
        _classStatusBtn(button : classStatusBtn)
        
        
        _grayLine2(uiview: gray_line2)
        _classStatusCollectionview1(collectionview: classStatusCollectionview1)
        
        _confirmBtn(button: confirmBtn)
        
    }
    func _scrollView(){
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    func _topLabel(){
        scrollView.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.text = "- 차시별 수업 현황"
        topLabel.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        topLabel.textColor = mainColor._3378fd
        
        topLabel.textAlignment = .left
        
        topLabel.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 14).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func grayLine ()
    {
        self.scrollView.addSubview(gray_line)
        gray_line.translatesAutoresizingMaskIntoConstraints = false
        gray_line.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        gray_line.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 14).isActive = true
        gray_line.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gray_line.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gray_line.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    func _classStatusCollectionview(collectionview : UICollectionView){
        scrollView.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(classStatusCell.self, forCellWithReuseIdentifier: "classStatusCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        collectionview.topAnchor.constraint(equalTo: self.gray_line.bottomAnchor, constant: 2.5).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        collectionview.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.09 * 7).isActive = true
        
    }
    func _grayLine1(uiview : UIView){
        self.scrollView.addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.classStatusCollectionview.bottomAnchor, constant: 0).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    
    func _positionStatusLabel(label : UILabel){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "- 동작별 현황"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textColor = mainColor._3378fd
        
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: self.gray_line1.bottomAnchor, constant: 14).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    func _classStatusBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("수업 기록", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.addTarget(self, action: #selector(classStatusBtnAction), for: .touchUpInside)
        
        button.centerYAnchor.constraint(equalTo: positionStatusLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: evaluationBtn.leadingAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func _testStatusBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("과제 기록", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.addTarget(self, action: #selector(testStatusBtnAction), for: .touchUpInside)
        button.isHidden = true
        
        button.centerYAnchor.constraint(equalTo: positionStatusLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: evaluationBtn.leadingAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func _evaluationBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("평가 기록", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.addTarget(self, action: #selector(evaluationBtnAction), for: .touchUpInside)
        
        button.centerYAnchor.constraint(equalTo: positionStatusLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //eeeeee <- 버튼 비활성화
    }
    func _grayLine2(uiview : UIView){
        self.scrollView.addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.positionStatusLabel.bottomAnchor, constant: 14).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    func _classStatusCollectionview1(collectionview : UICollectionView){
        //동작별 현황 컬랙션뷰
        scrollView.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        collectionview.isPagingEnabled = false
        collectionview.isScrollEnabled = false
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(classStatusCell1.self, forCellWithReuseIdentifier: "classStatusCell1")
        collectionview.register(classStatus1Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "classStatus1Header")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        collectionview.topAnchor.constraint(equalTo: self.gray_line2.bottomAnchor, constant: 10).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18).isActive = true
        collectionview.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.09 * 12).isActive = true
    }
    
    func _confirmBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor._3378fd
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
        
    }
}
