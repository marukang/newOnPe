//
//  faqPostViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/27.
//

import UIKit

class faqPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        
    }
    
    let titleTextField = UITextField()
    let grayLine = UIView()
    let categoryLabel = UILabel()
    let grayLine1 = UIView()
    
    let contentTextview = UITextView()
    
    var faqcontent : Faq?{
        didSet{
            setupContent()
        }
        
    }
    
    public func setupContent(){
        titleTextField.text = faqcontent?.faq_title
        categoryLabel.text = faqcontent?.faq_type
        contentTextview.text = faqcontent?.faq_content
    }
}


extension faqPostViewController {
    func setupLayout(){
        _titleTextField(textField: titleTextField)
        _categoryLabel(label : categoryLabel)
        
        _grayLine1(uiview: grayLine1)
        _contentTextview(textview : contentTextview)
        
    }
    
    func _titleTextField(textField : UITextField){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        //textField.text = "제목은 뭐로 적어야하나요?"
        textField.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.isEnabled = false
        //textField.delegate = self
        
        textField.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo:  view.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo:  view.trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    func _categoryLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.textAlignment = .left
        //label.text = "회원정보 관련"
        
        label.topAnchor.constraint(equalTo: titleTextField.bottomAnchor,constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
    }
    
    func _grayLine1(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    func _contentTextview(textview : UITextView){
        view.addSubview(textview)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.font = UIFont.NotoSansCJKkr(type: .normal, size: 18)
        textview.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        textview.isEditable = false
        /*
        textview.text =
            """
            구루미에 네이버 계정으로 로그인시 네이버 이메일을 정상적으로 불러오지 못하거나 (닉네임이 no-name으로 표시)

            네이버로 로그인했으나 다른 이메일 계정으로 로그인이 되는분들이 있습니다.

            해당 사용자분들은 네이버에 기본 이메일을 다른 이메일로 설정을 해두어 다른 정보를 가져오게 되어 발생하는 문제이며

            네이버측에 오류 사항을 접수는 진행했으나 개선되지 않아 구루미에서 한번 더 이메일을 재인증 해주시면 정상적으로 로그인이 됩니다.
            """
        */
        textview.textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        textview.topAnchor.constraint(equalTo: grayLine1.bottomAnchor).isActive = true
        textview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    
    
   
}

