//
//  classNoticeViewController.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/12.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
protocol classNoticeViewControllerDelegate {
    func classNoticeViewWillAppear(result : Int)
}
class classNoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectClassCode = UserInformation.student_classcodeList[ViewController1.pageControlerRow]
        setupLayout()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.classNoticeViewWillAppear(result : 1)
        AF.appMemberGetMyNews(student_id: UserInformation.student_id, student_token: UserInformation.access_token, type: "notice", class_code: selectClassCode, url: "app/member/get_my_news", completion : {
            [weak self] result, result1 in
            
            self?.getClassNoticeList.removeAll()
            
            if result == 0 {
                if let result1 = result1 {
                 
                    self?.getClassNoticeList = result1
                    self?.classNoticeListCollectionview.reloadData()
                }
                
            } else if result == 1 {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            } else {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
            
        })
    }
    let AF = ServerConnectionLegacy()
    let classTextField = UITextField()
    let classTextFieldPicker = UIPickerView()
    let arrowImageview = UIImageView()
    let grayLine2 = UIView()
    let classNoticeListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var selectClassCode : String?
    var setClassName : String?
    var delegate : classNoticeViewControllerDelegate?
    var getClassNoticeList : [pushList] = []

}
//MARK: - pickerDelegate
extension classNoticeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    @objc
    func action(){
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return UserInformation.student_classcodeNameList.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UserInformation.student_classcodeNameList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectClassCode = UserInformation.student_classcodeList[row]
        classTextField.text = UserInformation.student_classcodeNameList[row]
        
        AF.appMemberGetMyNews(student_id: UserInformation.student_id, student_token: UserInformation.access_token, type: "notice", class_code: selectClassCode, url: "app/member/get_my_news", completion : {
            [weak self] result, result1 in
            
            self?.getClassNoticeList.removeAll()
            
            if result == 0 {
                if let result1 = result1 {
                 
                    self?.getClassNoticeList = result1
                    self?.classNoticeListCollectionview.reloadData()
                }
                
            } else if result == 1 {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            } else {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
            
        })
        
        
        
    }
    
    
}
extension classNoticeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, classNoticeCelllDelegate{
    func classNoticeCellGesture(setPushList: pushList) {
        let vc = classNoticePostViewController()
        vc.title = "학급 공지사항"
        vc.getPushList = setPushList
        vc.view.backgroundColor = .white
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getClassNoticeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classNoticeCell", for: indexPath) as! classNoticeCell
        cell.delegate = self
        cell.messageNumber = indexPath.row + 1
        cell.setPushList = getClassNoticeList[indexPath.row]
        
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
extension classNoticeViewController {
    func setupLayout(){
        _classTextField(textField: classTextField)
        _classTextFieldPicker(picker: classTextFieldPicker)
        _arrowImageview(imageview : arrowImageview)
        _grayLine2(uiview: grayLine2)
        _classNoticeListCollectionview(collectionview: classNoticeListCollectionview)
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
        
        
        textField.text = UserInformation.student_classcodeNameList[ViewController1.pageControlerRow]
        
        textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
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
    func _classNoticeListCollectionview(collectionview : UICollectionView){
        view.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        collectionview.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(classNoticeCell.self, forCellWithReuseIdentifier: "classNoticeCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        collectionview.topAnchor.constraint(equalTo: grayLine2.bottomAnchor, constant: 0).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
}
