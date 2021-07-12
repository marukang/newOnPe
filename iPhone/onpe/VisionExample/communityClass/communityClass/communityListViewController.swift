//
//  communityListViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/25.
//

import UIKit

class communityListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        AF.delegate14 = self
        selectClassCode = userInformationClass.student_classcodeList[ViewController1.pageControlerRow]
        //if let getStudentClassDode = userInformationClass.s
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AF.appCommunityGetStudentCommunityList(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_class_code: "\(userInformationClass.student_classcodeList[ViewController1.pageControlerRow])", url: "app/community/get_student_community_list")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    let AF = ServerConnectionLegacy()
    let searchTextField = UITextField()//검색 텍스트필드
    let searchImageview = UIImageView()//돋보기 이미지
    
    let grayLine1 = UIView()
    let classTextField = UITextField()
    let classTextFieldPicker = UIPickerView()
    let arrowImageview = UIImageView()
    let grayLine2 = UIView()
    
    let writeBtn = UIButton()
    
    let communityListCollectionview = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let myclassList = ["고성고 1학년","고성고 2학년"]
    var getStudentClassDode : String?
    var getCommunityList : [CommunityList]?
    var selectClassCode : String = ""
}
extension communityListViewController : appCommunityGetStudentCommunityListDelegate {
    func appCommunityGetStudentCommunityList(result: Int, CommunityList: [CommunityList]?) {
        if result == 0 {
            getCommunityList?.removeAll()
            getCommunityList = CommunityList
            communityListCollectionview.reloadData()
        } else if result == 1{
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
    }
    
    
}
//MARK: - @obj 함수
extension communityListViewController {
    @objc
    func action(){
        self.view.endEditing(true)
    }
    @objc
    func writeBtnAction(){
        
        let vc = writeViewController()
        vc.view.backgroundColor = .white
        vc.title = "글쓰기"
        vc.getType = "커뮤니티"
        vc.selectClassCode = selectClassCode
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: - collectionview Delegate
extension communityListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, communityListCellDelegate {
    
    func getPostCode(code: Int) {
        
        let vc = communityPostViewController()
        vc.title = "학급 커뮤니티"
        vc.view.backgroundColor = .white
        vc.communityNumber = code
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("컬랙션뷰 개수",getCommunityList)
        return getCommunityList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "communityListCell", for: indexPath) as! communityListCell
        cell.indexpathrow = indexPath.row + 1
        cell.delegate = self
        cell.getCommunityListStruct = getCommunityList?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.205)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
//MARK: - pickerDelegate
extension communityListViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return userInformationClass.student_classcodeNameList.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userInformationClass.student_classcodeNameList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectClassCode = userInformationClass.student_classcodeList[row]
        classTextField.text = userInformationClass.student_classcodeNameList[row]
        AF.appCommunityGetStudentCommunityList(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, student_class_code: "\(selectClassCode)", url: "app/community/get_student_community_list")
    }
    
    
    
}
extension communityListViewController {
    func setupLayout(){
        _searchTextField(textField: searchTextField)//검색
        _searchImageview(imageview: searchImageview)//돋보기 이미지
        
        _grayLine1(uiview: grayLine1)
        _classTextField(textField: classTextField)
        _classTextFieldPicker(picker: classTextFieldPicker)
        _arrowImageview(imageview : arrowImageview)
        _grayLine2(uiview: grayLine2)
        
        _writeBtn(button: writeBtn)
        _communityListCollectionview(collectionview : communityListCollectionview)
    }
    
    func _searchTextField(textField : UITextField){
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        textField.placeholder = "검색어를 입력해주세요."
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = mainColor._3378fd.cgColor
        textField.layer.cornerRadius = 8
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }//검색
    func _searchImageview(imageview : UIImageView){
        view.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "asdfasdg")
        imageview.contentMode = .scaleAspectFit
        
        imageview.topAnchor.constraint(equalTo: searchTextField.topAnchor,constant: 10).isActive = true
        imageview.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor,constant: -20).isActive = true
        imageview.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor ,constant: -10).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
    }//돋보기 이미지
    
    func _grayLine1(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _classTextField(textField : UITextField){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = mainColor._404040
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4)
        textField.tintColor = .clear
        textField.textColor = .black
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(100)
        
        
        textField.text = userInformationClass.student_classcodeNameList[ViewController1.pageControlerRow]
        
        textField.topAnchor.constraint(equalTo: grayLine1.bottomAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    func _classTextFieldPicker(picker : UIPickerView){
        picker.delegate = self
        picker.dataSource = self
        classTextField.inputView = picker
        dismissPickerView(textField: classTextField)
    }
    
    func dismissPickerView(textField : UITextField) {
        let toolBar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    func _arrowImageview(imageview : UIImageView){
        view.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "arrow_bottom_box")
        imageview.contentMode = .scaleAspectFit
        
        imageview.topAnchor.constraint(equalTo: classTextField.topAnchor,constant: 0).isActive = true
        imageview.trailingAnchor.constraint(equalTo: classTextField.trailingAnchor, constant: -20).isActive = true
        imageview.bottomAnchor.constraint(equalTo: classTextField.bottomAnchor, constant: 0).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 27).isActive = true
    }
    func _grayLine2(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.classTextField.bottomAnchor, constant: 10).isActive = true
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
    
    func _communityListCollectionview(collectionview : UICollectionView){
        view.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        collectionview.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(communityListCell.self, forCellWithReuseIdentifier: "communityListCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        collectionview.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 10).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: writeBtn.topAnchor, constant: -10).isActive = true
    }
}
