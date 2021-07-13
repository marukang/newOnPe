//
//  communityPostViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/26.
//

import UIKit

class communityPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AF.delegate12 = self
        setupLayout()
        let deviceType = UIDevice().type
        
        let deviceModel = deviceType.rawValue
        sizetheFitsControlByDevice(deviceType: deviceModel)
       
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if let communityNumber = self.communityNumber{
            print("community_number : ",communityNumber)
            //상세글 가져오기
            AF.appCommunityGetStudentCommunity(student_id: UserInformation.student_id, student_token: UserInformation.access_token, community_number: communityNumber, url: "app/community/get_student_community")
            
            
        }
        scrollView.contentSize = .init(width: view.frame.width, height: view.frame.height)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    let AF = ServerConnectionLegacy()
    var communityHeaderIndex : Community?
    var communityNumber : Int?
    var getCommentList : [CommentList]?
    let scrollView = UIScrollView()
    let communityPostcollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var headerHight : CGFloat = 0
    let replayTextView = UITextView()
    let writeBtn = UIButton()
    var replayTextBool = false
    //var replayList = ["At the end of the day though, it is essentially the same as calculated the text size via sizeWithAttributes, so maybe that is the preferred answer.","Hello World","At the end of the day though, it is"]
    
    
    func sizetheFitsControlByDevice(deviceType : String)
    {
        
        if deviceType == "iPhone 8" || deviceType == "iPhone 7" || deviceType == "iPhone 6" || deviceType == "iPhone 6S"
        {
            
            headerHight = 20
        } else if deviceType == "iPhone 11" || deviceType == "iPhone XR"  {
            
            headerHight = 10
            
        } else if deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6S Plus" || deviceType == "iPhone 7 Plus" || deviceType == "iPhone 8 Plus" {
            
            headerHight = 10
            
        } else if deviceType == "iPhone 11 Pro Max" || deviceType == "iPhone XS Max" {
            
            headerHight = 10
            
        } else if deviceType == "iPhone 11 Pro" || deviceType == "iPhone X" || deviceType == "iPhone XS"  {
            
            headerHight = 10
            
        } else {
            let device : String = UIDevice.current.name
            
            if device == "iPhone 12 Pro" || device == "iPhone 12" || device == "iPhone 12 Pro Max" || deviceType == "iPhone 12 mini"{
            
                headerHight = 10
                
            } else {
            
                headerHight  = 20
            }
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
    @objc
    func doneBtnFromKeyboardClicked(sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
       
      self.view.endEditing(true)
    }
    
    var keyboardWillHideBool = false//키보드 '내리는' 액션을 한번만 시행 하기 위해 사용
    var keyboardWillShowBool = false//키보드 '올리는' 액션을 한번만 실행 하기 위해 사용
    @objc
    func keyboardWillShow(sender: NSNotification) {
        if !keyboardWillShowBool {
            keyboardWillShowBool = true
            let userInfo = sender.userInfo!
            let keyboardSize: CGSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey as NSObject]! as AnyObject).cgRectValue.size
            
            
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                //print("키보드 ani1 : ",self.scrollView.frame.origin.y)
                self.scrollView.frame.origin.y -= keyboardSize.height
                //print("키보드 ani2 : ",self.scrollView.frame.origin.y)
                
            })
        }
        keyboardWillHideBool = true
        
        
    }

    @objc
    func keyboardWillHide(sender: NSNotification) {
        //print("키보드 ani3 : ",self.scrollView.frame.origin.y)
        if keyboardWillHideBool {
            keyboardWillHideBool = false
            keyboardWillShowBool = false
            self.scrollView.frame.origin.y = 0
        }
        
        //print("키보드 ani4 : ",self.scrollView.frame.origin.y)
        
        
    }
    
}
extension communityPostViewController : appCommunityGetStudentCommunityDelegate {
    func appCommunityDeleteStudentCommunity(result: Int) {
        if result == 0 {
            self.navigationController?.popViewController(animated: true)
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
  
    
    func appCommunityCreateStudentCommunityCommentList(result: Int) {
        if result == 0 {
            AF.appCommunityGetStudentCommunityCommentList(student_id: UserInformation.student_id, student_token: UserInformation.access_token, community_number: communityNumber!, url: "app/community/get_student_community_comment_list")
            
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appCommunityDeleteStudentCommunityCommentList(result: Int, indexpath: Int) {
        if result == 0 {
            print(indexpath)
            let row = indexpath
            self.getCommentList?.remove(at: row)
            
        
            self.communityPostcollectionview.performBatchUpdates({
                
                self.communityPostcollectionview.deleteItems(at: [IndexPath(item: row, section: 0)])
                
            }, completion:  {_ in
                self.communityPostcollectionview.reloadData()
            })
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    func appCommunityGetStudentCommunityCommentList(result: Int, commentList: [CommentList]?) {
        if result == 0 {
            if commentList?.count != 0 {
                getCommentList = commentList
            }
            if replayTextBool{
                replayTextView.text = ""
            }
            replayTextBool = true
            
            communityPostcollectionview.reloadData()
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
    }
    
    
    func appCommunityGetStudentCommunity(result: Int, community: Community?) {
        if result == 0 {
            communityHeaderIndex = community
            AF.appCommunityGetStudentCommunityCommentList(student_id: UserInformation.student_id, student_token: UserInformation.access_token, community_number: communityNumber!, url: "app/community/get_student_community_comment_list")
            
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
    }
    
    
}
//MARK: - @objc
extension communityPostViewController {
    @objc
    func writeBtnAction(){
        if replayTextView.text == "댓글 내용을 작성하세요."{
            extensionClass.showToast(view: view, message: "댓글을 작성해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            let count = replayTextView.text.count
            if count == 0 {
                extensionClass.showToast(view: view, message: "댓글을 작성해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            } else {
                AF.appCommunityCreateStudentCommunityCommentList(student_id: UserInformation.student_id, student_token: UserInformation.access_token, student_name: UserInformation.student_name, community_number: communityNumber!, comment_content: replayTextView.text, url: "app/community/create_student_community_comment_list")
                
                
            }
        }
        
        
    }
}

//MARK: - UITextFieldDelegate
extension communityPostViewController :  UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == replayTextView{
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
        if textView.textColor == mainColor.hexStringToUIColor(hex: "#595959") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "댓글 내용을 작성하세요."
            textView.textColor = mainColor.hexStringToUIColor(hex: "#595959")
        }
    }

}

//MARK: - collectionview
extension communityPostViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, communityPostHeaderDelegate, communityPostCellDelegate {
    
    //댓글 삭제 버튼 눌럿을때
    func deleteBtnAction(row: Int, indexpath : Int) {
        let alert = UIAlertController(title: "온체육", message: "댓글을 삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "삭제", style: .default) { _ in
            //print(customExerciseList)
            self.AF.appCommunityDeleteStudentCommunityCommentList(student_id: UserInformation.student_id, student_token: UserInformation.access_token, comment_number: row, community_number: (self.communityNumber)!, indexpath : indexpath ,url: "app/community/delete_student_community_comment_list")
            
        }
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelBtn)
        present(alert, animated: true, completion: nil)
    }
    
    //목록 이동하긱버튼 눌렀을때
    func listBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func deleteBtnAction() {
        navigationController?.popViewController(animated: true)
        //AF.appCommunityDeleteStudentCommunity(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, community_number: communityNumber!, url: "app/community/delete_student_community")
        
    }
    
    func modifyBtnAction() {
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 1.75 + headerHight)
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "communityPostHeader", for: indexPath) as! communityPostHeader
        header._communityPostViewController = self
        header.getCommunityHeaderIndex = communityHeaderIndex
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return getCommentList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "communityPostCell", for: indexPath) as! communityPostCell
        cell.getCommentStruct = getCommentList?[indexPath.row]
        cell.indexpath = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let content = getCommentList?[indexPath.row].comment_content {
            let size = (content as NSString).size(withAttributes: nil)
            
            let cellHeight : CGFloat = (round((size.width / collectionView.frame.width ) * 10 ) / 10 * 4) * 22.5
            /*
            print("나눈값 : ",size.width / collectionView.frame.width)
            print("반올림 값 : ",round((size.width / collectionView.frame.width ) * 10 ) / 10)
            print("계산 값 : ", cellHeight)
            */
            if (cellHeight) < 50 {
                return CGSize(width: collectionView.frame.width, height: 100)
            } else if 50 < cellHeight, cellHeight < 120 {
                return CGSize(width: collectionView.frame.width, height: 150)
            }  else {
                return CGSize(width: collectionView.frame.width, height: cellHeight)
            }
        } else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension communityPostViewController {
    func setupLayout(){
        _scrollView(scrollview : scrollView)
        _writeBtn(button : writeBtn)
        _replayTextView(textview : replayTextView)
        _communityPostcollectionview(collectionview : communityPostcollectionview)
        
        
    }
    func _scrollView(scrollview : UIScrollView){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func _communityPostcollectionview(collectionview : UICollectionView){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.collectionViewLayout = layout
        collectionview.isPagingEnabled = false
        collectionview.backgroundColor = .white
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(communityPostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "communityPostHeader")
        collectionview.register(communityPostCell.self, forCellWithReuseIdentifier: "communityPostCell")
        // home_collectionview.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(collectionview)
        
        
        collectionview.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: replayTextView.topAnchor, constant: -20).isActive = true

        
    }
    func _replayTextView(textview : UITextView){
        scrollView.addSubview(textview)
        textview.translatesAutoresizingMaskIntoConstraints  = false
        textview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        textview.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        textview.textColor = mainColor.hexStringToUIColor(hex: "#595959")
        textview.text = "댓글 내용을 작성하세요."
        textview.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textview.delegate = self
        textViewDoneBtnMake(textview: textview)
        
        textview.bottomAnchor.constraint(equalTo: writeBtn.topAnchor).isActive = true
        textview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        textview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        textview.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
    }
    func _writeBtn(button : UIButton){
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("댓글 등록", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor._3378fd
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(writeBtnAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
    }
}
