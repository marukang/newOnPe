//
//  joinViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/12.
//

import UIKit

class join1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = "회원가입"
        
        setupLayout()
        AF.delegate1 = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scroll_view.contentSize = .init(width: self.view.frame.width, height: self.view.frame.width * 2.4)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.window?.endEditing(true)
         
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - 레이아웃 오브젝트 변수
    let scroll_view : UIScrollView = UIScrollView()
    
    let id_label = UILabel()//아이디
    let id_text_field = UITextField()
    let id_text_check_btn = UIButton()
    let password1_label = UILabel()//비밀번호
    let password1_text_field = UITextField()
    let password2_label = UILabel()//비밀번호 확인
    let password2_text_field = UITextField()
    let name_label = UILabel()//이름
    let name_text_field = UITextField()
    let email_label = UILabel()//이메일
    let email2_label = UILabel()//"비밀번호를 분실 또는 휴대전화 사용이 불가능한 경우 계정을 복구 하는데 사용됩니다."
    let email_text_field = UITextField()
    let email_text_check_btn = UIButton()
    
    let cellphone_label = UILabel()
    let cellphone_text_field = UITextField()
    
    let verfiy_label = UILabel()
    let verfiy_text_field = UITextField()
    let verfiy_check_btn = UIButton()
    
    var verfiyCode : String?
    var getVerfiyCode : String?
    var verfiyCode_bool : Bool = false
    
    let circle_check1_btn = UIButton()
    let check1_label = UILabel()//"전체 동의하기"
    let circle_check2_btn = UIButton()
    let check2_label = UILabel()//"(주) FITME 개인정보 수집 및 이용동의 (필수)"
    let circle_check3_btn = UIButton()
    let privacy_btn = UIButton()//개인정보 처리
    let check3_label = UILabel()//"Fitme 이용약관(필수)"
    let circle_check4_btn = UIButton()
    let term_btn = UIButton()//이용약관
    let check4_label = UILabel()//"마케팅 활용 및 광고 정보 수신동의(선택)"
    
    
    let checkImage : UIImage = #imageLiteral(resourceName: "blue_rectangle")
    let uncheckImage : UIImage = #imageLiteral(resourceName: "gray_rectangle")
    var circle_check1_bool : Bool = false
    var circle_check2_bool : Bool = false
    var circle_check3_bool : Bool = false
    var circle_check4_bool : Bool = false
    
    
   
    let join_btn = UIButton()//"가입완료"
    let bottom_view = UIView()//바닥에 뷰
    
    
    //MARK: - 일반변수
    var id : String?
    var id_bool : Bool = false
    var check_id : String = ""
    var password1 : String?
    var password1_bool : Bool = false
    var password2 : String?
    var password2_bool : Bool = false
    var name : String?
    var name_bool : Bool = false
    var cellphone_text : String?
    var cellphone_bool : Bool = false
    var email : String?
    var email_bool : Bool = false
    var check_email : String = ""
    
    
    var location_result_dic : [[String : CGFloat]] = [[:]]
    var user_image_url_array : [String] = []
    var like_produdct_key_list : [String] = []
    var favorite_shop_list : [String] = []
    
    var joinToggle : Bool = false
    
    let AF = ServerConnectionLegacy()

}
extension join1ViewController : appOverlapCheckDelegate {
    func appSignUp(result: Int) {
        if result == 0 {
            
            let vc = join3ViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        } else if result == 1 {
            extensionClass.showToast(view: view, message: "잘못된 접근 방법입니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appEmailOverlapCheck(result: String) {
        //email중복체크
        if let resultInt = Int(result) {
            if resultInt > 3 {
                email_bool = true
                getVerfiyCode = result
                let alert = UIAlertController(title: "온체육", message: "이메일에서 인증코드를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    self.email_label.textColor = mainColor._3378fd
                    self.email_text_field.layer.borderColor = mainColor._3378fd.cgColor
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
                
            } else if resultInt == 1 {
                email_bool = false
                let alert = UIAlertController(title: "온체육", message: "중복된 이메일이 존재합니다.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    self.email_label.textColor = .red
                    self.email_text_field.layer.borderColor = UIColor.red.cgColor
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            } else {
                email_bool = false
                extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
        }
        
    }
    func appIdOverlapCheck(result: Int) {
        //ID중복체크 delegate
        if result == 0{
            //중복아님
            id_bool = true
            let alert = UIAlertController(title: "온체육", message: "이용 가능한 아이디 입니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.id_label.textColor = mainColor._3378fd
                self.id_text_field.layer.borderColor = mainColor._3378fd.cgColor
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            checkInputToggle()
        } else if result == 1 {
            id_bool = false
            id_label.textColor = .red
            id_text_field.layer.borderColor = UIColor.red.cgColor
            let alert = UIAlertController(title: "온체육", message: "중복된 아이디가 존재합니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            //중복
        } else {
            id_bool = false
            let alert = UIAlertController(title: "온체육", message: extensionClass.connectErrorText, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}
//MARK: - @objc 함수들
extension join1ViewController
{
    
    func checkInputToggle(){
        
        if id_bool, password1_bool, password2_bool, name_bool, email_bool, verfiyCode_bool, circle_check2_bool,circle_check3_bool {
            joinToggle = true
            join_btn.backgroundColor = mainColor._3378fd
        } else {
            joinToggle = false
            join_btn.backgroundColor = mainColor.hexStringToUIColor(hex: "#9f9f9f")
        }
    }
    @objc
    func verfiyCheckBtnAction(){
        
        if getVerfiyCode == verfiyCode  {
            print("인증완료")
            verfiyCode_bool = true
            let alert = UIAlertController(title: "온체육", message: "인증이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.verfiy_label.textColor = mainColor._3378fd
                self.verfiy_text_field.layer.borderColor = mainColor._3378fd.cgColor
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            verfiyCode_bool = false
            extensionClass.showToast(view: view, message: "인증번호가 올바르지 않습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4) )
            verfiy_label.textColor = .red
            verfiy_text_field.layer.borderColor = UIColor.red.cgColor
        }
        checkInputToggle()
    }
    @objc
    func joinButtonAction()
    {
        
        if joinToggle{
            if id_bool, password2_bool, email_bool, name_bool {
                
                let student_id = id_text_field.text
                let student_password = password2_text_field.text
                let student_email = email_text_field.text
                let student_name = name_text_field.text
                let authentication_code = verfiy_text_field.text
                let _ = cellphone_text_field.text
                let student_push_agreement = circle_check4_bool
                var student_push_agreementStr : String?
                if student_push_agreement{
                    student_push_agreementStr = "y"
                } else {
                    student_push_agreementStr = "n"
                }
                AF.appSignUp(student_id: student_id!, student_password: student_password!, student_email: student_email!, student_name: student_name!, authentication_code: authentication_code!, student_phone_number: cellphone_text ?? "", student_push_agreement: student_push_agreementStr!, url: "app/sign_up")
                //self.simpleJoinConfirm(id: id, email: email, password: password, name: name) 회원가입 메서드
            } else {
                print("아이디 체크 : ",id_bool)
                print("이메일 체크 : ",email_bool)
                extensionClass.showToast(view: self.view, message: "필수 항목을 입력해주세요.", font: .systemFont(ofSize: 15))
            }
        } else {
            if !id_bool{
                
            } else if !email_bool {
                
            } else if !password2_bool {
                
            } else if !email_bool {
                
            } else if !name_bool {
                
            } else if !verfiyCode_bool {
                
            } else if !circle_check2_bool,!circle_check3_bool {
                
            }
            print("아이디 체크 : ",id_bool)
            print("이메일 체크 : ",email_bool)
            extensionClass.showToast(view: self.view, message: "필수 항목을 입력해주세요.", font: .systemFont(ofSize: 15))
        }
        
        
        

    
    }
    /* 휴대폰 숫자 DB의 저장형태로 보내기 위해 아래와 같은 형태로 변환
     - 휴대폰 01012345678을 010-1234-5678으로 변환
     - 휴대폰 0101234567을 010-123-4567으로 변환
     */
    func cellPhoneToData(cellPhone1 : String) -> String
    {
        var s : String = cellPhone1
        if s.count > 10 {
            let i1 = s.index(s.startIndex, offsetBy: 3)
            s.insert("-", at: i1)
            let i2 = s.index(s.startIndex, offsetBy: 8)
            s.insert("-", at: i2)
        } else if s.count <= 10, s.count > 6 {
            let i1 = s.index(s.startIndex, offsetBy: 3)
            s.insert("-", at: i1)
            let i2 = s.index(s.startIndex, offsetBy: 7)
            s.insert("-", at: i2)
        } else {
            s = "0"
        }
        
        return s
    }
    
    //휴대폰번호체크
    @objc
    func cellphoneTextFieldAction()
    {
        self.cellphone_text = self.cellPhoneToData(cellPhone1: cellphone_text_field.text ?? "")
        
        if let cellphone_count = self.cellphone_text?.count
        {
            
            if cellphone_count > 11
            {
                cellphone_bool = true
                cellphone_text_field.layer.borderColor = mainColor._3378fd.cgColor
                cellphone_label.textColor = mainColor._3378fd
                
            } else if cellphone_text_field.text?.count == 0 {
                cellphone_bool = false
                cellphone_text_field.layer.borderColor = mainColor._ebebeb.cgColor
                cellphone_label.textColor = .black
                
                
            } else {
                cellphone_bool = false
                cellphone_text_field.layer.borderColor = mainColor._ebebeb.cgColor
                cellphone_label.textColor = .red
                
            }
            
            
        }
        
        checkInputToggle()
        
    }
    @objc
    func verfiyCodeCheckAction(){
        verfiyCode = verfiy_text_field.text ?? ""
        if let count = verfiyCode?.count  {
            if  6 == count{
                
                verfiy_check_btn.isEnabled = true
                
            } else {
                verfiyCode_bool = false
                verfiy_check_btn.isEnabled = false
                verfiy_label.textColor = .red
                verfiy_text_field.layer.borderColor = UIColor.red.cgColor
            }
        }
        checkInputToggle()
    }
    
    //아이디 체크
    @objc func idTextFieldaAction()
    {
        
        self.id = id_text_field.text
        if let id = self.id
        {
            if id.count > 3, id.count < 13
            {
                if isValidId(id: id)//정규표현식으로 아이디 체크
                {
                    //중복확인 버튼 활성화
                    
                    id_text_check_btn.isEnabled = true
                    
                    //id_text_check_btn.backgroundColor = mainColor._3378fd
                    
                    
                } else {
                    //id_label.textColor = .red
                    //id_text_field.layer.borderColor = UIColor.red.cgColor
                    id_text_check_btn.isEnabled = false
                    //id_text_check_btn.backgroundColor = .systemGray4
                    
                    
                }
            } else {
                //id_label.textColor = .red
                //id_text_field.layer.borderColor = UIColor.red.cgColor
                id_text_check_btn.isEnabled = false
                //id_text_check_btn.backgroundColor = .systemGray4
                
                
            }
            
            
        }
        if id_bool
        {
            /* 중복 확인 검사후 id를 바꿀 경우를 대비하여서 만든 if문
             작동원리
             1. 중복확인을 누르고 중복되지 않았다
             2. 하지만 이용자가 다른아이를 다시 중복체크하고 싶어서 새로운 아이디를 입력한다.
             3. 그러면 밑의 if문이 실행되고 id_bool이 false로 바꿔서 중복체크를 다시해야한다.
             */
            if self.check_id != id_text_field.text
            {
                self.id_label.textColor = .red
                self.id_text_field.layer.borderColor = UIColor.red.cgColor
                self.id_bool = false
            }
        }
        checkInputToggle()
        
    }
    //id체크 정규표현식
    func isValidId(id : String) -> Bool
    {
        //let koreanRegEx = "^(?=.*[가-힣\\s]).{2,5}"
        let koreanRegEx = "^[a-zA-Z0-9]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", koreanRegEx)
        return predicate.evaluate(with: id)
    }
    //한글만 적는지 정규표현식
    func isValidKorean(name : String) -> Bool
    {
        //let koreanRegEx = "^(?=.*[가-힣\\s]).{2,5}"
        let koreanRegEx = "^[ㄱ-ㅎㅏ-ㅣ가-힣]{2,5}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", koreanRegEx)
        return predicate.evaluate(with: name)
    }
    //이름체크
    @objc func nameTextFieldAction()
    {
        self.name = self.name_text_field.text
        if let name = self.name {
            if isValidKorean(name: name) {
                
                self.name_label.textColor = mainColor._3378fd
                self.name_text_field.layer.borderColor = mainColor._3378fd.cgColor
                self.name_bool = true
            } else {
                
                self.name_label.textColor = .red
                self.name_text_field.layer.borderColor = UIColor.red.cgColor
                self.name_bool = true
            }
        }
        checkInputToggle()
    }
    
    //영어, 숫자 포함한 8~16자리
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
    //패스워드1 체크
    @objc func password1Value()
    {
        self.password1 = password1_text_field.text
        if validpassword(mypassword: self.password1 ?? "")
        {
            if isValidPassword(password: self.password1 ?? "")
            {
                password1_label.textColor = mainColor._3378fd
                password1_text_field.layer.borderColor = mainColor._3378fd.cgColor
                password1_bool = true
            } else {
                password1_label.textColor = .red
                password1_text_field.layer.borderColor = UIColor.red.cgColor
                password1_bool = false
            }
        } else {
            
            password1_label.textColor = .red
            password1_text_field.layer.borderColor = UIColor.red.cgColor
            password1_bool = false
        }
        checkInputToggle()
        
    }
    //패스워드2 체크
    @objc func password2TextFieldAction()
    {
        self.password2 = password2_text_field.text
        if validpassword(mypassword: self.password2 ?? "")
        {
            if self.password2 == self.password1
            {
                
                password2_label.textColor = mainColor._3378fd
                password2_text_field.layer.borderColor = mainColor._3378fd.cgColor
                password2_bool = true
            } else {
                
                password2_label.textColor = .red
                password2_text_field.layer.borderColor = UIColor.red.cgColor
                password2_bool = false
            }
        } else {
            
            password2_label.textColor = .red
            password2_text_field.layer.borderColor = UIColor.red.cgColor
            password2_bool = false
        }
        checkInputToggle()
        
        //print("self.password2 : ",self.password2 ?? "없음")
        //print("self.paswword1 : ",self.password1 ?? "없음")
    }
    func validpassword(mypassword : String) -> Bool
    {//숫자+문자 포함해서 8~20글자 사이의 text 체크하는 정규표현식
        let passwordreg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: mypassword)
    }
    //이메일 체크 함수
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    //이메일 체크
    @objc func emailTextFieldAction()
    {
        self.email = self.email_text_field.text
        if isValidEmail(email: email ?? "")
        {
            
            self.email_bool = true
            self.check_email = self.email_text_field.text!
            
            email_text_check_btn.isEnabled = true
             
             
        } else {
            
            //self.email_label.textColor = .red
            //self.email_text_field.layer.borderColor = UIColor.red.cgColor
            self.email_bool = false
            self.check_email = ""
            
             email_text_check_btn.isEnabled = false
             
        }
        
        if email_bool
        {
            /* 중복 확인 검사후 email를 바꿀 경우를 대비하여서 만든 if문
             작동원리
             1. 중복확인을 누르고 중복되지 않았다
             2. 하지만 이용자가 다른 이메일을 다시 중복체크하고 싶어서 새로운 아이디를 입력한다.
             3. 그러면 밑의 if문이 실행되고 email_bool이 false로 바꿔서 중복체크를 다시해야한다.
             */
            if self.check_email != email_text_field.text
            {
                
                 self.email_label.textColor = .red
                 self.email_label.text = "다시 아이디를 입력해주세요."
                 self.email_text_field.layer.borderColor = UIColor.red.cgColor
                 self.email_bool = false
                 
                
            }
        }
        checkInputToggle()
        //print("이메일 : ",email)
        //print("이메일 체크 : ",email_bool)
    }
    
    @objc
    func idTextCheckButtonAction(_ sender : UIButton)
    {
        /*
         - id 중복체크 서버로 보내기
         - 데이터 통신을 통한 'result'(json Data)의 값이 0이면 중복이 아니고, 1이면 중복이다.
         */
        AF.appIdOverlapCheck(student_id: id_text_field.text ?? "", url: "app/id_overlap_check")
    
    }
    
    @objc
    func emailTextCheckButtonAction(_ sender : UIButton)
    {
        
        AF.appEmailOverlapCheck(student_email: email_text_field.text ?? "", url: "app/email_authentication")
        email_bool = true
        checkInputToggle()
        /*
         - email 중복체크 서버로 보내기
         - 데이터 통신을 통한 'result'(json Data)의 값이 0이면 중복이 아니고, 1이면 중복이다.
         */
        
    }
    private func simpleJoinConfirm(id : String, email : String, password : String, name : String)
    {
        
    }
    func textFieldDoneBtnMake(text_field : UITextField)
    {//텍스트 입력할시 키보드 위에 done 기능 구현
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
//MARK - 이용약관 등등에 필요한 함수들
extension join1ViewController {
    @objc func termButtonAction(_ sender: UIButton)
    {
        
        
        let vc = termContentViewController()
        vc.title = "서비스 이용약관"
        vc.view.backgroundColor = .white
        vc.getType = false
            
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func privacyButtonAction(_ sender : UIButton)
    {
        let vc = termContentViewController()
        vc.title = "개인정보 처리 방침"
        vc.view.backgroundColor = .white
        vc.getType = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func checkImageChange(isChecked : Bool) -> UIImage
    {
        var image : UIImage
        if isChecked
        {
            image = self.checkImage
        } else {
            image = self.uncheckImage
        }
        return image
    }
    //전체 동의
    @objc func check1Btn(sender: UIButton)
    {
        if circle_check1_bool {
            circle_check1_bool = false
            circle_check2_bool = false
            circle_check3_bool = false
            circle_check4_bool = false
            
            circle_check1_btn.setImage(self.checkImageChange(isChecked: circle_check1_bool), for: .normal)
            circle_check2_btn.setImage(self.checkImageChange(isChecked: circle_check2_bool), for: .normal)
            circle_check3_btn.setImage(self.checkImageChange(isChecked: circle_check3_bool), for: .normal)
            circle_check4_btn.setImage(self.checkImageChange(isChecked: circle_check4_bool), for: .normal)
            
        } else {
            circle_check1_bool = true
            circle_check2_bool = true
            circle_check3_bool = true
            circle_check4_bool = true
            
            circle_check1_btn.setImage(self.checkImageChange(isChecked: circle_check1_bool), for: .normal)
            circle_check1_btn.setImage(self.checkImageChange(isChecked: circle_check1_bool), for: .normal)
            circle_check2_btn.setImage(self.checkImageChange(isChecked: circle_check2_bool), for: .normal)
            circle_check3_btn.setImage(self.checkImageChange(isChecked: circle_check3_bool), for: .normal)
            circle_check4_btn.setImage(self.checkImageChange(isChecked: circle_check4_bool), for: .normal)
            
        }
        checkInputToggle()
    }
    //개인정보 수집 및 이용동의 (필수) 타겟
    @objc func check2Btn(sender: UIButton)
    {
        if circle_check2_bool {
            circle_check1_bool = false
            circle_check1_btn.setImage(self.checkImageChange(isChecked: circle_check1_bool), for: .normal)
            circle_check2_bool = false
            circle_check2_btn.setImage(self.checkImageChange(isChecked: circle_check2_bool), for: .normal)
        } else {
            circle_check2_bool = true
            circle_check2_btn.setImage(self.checkImageChange(isChecked: circle_check2_bool), for: .normal)
        }
        checkInputToggle()
    }
    //이용약관(필수) 타겟
    @objc func check3Btn(sender: UIButton)
    {
        if circle_check3_bool {
            circle_check1_bool = false
            circle_check1_btn.setImage(self.checkImageChange(isChecked: circle_check1_bool), for: .normal)
            circle_check3_bool = false
            circle_check3_btn.setImage(self.checkImageChange(isChecked: circle_check3_bool), for: .normal)
        } else {
            circle_check3_bool = true
            circle_check3_btn.setImage(self.checkImageChange(isChecked: circle_check3_bool), for: .normal)
        }
        checkInputToggle()
    }
    //푸쉬 알람 동의
    @objc func check4Btn(sender: UIButton)
    {
        if circle_check4_bool {
            circle_check1_bool = false
            circle_check1_btn.setImage(self.checkImageChange(isChecked: circle_check1_bool), for: .normal)
            circle_check4_bool = false
            circle_check4_btn.setImage(self.checkImageChange(isChecked: circle_check4_bool), for: .normal)
        } else {
            circle_check4_bool = true
            circle_check4_btn.setImage(self.checkImageChange(isChecked: circle_check4_bool), for: .normal)
        }
        checkInputToggle()
    }
    
    
}

//MARK: - textdFieldDelegate
extension join1ViewController : UITextFieldDelegate
{
    
    //글자 수 못넘게 하기 위해 사용한 델리게이트
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == id_text_field
        {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 16
        } else if textField ==  password1_text_field || textField == password2_text_field {
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 16
        } else if textField == name_text_field {
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            print("textFieldText : ", textFieldText.count)
            print("substringToReplace : ",substringToReplace.count)
            print("string : ",string.count)
            return count <= 4
        } else {
            return true
        }
        
    }
}

extension join1ViewController {
    func setupLayout()
    {
        scrollView()
        
        
        idTextField()
        idLabel()
        
        idTextCheckBtn()
        
        password1TextField()
        password1Label()
        
        password2TextField()
        password2Label()
        
        nameTextField()
        nameLabel()
        
        cellphoneTextField(textField: cellphone_text_field, textField1: name_text_field, text: "휴대폰 번호를 입력해주세요.(-제외)")
        setLabel(label: cellphone_label, textField: cellphone_text_field, text: "휴대폰 번호 (선택)",width: 132)
        
        emailTextField()
        emailLabel()
        emailTextCheckBtn()
        
        verfiyTextField(textField: verfiy_text_field, textField1: email_text_field, text: "인증번호 6자리를 입력하세요.")
        setLabel(label: verfiy_label, textField: verfiy_text_field, text: "인증번호", width: 55)
        verfiyCheckBtn()
        
        
        
       
        circleCheck1Btn()
        check1Label()
        circleCheck2Btn()
        check2Label()
        circleCheck3Btn()
        privacyBtn()//개인정보 처리
        check3Label()
        circleCheck4Btn()
        termBtn()//이용약관
        check4Label()
        
        
        joinBtn()
        
    }
    func scrollView()
    {
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        scroll_view.showsVerticalScrollIndicator = false
        scroll_view.isScrollEnabled = true
        view.addSubview(scroll_view)
        
        scroll_view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll_view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scroll_view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scroll_view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    func idTextField()
    {
        id_text_field.translatesAutoresizingMaskIntoConstraints = false
        id_text_field.textAlignment = .left
        id_text_field.textColor = .black
        id_text_field.becomeFirstResponder()
        id_text_field.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        id_text_field.setLeftPaddingPoints(10)
        id_text_field.setRightPaddingPoints(10)
        id_text_field.layer.borderWidth = 1.5
        id_text_field.layer.cornerRadius = 10
        id_text_field.autocapitalizationType = .none
        id_text_field.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        id_text_field.placeholder = "아이디를 입력하세요(4~12자리)"
        id_text_field.delegate = self
        id_text_field.text = ""
        id_text_field.addTarget(self, action: #selector(idTextFieldaAction), for: .editingChanged)
        scroll_view.addSubview(id_text_field)
        textFieldDoneBtnMake(text_field: id_text_field)
        
        id_text_field.topAnchor.constraint(equalTo: self.scroll_view.topAnchor, constant: 40).isActive = true
        id_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        id_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        id_text_field.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func idLabel()
    {  /*
        let str = "아이디*"
        let str_1 = "*"
        let total_word = (str as NSString).range(of: str_1)
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.red], range: total_word)
        */
        
        id_label.translatesAutoresizingMaskIntoConstraints = false
        id_label.textAlignment = .center
        id_label.backgroundColor = .white
        id_label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        id_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        id_label.text = "아이디"
        scroll_view.addSubview(id_label)
        
        id_label.topAnchor.constraint(equalTo: self.id_text_field.topAnchor,constant: -10).isActive = true
        id_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        id_label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        id_label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    func idTextCheckBtn()
    {
        id_text_check_btn.translatesAutoresizingMaskIntoConstraints = false
        id_text_check_btn.setTitle("중복체크", for: .normal)
        id_text_check_btn.setTitleColor(mainColor._3378fd, for: .normal)
        id_text_check_btn.setTitleColor(.systemGray4, for: .disabled)
        id_text_check_btn.backgroundColor = .white
        id_text_check_btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        
        id_text_check_btn.layer.cornerRadius = 10
        
        id_text_check_btn.isEnabled = false
        id_text_check_btn.addTarget(self, action: #selector(idTextCheckButtonAction(_:)), for: .touchUpInside)
        scroll_view.addSubview(id_text_check_btn)
        
        id_text_check_btn.topAnchor.constraint(equalTo: self.id_text_field.topAnchor, constant: 15).isActive = true
        id_text_check_btn.bottomAnchor.constraint(equalTo: self.id_text_field.bottomAnchor, constant: -15).isActive = true
        id_text_check_btn.trailingAnchor.constraint(equalTo: self.id_text_field.trailingAnchor ,constant:  -8).isActive = true
        id_text_check_btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    func password1TextField()
    {
        password1_text_field.translatesAutoresizingMaskIntoConstraints = false
        password1_text_field.textAlignment = .left
        password1_text_field.textColor = .black
        password1_text_field.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        password1_text_field.setLeftPaddingPoints(10)
        password1_text_field.setRightPaddingPoints(10)
        password1_text_field.layer.borderWidth = 1.5
        password1_text_field.layer.cornerRadius = 10
        password1_text_field.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        password1_text_field.placeholder = "영문, 숫자, 특수문자를 포함한 8~16자리"
        password1_text_field.isSecureTextEntry = true
        password1_text_field.text = ""
        password1_text_field.delegate = self
        textFieldDoneBtnMake(text_field: password1_text_field)
        password1_text_field.addTarget(self, action: #selector(password1Value), for: .editingChanged)
        scroll_view.addSubview(password1_text_field)
    
        
        password1_text_field.topAnchor.constraint(equalTo: self.id_text_field.bottomAnchor, constant: 31).isActive = true
        password1_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        password1_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        password1_text_field.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func password1Label()
    {
        /*
        let str = "비밀번호*"
        let str_1 = "*"
        let total_word = (str as NSString).range(of: str_1)
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.red], range: total_word)
        */
        
    
        password1_label.translatesAutoresizingMaskIntoConstraints = false
        password1_label.textAlignment = .center
        password1_label.backgroundColor = .white
        password1_label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        password1_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        password1_label.text = "비밀번호 입력"
        scroll_view.addSubview(password1_label)
        
        password1_label.topAnchor.constraint(equalTo: self.password1_text_field.topAnchor, constant : -10).isActive = true
        password1_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        password1_label.widthAnchor.constraint(equalToConstant: 85).isActive = true
        password1_label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    
    func password2TextField()
    {
        password2_text_field.translatesAutoresizingMaskIntoConstraints = false
        password2_text_field.textAlignment = .left
        password2_text_field.textColor = .black
        password2_text_field.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        password2_text_field.setLeftPaddingPoints(10)
        password2_text_field.setRightPaddingPoints(10)
        password2_text_field.layer.borderWidth = 1.5
        password2_text_field.layer.cornerRadius = 10
        password2_text_field.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        password2_text_field.placeholder = "영문, 숫자, 특수문자를 포함한 8~16자리"
        password2_text_field.isSecureTextEntry = true
        password2_text_field.text = ""
        password2_text_field.delegate = self
        textFieldDoneBtnMake(text_field: password2_text_field)
        password2_text_field.addTarget(self, action: #selector(password2TextFieldAction), for: .editingChanged)
        scroll_view.addSubview(password2_text_field)
        
        password2_text_field.topAnchor.constraint(equalTo: self.password1_text_field.bottomAnchor, constant: 31).isActive = true
        password2_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        password2_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        password2_text_field.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func password2Label()
    {
        /*
        let str = "비밀번호 확인*"
        let str_1 = "*"
        let total_word = (str as NSString).range(of: str_1)
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.red], range: total_word)
        */
        password2_label.translatesAutoresizingMaskIntoConstraints = false
        password2_label.textAlignment = .center
        password2_label.backgroundColor = .white
        password2_label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        password2_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        password2_label.text = "비밀번호 재확인"
        scroll_view.addSubview(password2_label)
        
        
        
        password2_label.topAnchor.constraint(equalTo: self.password2_text_field.topAnchor, constant : -10).isActive = true
        password2_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        password2_label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        password2_label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    
    func nameTextField()
    {
        name_text_field.translatesAutoresizingMaskIntoConstraints = false
        name_text_field.textAlignment = .left
        name_text_field.textColor = .black
        name_text_field.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        name_text_field.setLeftPaddingPoints(10)
        name_text_field.setRightPaddingPoints(10)
        name_text_field.layer.borderWidth = 1.5
        name_text_field.layer.cornerRadius = 10
        name_text_field.smartInsertDeleteType = .no
        name_text_field.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        name_text_field.placeholder = "이름을 입력하세요."
        //id_text_field.isSecureTextEntry = true
        //name_text_field.text = ""
        name_text_field.delegate = self
        textFieldDoneBtnMake(text_field: name_text_field)
        
        name_text_field.addTarget(self, action: #selector(nameTextFieldAction), for: .editingChanged)
        scroll_view.addSubview(name_text_field)
        
        name_text_field.topAnchor.constraint(equalTo: self.password2_text_field.bottomAnchor, constant: 31).isActive = true
        name_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        name_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        name_text_field.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func nameLabel()
    {
        /*
        let str = "이름*"
        let str_1 = "*"
        let total_word = (str as NSString).range(of: str_1)
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.red], range: total_word)
        */
        name_label.translatesAutoresizingMaskIntoConstraints = false
        name_label.textAlignment = .center
        name_label.backgroundColor = .white
        name_label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        name_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        name_label.text = "이름"
        scroll_view.addSubview(name_label)
        
        name_label.topAnchor.constraint(equalTo: self.name_text_field.topAnchor, constant : -10).isActive = true
        name_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        name_label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        name_label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    func setLabel(label : UILabel, textField: UITextField, text : String, width : CGFloat){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.text = text
        scroll_view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: textField.topAnchor, constant : -10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    func cellphoneTextField(textField : UITextField, textField1 : UITextField, text : String){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.textColor = .black
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        textField.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        textField.placeholder = text
        //id_text_field.isSecureTextEntry = true
        //textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.addTarget(self, action: #selector(cellphoneTextFieldAction), for: .editingChanged)
        scroll_view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func verfiyTextField(textField : UITextField, textField1 : UITextField, text : String){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.textColor = .black
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        textField.placeholder = text
        //id_text_field.isSecureTextEntry = true
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.addTarget(self, action: #selector(verfiyCodeCheckAction), for: .editingChanged)
        scroll_view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func verfiyCheckBtn()
    {
        verfiy_check_btn.translatesAutoresizingMaskIntoConstraints = false
        verfiy_check_btn.setTitle("인증확인", for: .normal)
        verfiy_check_btn.setTitleColor(mainColor._3378fd, for: .normal)
        verfiy_check_btn.setTitleColor(.systemGray4, for: .disabled)
        
        verfiy_check_btn.titleLabel?.font = .systemFont(ofSize: 13)
        
        verfiy_check_btn.isEnabled = false
        
        verfiy_check_btn.addTarget(self, action: #selector(verfiyCheckBtnAction), for: .touchUpInside)
        scroll_view.addSubview(verfiy_check_btn)
        
        
        verfiy_check_btn.topAnchor.constraint(equalTo: self.verfiy_text_field.topAnchor, constant: 15).isActive = true
        verfiy_check_btn.bottomAnchor.constraint(equalTo: self.verfiy_text_field.bottomAnchor, constant: -15).isActive = true
        verfiy_check_btn.trailingAnchor.constraint(equalTo: self.verfiy_text_field.trailingAnchor ,constant:  -8).isActive = true
        verfiy_check_btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    func emailLabel()
    {
        /*
        let str = "이메일*"
        let str_1 = "*"
        let total_word = (str as NSString).range(of: str_1)
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.red], range: total_word)
        */
        email_label.translatesAutoresizingMaskIntoConstraints = false
        email_label.textAlignment = .center
        email_label.backgroundColor = .white
        email_label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        email_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        email_label.text = "이메일"
        scroll_view.addSubview(email_label)
        
        
        
        email_label.topAnchor.constraint(equalTo: self.email_text_field.topAnchor, constant : -10).isActive = true
        email_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        email_label.widthAnchor.constraint(equalToConstant: 42).isActive = true
        email_label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    func emailTextField()
    {
        email_text_field.translatesAutoresizingMaskIntoConstraints = false
        email_text_field.textAlignment = .left
        email_text_field.textColor = .black
        email_text_field.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        email_text_field.setLeftPaddingPoints(10)
        email_text_field.setRightPaddingPoints(10)
        email_text_field.layer.borderWidth = 1.5
        email_text_field.layer.cornerRadius = 10
        email_text_field.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        email_text_field.placeholder = "이메일을 입력하세요."
        email_text_field.autocapitalizationType = .none
        email_text_field.keyboardType = .emailAddress
        email_text_field.text = ""
        email_text_field.addTarget(self, action: #selector(emailTextFieldAction), for: .editingChanged)
        textFieldDoneBtnMake(text_field: email_text_field)
        scroll_view.addSubview(email_text_field)
        
        
        email_text_field.topAnchor.constraint(equalTo: self.cellphone_text_field.bottomAnchor, constant: 31).isActive = true
        email_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        email_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        email_text_field.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func emailTextCheckBtn()
    {
        email_text_check_btn.translatesAutoresizingMaskIntoConstraints = false
        email_text_check_btn.setTitle("중복체크", for: .normal)
        email_text_check_btn.setTitleColor(mainColor._3378fd, for: .normal)
        email_text_check_btn.setTitleColor(.systemGray4, for: .disabled)
        
        email_text_check_btn.titleLabel?.font = .systemFont(ofSize: 13)
        
        email_text_check_btn.isEnabled = false
        
        email_text_check_btn.addTarget(self, action: #selector(emailTextCheckButtonAction), for: .touchUpInside)
        scroll_view.addSubview(email_text_check_btn)
        
        
        email_text_check_btn.topAnchor.constraint(equalTo: self.email_text_field.topAnchor, constant: 15).isActive = true
        email_text_check_btn.bottomAnchor.constraint(equalTo: self.email_text_field.bottomAnchor, constant: -15).isActive = true
        email_text_check_btn.trailingAnchor.constraint(equalTo: self.email_text_field.trailingAnchor ,constant:  -8).isActive = true
        email_text_check_btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    

    
   
    
    func circleCheck1Btn()
    {
        circle_check1_btn.translatesAutoresizingMaskIntoConstraints = false
        circle_check1_btn.setImage(#imageLiteral(resourceName: "gray_rectangle"), for: .normal)
        circle_check1_btn.imageView?.contentMode = .scaleAspectFit
        //circle_check1_btn.contentEdgeInsets = .init(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
        circle_check1_btn.addTarget(self, action: #selector(check1Btn), for: .touchUpInside)
        view.addSubview(circle_check1_btn)
        
        circle_check1_btn.topAnchor.constraint(equalTo: self.verfiy_text_field.bottomAnchor, constant: 15).isActive = true
        circle_check1_btn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : self.view.frame.width * 0.03).isActive = true
        circle_check1_btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        circle_check1_btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func check1Label()
    {
        check1_label.translatesAutoresizingMaskIntoConstraints = false
        check1_label.textAlignment = .left
        check1_label.textColor = .black
        
        check1_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        check1_label.text = "전체 동의하기"
        view.addSubview(check1_label)
        
        check1_label.centerYAnchor.constraint(equalTo: self.circle_check1_btn.centerYAnchor).isActive = true
        check1_label.leadingAnchor.constraint(equalTo: self.circle_check1_btn.trailingAnchor, constant : self.view.frame.width * 0.02).isActive = true
        check1_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        check1_label.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.03).isActive = true
    }
    func circleCheck2Btn()
    {
        circle_check2_btn.translatesAutoresizingMaskIntoConstraints = false
        circle_check2_btn.setImage(#imageLiteral(resourceName: "gray_rectangle"), for: .normal)
        circle_check2_btn.imageView?.contentMode = .scaleAspectFit
        //circle_check1_btn.contentEdgeInsets = .init(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
        circle_check2_btn.addTarget(self, action: #selector(check2Btn), for: .touchUpInside)
        view.addSubview(circle_check2_btn)
        
        circle_check2_btn.topAnchor.constraint(equalTo: self.circle_check1_btn.bottomAnchor, constant: 0).isActive = true
        circle_check2_btn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : self.view.frame.width * 0.03).isActive = true
        circle_check2_btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        circle_check2_btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func check2Label()
    {
        check2_label.translatesAutoresizingMaskIntoConstraints = false
        check2_label.textAlignment = .left
        check2_label.textColor = .black
        check2_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        check2_label.text = "(주) 온체육 개인정보 수집 및 이용동의 (필수)"
        view.addSubview(check2_label)
        
        check2_label.centerYAnchor.constraint(equalTo: self.circle_check2_btn.centerYAnchor, constant: 0).isActive = true
        check2_label.leadingAnchor.constraint(equalTo: self.circle_check2_btn.trailingAnchor, constant : self.view.frame.width * 0.02).isActive = true
        
        check2_label.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.03).isActive = true
    }
    func circleCheck3Btn()
    {
        circle_check3_btn.translatesAutoresizingMaskIntoConstraints = false
        circle_check3_btn.setImage(#imageLiteral(resourceName: "gray_rectangle"), for: .normal)
        circle_check3_btn.imageView?.contentMode = .scaleAspectFit
        circle_check3_btn.addTarget(self, action: #selector(check3Btn), for: .touchUpInside)
        //circle_check1_btn.contentEdgeInsets = .init(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
        view.addSubview(circle_check3_btn)
        
        circle_check3_btn.topAnchor.constraint(equalTo: self.circle_check2_btn.bottomAnchor, constant: 0).isActive = true
        circle_check3_btn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : self.view.frame.width * 0.03).isActive = true
        circle_check3_btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        circle_check3_btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func privacyBtn()//개인정보 처리
    {
        privacy_btn.translatesAutoresizingMaskIntoConstraints = false
        privacy_btn.setTitle("(자세히)", for: .normal)
        privacy_btn.setTitleColor(.systemGray2, for: .normal)
        privacy_btn.titleLabel?.font = .systemFont(ofSize: 10)
        privacy_btn.addTarget(self, action: #selector(privacyButtonAction(_:)), for: .touchUpInside)
        view.addSubview(privacy_btn)
        
        privacy_btn.topAnchor.constraint(equalTo: check2_label.topAnchor).isActive = true
        privacy_btn.leadingAnchor.constraint(equalTo: self.check2_label.trailingAnchor, constant: 10).isActive = true
        privacy_btn.bottomAnchor.constraint(equalTo: check2_label.bottomAnchor).isActive = true
    }
    
    func check3Label()
    {
        check3_label.translatesAutoresizingMaskIntoConstraints = false
        check3_label.textAlignment = .left
        check3_label.textColor = .black
        check3_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        check3_label.text = "온체육 이용약관(필수)"
        view.addSubview(check3_label)
        
        check3_label.centerYAnchor.constraint(equalTo: self.circle_check3_btn.centerYAnchor, constant: 0).isActive = true
        check3_label.leadingAnchor.constraint(equalTo: self.circle_check3_btn.trailingAnchor, constant : self.view.frame.width * 0.02).isActive = true
        
        check3_label.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.03).isActive = true
    }
    func circleCheck4Btn(){
        circle_check4_btn.translatesAutoresizingMaskIntoConstraints = false
        circle_check4_btn.setImage(#imageLiteral(resourceName: "gray_rectangle"), for: .normal)
        circle_check4_btn.imageView?.contentMode = .scaleAspectFit
        circle_check4_btn.addTarget(self, action: #selector(check4Btn), for: .touchUpInside)
        
        view.addSubview(circle_check4_btn)
        
        circle_check4_btn.topAnchor.constraint(equalTo: self.circle_check3_btn.bottomAnchor, constant: 0).isActive = true
        circle_check4_btn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : self.view.frame.width * 0.03).isActive = true
        circle_check4_btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        circle_check4_btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func termBtn()//이용약관
    {
        term_btn.translatesAutoresizingMaskIntoConstraints = false
        term_btn.setTitle("(자세히)", for: .normal)
        term_btn.setTitleColor(.systemGray2, for: .normal)
        term_btn.titleLabel?.font = .systemFont(ofSize: 10)
        term_btn.addTarget(self, action: #selector(termButtonAction(_:)), for: .touchUpInside)
        view.addSubview(term_btn)
        
        term_btn.centerYAnchor.constraint(equalTo: circle_check3_btn.centerYAnchor).isActive = true
        term_btn.leadingAnchor.constraint(equalTo: self.check3_label.trailingAnchor, constant: 10).isActive = true
        term_btn.bottomAnchor.constraint(equalTo: check3_label.bottomAnchor).isActive = true
    }
    func check4Label()
    {
        check4_label.translatesAutoresizingMaskIntoConstraints = false
        check4_label.textAlignment = .left
        check4_label.textColor = .black
        check4_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        check4_label.text = "푸쉬 알람 동의(선택)"
        view.addSubview(check4_label)
        
        check4_label.centerYAnchor.constraint(equalTo: self.circle_check4_btn.centerYAnchor, constant: 0).isActive = true
        check4_label.leadingAnchor.constraint(equalTo: self.circle_check4_btn.trailingAnchor, constant : self.view.frame.width * 0.02).isActive = true
        check4_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        check4_label.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.03).isActive = true
    }
    

   
    
    func joinBtn(){
        join_btn.translatesAutoresizingMaskIntoConstraints = false
        join_btn.backgroundColor = mainColor.hexStringToUIColor(hex: "#9f9f9f")
        join_btn.setTitleColor(.white, for: .normal)
        join_btn.setTitle("다음", for: .normal)
        join_btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        
        join_btn.addTarget(self, action: #selector(joinButtonAction), for: .touchUpInside)
        
        view.addSubview(join_btn)
        
        join_btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        join_btn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : 0).isActive = true
        join_btn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant : 0).isActive = true
        join_btn.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
    }
}
