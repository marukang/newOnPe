//
//  messagePostViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/26.
//

import UIKit

class messagePostViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        AF.delegate8 = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if answerCheckLabelStr == "답변완료"{
            setHideLayout(bool: true)
        } else {
            setHideLayout(bool: false)
        }
        
        if let messageNumber = self.messageNumber{
            //print(messageNumber)
            AF.appCommunityGetStudentMessage(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, message_number: messageNumber, url: "app/community/get_student_message")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if answerCheckLabelStr == "답변완료"{
            scrollView.contentSize = .init(width: view.frame.width, height: answerTextView.frame.height + answerTextView.frame.origin.y + 20)
        } else {
            scrollView.contentSize = .init(width: view.frame.width, height: answerCheckLabel.frame.height + answerCheckLabel.frame.origin.y + 20)
        }
        
    }
    
    let AF = ServerConnectionLegacy()
    var messageNumber : Int?
    let scrollView = UIScrollView()
    
    let titleTextField = UITextField()
    
    let userLabel = UILabel()
    let grayLine1 = UIView()
    
    let contentTextView = UITextView()
    let grayLine2 = UIView()
    
    let listBtn = UIButton()
    let deleteBtn = UIButton()
    let modifyBtn = UIButton()
    let answerCheckLabel = UILabel()//답변완료 or 미 답변 확인 라벨
    var answerCheckLabelStr : String = ""
    let answerTitleLabel = UILabel()
    
    
    let answerLabel = UILabel()//작성자 : 아이디(선생님) ・ 작성일 : 2021-01-13
    let grayLine5 = UIView()
    
    let answerTextView = UITextView()
    
    let writeBtn = UIButton()
    
    
    
    func setHideLayout(bool : Bool){
        if bool {
            answerTitleLabel.isHidden = false
            
            
            answerLabel.isHidden = false
            grayLine5.isHidden = false
            
            answerTextView.isHidden = false
        } else {
            answerTitleLabel.isHidden = true
            
            
            answerLabel.isHidden = true
            grayLine5.isHidden = true
            
            answerTextView.isHidden = true
        }
    }
}
//MARK: - @objc
extension messagePostViewController {
    @objc
    func deleteBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "메세지를 삭제 하시겠습니까?.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "삭제", style: .default) { _ in
            self.AF.appCommunityDeleteStudentMessage(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_message_number: self.messageNumber!, url: "app/community/delete_student_message")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    @objc
    func writeBtnAction(){
        
        if titleTextField.text?.count ?? 0 > 1, titleTextField.text != ""  {
            if contentTextView.text.count > 0, contentTextView.text != nil {
                
                AF.appCommunityUpdateStudentMessage(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_message_number: messageNumber!, student_message_title: titleTextField.text ?? "", student_message_text: contentTextView.text, url: "app/community/update_student_message")
                
            } else {
                extensionClass.showToast(view: view, message: "내용을 작성해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
        } else {
            
            extensionClass.showToast(view: view, message: "제목을 작성해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
    }
    @objc
    func modifyBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "내용을 수정 하시겠습니까?.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.writeBtn.isHidden = false
            self.titleTextField.isEnabled = true
            self.contentTextView.isEditable = true
            self.contentTextView.becomeFirstResponder()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
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
    @objc
    func doneBtnFromKeyboardClicked(sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
      self.view.endEditing(true)
    }
}
extension messagePostViewController : appCommunityGetStudentMessageDelegate {
    func appCommunityDeleteStudentMessage(result: Int) {
        //메세지 삭제 함수
        if result == 0 {
            
            
            
            extensionClass.showToast(view: view, message: "삭제 완료되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.navigationController?.popViewController(animated: true)
            }
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    func appCommunityUpdateStudentMessage(result: Int) {
        //게시글 수정후 서버 통신 완료 메세지 받는 함수
        if result == 0 {
            writeBtn.isHidden = true
            titleTextField.isEnabled = false
            contentTextView.isEditable = false
            extensionClass.showToast(view: view, message: "수정 완료", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else if result == 1{
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appCommunityGetStudentMessage(result: Int, message_title: String, message_text: String, message_name: String, message_date: String, message_comment_state: String, message_comment_date: String, message_comment: String, message_teacher_name: String) {
        
        
        if result == 0 {
            let messageDate = extensionClass.DateToString(date: message_date,type: 0)
            titleTextField.text = message_title
            userLabel.text = "작성자 : \(message_name) ・ 작성일 \(messageDate)"
            contentTextView.text = message_text
            if userInformationClass.student_name != message_name {
                modifyBtn.isHidden = true
                deleteBtn.isHidden = true
            }
            let messageCommentDate = extensionClass.DateToString(date: message_comment_date,type: 0)
            if message_comment_state == "1" {
                answerLabel.text = "작성자 : \(message_teacher_name) ・ 작성일 \(messageCommentDate)"
                answerTextView.text = message_comment
            }
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        
        //print("message_comment_state : ",message_comment_state)
    }
    
    
}
extension messagePostViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == contentTextView{
            guard let textFieldText = textView.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + text.count
            return count <= 500
        } else {
            return true
        }
    }
}
extension messagePostViewController {
    func setupLayout(){
        _scrollView(scrollview : scrollView)
        _titleTextField(textField: titleTextField)
        _userLabel(label : userLabel)
        
        _grayLine1(uiview: grayLine1)
        _contentTextView(textView: contentTextView)
        
        _grayLine2(uiview: grayLine2)
        
        _listBtn(button: listBtn)
        _deleteBtn(button: deleteBtn)
        _modifyBtn(button: modifyBtn)
        _answerCheckLabel(label : answerCheckLabel)
        _answerTitleLabel(label : answerTitleLabel)
        
        _answerLabel(label: answerLabel)//작성자 : 아이디(선생님) ・ 작성일 : 2021-01-13
        _grayLine5(uiview: grayLine5)
        
        _answerTextView(textView: answerTextView)
        
        _writeBtn(button: writeBtn)
        
        
    }
    func _scrollView(scrollview : UIScrollView){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func _titleTextField(textField : UITextField){
        scrollView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        textField.text = "제목은 뭐로 적어야하나요?"
        textField.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.isEnabled = false
        //textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        
        textField.topAnchor.constraint(equalTo:  scrollView.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo:  view.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo:  view.trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    func _userLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.textAlignment = .left
        label.text = "작성자 : 홍길동 ・ 작성일 2021-01-13"
        
        label.topAnchor.constraint(equalTo: titleTextField.bottomAnchor,constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
    }
    
    func _grayLine1(uiview : UIView){
        scrollView.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _contentTextView(textView : UITextView){
        scrollView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font =  UIFont.NotoSansCJKkr(type: .normal, size: 14)
        textView.textColor = mainColor._404040
        textView.textAlignment = .left
        textViewDoneBtnMake(textview: textView)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        
        textView.topAnchor.constraint(equalTo: grayLine1.bottomAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(equalToConstant:  view.frame.height / 2).isActive = true
    }
    
    func _grayLine2(uiview : UIView){
        scrollView.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    
    func _listBtn(button: UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("목록", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        //button.addTarget(self, action: #selector(listBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 7).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _deleteBtn(button: UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        //button.layer.borderColor = mainColor._3378fd.cgColor
        //button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 7).isActive = true
        button.trailingAnchor.constraint(equalTo: listBtn.leadingAnchor, constant: -7).isActive = true
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _modifyBtn(button: UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.setTitle("수정", for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        //button.layer.borderColor = mainColor._3378fd.cgColor
        //button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(modifyBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 7).isActive = true
        button.trailingAnchor.constraint(equalTo: deleteBtn.leadingAnchor, constant: -7).isActive = true
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _answerCheckLabel(label : UILabel){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = answerCheckLabelStr
        if answerCheckLabelStr == "답변완료"{
            label.textColor = mainColor._3378fd
            label.layer.borderColor = mainColor._3378fd.cgColor
        } else {
            label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
            label.layer.borderColor = mainColor.hexStringToUIColor(hex: "#777777").cgColor
        }
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        
        
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        
        label.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 7).isActive = true
        label.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 60).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func _answerTitleLabel(label : UILabel){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        label.textColor = mainColor._404040
        label.text = "    ⌞ 답변입니다."
        
        
        
        label.topAnchor.constraint(equalTo: answerCheckLabel.bottomAnchor, constant: 7).isActive = true
        label.leadingAnchor.constraint(equalTo:  view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func _answerLabel(label : UILabel){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4)
        label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        label.textAlignment = .left
        //label.text = "작성자 : 홍길동 ・ 작성일 2021-01-13"
        
        label.topAnchor.constraint(equalTo: answerTitleLabel.bottomAnchor,constant: 7).isActive = true
        label.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
    }//작성자 : 아이디(선생님) ・ 작성일 : 2021-01-13
    
    func _grayLine5(uiview : UIView){
        scrollView.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 7).isActive = true
        uiview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    func _answerTextView(textView : UITextView){
        scrollView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font =  UIFont.NotoSansCJKkr(type: .normal, size: 14)
        textView.textColor = mainColor._404040
        textView.textAlignment = .left
        //textView.numberOfLines = 0
        //textView.lineBreakMode = .byWordWrapping
        //textView.delegate = self
        
        
        textView.topAnchor.constraint(equalTo: grayLine5.bottomAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(equalToConstant:  view.frame.height / 2).isActive = true
    }
    
    func _writeBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("글쓰기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor._3378fd
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(writeBtnAction), for: .touchUpInside)
        button.isHidden = true
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
    }
}
