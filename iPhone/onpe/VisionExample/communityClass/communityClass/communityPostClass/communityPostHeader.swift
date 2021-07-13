//
//  communityPostHeader.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/26.
//

import UIKit

protocol communityPostHeaderDelegate {
    func listBtnAction()
    func deleteBtnAction()
    func modifyBtnAction()
}

class communityPostHeader: UICollectionReusableView, appCommunityPostStudentCommunityDelegate {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        AF.delegate13 = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let AF = ServerConnectionLegacy()
    
    let titleTextField = UITextField()
    let grayLine = UIView()
    let userLabel = UILabel()
    let grayLine1 = UIView()
    
    let contentTextView = UITextView()
    let grayLine2 = UIView()
    let attachLabel = UILabel()
    let attachFileBtn1 = UIButton()
    let attachFileBtn2 = UIButton()
    let grayLine3 = UIView()
    let listBtn = UIButton()
    let deleteBtn = UIButton()
    let modifyBtn = UIButton()
    let grayLine4 = UIView()
    var getCommunityHeaderIndex : Community? {
        didSet{
            setupText()
        }
    }
    var imagePicker: UIImagePickerController!
    var delegate : communityPostHeaderDelegate?
    var _communityPostViewController : communityPostViewController?
    var getCommunityNumber : String?
    var setFile1Bool = false
    var setFile2Bool = false
    var getFile1 : String?
    var getFile2 : String?
    var setImageFile1 : UIImage?
    var setImageFile2 : UIImage?
    func appCommunityDeleteStudentCommunity(result: Int) {
        //삭제하면 실행되는 함수
        if result == 0 {
            delegate?.deleteBtnAction()
        } else if result == 1 {
            extensionClass.showToast(view: (_communityPostViewController?.view!)!, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: (_communityPostViewController?.view)!, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    @objc
    func listBtnAction(){
        delegate?.listBtnAction()
    }
    @objc
    func deleteBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "게시글을 삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "삭제", style: .default) { (action) in
            
            self.AF.appCommunityDeleteStudentCommunity(student_id: UserInformation.student_id, student_token: UserInformation.access_token, community_number: (self.getCommunityHeaderIndex?.community_number)!, url: "app/community/delete_student_community")
            
        }
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelBtn)
        _communityPostViewController?.present(alert, animated: true, completion: nil)
        
    }
    @objc
    func modifyBtnAction(){
        let alert = UIAlertController(title: "온체육", message: "게시글을 수정 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "수정", style: .default) { [self] (action) in
            let vc = writeViewController()
            vc.view.backgroundColor = .white
            vc.title = "글쓰기"
            vc.getType = "커뮤니티"
            vc.getType1 = "커뮤니티 수정"
            vc.getCommunityNumber = getCommunityHeaderIndex?.community_number
            vc.titleTextField.text = getCommunityHeaderIndex?.community_title
            
            
            vc.contentTextView.text = getCommunityHeaderIndex?.community_text
            
            
            vc.userLabel.text = "작성자 : " + (getCommunityHeaderIndex?.community_name!)!
            vc.getFile1 = getFile1 ?? nil
            vc.getFile2 = getFile2 ?? nil
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self._communityPostViewController?.navigationItem.backBarButtonItem = backItem
            self._communityPostViewController?.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelBtn)
        _communityPostViewController?.present(alert, animated: true, completion: nil)
        //delegate?.modifyBtnAction()
    }
    
    @objc
    func attachFileBtn1Action(){
        if let url = getFile1 {
            
            UIApplication.shared.open(URL(string: url)!)
        }
        
    }
    @objc
    func attachFileBtn2Action(){
        if let url = getFile2 {
            setFile2Bool = true
            UIApplication.shared.open(URL(string: url)!)
        }
        
        
    }
    
    func setupText(){
        guard let name = getCommunityHeaderIndex?.community_name else { return }
        guard let date = getCommunityHeaderIndex?.community_date else { return }
        guard let title = getCommunityHeaderIndex?.community_title else { return }
        guard let content = getCommunityHeaderIndex?.community_text else { return }
        if let file1 = getCommunityHeaderIndex?.community_file1 {
            if file1 != "" {
                getFile1 = AF.basURL + file1
                attachFileBtn1.layer.borderColor = mainColor._3378fd.cgColor
                attachFileBtn1.setTitleColor(mainColor._3378fd, for: .normal)
            }
            
        }
        if let file2 = getCommunityHeaderIndex?.community_file2 {
            if file2 != "" {
                getFile2 = AF.basURL + file2
                attachFileBtn2.layer.borderColor = mainColor._3378fd.cgColor
                attachFileBtn2.setTitleColor(mainColor._3378fd, for: .normal)
            }
            
        }
        titleTextField.text = title
        userLabel.text = "작성자 : \(name) ・ 작성일 \(extensionClass.DateToString(date: date,type: 0))"
        print(content)
        var htmlTag = content.replacingOccurrences(of: "& lt;", with: "<")
        htmlTag = htmlTag.replacingOccurrences(of: "& gt;", with: ">")
        htmlTag = htmlTag.replacingOccurrences(of: "img", with:
"""
img style="width:\(frame.width * 0.75)px;"
""")
        htmlTag = htmlTag.replacingOccurrences(of:
"""
src="/
""", with:
"""
src="\(AF.basURL)
""")
        //contentTextView.text = content
        print(htmlTag)

        contentTextView.attributedText = htmlTag.htmlToAttributedString
        if UserInformation.student_id == getCommunityHeaderIndex?.community_id{
            deleteBtn.isHidden = false
            modifyBtn.isHidden = false
        } else {
            deleteBtn.isHidden = true
            modifyBtn.isHidden = true
        }
        
    }
}

