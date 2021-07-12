//
//  teacherMessagePostViewController.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/15.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class teacherMessagePostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    

    
    let grayLine0 = UIView()
    let userLabel = UILabel()
    let grayLine1 = UIView()
    
    let contentTextView = UITextView()
    var getPushList : pushList?{
        didSet{
            if let getPushList = getPushList{
                
                userLabel.text = "선생님 : \(getPushList.name ?? "") ・ 작성일 \(extensionClass.DateToString(date: getPushList.message_date!, type: 0))"
                contentTextView.text = getPushList.message_content
                
            }
        }
    }

}
//MARK: -일반 함수
extension teacherMessagePostViewController {
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
    @objc
    func doneBtnFromKeyboardClicked(sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
      self.view.endEditing(true)
    }
}
extension teacherMessagePostViewController {
    func setupLayout(){
        
        _grayLine0(uiview: grayLine0)
        _userLabel(label : userLabel)
        
        _grayLine1(uiview: grayLine1)
        _contentTextView(textView: contentTextView)
    }
    
    func _grayLine0(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        uiview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
   
    func _userLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.textAlignment = .left
        //label.text = "작성자 : 홍길동 ・ 작성일 2021-01-13"
        
        label.topAnchor.constraint(equalTo:grayLine0.bottomAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
    }
    
    func _grayLine1(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _contentTextView(textView : UITextView){
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font =  UIFont.NotoSansCJKkr(type: .normal, size: 14)
        textView.textColor = mainColor._404040
        textView.textAlignment = .left
        textViewDoneBtnMake(textview: textView)
        textView.isEditable = false
        textView.isScrollEnabled = false
        
        
        textView.topAnchor.constraint(equalTo: grayLine1.bottomAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(equalToConstant:  view.frame.height / 2).isActive = true
    }
}

