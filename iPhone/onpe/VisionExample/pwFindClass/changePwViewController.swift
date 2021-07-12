//
//  changePwViewController
//  FitMeProject
//
//  Created by Ik ju Song on 2020/03/18.
//  Copyright © 2020 Ik ju Song. All rights reserved.
//

import UIKit


/**
 현재 페이이지 :  비밀번호 변경
 다음 페이지 : idFindResultViewController
 */
class changePwViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //블랙모드 방지
        
        /*
        - 무슨 기기인지 알아보는 코드
         */
        let deviceType = UIDevice().type
        let _ = deviceType.rawValue
        
        self.title = "비밀번호 변경"
        setupLayout()
        AF.delegate4 = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.window?.endEditing(true)
         
    }
    var getEmail : String?
    var getVerfiyCode : String?
    let topLabel = UILabel()//가입 당시 입력한 이름/이메일을 입력해주세요.
    let gray_line = UIView()
    let pw_label1 = UILabel()//변경 비밀번호
    let pw_text_field1 = UITextField()
    var pwBool1 = false
    
    let pw_label2 = UILabel()//변경 비밀번호 확인
    let pw_text_field2 = UITextField()
    var pwBool2 = false
    
    var changePwBool = false
    let change_pw_btn = UIButton()
    
    let AF = ServerConnectionLegacy()

}
extension changePwViewController : appPwFindResultDelegate {
    func appPwFindResult(result: Int) {
        if result == 0 {
            
            let vc = pwResultViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        } else if result == 1 {
            extensionClass.showToast(view: view, message: "잘못된 접근 방법입니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
}
extension changePwViewController  : UITextFieldDelegate{
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pw_text_field1
        {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 16
        } else if textField == pw_text_field2 {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 16
        } else {
            return true
        }
        
    }
}
extension changePwViewController
{
    //MARK: - 일반 함수
    func checkAllRequireComplete(){
        if pwBool1, pwBool2  {
            changePwBool = true
            
            change_pw_btn.backgroundColor = mainColor._3378fd
        } else {
            changePwBool = false
            change_pw_btn.backgroundColor = mainColor._9f9f9f
            
        }
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
    
    func textFieldDoneBtnMake(text_field : UITextField)
    {//텍스트 입력할시 키보드 위에 done 기능 구현
        let ViewForDoneButtonOnKeyboard = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        ViewForDoneButtonOnKeyboard.translatesAutoresizingMaskIntoConstraints = false
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    
    //MARK: - objc 함수
    
    @objc
    func doneBtnFromKeyboardClicked(sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
       
      self.view.endEditing(true)
    }
    @objc
    func changePwButtonAction(_ sender : UIButton)
    {
        
        if changePwBool {
            if pw_text_field1.text == pw_text_field2.text{
                AF.appFindChangePw(student_email: getEmail ?? "", student_password: pw_text_field2.text ?? "", authentication_code: getVerfiyCode ?? "", url: "app/find_change_pw")
                    
            } else {
                extensionClass.showToast(view: view, message: "비밀번호를 다시 확인해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                pw_label1.textColor = .red
                pw_text_field1.layer.borderColor = UIColor.red.cgColor
                
                pw_label2.textColor = .red
                pw_text_field2.layer.borderColor = UIColor.red.cgColor
            }
        } else {
            extensionClass.showToast(view: view, message: "필수 사항을 입력해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
        
        
        
    }
    @objc
    func pw1TextFieldAction(){
        if isValidPassword(password: pw_text_field1.text ?? ""){
            if let count = pw_text_field1.text?.count{
                if count > 5{
                    pwBool1 = true
                    pw_text_field1.layer.borderColor = mainColor._3378fd.cgColor
                    pw_label1.textColor = mainColor._3378fd
                } else {
                    pwBool1 = false
                    pw_text_field1.layer.borderColor = UIColor.red.cgColor
                    pw_label1.textColor = .red
                }
                
            }
        } else {
            pwBool1 = false
            pw_text_field1.layer.borderColor = UIColor.red.cgColor
            pw_label1.textColor = .red
        }
        checkAllRequireComplete()
        
        
    }
    @objc
    func pw2TextFieldAction(){
        if isValidPassword(password: pw_text_field2.text ?? ""){
            if let count = pw_text_field2.text?.count{
                if count > 5 {
                    pwBool2 = true
                    pw_text_field2.layer.borderColor = mainColor._3378fd.cgColor
                    pw_label2.textColor = mainColor._3378fd
                } else {
                    pwBool2 = false
                    pw_text_field2.layer.borderColor = UIColor.red.cgColor
                    pw_label2.textColor = .red
                }
            }
        } else {
            pwBool2 = false
            pw_text_field2.layer.borderColor = UIColor.red.cgColor
            pw_label2.textColor = .red
        }
        
        checkAllRequireComplete()
    }
    
   
}

extension changePwViewController
{
    func setupLayout()
    {
        _topLabel()
        grayLine()
        
        pw1TextField(textField: pw_text_field1, text: "영어, 숫자, 특수문자를 포함한 8~16자리.")
        setLabel(label: pw_label1, textField: pw_text_field1, text: "변경 비밀번호", width: 80)
        
        pw2TextField(textField: pw_text_field2, textField1: pw_text_field1, text: "영어, 숫자, 특수문자를 포함한 8~16자리.")
        setLabel(label: pw_label2, textField: pw_text_field2, text: "변경 비밀번호 확인", width: 110)
        
        
        
        _confirmBtn(button: change_pw_btn)
        
    }
    
    func _topLabel(){
        view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.text = "새롭게 사용할 비밀번호를 입력해주세요."
        topLabel.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        topLabel.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        
        topLabel.textAlignment = .left
        
        topLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 14).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func grayLine ()
    {
        gray_line.translatesAutoresizingMaskIntoConstraints = false
        gray_line.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        self.view.addSubview(gray_line)
        
        gray_line.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 14).isActive = true
        gray_line.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        gray_line.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gray_line.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    
    
    func pw1TextField(textField : UITextField, text : String)
    {
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
        textField.isSecureTextEntry = true
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.addTarget(self, action: #selector(pw1TextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: gray_line.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setLabel(label : UILabel, textField : UITextField,text : String, width : CGFloat)
    {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.text = text
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: textField.topAnchor, constant : -10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    func pw2TextField (textField : UITextField, textField1 : UITextField, text : String)
    {
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
        textField.isSecureTextEntry = true
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.addTarget(self, action: #selector(pw2TextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    
    
    func _confirmBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#9f9f9f")
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(changePwButtonAction(_:)), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
        
    }
    
    
}
