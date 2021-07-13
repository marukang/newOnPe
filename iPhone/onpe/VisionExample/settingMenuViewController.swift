//
//  settingViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/26.
//

import UIKit

class settingMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        AF.delegate6 = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWindow = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        print(getWindow)
        if UserInformation.student_push_agreement == "1"{
            pushSwitchBtn.setOn(true, animated: false)
            
        } else {
            pushSwitchBtn.setOn(false, animated: false)
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        if setPushValue != "" {
            AF.appMemberPushAgreementChange(student_id: UserInformation.student_id, student_push_agreement: setPushValue, student_token: UserInformation.access_token, url: "app/member/push_agreement_change")
        }
    }
    let pushLabel = UILabel()
    let versionLabel = UILabel()//서비스 버전
    let versionStrLabel = UILabel()//1.0.1
    let termLabel = UILabel()//서비스 약관
    let removeLabel = UILabel()//서비스 탈퇴
    let askLabel = UILabel()//서비스 문의
    
    let pushSwitchBtn = UISwitch()//푸시알림 스위치
    let versionBtn = UIButton()//버전 업데이트 체크
    let termBtn = UIButton()//서비스 약관 보기
    let removeBtn = UIButton()//서비스 탈퇴 하기
    let emailLabel = UILabel()//complexion@complexion.com 적기
    let logoutLable = UILabel()//로그아웃
    let logoutBtn = UIButton()//로그아웃 버튼
    
    var setPushValue : String = ""
    let AF = ServerConnectionLegacy()
    
    let removeCollectionview : UICollectionView = {
        let cv = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.backgroundColor = .white
        
        return cv
    }()
    let black_view1 = UIView()
    var getWindow : UIWindow?
    var removeCollectionview_height : CGFloat = 0.65
    var removeCollectionview_value : CGFloat = 0
    var removeCollectionviewY : CGFloat = 0
    var keyboardWillHideBool = false
    var keyboardWillShowBool = false
    
    @objc
    func logoutBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "정말로 로그아웃하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            UserInformation.student_id = ""
            UserInformation.student_name = ""
            UserInformation.student_email = ""
            UserInformation.student_phone = ""
            UserInformation.student_push_agreement = ""
            UserInformation.student_email_agreement = ""
            UserInformation.student_message_agreement = ""
            UserInformation.student_image_url = ""
            UserInformation.student_content = ""
            UserInformation.student_tall = ""
            UserInformation.student_weight = ""
            UserInformation.student_age = ""
            UserInformation.student_sex = ""
            UserInformation.student_school = ""
            UserInformation.student_level = ""
            UserInformation.student_class = ""
            UserInformation.student_number = ""
            UserInformation.student_state = ""
            UserInformation.news_state = ""
            UserInformation.new_messgae_state = ""
            UserInformation.student_classcode = []
            UserInformation.student_classcodeList = []
            UserInformation.student_classcodeNameList = []
            UserInformation.student_create_date = ""
            UserInformation.student_recent_join_date = ""
            UserInformation.student_recent_exercise_date = ""
            
            UserInformation.access_token = ""
            UserInformation.fcm_token = ""
            
            UserInformation.preferences.removeObject(forKey: UserInformation.autoLoginKey)
            
            let vc = loginViewController()
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @objc
    func termBtnAction(){
        let vc = termListViewController()
        vc.title = "이용약관"
        vc.view.backgroundColor = .white
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func removeBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "정말로 탈퇴하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            self.removeCollectionviewUp()
            alert.dismiss(animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: 회원탈퇴 바텀시트 다이얼로그 관련 함수모음
extension settingMenuViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, removeCellDelegate {
    
    
    func btnAction(password: String) {
        print(password)
        
        AF.appMemberStudentResign(student_id: UserInformation.student_id, student_password: password, student_token: UserInformation.access_token, url: "app/member/student_resign", {result0, result1 in
            
            if result0 == 0 {
                //회원탈퇴 완료될 경우
                print("탈퇴완료 : \(result1)")
                if result1 == "student_password" {
                    let alert = UIAlertController(title: "온체육", message: "비밀번호가 올바르지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let cancelAction = UIAlertAction(title: "확인", style: .cancel)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                } else if result1 == "success_resign"{
                    self.removeCollectionviewDown({
                        let alert = UIAlertController(title: "온체육", message: "회원탈퇴가 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                        
                        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                            
                            UserInformation.student_id = ""
                            UserInformation.student_name = ""
                            UserInformation.student_email = ""
                            UserInformation.student_phone = ""
                            UserInformation.student_push_agreement = ""
                            UserInformation.student_email_agreement = ""
                            UserInformation.student_message_agreement = ""
                            UserInformation.student_image_url = ""
                            UserInformation.student_content = ""
                            UserInformation.student_tall = ""
                            UserInformation.student_weight = ""
                            UserInformation.student_age = ""
                            UserInformation.student_sex = ""
                            UserInformation.student_school = ""
                            UserInformation.student_level = ""
                            UserInformation.student_class = ""
                            UserInformation.student_number = ""
                            UserInformation.student_state = ""
                            UserInformation.news_state = ""
                            UserInformation.new_messgae_state = ""
                            UserInformation.student_classcode = []
                            UserInformation.student_classcodeList = []
                            UserInformation.student_classcodeNameList = []
                            UserInformation.student_create_date = ""
                            UserInformation.student_recent_join_date = ""
                            UserInformation.student_recent_exercise_date = ""
                            
                            UserInformation.access_token = ""
                            UserInformation.fcm_token = ""
                            
                            UserInformation.preferences.removeObject(forKey: UserInformation.autoLoginKey)
                            
                            let vc = loginViewController()
                            let navController = UINavigationController(rootViewController: vc)
                            navController.modalPresentationStyle = .fullScreen
                            self.present(navController, animated: true, completion: nil)
                            
                            alert.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    })
                }
                
            } else {
                //비밀번호 틀릴경우
                print("에러")
                if result1 == "student_password" {
                    let alert = UIAlertController(title: "온체육", message: "비밀번호가 올바르지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let cancelAction = UIAlertAction(title: "확인", style: .cancel)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
        })
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "removeCell", for: indexPath) as! removeCell
        cell.delegate = self
        cell.parentView = self.view
        return cell
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
    
    func removeCollectionviewUp()
    {
        //신규 수업 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let window = getWindow {
            
            black_view1.translatesAutoresizingMaskIntoConstraints = false
            black_view1.backgroundColor = UIColor(white: 0, alpha: 0.5)
            black_view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBottomSheet(gestureRecognizer:))))
            
            removeCollectionview.delegate = self
            removeCollectionview.dataSource = self
            window.addSubview(black_view1)
            removeCollectionview.backgroundColor = .white
            removeCollectionview.isScrollEnabled = false
            removeCollectionview.translatesAutoresizingMaskIntoConstraints = false
            
            removeCollectionview.layer.cornerRadius = 20
            removeCollectionview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            window.addSubview(removeCollectionview)
            
            removeCollectionview.register(removeCell.self, forCellWithReuseIdentifier: "removeCell")
            blackView1(window: window)//검은색 뒷배경 설정 함수
            
            removeCollectionview.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 0)
            
            black_view1.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //let window_height : CGFloat = 0.7
                self.removeCollectionview_value =  window.frame.height * (1 - self.removeCollectionview_height)
                
                self.removeCollectionviewY = window.frame.height
                
                self.black_view1.alpha = 1
                self.removeCollectionview.frame = CGRect(x: 0, y: (window.frame.height * self.removeCollectionview_height), width: window.frame.width, height: self.removeCollectionview_value)
                
                self.removeCollectionview.reloadData()
            }, completion: nil)
            
        }
    }
    @objc
    func closeBottomSheet(gestureRecognizer: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view1.alpha = 0
            
            self.removeCollectionview.frame = CGRect(x: 0, y: self.removeCollectionviewY, width: self.view.frame.width, height: self.removeCollectionview_value)
            //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
        }, completion: {done in
            if done {
                self.removeCollectionview.removeFromSuperview()
                self.black_view1.removeFromSuperview()
            }
        })
    }
    
    func removeCollectionviewDown(_ completion : @escaping ()-> Void){
        UIView.animate(withDuration: 0.3, animations: {
            self.black_view1.alpha = 0
            
            self.removeCollectionview.frame = CGRect(x: 0, y: self.removeCollectionviewY, width: self.view.frame.width, height: self.removeCollectionview_value)
            completion()
            //self.white_filter_collectionview.deleteItems(at: [IndexPath.init(item: 0, section: 0)])
        }, completion: {done in
            if done {
                
                self.removeCollectionview.removeFromSuperview()
                self.black_view1.removeFromSuperview()
            }
        })
    }
    func blackView1(window : UIWindow)
    {
        black_view1.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        black_view1.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        black_view1.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        black_view1.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
    }
}

