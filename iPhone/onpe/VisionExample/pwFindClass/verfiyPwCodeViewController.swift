//
//  verfiyCodeViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/20.
//

import UIKit

class verfiyPwCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "비밀번호 찾기"
        setupLayout()
        mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.window?.endEditing(true)
        mTimer.invalidate()
    }
    
    @objc
    func timerCallback(){
        //인증번호 입력하기 까지 제한시간 콜백함수
        number += 1
        
        second = 60 - number
        if second == 0 {
            number = 0
            minute -= 1
            if minute < 0{
                mTimer.invalidate()
            }
        }
        if second < 10{
            if minute == -1 {
                countNumber.text = String("00 : 00")
                countNumber.textColor = .red
                extensionClass.showToast(view: self.view, message: "제한시간을 초과 하셨습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                countNumber.text = String("0\(minute) : 0\(second)")
            }
            
        } else {
            countNumber.text = String("0\(minute) : \(second)")
        }
        
    }


    var getEmail : String = ""
    var getVerfiyCode : String = "0"
    let topLabel = UILabel()//가입 당시 입력한 이름/이메일을 입력해주세요.
    let gray_line = UIView()
    
    let countNumber = UILabel()
    
    var mTimer : Timer = Timer()
    var number : Int = 0//default 0으로 세팅
    
    var minute : Int = 5// 5분 세팅
    var second : Int = 0//초 세팅
    let codeTextField1 = UITextField()
    let codeTextField2 = UITextField()
    let codeTextField3 = UITextField()
    let codeTextField4 = UITextField()
    let codeTextField5 = UITextField()
    let codeTextField6 = UITextField()
    
    var code1Bool = false
    var code2Bool = false
    var code3Bool = false
    var code4Bool = false
    var code5Bool = false
    var code6Bool = false
    
    var confirmBool = false
    let confirmBtn = UIButton()
    

}
//MARK: - 일반함수
extension verfiyPwCodeViewController {
    func checkAllRequireComplete(){
        if code1Bool, code2Bool, code3Bool, code4Bool, code5Bool, code6Bool {
            confirmBool = true
            confirmBtn.backgroundColor = mainColor._3378fd
        } else {
            confirmBool = false
            confirmBtn.backgroundColor = mainColor._9f9f9f
        }
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
//MARK: - @objc 함수
extension verfiyPwCodeViewController{
    @objc
    func confirmButtonAction(){
        if confirmBool {
            let checkBool = true// 서버로 검증 하고 값 지정
            if checkBool{
                
                let vc = changePwViewController()
                vc.getEmail = getEmail
                vc.getVerfiyCode = getVerfiyCode
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                codeTextField1.layer.borderColor = UIColor.red.cgColor
                codeTextField2.layer.borderColor = UIColor.red.cgColor
                codeTextField3.layer.borderColor = UIColor.red.cgColor
                codeTextField4.layer.borderColor = UIColor.red.cgColor
                codeTextField5.layer.borderColor = UIColor.red.cgColor
                codeTextField6.layer.borderColor = UIColor.red.cgColor
                extensionClass.showToast(view: self.view, message: "인증번호가 올바르지 않습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
        } else {
            extensionClass.showToast(view: self.view, message: "인증코드를 입력해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    @objc
    func codeTextField1Action(){
        let code : String = "\(getVerfiyCode[getVerfiyCode.index(getVerfiyCode.startIndex, offsetBy: 0)])"
        
        if let text = codeTextField1.text{
            if text == code {
                code1Bool = true
                codeTextField1.layer.borderColor = mainColor._3378fd.cgColor
            } else {
                code1Bool = false
                codeTextField1.layer.borderColor = UIColor.red.cgColor
            }
        }
        checkAllRequireComplete()
    }
    @objc
    func codeTextField2Action(){
        let code : String = "\(getVerfiyCode[getVerfiyCode.index(getVerfiyCode.startIndex, offsetBy: 1)])"
        if let text = codeTextField2.text{
            if text == code {
                code2Bool = true
                codeTextField2.layer.borderColor = mainColor._3378fd.cgColor
            } else {
                code2Bool = false
                codeTextField2.layer.borderColor = UIColor.red.cgColor
            }
        }
        checkAllRequireComplete()
    }
    @objc
    func codeTextField3Action(){
        let code : String = "\(getVerfiyCode[getVerfiyCode.index(getVerfiyCode.startIndex, offsetBy: 2)])"
        if let text = codeTextField3.text{
            if text == code {
                code3Bool = true
                codeTextField3.layer.borderColor = mainColor._3378fd.cgColor
            } else {
                code3Bool = false
                codeTextField3.layer.borderColor = UIColor.red.cgColor
            }
        }
        checkAllRequireComplete()
    }
    @objc
    func codeTextField4Action(){
        let code : String = "\(getVerfiyCode[getVerfiyCode.index(getVerfiyCode.startIndex, offsetBy: 3)])"
        if let text = codeTextField4.text{
            if text == code {
                code4Bool = true
                codeTextField4.layer.borderColor = mainColor._3378fd.cgColor
            } else {
                code4Bool = false
                codeTextField4.layer.borderColor = UIColor.red.cgColor
            }
        }
        checkAllRequireComplete()
    }
    @objc
    func codeTextField5Action(){
        let code : String = "\(getVerfiyCode[getVerfiyCode.index(getVerfiyCode.startIndex, offsetBy: 4)])"
        if let text = codeTextField5.text{
            if text == code {
                code5Bool = true
                codeTextField5.layer.borderColor = mainColor._3378fd.cgColor
            } else {
                code5Bool = false
                codeTextField5.layer.borderColor = UIColor.red.cgColor
            }
        }
        checkAllRequireComplete()
    }
    @objc
    func codeTextField6Action(){
        let code : String = "\(getVerfiyCode[getVerfiyCode.index(getVerfiyCode.startIndex, offsetBy: 5)])"
        if let text = codeTextField6.text{
            if text == code {
                code6Bool = true
                codeTextField6.layer.borderColor = mainColor._3378fd.cgColor
            } else {
                code6Bool = false
                codeTextField6.layer.borderColor = UIColor.red.cgColor
            }
        }
        checkAllRequireComplete()
    }
    
}
extension verfiyPwCodeViewController : UITextFieldDelegate{
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        //1자리수만 입력가능
        return count <= 1
    }
}

extension verfiyPwCodeViewController
{
    func setupLayout()
    {
        _topLabel()
        grayLine()
        _countNumber()
        
        _confirmBtn(button: confirmBtn)
        _codeTextField1(textField: codeTextField1)
        _codeTextField2(textField: codeTextField2, textField1: codeTextField1 , number: 2)
        _codeTextField2(textField: codeTextField3, textField1: codeTextField2 , number: 3)
        _codeTextField2(textField: codeTextField4, textField1: codeTextField3 , number: 4)
        _codeTextField2(textField: codeTextField5, textField1: codeTextField4 , number: 5)
        _codeTextField2(textField: codeTextField6, textField1: codeTextField5 , number: 6)
        
        
    }
    
    func _topLabel(){
        view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.text = "이메일에서 받은 인증코드를 입력해주세요."
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
    func _countNumber(){
        view.addSubview(countNumber)
        
        countNumber.translatesAutoresizingMaskIntoConstraints = false
        countNumber.text = "05 : 00"
        countNumber.font = UIFont.NotoSansCJKkr(type: .medium, size: 35)
        countNumber.textColor = .black
        countNumber.textAlignment = .center
        
        countNumber.topAnchor.constraint(equalTo: self.gray_line.bottomAnchor, constant: 52).isActive = true
        countNumber.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        countNumber.widthAnchor.constraint(equalToConstant: 120).isActive = true
        countNumber.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    func _codeTextField1(textField : UITextField){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.textColor = .black
        textField.font = UIFont.NotoSansCJKkr(type: .medium, size: extensionClass.textSize2)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.keyboardType = .numberPad
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        textField.text = ""
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.addTarget(self, action: #selector(codeTextField1Action), for: .editingChanged)
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: countNumber.bottomAnchor, constant: 40).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textField.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 80) / 6).isActive = true
        textField.heightAnchor.constraint(equalToConstant: (self.view.frame.width - 76) / 6).isActive = true
    }
    func _codeTextField2(textField : UITextField, textField1 : UITextField, number : Int){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.textColor = .black
        textField.font = UIFont.NotoSansCJKkr(type: .medium, size: extensionClass.textSize2)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        textField.keyboardType = .numberPad
        textFieldDoneBtnMake(text_field: textField)
        textField.text = ""
        textField.delegate = self
        
        switch number {
        case 2:
            textField.addTarget(self, action: #selector(codeTextField2Action), for: .editingChanged)
            break
        case 3:
            textField.addTarget(self, action: #selector(codeTextField3Action), for: .editingChanged)
            break
        case 4:
            textField.addTarget(self, action: #selector(codeTextField4Action), for: .editingChanged)
            break
        case 5:
            textField.addTarget(self, action: #selector(codeTextField5Action), for: .editingChanged)
            break
        case 6:
            textField.addTarget(self, action: #selector(codeTextField6Action), for: .editingChanged)
            break
        default:
            break
        }
        
        view.addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: countNumber.bottomAnchor, constant: 40).isActive = true
        textField.leadingAnchor.constraint(equalTo: textField1.trailingAnchor, constant: 8).isActive = true
        textField.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 80) / 6).isActive = true
        textField.heightAnchor.constraint(equalToConstant: (self.view.frame.width - 76) / 6).isActive = true
    }
    
    
    func _confirmBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ID찾기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#9f9f9f")
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
        
    }
    
    
}
