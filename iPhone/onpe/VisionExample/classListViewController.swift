//
//  classListViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/20.
//

import UIKit

class classListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.delegate16 = self
        AF.delegate15 = self
        
        //self.navigationController?.navigationBar.barTintColor = .white //- 상단 네비게이션 바 흰색으로 바꾸기
        let deviceType = UIDevice().type
        
        let deviceModel = deviceType.rawValue
        sizetheFitsControlByDevice(deviceType: deviceModel)
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)
        self.title = "수업 목록"
        navigationItem.setRightBarButtonItems([sideMenuNarBtn], animated: false)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSideMenuCollectionviewY = statusBarHeight
        setupLayout()
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
    
    let classTextField = UITextField()
    let classTextFieldPicker = UIPickerView()
    let topLabelImageview = UIImageView()
    let gray_line = UIView()
    
    let classDeleteBtn = UIButton()
    let classCommunityBtn = UIButton()
    let gray_line1 = UIView()
    
    let classListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var getClassCode : String = ""
    var getClassList : [ClassList]?{
        didSet{
            print(getClassList)
            print("-----")
            self.classListCollectionview.reloadData()
        }
    }
    
    var indexTitle : String = ""
    let AF = ServerConnectionLegacy()
        
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
extension classListViewController : sideMenuCellDelegate {
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
        sideMenuCollectionview.register(classListCellCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "classListCellCollectionViewHeader")
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
extension classListViewController {
    @objc
    func classCommunityBtnAction(){
        let vc = communityViewController()
        vc.view.backgroundColor = .white
        vc.title = "커뮤니티"
        let navController = UINavigationController(rootViewController: vc)
        //navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
        /*
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
}
//MARK: - AFclass Delegate
extension classListViewController : unitListPageDelegate, mainPageDelegate {
    func appClassStudentClassUpdate(result: Int) {
        //사용안함
    }
    
    func appClassGetClassUnitList(result: Int, ClassListStr: String, fail : String?) {
        if result == 0 {
            
            if let data = ClassListStr.data(using: .utf8) {
                do {
                    let getResult = try JSONDecoder().decode([ClassList].self, from: data)
                    getClassList = getResult
                    
                    
                } catch let error {
                    print(error)
                }
            }
            
            classListCollectionview.reloadData()
            
        } else if result == 1 {
            //getClassList = []
            extensionClass.showToast(view: view, message: "해당 클래스가 없거나 잘못된 접근입니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            classListCollectionview.reloadData()
            
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
    
    
    
    func appRecordGetStudentClassRecord(result: Int, recordDic: recordDic?) {
        if result == 0 {
            
            //x차시 공다루기 수업의 수업현황 이동함수
            let vc = classStatusViewController()
            vc.title = indexTitle// 입력
            vc.getRecordDic = recordDic
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if result == 1 {
            extensionClass.showToast(view: view, message: "수업에 먼저 참석해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appCurriculumStudentGetCurriculum(result: Int, unitList: [UnitList]) {
        if result == 0 {
            let vc = classContentViewController()
            vc.title = "\(indexTitle)"// 입력
            var unitListIndex : UnitList?
            print(unitList)
            if unitList.count == 1 {
                //전체형일때
                vc.unitType = "0"
                unitListIndex = unitList[0]
            } else {
                var i = 0
                for unitListArr in unitList {
                    var breakBool = false
                    for idList in extensionClass.jsonToArray(jsonString: unitListArr.unit_group_id_list ?? "") {
                        if idList == userInformationClass.student_id {
                            breakBool = true
                            break
                        }
                        
                    }
                    if breakBool {
                        break
                    }
                    i += 1
                }
                
                vc.unitType = "1"
                vc.unitGroupName = "\(unitList[i].unit_group_name!)"
                unitListIndex = unitList[i]
                //맞춤형일때 unit_group_number_list 에서 학생 번호에 맞는 리스트의 값을 다음 페이지로 넘겨준다.
            }
            print(vc.unitType)
            print(vc.unitGroupName)
            print(unitListIndex)
            vc.unitList = unitListIndex ?? nil
            vc.view.backgroundColor = .white
            let backItem = UIBarButtonItem()
            backItem.title = ""
            
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        } else if result == 1{
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
    }
    
    
}
extension classListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, classListCellCollectionViewCellDelegate {
    
    func classCode(unitCode : String, classCode : String ,title : String, deadLine : Bool) {
        if deadLine {
            
            indexTitle = title
            //x차시 공다루기 수업 이동 함수
            //classCodeNumber -> unit_code(차시별 코드)
            AF.appCurriculumStudentGetCurriculum(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, unit_code: unitCode, url: "app/curriculum/student_get_curriculum")
            
        } else {
            
            extensionClass.showToast(view: view, message: "수업 기간이 종료 되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
    }
    
    func classCodeReport(unitCode : String, classCode : String, title : String) {
        indexTitle = title
        print("클래스 코드 : ",classCode)
        print("차시별 코드 : ",unitCode)
        AF.appRecordGetStudentClassRecord(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: classCode, unit_code: unitCode, url: "app/record/get_student_class_record")
        
        
    }
    
    
    //collectionview Header Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == classListCollectionview {
            return CGSize(width: collectionView.frame.width, height: 180)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        
        
        if collectionView == classListCollectionview{
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "classListCellCollectionViewHeader", for: indexPath) as? classListCellCollectionViewHeader else {
                return UICollectionReusableView()
            }
            
            return header
        } else {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "classListCellCollectionViewHeader", for: indexPath) as? classListCellCollectionViewHeader else {
                return UICollectionReusableView()
            }
            header.isHidden = true
            return header
            
        }
        
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sideMenuCollectionview{
            return 1
        } else {
            return getClassList?.count ?? 0
        }
            
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sideMenuCollectionview {
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classListCellCollectionViewCell", for: indexPath) as! classListCellCollectionViewCell
            cell.delegate = self
            cell.indexrow = indexPath.row
            cell.getClassList = self.getClassList?[indexPath.row]
            cell.classCode = self.getClassCode
            
            //cell.classCodeReport = String(indexPath.row + 1)//x차시 수업현황 코드
            //cell.sideMenuFotterContent = self.sideMenuFotterContent
            return cell
        }
            
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sideMenuCollectionview {
            return 0
        } else {
            return 10
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sideMenuCollectionview {
            return 0
        } else {
            return 0
        }
    }
    
    
}
//MARK: - pickerDelegate
extension classListViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return userInformationClass.student_classcodeList.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userInformationClass.student_classcodeNameList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getClassCode = userInformationClass.student_classcodeList[row]
        classTextField.text = userInformationClass.student_classcodeNameList[row]
        AF.appClassGetClassUnitList(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, class_code: getClassCode, url: "app/class/get_class_unit_list")
        
    }
    
    
}
extension classListViewController {
    @objc
    func action(){
        self.view.endEditing(true)
    }
    func setupLayout(){
        _classTextField(textField: classTextField)
        _classTextFieldPicker(picker: classTextFieldPicker)
        _topLabelImageview(imageview: topLabelImageview)
        grayLine()
        
        
        _classDeleteBtn(button: classDeleteBtn)
        _classCommunityBtn(button: classCommunityBtn)
        _gray_line1(grayLine: gray_line1)
        _classListCollectionview(collectioniew: classListCollectionview)
    }
    
    func _classTextField(textField : UITextField){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "\(userInformationClass.student_classcodeNameList[ViewController1.pageControlerRow])"
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        
        textField.textAlignment = .left
        textField.layer.zPosition = 1
        textField.tintColor = .clear
        textField.textColor = .black
        
        
        textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 14).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    func _classTextFieldPicker(picker : UIPickerView){
        picker.delegate = self
        picker.dataSource = self
        classTextField.inputView = picker
        dismissPickerView(textField: classTextField)
    }
    func dismissPickerView(textField : UITextField) {
        let toolBar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    func _topLabelImageview(imageview : UIImageView){
        view.addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "arrow_bottom_box")
        imageview.contentMode = .scaleAspectFit
        
        imageview.centerYAnchor.constraint(equalTo: self.classTextField.centerYAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: self.classTextField.trailingAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func grayLine ()
    {
        gray_line.translatesAutoresizingMaskIntoConstraints = false
        gray_line.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        self.view.addSubview(gray_line)
        
        gray_line.topAnchor.constraint(equalTo: self.classTextField.bottomAnchor, constant: 14).isActive = true
        gray_line.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gray_line.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gray_line.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    
    func _classDeleteBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("학기 수업 삭제하기", for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.layer.cornerRadius = 8
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.isHidden = true
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -27).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _classCommunityBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("학급 커뮤니티", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(classCommunityBtnAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -27).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    func _gray_line1(grayLine : UIView){
        view.addSubview(grayLine)
        
        grayLine.translatesAutoresizingMaskIntoConstraints = false
        grayLine.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        grayLine.bottomAnchor.constraint(equalTo: self.classCommunityBtn.topAnchor, constant: -20).isActive = true
        grayLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        grayLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        grayLine.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    
    func _classListCollectionview(collectioniew : UICollectionView){
        view.addSubview(collectioniew)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectioniew.backgroundColor = .white
        collectioniew.collectionViewLayout = layout
        
        collectioniew.translatesAutoresizingMaskIntoConstraints = false
        collectioniew.register(classListCellCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "classListCellCollectionViewHeader")
        collectioniew.register(classListCellCollectionViewCell.self, forCellWithReuseIdentifier: "classListCellCollectionViewCell")
        
        collectioniew.delegate = self
        collectioniew.dataSource = self
        
        
        collectioniew.topAnchor.constraint(equalTo: self.gray_line.bottomAnchor, constant: 10).isActive = true
        collectioniew.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        collectioniew.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        collectioniew.bottomAnchor.constraint(equalTo: self.gray_line1.topAnchor, constant: -10).isActive = true
    }
}
