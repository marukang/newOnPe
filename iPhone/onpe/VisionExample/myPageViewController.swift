//
//  myPageViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/21.
//

import UIKit
import SDWebImage

class myPageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "마이페이지"
        
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)
        setClassManageHide(bool: true)
        setUserManageHide(bool: true)
        setPwChangeHide(bool: true)
        setHeightValue()
        setupLayout()
        setupText()
        
        
        AF.delegate7 = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if setUserManageArea{
            setUserManageArea = !setUserManageArea
            classManageBool = true
            setClassManageHide(bool: false)
            grayLineHeight?.constant = grayLineHeightValue
            UIView.animate(withDuration: 0.5, animations: {
                self.arrowImageview1.transform = .init(rotationAngle: .pi)
            }, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollview1.contentSize = .init(width: self.view.frame.width, height: self.view.frame.height * 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    let AF = ServerConnectionLegacy()
    var getProfileImage : UIImage?
    var checkProfileBool : Bool = false // 프로필 이미지를 변경한 적이 있다면 true로 변경한다.
    
    let scrollview1 = UIScrollView()
    //--------학급정보 관리 변수
    let classManageBtn = UIButton()
    let gradeTexField = UITextField()
    let gradeLabel = UILabel()
    let classTexField = UITextField()
    let classLabel = UILabel()
    let numberTexField = UITextField()
    let numberLabel = UILabel()
    let grayLine1 = UIView()
    var grayLineHeight : NSLayoutConstraint?
    var grayLineHeightValue : CGFloat = 0
    var classManageBool = false
    let classManageConirmBtn = UIButton()
    
    var gradeStr : String = ""//학년
    var classStr : String = ""//학급
    var numberStr : String = ""//번호
    //--------기초 정보 관리 변수
    let userManageBtn = UIButton()
    let userProfileImageview = UIImageView()
    let userProfileUploadBtn = UIButton()
    
    let introducesSelfLabel = UILabel()//자기소개
    let introducesSelfTextField = UITextView()//자기소개 칸
    
    let heightLabel = UILabel()
    let heightTextField = UITextField()
    
    let weightLabel = UILabel()
    let weightTextField = UITextField()
    
    let ageLabel = UILabel()
    let ageTextField = UITextField()
    
    let genderLabel = UILabel()
    let maleBtn = UIButton()
    let femaleBtn = UIButton()
    
    var maleSelected : Bool = true
    var femaleSelected : Bool = false
    
    let userManageConfirmBtn = UIButton()
    
    var grayLine2Height : NSLayoutConstraint?
    var grayLine2HeightValue : CGFloat = 0
    var userManageBool = false
    let grayLine2 = UIView()
    
    
    //--------비밀번호 변경 변수
    let pwChangeBtn = UIButton()
    let pw0Label = UILabel()
    let pw0TextField = UITextField()//현재비밀번호
    let pw1TextField = UITextField()//변경 비밀번호
    let pw1Label = UILabel()
    let pw2TextField = UITextField()//변경 비밀번호 확인
    let pw2Label = UILabel()
    let pwChangeConfirmBtn = UIButton()
    
    var grayLine3Height : NSLayoutConstraint?
    var grayLine3HeightValue : CGFloat = 0
    var pwChangeBool = false
    let grayLine3 = UIView()
    
    
    
    let arrowImageview1 = UIImageView()
    let arrowImageview2 = UIImageView()
    let arrowImageview3 = UIImageView()
    
    let black_view1 = UIView()
    let proFilecollectionview : UICollectionView = {
        let cv = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.backgroundColor = .white
        
        return cv
    }()
    var getWindow : UIWindow?
    var proFilecollectionview_height : CGFloat = 0.65
    var proFilecollectionview_value : CGFloat = 0
    var proFilecollectionviewY : CGFloat = 0
    
    
    var setUserManageArea = false// 해당 버튼을 true로 받고 마이페이지에 이동되면 합금 정보 관리 area를 펼쳐준다.
    
    
    
    var imagePicker: UIImagePickerController!
    
    //앨범 사진 선택후 실행되는 delegate 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        userProfileImageview.image = selectedImage
        getProfileImage = selectedImage
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view1.alpha = 0
            
            self.proFilecollectionview.frame = CGRect(x: 0, y: self.proFilecollectionviewY, width: self.view.frame.width, height: self.proFilecollectionview_value)
            //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
        }, completion: {done in
            if done {
                self.checkProfileBool = true
                self.proFilecollectionview.removeFromSuperview()
                self.black_view1.removeFromSuperview()
            }
        })
    }
    
}