extension settingMenuViewController : appMemberPushAgreementChangeDelegate{
    func appMemberPushAgreementChange(result: Int) {
        print(result)
        
        if result == 0 {
            UserInformation.student_push_agreement = setPushValue
            
        }
        
    }
    
    
}
//MARK: - @objc 함수
extension settingMenuViewController{
    @objc
    func pushSwitchBtnAction(){
        
            if pushSwitchBtn.isOn {
                setPushValue = "1"
                print("on")
            } else {
                setPushValue = "0"
                print("off")
            }
        
    }
}

extension settingMenuViewController {
    func setupLayout(){
        _pushLabel(label : pushLabel)
        _versionLabel(label: versionLabel)//서비스 버전
        _versionBtn(button: versionBtn)//버전 업데이트
        _versionStrLabel(label: versionStrLabel)//1.0.1
        _termLabel(label: termLabel)//서비스 약관
        _removeLabel(label: removeLabel)//서비스 탈퇴
        _askLabel(label: askLabel)//서비스 문의
        
        _pushSwitchBtn(switchBtn: pushSwitchBtn)
        
        _termBtn(button: termBtn)//서비스 약관 보기
        _removeBtn(button: removeBtn)//서비스 탈퇴 하기
        _emailLabel(label : emailLabel)//complexion@complexion.com 적기
        _logoutLable(label : logoutLable)
        _logoutBtn(button : logoutBtn)
        
    }
    func _pushLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PUSH 알림"
        label.textColor = mainColor._404040
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _versionLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "서비스 버전"
        label.textColor = mainColor._404040
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        
        label.topAnchor.constraint(equalTo: pushLabel.bottomAnchor, constant: 35).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }//서비스 버전
    func _versionStrLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1.0.2"
        label.textColor = mainColor._404040
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .center
        
        /*
        label.centerYAnchor.constraint(equalTo: versionBtn.centerYAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: versionBtn.leadingAnchor,constant: -10).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        */
        label.centerYAnchor.constraint(equalTo: versionLabel.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }//1.0.1
    func _termLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "서비스 약관"
        label.textColor = mainColor._404040
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        
        label.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 35).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }//서비스 약관
    func _removeLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "서비스 탈퇴"
        label.textColor = mainColor._404040
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        //label.isHidden = true
        
        label.topAnchor.constraint(equalTo: termLabel.bottomAnchor, constant: 35).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }//서비스 탈퇴
    func _askLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "서비스 문의"
        label.textColor = mainColor._404040
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        
        label.topAnchor.constraint(equalTo: removeLabel.bottomAnchor, constant: 35).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }//서비스 문의
    func _pushSwitchBtn(switchBtn : UISwitch){
        view.addSubview(switchBtn)
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.tintColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        switchBtn.onTintColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        switchBtn.thumbTintColor = mainColor._3378fd
        switchBtn.addTarget(self, action: #selector(pushSwitchBtnAction), for: .valueChanged)
        
        
        switchBtn.centerYAnchor.constraint(equalTo: self.pushLabel.centerYAnchor).isActive = true
        switchBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
    }
    func _versionBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("업데이트", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.backgroundColor = mainColor._3378fd
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.isHidden = true
        
        button.centerYAnchor.constraint(equalTo: versionLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }//버전 업데이트
    func _termBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("약관보기", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#404040"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(termBtnAction), for: .touchUpInside)
        button.centerYAnchor.constraint(equalTo: termLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }//서비스 약관 보기
    func _removeBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#404040"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(removeBtnAction), for: .touchUpInside)
        //button.isHidden = true
        
        button.centerYAnchor.constraint(equalTo: removeLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }//서비스 탈퇴 하기
    func _emailLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "complexion@complexion.com"
        label.textAlignment = .right
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        
        label.centerYAnchor.constraint(equalTo: askLabel.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 190).isActive = true
    }//complexion@complexion.com 적기
    func _logoutLable(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "로그아웃"
        label.textColor = mainColor._404040
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        
        label.topAnchor.constraint(equalTo: askLabel.bottomAnchor, constant: 35).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    func _logoutBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#404040"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(logoutBtnAction), for: .touchUpInside)
        
        
        button.centerYAnchor.constraint(equalTo: logoutLable.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
