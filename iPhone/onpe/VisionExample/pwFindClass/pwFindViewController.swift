//
//  pwFindViewController.swift
//  FitMeProject
//
//  Created by Ik ju Song on 2020/03/18.
//  Copyright © 2020 Ik ju Song. All rights reserved.
//

import UIKit


/**
 현재 페이이지 :  아이디 찾기 페이지
 다음 페이지 : idFindResultViewController
 */
class pwFindViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //블랙모드 방지
        
        /*
        - 무슨 기기인지 알아보는 코드
         */
        let deviceType = UIDevice().type
        let _ = deviceType.rawValue
        
        self.title = "비밀번호 찾기"
        setupLayout()
        AF.delegate3 = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.window?.endEditing(true)
         
    }
    
    let topLabel = UILabel()//가입 당시 입력한 이름/이메일을 입력해주세요.
    let gray_line = UIView()
    let name_label = UILabel()
    let name_text_field = UITextField()
    var nameBool = false
    
    let id_label = UILabel()
    let id_text_field = UITextField()
    var idBool = false
    
    let email_label = UILabel()
    let email_text_field = UITextField()
    var emailBool = false
    
    var findpwBool = false
    let find_pw_btn = UIButton()
    
    let AF = ServerConnectionLegacy()

}
extension pwFindViewController : appPwFindDelegate{
    func appPwFind(result: Int) {
        if result > 3 {
            
            let vc = verfiyPwCodeViewController()
            vc.getEmail = email_text_field.text ?? ""
            vc.getVerfiyCode = String(result)
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if result == 1 {
            extensionClass.showToast(view: view, message: "잘못된 접근 방법입니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else if result == 2 {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
}
extension pwFindViewController : UITextFieldDelegate{
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == name_text_field
        {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 5
        } else if textField == id_text_field {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 13
        } else if textField == email_text_field {
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 30
        } else {
            return true
        }
        
    }
}
extension pwFindViewController
{
    //MARK: - 일반 함수
    func checkAllRequireComplete(){
        if nameBool, emailBool, idBool {
            findpwBool = true
            
            find_pw_btn.backgroundColor = mainColor._3378fd
        } else {
            findpwBool = false
            find_pw_btn.backgroundColor = mainColor._9f9f9f
            
        }
    }
    //이메일 체크 함수
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
    func findPwButtonAction(_ sender : UIButton)
    {
        
        
        if findpwBool {
            AF.appFindPw(student_id: id_text_field.text ?? "", student_name: name_text_field.text ?? "", student_email: email_text_field.text ?? "", url: "app/find_pw")
        } else {
            extensionClass.showToast(view: view, message: "필수 사항을 입력해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
    }
    @objc
    func nameTextFieldAction(){
        if let count = name_text_field.text?.count{
            if count > 1{
                nameBool = true
                name_text_field.layer.borderColor = mainColor._3378fd.cgColor
                name_label.textColor = mainColor._3378fd
            } else {
                nameBool = false
                name_text_field.layer.borderColor = UIColor.red.cgColor
                name_label.textColor = .red
            }
            checkAllRequireComplete()
        }
        
    }
    @objc
    func idTextFieldAction(){
        if let count = id_text_field.text?.count{
            if count > 3 {
                idBool = true
                id_text_field.layer.borderColor = mainColor._3378fd.cgColor
                id_label.textColor = mainColor._3378fd
            } else {
                idBool = false
                id_text_field.layer.borderColor = UIColor.red.cgColor
                id_label.textColor = .red
            }
        }
        checkAllRequireComplete()
    }
    
    @objc
    func emailTextFieldAction(){
        if let text = email_text_field.text {
            if isValidEmail(email: text){
                emailBool = true
                email_text_field.layer.borderColor = mainColor._3378fd.cgColor
                email_label.textColor = mainColor._3378fd
            } else {
                emailBool = false
                email_text_field.layer.borderColor = UIColor.red.cgColor
                email_label.textColor = .red
            }
            checkAllRequireComplete()
        }
        
    }
}

extension pwFindViewController
{
    func setupLayout()
    {
        _topLabel()
        grayLine()
        
        nameTextField(textField: name_text_field, text: "이름을 입력해주세요.")
        setLabel(label: name_label, textField: name_text_field, text: "이름", width: 30)
        
        idTextField(textField: id_text_field, textField1: name_text_field, text: "아이디를 입력해주세요.")
        setLabel(label: id_label, textField: id_text_field, text: "아이디", width: 40)
        
        emailTextField(textField:email_text_field, textField1: id_text_field, text: "이메일을 입력해주세요.")
        setLabel(label: email_label, textField: email_text_field, text: "이메일 주소", width: 68)
        
        
        _confirmBtn(button: find_pw_btn)
        
    }
    
    func _topLabel(){
        view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.text = "가입 당시 입력한 이름/아이디/이메일을 입력해주세요."
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
    func nameTextField (textField : UITextField, text : String)
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
        textFieldDoneBtnMake(text_field: textField)
        //id_text_field.isSecureTextEntry = true
        textField.text = ""
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(nameTextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: gray_line.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func idTextField (textField : UITextField, textField1 : UITextField, text : String)
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
        //id_text_field.isSecureTextEntry = true
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.addTarget(self, action: #selector(idTextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func emailTextField (textField : UITextField, textField1 : UITextField, text : String)
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
        //id_text_field.isSecureTextEntry = true
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.addTarget(self, action: #selector(emailTextFieldAction), for: .editingChanged)
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
        button.addTarget(self, action: #selector(findPwButtonAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
        
    }
    
    
}
