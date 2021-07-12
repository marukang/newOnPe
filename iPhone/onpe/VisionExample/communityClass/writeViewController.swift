//
//  writeViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/25.
//

import UIKit

class writeViewController: UIViewController  {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        AF.delegate9 = self
        setImageList.removeAll()
    }
    let AF = ServerConnectionLegacy()
    var selectClassCode : String = ""
    let titleTextField = UITextField()
    let grayLine = UIView()
    let userLabel = UILabel()
    
    let grayLine1 = UIView()
    let contentTextView = UITextView()
    
    let grayLine2 = UIView()
    let attachLabel = UILabel()
    let attachBtn = UIButton()
    let attachFileBtn1 = UIButton()
    let attachFileBtn2 = UIButton()
    let attachFileDeleteBtn1 = UIButton()// 사진 삭제 버튼
    let attachFileDeleteBtn2 = UIButton()
    
    var imagePicker: UIImagePickerController!
    var getCommunityNumber : String?
    var setFile1FirstCheckBool = false
    var setFile2FirstCheckBool = false
    var setFile1Bool = false
    var setFile2Bool = false
    var getFile1 : String?{
        didSet{
            if getFile1 != nil {
                if let fileUrl = getFile1?.components(separatedBy: "/") {
                    getFile1 = String(fileUrl.last ?? "")
                }
                print("community_file1",getFile1)
                attachFileDeleteBtn1.isHidden = false
                
                attachFileBtn1.layer.borderColor = mainColor._3378fd.cgColor
                attachFileBtn1.setTitleColor(mainColor._3378fd, for: .normal)
            } else {
                if getFile1 == nil {
                    setFile1FirstCheckBool = true
                }
                
            }
        }
    }
    var getFile2 : String?{
        didSet{
            if getFile2 != nil {
                if let fileUrl = getFile2?.components(separatedBy: "/") {
                    getFile2 = String(fileUrl.last ?? "")
                }
                print("community_file2",getFile2)
                attachFileDeleteBtn2.isHidden = false
                
                attachFileBtn2.layer.borderColor = mainColor._3378fd.cgColor
                attachFileBtn2.setTitleColor(mainColor._3378fd, for: .normal)
            } else {
                if getFile2 == nil {
                    setFile2FirstCheckBool = true
                }
                
            }
        }
    }
    var setImageFile1 : UIImage?
    var setImageFile2 : UIImage?
    var setImageList : [UIImage] = []
    var setDeleteImageList : [String] = []
    let writeBtn = UIButton()
    var writeBtnBool = false// 중복 글쓰기를 막아주기 위해서 사용되는 변수 , 글작성시 true로 바뀌고 서버로부터 전송된 값을 받아오면 false로 다시 돌아간다.
    var getType : String = "" {
        didSet{
            setHide(type: getType)
        }
    }//서버에 글을 올릴때 커뮤니티 글인지, 메세지 글인지 확인하기 위한 인자 값 -> 커뮤니티, 메세지 로 확인
    var getType1 : String?//nil이면 사진 업로드, nil이 아니면 게시글 수정
    
    func setHide(type : String){
        if type == "메세지"{
            attachLabel.isHidden = true
            attachBtn.isHidden = true
            attachFileBtn1.isHidden = true
            attachFileBtn2.isHidden = true
        } else {
            attachLabel.isHidden = false
            attachBtn.isHidden = false
            attachFileBtn1.isHidden = false
            attachFileBtn2.isHidden = false
        }
    }

}
extension writeViewController : appCommunitySendStudentMessageDelegate{
    func appCommunityCreateStudentCommunity(result: Int) {
        writeBtnBool = false
        if result == 0 {
            extensionClass.showToast(view: view, message: "작성이 완료되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.navigationController?.popViewController(animated: true)
            }
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appCommunityUpdateStudentCommunity(result: Int) {
        writeBtnBool = false
        if result == 0 {
            extensionClass.showToast(view: view, message: "수정이 완료되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is communityListViewController {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
                
            }
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appCommunitySendStudentMessage(result: Int) {
        writeBtnBool = false
        if result == 0 {
            extensionClass.showToast(view: view, message: "작성이 완료되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.navigationController?.popViewController(animated: true)
            }
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
}
extension writeViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //앨범 사진 선택후 실행되는 delegate 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        if setFile1Bool {
            setFile2Bool = false
            setImageFile1 = selectedImage
        }
        if setFile2Bool {
            setFile1Bool = false
            
            setImageFile2 = selectedImage
        }
        //userProfileImageview.image = selectedImage
        //getProfileImage = selectedImage
        checkImageFile()
    }
    
    func checkImageFile(){
        if setFile1Bool {
            if !setFile1FirstCheckBool{
                
                setFile1FirstCheckBool = true
                if let file = getFile1 {
                    setDeleteImageList.append(file)
                }
                
                
            }
            setFile1Bool = false
            attachFileBtn1.layer.borderColor = mainColor._3378fd.cgColor
            attachFileBtn1.setTitleColor(mainColor._3378fd, for: .normal)
        }
        
        
        if setFile2Bool{
            if !setFile2FirstCheckBool{
                setFile2FirstCheckBool = true
                if let file = getFile2 {
                    setDeleteImageList.append(file)
                }
                
            }
            setFile2Bool = false
            attachFileBtn2.layer.borderColor = mainColor._3378fd.cgColor
            attachFileBtn2.setTitleColor(mainColor._3378fd, for: .normal)
        }
    }
    
    
    func takePhoto() {
        selectImageFrom(.camera)
        //extensionClass.showToast(view: self.getWindow!, message: "잠시만 기다려주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    func save() {
        selectImageFrom(.photoLibrary)
    }
}
//MARK: - @objc 함수
extension writeViewController {
    @objc
    func attachBtnAction(){
        if setImageFile1 == nil {
            attachFileBtn1Action()
        } else if setImageFile2 == nil {
            attachFileBtn2Action()
        }
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
    @objc
    func attachFileDeleteBtn1Action(){
        let alert = UIAlertController(title: "온체육", message: "사진을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            if !self.setFile1FirstCheckBool{
                
                self.setFile1FirstCheckBool = true
                self.setDeleteImageList.append(self.getFile1!)
                self.getFile1 = nil
                self.attachFileBtn1.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
                self.attachFileBtn1.layer.borderColor =  mainColor.hexStringToUIColor(hex: "#9f9f9f").cgColor
                
            }
            
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func attachFileDeleteBtn2Action(){
        let alert = UIAlertController(title: "온체육", message: "사진을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            if !self.setFile2FirstCheckBool{
                
                self.setFile2FirstCheckBool = true
                self.setDeleteImageList.append(self.getFile2!)
                
                self.getFile2 = nil
                self.attachFileBtn2.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
                self.attachFileBtn2.layer.borderColor =  mainColor.hexStringToUIColor(hex: "#9f9f9f").cgColor
                
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @objc
    func attachFileBtn1Action(){
        
        setFile1Bool = true
        save()
        
    }
    
    @objc
    func attachFileBtn2Action(){
        
        setFile2Bool = true
        save()
        
    }
    @objc
    func writeBtnAction(){
        if titleTextField.text?.count ?? 0 > 1 {
            //최소 제목은 2글자이상
            if contentTextView.text.count > 2 {
                if !writeBtnBool {
                    writeBtnBool = true
                    let a = userInformationClass.self
                    if getType == "메세지"{
                        AF.appCommunitySendStudentMessage(student_id: a.student_id, student_token: a.access_token, student_name: a.student_name, student_class_code: self.selectClassCode, student_message_title: titleTextField.text!, student_message_text: contentTextView.text!, url: "app/community/send_student_message")
                    } else {
                        if getType1 == nil {
                            if setImageFile1 != nil, setImageFile2 != nil {
                                setImageList.append(setImageFile1!)
                                setImageList.append(setImageFile2!)
                            } else {
                                if setImageFile1 != nil {
                                    setImageList.append(setImageFile1!)
                                } else {
                                    if setImageFile2 != nil{
                                        setImageList.append(setImageFile2!)
                                    }
                                    
                                }
                            }
                            
                            AF.appCommunityCreateStudentCommunity(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_name: userInformationClass.student_name, student_class_code: selectClassCode, community_title: titleTextField.text!, community_text: contentTextView.text!,community_file: setImageList, url: "app/community/create_student_community")
                        } else {
                            
                            
                            if let setImageFile1 = setImageFile1 {
                                setImageList.append(setImageFile1)
                            }
                            
                            if let setImageFile2 = setImageFile2 {
                                setImageList.append(setImageFile2)
                            }

                            print("추가 이미지 파일 : ",setImageList)
                            print("삭제 이미지 파일 : ",setDeleteImageList)
                            
                            
                            if let fileUrl = self.getFile1?.components(separatedBy: "/") {
                                
                                self.getFile1 = String(fileUrl.last ?? "")
                                
                            }
                            if let fileUrl = self.getFile2?.components(separatedBy: "/") {
                                
                                self.getFile2 = String(fileUrl.last ?? "")
                                
                            }
                            print("community_file1 : ",getFile1)
                            print("community_file2 : ",getFile2)
                            AF.appCommunityUpdateStudentCommunity(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, community_title: titleTextField.text!, community_text: contentTextView.text!, community_number: getCommunityNumber!, community_file1: getFile1 ?? nil, community_file2: getFile2 ?? nil, community_new_file: setImageList, community_file_delete_name: setDeleteImageList, url: "app/community/update_student_community")
                            setImageList.removeAll()
                        }
                        
                    }
                }
                
                
            } else {
                extensionClass.showToast(view: view, message: "최소 2글자 이상 내용을 작성해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
        } else {
            extensionClass.showToast(view: view, message: "최소 2글자 이상은 작성해야 합니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            
        }

    }
}
extension writeViewController : UITextFieldDelegate, UITextViewDelegate {
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == mainColor._404040 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "본문 내용을 작성하세요."
            textView.textColor = mainColor._404040
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == titleTextField
        {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 25
        } else {
            return true
        }
    }
}
extension writeViewController {
    func setupLayout(){
        _titleTextField(textField: titleTextField)
        _userLabel(label : userLabel)
        
        _grayLine1(uiview: grayLine1)
        
        _writeBtn(button : writeBtn)
        _attachFileBtn2(button: attachFileBtn2)
        _attachFileBtn1(button: attachFileBtn1)
        _attachLabel(label: attachLabel)
        //_attachBtn(button: attachBtn)
        _grayLine2(uiview: grayLine2)
        
        _contentTextView(textView: contentTextView)
        _attachFileDeleteBtn1(button: attachFileDeleteBtn1)
        _attachFileDeleteBtn2(button : attachFileDeleteBtn2)
    }
    
    func _titleTextField(textField : UITextField){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        textField.placeholder = "제목을 작성하세요."
        textField.textColor = mainColor._404040
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.delegate = self
        textFieldDoneBtnMake(text_field: textField)
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    func _userLabel(label : UILabel){
        view.addSubview(label)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.textAlignment = .left
        //label.text = "작성자 : 홍길동"
        
        label.topAnchor.constraint(equalTo: titleTextField.bottomAnchor,constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    func _grayLine1(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    
    func _writeBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("글쓰기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor._3378fd
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(writeBtnAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
    }
    
    func _grayLine2(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.bottomAnchor.constraint(equalTo: attachLabel.topAnchor, constant: -10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _attachLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        label.text = "첨부자료"
        label.textColor = mainColor._404040
        
        label.bottomAnchor.constraint(equalTo: attachFileBtn1.topAnchor, constant: -10).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func _attachBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("첨부", for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.addTarget(self, action: #selector(attachBtnAction), for: .touchUpInside)
        
        button.centerYAnchor.constraint(equalTo: attachLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    func _attachFileBtn1(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("자료", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "file_image"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1
        button.layer.borderColor =  mainColor.hexStringToUIColor(hex: "#9f9f9f").cgColor
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 7.5, left: 10, bottom: 7.5, right: 0)
        button.titleEdgeInsets.left = 15
        button.addTarget(self, action: #selector(attachFileBtn1Action), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: attachFileBtn2.topAnchor, constant: -10).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    func _attachFileBtn2(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("자료", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "#9f9f9f"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "file_image"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.layer.cornerRadius = 7
        button.layer.borderWidth = 1
        button.layer.borderColor =  mainColor.hexStringToUIColor(hex: "#9f9f9f").cgColor
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 7.5, left: 10, bottom: 7.5, right: 0)
        button.titleEdgeInsets.left = 15
        button.addTarget(self, action: #selector(attachFileBtn2Action), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: writeBtn.topAnchor, constant: -30).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func _contentTextView(textView : UITextView){
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font =  UIFont.NotoSansCJKkr(type: .normal, size: 14)
        textView.textColor = mainColor._404040
        textView.textAlignment = .left
        textView.delegate = self
        textView.text = "본문 내용을 작성하세요."
        textViewDoneBtnMake(textview: textView)
        textView.topAnchor.constraint(equalTo: grayLine1.bottomAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textView.bottomAnchor.constraint(equalTo: grayLine2.topAnchor, constant: -20).isActive = true
    }
    func _attachFileDeleteBtn1(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "trash")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        button.addTarget(self, action: #selector(attachFileDeleteBtn1Action), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: attachFileBtn1.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: attachFileBtn1.bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: attachFileBtn1.trailingAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func _attachFileDeleteBtn2(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(systemName: "trash")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        button.addTarget(self, action: #selector(attachFileDeleteBtn2Action), for: .touchUpInside)
        button.topAnchor.constraint(equalTo: attachFileBtn2.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: attachFileBtn2.bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: attachFileBtn2.trailingAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
