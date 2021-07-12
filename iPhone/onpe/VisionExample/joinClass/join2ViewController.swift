//
//  join2ViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/20.
//

import UIKit

class join2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = "기초 정보 입력"
        setupLayout()
        AF.delegate5 = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.window?.endEditing(true)
         
    }
    
    let introducesSelfLabel = UILabel()//자기소개
    let introducesSelfTextField = UITextView()//자기소개 칸
    var introducesBool = false
    
    let heightLabel = UILabel()
    let heightTextField = UITextField()
    
    var heightBool = false
    
    let weightLabel = UILabel()
    let weightTextField = UITextField()
    
    var weightBool  = false
    
    let ageLabel = UILabel()
    let ageTextField = UITextField()
    
    var ageBool = false
    
    let genderLabel = UILabel()
    let maleBtn = UIButton()
    let femaleBtn = UIButton()
    
    var maleSelected : Bool = true
    var femaleSelected : Bool = false
    var setSex : String = ""
    
    let nextBtn = UIButton()//회원가입 완료
    
    var nextBool = false
    
    let AF = ServerConnectionLegacy()
}
extension join2ViewController : appMemberDefaultInformationChangeDelegate {
    func appMemberDefaultInformationChange(result: Int) {
        if result == 0 {
            userInformationClass.student_content = introducesSelfTextField.text
            userInformationClass.student_sex = setSex
            self.dismiss(animated: true, completion: nil)
            extensionClass.showToast(view: view, message: "저장 완료.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else if result == 1 {
            extensionClass.showToast(view: view, message: "올바른 접근이 아닙니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
}
//MARK: - 일반함수
extension join2ViewController {
    func checkAllRequireComplete(){
        if introducesBool, heightBool, weightBool, ageBool{
            nextBool = true
            nextBtn.backgroundColor = mainColor._3378fd
        } else {
            nextBool = false
            nextBtn.backgroundColor = mainColor._9f9f9f
        }
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
//MARK: - @objc 함수
extension join2ViewController {
    @objc
    func introducesTextFieldAction(){
        if let count = introducesSelfTextField.text?.count {
            if count > 5 {
                introducesSelfTextField.layer.borderColor = mainColor._3378fd.cgColor
                introducesSelfLabel.textColor = mainColor._3378fd
                introducesBool = true
            } else {
                introducesSelfTextField.layer.borderColor = UIColor.red.cgColor
                introducesSelfLabel.textColor = .red
                introducesBool = true
            }
            checkAllRequireComplete()
        }
        
    }
    @objc
    func heightTextFieldAction(){
        if let count = heightTextField.text?.count {
            if count > 2 {
                heightTextField.layer.borderColor = mainColor._3378fd.cgColor
                heightLabel.textColor = mainColor._3378fd
                heightBool = true
            } else {
                heightTextField.layer.borderColor = UIColor.red.cgColor
                heightLabel.textColor = .red
                heightBool = false
            }
            checkAllRequireComplete()
        }
    }
    
    @objc
    func weightTextFieldAction(){
        if let count = weightTextField.text?.count {
            if count > 1 {
                weightTextField.layer.borderColor = mainColor._3378fd.cgColor
                weightLabel.textColor = mainColor._3378fd
                weightBool = true
            } else {
                weightTextField.layer.borderColor = UIColor.red.cgColor
                weightLabel.textColor = .red
                weightBool = false
            }
            checkAllRequireComplete()
        }
    }
    
    @objc
    func ageTextFieldAction(){
        if let count = ageTextField.text?.count {
            if count > 0 {
                ageTextField.layer.borderColor = mainColor._3378fd.cgColor
                ageLabel.textColor = mainColor._3378fd
                ageBool = true
            } else {
                ageTextField.layer.borderColor = UIColor.red.cgColor
                ageLabel.textColor = .red
                ageBool = false
            }
            checkAllRequireComplete()
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
        checkAllRequireComplete()
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
        checkAllRequireComplete()
        
    }
    
    @objc
    func nextButtonAction(){
        if nextBool {
            
            if maleSelected{
                setSex = "m"
            } else {
                setSex = "f"
            }
            userInformationClass.student_sex = setSex
            userInformationClass.student_age = ageTextField.text ?? ""
            userInformationClass.student_tall = heightTextField.text ?? ""
            userInformationClass.student_weight = weightTextField.text ?? ""
            AF.appMemberDefualtInformationChange(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_content: introducesSelfTextField.text ?? "", student_tall: heightTextField.text ?? "", student_weight: weightTextField.text ?? "", student_age: ageTextField.text ?? "", student_sex: setSex, url: "app/member/default_information_change")
            
            
        } else {
            extensionClass.showToast(view: self.view, message: "필수 사항을 입력해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
}
//MARK: - UITextFieldDelegate
extension join2ViewController : UITextFieldDelegate, UITextViewDelegate{
    
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
        if textView.textColor == mainColor.hexStringToUIColor(hex: "#d3d3d3") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "60자 이내로 입력해주세요. (최소 6글자 이상)"
            textView.textColor = mainColor.hexStringToUIColor(hex: "#d3d3d3")
        }
    }


    
    func textViewDidChange(_ textView: UITextView) {
        if textView == introducesSelfTextField {
            if let count = introducesSelfTextField.text?.count {
                if count > 5 {
                    introducesSelfTextField.layer.borderColor = mainColor._3378fd.cgColor
                    introducesSelfLabel.textColor = mainColor._3378fd
                    introducesBool = true
                } else {
                    introducesSelfTextField.layer.borderColor = UIColor.red.cgColor
                    introducesSelfLabel.textColor = .red
                    introducesBool = true
                }
                checkAllRequireComplete()
            }
        }
    }
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField ==  heightTextField || textField == weightTextField {
            
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
        } else {
            return true
        }
        
    }
}
//MARK: - 레이아웃 함수
extension join2ViewController{
    func setupLayout(){
        
        _introducesSelfTextField(textField: introducesSelfTextField, text: "60자 이내로 입력해주세요.(최소 6글자 이상)")//자기소개 칸
        setLabel(label: introducesSelfLabel, textField: heightTextField, text: "자기소개", width: 52)//자기소개
        
        _heightTextField(textField: heightTextField, textField1: heightTextField, text: "키를 입력해주세요.")
        setLabel(label: heightLabel, textField: heightTextField, text: "키", width: 15)
        
        
        _weightTextField(textField: weightTextField, textField1: heightTextField, text: "몸무게를 입력해주세요.")
        setLabel(label: weightLabel, textField: weightTextField, text: "몸무게", width: 40)
        
        
        _ageTextField(textField: ageTextField, textField1: weightTextField, text: "만 나이로 입력해주세요.")
        setLabel(label: ageLabel, textField: ageTextField, text: "나이", width: 26)
        
        _maleBtn(button: maleBtn, textField1: ageTextField, text: "남자")
        _femaleBtn(button: femaleBtn, textField1: ageTextField, text: "여자")
        setLabel1(label: genderLabel, button: maleBtn, text: "성별", width: 28)
        
        _nextBtn(button: nextBtn)
        
    }
    
    
    //textField에서 textView로 변경 함수명은 편의상 바꾸지 않음
    func _introducesSelfTextField(textField : UITextView, text : String){
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        //textField.setPadding(padding: .init(x: 10, y: 0, width: 0, height: 10))
        textField.textAlignment = .left
        textField.textColor = mainColor.hexStringToUIColor(hex: "#d3d3d3")
        textField.text = "60자 이내로 입력해주세요. (최소 6글자 이상)"
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        textField.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        
        //id_text_field.isSecureTextEntry = true
        
        textField.delegate = self
        textViewDoneBtnMake(textview: textField)
        
        //textField.addTarget(self, action: #selector(introducesTextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    func setLabel(label : UILabel, textField: UITextField, text : String, width : CGFloat){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.text = text
        view.addSubview(label)
        if text == "자기소개" {
            label.topAnchor.constraint(equalTo: introducesSelfTextField.topAnchor, constant : -10).isActive = true
        } else {
            label.topAnchor.constraint(equalTo: textField.topAnchor, constant : -10).isActive = true
        }
        
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.1).isActive = true
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    func _heightTextField(textField : UITextField, textField1 : UITextField, text : String){
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
        
        textField.addTarget(self, action: #selector(heightTextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        if text == "키를 입력해주세요."{
            textField.topAnchor.constraint(equalTo: introducesSelfTextField.bottomAnchor, constant: 31).isActive = true
        } else {
            textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
        }
        
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _weightTextField(textField : UITextField, textField1 : UITextField, text : String){
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
        
        textField.addTarget(self, action: #selector(weightTextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _ageTextField(textField : UITextField, textField1 : UITextField, text : String){
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
        
        textField.addTarget(self, action: #selector(ageTextFieldAction), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _maleBtn(button : UIButton, textField1 : UITextField, text : String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 10
        button.layer.borderColor = mainColor._3378fd.cgColor
        
        button.addTarget(self, action: #selector(maleButtonAction), for: .touchUpInside)
        view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
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
        button.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        
        button.addTarget(self, action: #selector(femaleButtonAction), for: .touchUpInside)
        view.addSubview(button)
        
        button.topAnchor.constraint(equalTo: textField1.bottomAnchor, constant: 31).isActive = true
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
    
    func _nextBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#9f9f9f")
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
        
    }
}
