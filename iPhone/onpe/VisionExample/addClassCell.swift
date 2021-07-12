//
//  addClassCell.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/03.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
protocol addClassCellDelegate {
    func btnAction(classCode : String)
    
}
class addClassCell: UICollectionViewCell, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label = UILabel()//입력할 내용은 클래스 코드입니다.
    let textField = UITextField()//수업 코드를 입력하세요.
    let btn = UIButton()//확인 버튼
    var delegate : addClassCellDelegate?
    var parentView : UIView?
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
        //delegate?.textFieldDone()
        self.endEditing(true)
        
    }
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField ==  self.textField  {
            
            guard let textFieldText = self.textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 15
        } else {
            return true
        }
        
    }
    
    
    @objc
    func btnAction(){
        if let classCode = textField.text {
            textField.text = nil
            delegate?.btnAction(classCode: classCode)
        }
    }
    
    func setupLayout(){
        _label(label : label)
        _textField(textField : textField)
        _btn(button : btn)
    }
    
    func _label(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "수업코드를 입력해주세요."
        label.textAlignment = .center
        label.font = UIFont.NotoSansCJKkr(type: .light, size: 16)
        label.textColor = mainColor._404040
        
        label.topAnchor.constraint(equalTo: topAnchor,constant: 40).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _textField(textField : UITextField){
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "f6f6f6")
        textField.textColor = .black
        textField.font = UIFont.NotoSansCJKkr(type: .light, size: 16)
        textField.placeholder = "수업 코드를 입력하세요."
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.delegate = self
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.clipsToBounds = true
        textFieldDoneBtnMake(text_field: textField)
        
        textField.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 20).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func _btn(button : UIButton){
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.backgroundColor = mainColor._3378fd
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 25).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