extension communityPostHeader {
    func setupLayout(){
        _titleTextField(textField: titleTextField)
        _userLabel(label : userLabel)
        
        _grayLine1(uiview: grayLine1)
        _contentTextView(textView: contentTextView)
        
        _grayLine2(uiview: grayLine2)
        _attachLabel(label: attachLabel)
        
        _attachFileBtn1(button: attachFileBtn1)
        _attachFileBtn2(button: attachFileBtn2)
        _grayLine3(uiview: grayLine3)
        
        _listBtn(button: listBtn)
        _deleteBtn(button: deleteBtn)
        _modifyBtn(button: modifyBtn)
        _grayLine4(uiview: grayLine4)
        
        
    }
    
    func _titleTextField(textField : UITextField){
         addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        //textField.text = "제목은 뭐로 적어야하나요?"
        textField.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.isEnabled = false
        //textField.delegate = self
        
        textField.topAnchor.constraint(equalTo:  safeAreaLayoutGuide.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo:  leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo:  trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    func _userLabel(label : UILabel){
         addSubview(label)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize1)
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.textAlignment = .left
        //label.text = "작성자 : 홍길동 ・ 작성일 2021-01-13"
        
        label.topAnchor.constraint(equalTo: titleTextField.bottomAnchor,constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo:  leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo:  trailingAnchor, constant: -20).isActive = true
    }
    
    func _grayLine1(uiview : UIView){
         addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _contentTextView(textView : UITextView){
         addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font =  UIFont.NotoSansCJKkr(type: .normal, size: 14)
        textView.textColor = mainColor._404040
        textView.textAlignment = .left
        textView.isEditable = false
        
        //textView.delegate = self
        /*
        textView.text = """
        - (CGSize) intrinsicContentSize {
        CGSize intrinsicSuperViewContentSize = [super intrinsicContentSize] ;
        intrinsicSuperViewContentSize.height += topInset + bottomInset ;
        intrinsicSuperViewContentSize.width += leftInset + rightInset ;
        return intrinsicSuperViewContentSize ;
        - (CGSize) intrinsicContentSize {
        CGSize intrinsicSuperViewContentSize = [super intrinsicContentSize] ;
        intrinsicSuperViewContentSize.height += topInset + bottomInset ;
        intrinsicSuperViewContentSize.width += leftInset + rightInset ;
        return intrinsicSuperViewContentSize ;
    """
        */
        
        textView.topAnchor.constraint(equalTo: grayLine1.bottomAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo:  leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo:  trailingAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(equalToConstant:  frame.width * 0.9).isActive = true
    }
    
    func _grayLine2(uiview : UIView){
         addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _attachLabel(label : UILabel){
         addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        label.text = "첨부자료"
        label.textColor = mainColor._404040
        
        label.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo:  leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant:  frame.width * 0.7).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func _attachFileBtn1(button : UIButton){
         addSubview(button)
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
        
        
        button.topAnchor.constraint(equalTo: attachLabel.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo:  leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo:  trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    func _attachFileBtn2(button : UIButton){
         addSubview(button)
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
        
        button.topAnchor.constraint(equalTo: attachFileBtn1.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo:  leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo:  trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    func _grayLine3(uiview : UIView){
         addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: attachFileBtn2.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    func _listBtn(button: UIButton){
        addSubview(button)
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
        button.addTarget(self, action: #selector(listBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: grayLine3.bottomAnchor, constant: 7).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _deleteBtn(button: UIButton){
        addSubview(button)
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
        
        button.topAnchor.constraint(equalTo: grayLine3.bottomAnchor, constant: 7).isActive = true
        button.trailingAnchor.constraint(equalTo: listBtn.leadingAnchor, constant: -7).isActive = true
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _modifyBtn(button: UIButton){
        addSubview(button)
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
        
        button.topAnchor.constraint(equalTo: grayLine3.bottomAnchor, constant: 7).isActive = true
        button.trailingAnchor.constraint(equalTo: deleteBtn.leadingAnchor, constant: -7).isActive = true
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _grayLine4(uiview: UIView){
        addSubview(uiview)
       
       uiview.translatesAutoresizingMaskIntoConstraints = false
       uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
       
       uiview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
       uiview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
       uiview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
       
       uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
}