extension myPageViewController : appMemberMypageDelegate {
    func appMemberPasswordInformationChange(result: Int) {
        if result == 0 {
            
            let alert = UIAlertController(title: "성공", message: "비밀번호 변경 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else if result == 1{
            extensionClass.showToast(view: view, message: "현재 비밀번호를 다시 확인해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appMemberDefaultInformationChange1(result: Int) {
        if result == 0 {
            let a = userInformationClass.self
            
            let alert = UIAlertController(title: "성공", message: "기초 정보가 수정 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                a.student_content = self.introducesSelfTextField.text!
                a.student_tall = self.heightTextField.text!
                a.student_weight = self.weightTextField.text!
                a.student_age = self.ageTextField.text!
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else if result == 1{
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appMemberProfileChange(result: Int, imageUrl: String) {
        if result == 0 {
            print(imageUrl)
            userInformationClass.student_image_url = imageUrl
        } else if result == 1 {
            
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
    
    func appMemberClassInformationChange(result: Int) {
        if result == 0 {
            let alert = UIAlertController(title: "성공", message: "학급 정보가 변경 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                userInformationClass.student_level = self.gradeStr
                userInformationClass.student_class = self.classStr
                userInformationClass.student_number = self.numberStr
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            
            
        } else if result == 1 {
            extensionClass.showToast(view: view, message: "정보가 올바르지 않습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
}

extension myPageViewController{
    
    func setClassManageHide(bool : Bool){
        //학급 정보 관리 숨김 설정 함수
        gradeLabel.isHidden = bool
        gradeTexField.isHidden = bool
        classLabel.isHidden = bool
        classTexField.isHidden = bool
        numberLabel.isHidden = bool
        numberTexField.isHidden = bool
        classManageConirmBtn.isHidden = bool
    }
    func setUserManageHide(bool : Bool){
        userProfileImageview.isHidden = bool
        userProfileUploadBtn.isHidden = bool
        
        introducesSelfLabel.isHidden = bool
        introducesSelfTextField.isHidden = bool
        heightLabel.isHidden = bool
        heightTextField.isHidden = bool
        
        weightLabel.isHidden = bool
        weightTextField.isHidden = bool
        
        ageLabel.isHidden = bool
        ageTextField.isHidden = bool
        
        genderLabel.isHidden = bool
        maleBtn.isHidden = bool
        femaleBtn.isHidden = bool
        userManageConfirmBtn.isHidden = bool
    }
    func setPwChangeHide(bool : Bool){
        
        
        pw0Label.isHidden = bool
        pw0TextField.isHidden = bool
        pw1Label.isHidden = bool
        pw1TextField.isHidden = bool
        pw2Label.isHidden = bool
        pw2TextField.isHidden = bool
        pwChangeConfirmBtn.isHidden = bool
    }
    
    func setHeightValue(){
        let grayline1Height = (20 * 2) + (60 * 4) + (30 * 3)
        grayLineHeightValue = CGFloat(grayline1Height)
        
        let grayline2Height = (20 * 2) + (90 * 4.5)
        grayLine2HeightValue = CGFloat(grayline2Height)
        
        let grayline3Height = (20 * 2) + (60 * 4) + (30 * 3)
        
        grayLine3HeightValue = CGFloat(grayline3Height)
    }
    
    func setupText(){
        //이용자 정보 text 적기
        let a = userInformationClass.self
        gradeTexField.text = a.student_level
        classTexField.text = a.student_class
        numberTexField.text = a.student_number
        if a.student_image_url != "" {
            self.userProfileImageview.sd_setImage(with: URL(string: a.student_image_url), completed: nil)
        }
        introducesSelfTextField.text = a.student_content
        heightTextField.text = a.student_tall
        weightTextField.text = a.student_weight
        ageTextField.text = a.student_age
        
        let sex = a.student_sex
        if sex != ""{
            if sex == "m"{
                femaleBtn.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
                femaleBtn.setTitleColor(mainColor.hexStringToUIColor(hex: "#ebebeb"), for: .normal)
                maleBtn.layer.borderColor = mainColor._3378fd.cgColor
                maleBtn.setTitleColor(mainColor._3378fd, for: .normal)
            } else {
                femaleBtn.layer.borderColor = mainColor._3378fd.cgColor
                femaleBtn.setTitleColor(mainColor._3378fd, for: .normal)
                maleBtn.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
                maleBtn.setTitleColor(mainColor.hexStringToUIColor(hex: "#ebebeb"), for: .normal)
            }
        }
    }
    func isValidPassword(password : String) -> Bool
    {
        /*
         정규표현식
         - (?=.*[A-Za-z])(?=.*[0-9]) < -의미
         영어 대문자 소문자 그리고 0~9의 문자들이 포함되는지 검사해라
         - {8,16} 8~ 16자리로 적엇는지 확인해라
         */
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()]).{8,16}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
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
    
    func textViewDoneBtnMake(textview : UITextView)
    {
        //텍스트 입력할시 키보드 위에 done 기능 구현
        let ViewForDoneButtonOnKeyboard = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        ViewForDoneButtonOnKeyboard.translatesAutoresizingMaskIntoConstraints = false
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        textview.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    func showToast(text : String){
        extensionClass.showToast(view: self.view, message: "\(text)", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
    }
    
    
    @objc
    func doneBtnFromKeyboardClicked(sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
        
        self.view.endEditing(true)
    }
    
    func takePhoto() {
        selectImageFrom(.camera)
        //extensionClass.showToast(view: self.getWindow!, message: "잠시만 기다려주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    func save() {
        selectImageFrom(.photoLibrary)
        
    }
    
}

//MARK: 바텀 시트 함수
extension myPageViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, proFileCellDelegate {
    
    func btnAction(number: Int) {
        if number == 0 {
            //사진촬영
            takePhoto()
            print("사진")
        } else if number == 1 {
            //앨범에서 가져오기
            save()
            print("앨범")
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "proFileCell", for: indexPath) as! proFileCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func blackView1(window : UIWindow)
    {
        black_view1.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        black_view1.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        black_view1.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        black_view1.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
    }
    @objc
    func userProfileUploadBtnAction()
    {
        //상세입력후 추천받을래요 라는 바텀시트바가 뜨게하는 함수
        if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        {
            getWindow = window
            black_view1.translatesAutoresizingMaskIntoConstraints = false
            black_view1.backgroundColor = UIColor(white: 0, alpha: 0.5)
            black_view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBottomSheet(gestureRecognizer:))))
            
            proFilecollectionview.delegate = self
            proFilecollectionview.dataSource = self
            window.addSubview(black_view1)
            proFilecollectionview.backgroundColor = .white
            proFilecollectionview.isScrollEnabled = false
            proFilecollectionview.translatesAutoresizingMaskIntoConstraints = false
            
            proFilecollectionview.layer.cornerRadius = 20
            proFilecollectionview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            window.addSubview(proFilecollectionview)
            
            proFilecollectionview.register(proFileCell.self, forCellWithReuseIdentifier: "proFileCell")
            blackView1(window: window)//검은색 뒷배경 설정 함수
            
            proFilecollectionview.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 0)
            
            black_view1.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //let window_height : CGFloat = 0.7
                self.proFilecollectionview_value =  window.frame.height * (1 - self.proFilecollectionview_height)
                
                self.proFilecollectionviewY = window.frame.height
                
                self.black_view1.alpha = 1
                self.proFilecollectionview.frame = CGRect(x: 0, y: (window.frame.height * self.proFilecollectionview_height), width: window.frame.width, height: self.proFilecollectionview_value)
                
                self.proFilecollectionview.reloadData()
            }, completion: nil)
            
        }
    }
    @objc
    func closeBottomSheet(gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view1.alpha = 0
            
            self.proFilecollectionview.frame = CGRect(x: 0, y: self.proFilecollectionviewY, width: self.view.frame.width, height: self.proFilecollectionview_value)
            //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
        }, completion: {done in
            if done {
                self.proFilecollectionview.removeFromSuperview()
                self.black_view1.removeFromSuperview()
            }
        })
    }
}
//MARK: - @objc
extension myPageViewController{
    
    //학급정보 관리
    @objc
    func classManageConfirmBtnAction(){
        gradeStr = gradeTexField.text ?? ""
        classStr = classTexField.text ?? ""
        numberStr = numberTexField.text ?? ""
        if gradeStr != "", classStr != "", numberStr != ""{
            userInformationClass.student_level = gradeStr
            userInformationClass.student_class = classStr
            userInformationClass.student_number = numberStr
            AF.appMemberClassInformationChange(student_id: userInformationClass.student_id, student_level: gradeStr, student_class: classStr, student_number: numberStr, student_token: userInformationClass.access_token, url: "app/member/class_information_change")
            
        } else {
            extensionClass.showToast(view: view, message: "정보를 입력해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
        //showToast(text: "학급 정보가 수정 되었습니다.")
    }
    //기초 정보 관리
    @objc
    func userManageConfirmBtnAction(){
        
        let introduce = introducesSelfTextField.text
        let height = heightTextField.text
        let weight = weightTextField.text
        let age = ageTextField.text
        userInformationClass.student_content = introduce ?? ""
        AF.appMemberDefualtInformationChange(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_content: introduce ?? "", student_tall: height ?? "", student_weight: weight ?? "" , student_age: age ?? "" , student_sex: "", url: "app/member/default_information_change")
        if checkProfileBool {
            if let imgae = getProfileImage {
                AF.appMemberProfileChange(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, file: imgae, url: "app/member/profile_change")
            }
            
        }
        
        //조건문 이후 변경 완료 토스트
        
    }
    //비밀번호 변경
    @objc
    func pwChangeConfirmBtnAction(){
        print("하이")
        if !isValidPassword(password: pw1TextField.text ?? ""){
            showToast(text: "올바른 양식으로 입력해주세요.")
            return
        }
        if !isValidPassword(password: pw2TextField.text ?? ""){
            showToast(text: "올바른 양식으로 입력해주세요.")
            return
        }
        if 0 == pw0TextField.text?.count {
            showToast(text: "현재 비밀번호를 입력해주세요.")
            return
        }
        
        guard let pw1 = pw1TextField.text else {return}
        guard let pw2 = pw2TextField.text else {return}
        
        if pw1 == pw2 {
            
            AF.appMemberPasswordInformationChange(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_password_before: pw0TextField.text ?? "", student_password_new: pw2, url: "app/member/password_information_change")
            
        } else {
            showToast(text: "변경할 비밀번호가 일치하지 않습니다.")
        }
        
        
    }
    
    @objc
    func classManageBtnAction(){
        if classManageBool{
            classManageBool = false
            setClassManageHide(bool: true)
            grayLineHeight?.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.arrowImageview1.transform = .init(rotationAngle: .pi * 2)
            }, completion: nil)
        } else {
            classManageBool = true
            setClassManageHide(bool: false)
            grayLineHeight?.constant = grayLineHeightValue
            UIView.animate(withDuration: 0.5, animations: {
                self.arrowImageview1.transform = .init(rotationAngle: .pi)
            }, completion: nil)
        }
    }
    
    @objc
    func userManageBtnAction(){
        if userManageBool {
            userManageBool = false
            setUserManageHide(bool: true)
            grayLine2Height?.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.arrowImageview2.transform = .init(rotationAngle: .pi * 2)
            }, completion: nil)
        } else {
            userManageBool = true
            setUserManageHide(bool: false)
            grayLine2Height?.constant = grayLine2HeightValue
            UIView.animate(withDuration: 0.5, animations: {
                self.arrowImageview2.transform = .init(rotationAngle: .pi)
            }, completion: nil)
        }
    }
    
    @objc
    func pwChangeBtnAction(){
        if pwChangeBool {
            pwChangeBool = false
            setPwChangeHide(bool: true)
            grayLine3Height?.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.arrowImageview3.transform = .init(rotationAngle: .pi * 2)
            }, completion: nil)
        } else {
            pwChangeBool = true
            setPwChangeHide(bool: false)
            grayLine3Height?.constant = grayLine3HeightValue
            UIView.animate(withDuration: 0.5, animations: {
                self.arrowImageview3.transform = .init(rotationAngle: .pi)
            }, completion: nil)
        }
    }
    
    
    
    @objc
    func maleButtonAction(){
        if !maleSelected{
            
            femaleBtn.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
            femaleBtn.setTitleColor(mainColor.hexStringToUIColor(hex: "#ebebeb"), for: .normal)
            maleBtn.layer.borderColor = mainColor._3378fd.cgColor
            maleBtn.setTitleColor(mainColor._3378fd, for: .normal)
            maleSelected = true
            femaleSelected = false
        }
        
    }
    
    @objc
    func femaleButtonAction(){
        if !femaleSelected{
            femaleBtn.layer.borderColor = mainColor._3378fd.cgColor
            femaleBtn.setTitleColor(mainColor._3378fd, for: .normal)
            maleBtn.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
            maleBtn.setTitleColor(mainColor.hexStringToUIColor(hex: "#ebebeb"), for: .normal)
            
            maleSelected = false
            femaleSelected = true
        }
        
        
    }
}
extension myPageViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == introducesSelfTextField{
            guard let textFieldText = textView.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + text.count
            return count <= 60
        } else {
            return true
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == introducesSelfTextField{
            if textView.textColor == mainColor.hexStringToUIColor(hex: "#d3d3d3") {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == introducesSelfTextField{
            if textView.text.isEmpty {
                textView.text = "60자 이내로 입력해주세요. (최소 6글자 이상)"
                textView.textColor = mainColor.hexStringToUIColor(hex: "#d3d3d3")
            }
        }
    }
    
    
}
//MARK: - UITextFieldDelegate
extension myPageViewController : UITextFieldDelegate{
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == gradeTexField || textField == classTexField || textField == numberTexField{
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 2
        } else if textField ==  heightTextField || textField == weightTextField {
            
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 3
        } else if textField == ageTextField {
            
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 2
        } else if textField == pw0TextField || textField == pw1TextField || textField == pw2TextField  {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 16
        }
        else {
            return true
        }
        
    }
    
}
extension myPageViewController{
    
    func setupLayout(){
        _scrollview1(scrollview: scrollview1)
        
        //-------------- 학급 정보 관리 레이아웃
        _classManageBtn(button: classManageBtn, text: "학급 정보 관리")
        setArrowImage(imageview: arrowImageview1, button: classManageBtn)
        _setTextField1(textField: gradeTexField, button: classManageBtn, text: "학년을 입력하세요.", label : "학년")
        _setLabel(label: gradeLabel, textField: gradeTexField, text: "학년", width: 26)
        _setTextField2(textField: classTexField, textField1: gradeTexField, text: "반을 입력하세요.", label: "학급")
        _setLabel(label: classLabel, textField: classTexField, text: "학급", width: 26)
        _setTextField2(textField: numberTexField, textField1: classTexField, text: "번호를 일력하세요.", label: "번호")
        _setLabel(label: numberLabel, textField: numberTexField, text: "번호", width: 26)
        _confirmBtn(button: classManageConirmBtn, textField1: numberTexField, label: "학급 정보 관리")
        _grayLine1(uiview: grayLine1)
        
        //-------------- 기초정보 관리 레이아웃
        _userManageBtn(button: userManageBtn, uiview: grayLine1, text: "기초 정보 관리")
        setArrowImage(imageview: arrowImageview2, button: userManageBtn)
        _userProfileImageview(imageview : userProfileImageview)
        _userProfileUploadBtn(button : userProfileUploadBtn)
        _introducesSelfTextView(textview: introducesSelfTextField, text: "60자 이내로 입력해주세요. (최소 6글자 이상)")
        _setLabel(label: introducesSelfLabel, textField: numberTexField, text: "좌우명", width: 52)
        
        /*
        _setTextField2(textField: heightTextField, textField1: heightTextField, text: "키를 입력해주세요.", label: "키")
        _setLabel(label: heightLabel, textField: heightTextField, text: "키", width: 15)
        _setTextField2(textField: weightTextField, textField1: heightTextField, text: "몸무게를 입력해주세요..", label: "몸무게")
        _setLabel(label: weightLabel, textField: weightTextField, text: "몸무게", width: 41)
        _setTextField2(textField: ageTextField, textField1: weightTextField, text: "만 나이로 입력해주세요", label: "나이")
        _setLabel(label: ageLabel, textField: ageTextField, text: "나이", width: 27)
        _maleBtn(button: maleBtn, textField1: ageTextField, text: "남자")
        _femaleBtn(button: femaleBtn, textField1: ageTextField, text: "여자")
        setLabel1(label: genderLabel, button: maleBtn, text: "성별", width: 28)
         */
        _confirmBtn(button: userManageConfirmBtn, textField1: ageTextField, label: "기초 정보 관리")
        
        
        _grayLine2(uiview: grayLine2)
        //-------------- 비밀번호 변경 레이아웃
        
        _pwChangeBtn(button: pwChangeBtn, uiview: grayLine2, text: "비밀번호 변경")
        setArrowImage(imageview: arrowImageview3, button: pwChangeBtn)
        _setTextField1(textField: pw0TextField, button: pwChangeBtn, text: "현재 비밀번호를 입력하세요.", label: "현재 비밀번호")
        _setLabel(label: pw0Label, textField: pw0TextField, text: "현재 비밀번호", width: 85)
        _setTextField2(textField: pw1TextField, textField1: pw0TextField, text: "영어, 숫자, 특수문자를 포함한 8~16자리.", label: "변경 비밀번호")
        _setLabel(label: pw1Label, textField: pw1TextField, text: "변경 비밀번호", width: 85)
        _setTextField2(textField: pw2TextField, textField1: pw1TextField, text: "영어, 숫자, 특수문자를 포함한 8~16자리.", label: "변경 비밀번호")
        _setLabel(label: pw2Label, textField: pw2TextField, text: "변경 비밀번호 확인", width: 125)
        _confirmBtn(button: pwChangeConfirmBtn, textField1: pw2TextField, label: "비밀번호 변경")
        _grayLine3(uiview: grayLine3)
    }
    
    func _scrollview1(scrollview : UIScrollView){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
    }
    
    
    func _classManageBtn(button : UIButton, text : String){
        scrollview1.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        
        button.addTarget(self, action: #selector(classManageBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: scrollview1.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }//참고자료
    
    
    func _grayLine1(uiview : UIView){
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        grayLineHeight = uiview.topAnchor.constraint(equalTo: self.classManageBtn.bottomAnchor, constant: 0)
        grayLineHeight?.isActive = true
        
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    func _userManageBtn(button : UIButton, uiview : UIView ,text : String){
        scrollview1.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(userManageBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }//유뷰트 영상
    
    func _grayLine2(uiview : UIView){
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        grayLine2Height = uiview.topAnchor.constraint(equalTo: self.userManageBtn.bottomAnchor , constant: 0)
        grayLine2Height?.isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    
    func _pwChangeBtn(button : UIButton, uiview : UIView ,text : String){
        scrollview1.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(pwChangeBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }//수업 관련 링크
    
    
    func _grayLine3(uiview : UIView){
        scrollview1.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        grayLine3Height = uiview.topAnchor.constraint(equalTo: self.pwChangeBtn.bottomAnchor , constant: 0)
        grayLine3Height?.isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    //button 바로 밑에 textField 사용할때 사용하는 함수 예) 학급정보관리 버튼 밑에 학년 textField ...
    func _setTextField1(textField : UITextField, button : UIButton, text : String , label : String){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.textColor = .black
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        textField.placeholder = text
        if label == "학년" {
            textField.keyboardType = .numberPad
        }
        if label == "현재 비밀번호"{
            textField.isSecureTextEntry = true
        }
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        //textField.addTarget(self, action: #selector(heightTextFieldAction), for: .editingChanged)
        scrollview1.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    //textfield바로 밑에 바로 텍스트 field넣을때 사용
    func _setTextField2(textField : UITextField, textField1 : UITextField, text : String, label : String){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.textColor = .black
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        textField.placeholder = text
        if label == "키" || label == "몸무게" || label == "나이" || label == "학년" || label == "학급" || label == "번호" {
            textField.keyboardType = .numberPad
        }
        if label == "변경 비밀번호 확인" || label == "변경 비밀번호" {
            textField.isSecureTextEntry = true
        }
        
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        scrollview1.addSubview(textField)
        if label == "키"{
            textField.topAnchor.constraint(equalTo: introducesSelfTextField.bottomAnchor, constant: 30).isActive = true
        } else {
            textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 30).isActive = true
        }
        
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func _setLabel(label : UILabel, textField: UITextField, text : String, width : CGFloat){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.text = text
        scrollview1.addSubview(label)
        
        if text == "좌우명"{
            label.topAnchor.constraint(equalTo: introducesSelfTextField.topAnchor, constant : -10).isActive = true
        } else {
            label.topAnchor.constraint(equalTo: textField.topAnchor, constant : -10).isActive = true
        }
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
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
    
    
    
    func _userProfileImageview(imageview : UIImageView){
        scrollview1.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        imageview.backgroundColor = .systemGray5
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 10
        imageview.clipsToBounds = true
        imageview.layer.masksToBounds = true
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        
        imageview.topAnchor.constraint(equalTo: self.userManageBtn.bottomAnchor , constant: 20).isActive = true
        imageview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 90).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }//프로필 사진
    func _userProfileUploadBtn(button : UIButton){
        scrollview1.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("프로필 사진 업로드 +", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#777777"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 4
        button.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        button.addTarget(self, action: #selector(userProfileUploadBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.userProfileImageview.bottomAnchor, constant: 20).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 135).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func _introducesSelfTextView(textview : UITextView, text : String){
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        textview.textAlignment = .left
        textview.textColor = .black
        textview.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        textViewDoneBtnMake(textview: textview)
        textview.layer.borderWidth = 1.5
        textview.layer.cornerRadius = 10
        textview.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        //textview.text = ""
        textview.delegate = self
        textview.text = userInformationClass.student_content
        //textFieldDoneBtnMake(text_field: textField)
        
        //textField.addTarget(self, action: #selector(introducesTextFieldAction), for: .editingChanged)
        scrollview1.addSubview(textview)
        
        textview.topAnchor.constraint(equalTo: self.userProfileUploadBtn.bottomAnchor, constant: 25).isActive = true
        textview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textview.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func _maleBtn(button : UIButton, textField1 : UITextField, text : String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 10
        //button.layer.borderColor = mainColor._3378fd.cgColor
        
        //button.addTarget(self, action: #selector(maleButtonAction), for: .touchUpInside)
        button.isEnabled = false
        view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 30).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2 - 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _femaleBtn(button : UIButton, textField1 : UITextField, text : String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#ebebeb"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 10
        button.isEnabled = false
        //button.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        
        //button.addTarget(self, action: #selector(femaleButtonAction), for: .touchUpInside)
        view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 30).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2 - 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    //성별라벨을 위해 사용
    func setLabel1(label : UILabel, button: UIButton, text : String, width : CGFloat){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = mainColor._3378fd
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.text = text
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: button.topAnchor, constant : -10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    func _confirmBtn(button : UIButton, textField1 : UITextField, label : String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 10
        button.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        if label == "학급 정보 관리"{
            button.addTarget(self, action: #selector(classManageConfirmBtnAction), for: .touchUpInside)
        } else if label == "기초 정보 관리"{
            button.addTarget(self, action: #selector(userManageConfirmBtnAction), for: .touchUpInside)
        } else if label == "비밀번호 변경"{
            button.addTarget(self, action: #selector(pwChangeConfirmBtnAction), for: .touchUpInside)
        }
        
        scrollview1.addSubview(button)
        if label == "기초 정보 관리"{
            button.topAnchor.constraint(equalTo: introducesSelfTextField.bottomAnchor, constant: 30).isActive = true
        } else {
            button.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 30).isActive = true
        }
        
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    
    
    
}
