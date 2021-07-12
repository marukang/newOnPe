//
//  selfClassCustomViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/24.
//

import UIKit
/**
 - 미완성 부분
 1. 수업시작
 2. 수업 결과 확인
 3. 종목, 대분류 에 따른 동작명 리스트 변경
 */


class selfClassCustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        customExerciseList.removeAll()
        
        
    }
    
    let eventTextField = UITextField()
    let categoryTextField = UITextField()
    let exerciseNameTextField = UITextField()
    
    let sideMenuCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    let addBtn = UIButton()
    
    let garyLine1 = UIView()
    
    let customClassListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let garyLine2 = UIView()
    
    let startClassBtn = UIButton()
    let resultBtn = UIButton()
    let resetBtn = UIButton()
    
    let arrowImage1 = UIImageView()
    let arrowImage2 = UIImageView()
    let arrowImage3 = UIImageView()
    
    let eventPickerView = UIPickerView()
    let categoryPickerView = UIPickerView()
    let exerciseNamePickerView = UIPickerView()
    
    let eventList = ["농구","축구","야구"]
    let categoryList = ["공다루기","공때리기","공치기","공던지기","공 터트리기","공 짜끼",]
    let exerciseNameList = ["히욧","하얏","키키","핑퐁","뽀로로","삐꾸","팅꼬","띵똥"]
    var selectExerciseList : [String] = ["","",""]
    /**
     - selectExerciseList :
     - index : 0 - > eventPickerView으로 선택된 값 저장
     - index : 1 - > categoryPickerView으로 선택된 값 저장
     - index : 2 - > exerciseNamePickerView으로 선택된 값 저장
     */
    var customExerciseList : [[String]] = [[]]
        
        
    var categoryBool = false
    var exerciseNameBool = false

    
    func activateTextField(textField : UITextField, bool : Bool){
        if bool {
            textField.isEnabled = true
            textField.backgroundColor = .white
            textField.textColor = mainColor._3378fd
            textField.layer.borderWidth = 1
            textField.layer.borderColor = mainColor._3378fd.cgColor
        } else {
            textField.isEnabled = false
            textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
            textField.textColor = .white
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.clear.cgColor
            
        }
        
        
    }
}
//MARK: - @objc 함수
extension selfClassCustomViewController{
    @objc
    func action(){
        self.view.endEditing(true)
    }
    @objc
    func addBtnAction(){
        if selectExerciseList[0] == "" || selectExerciseList[1] == "" || selectExerciseList[2] == "" {
            extensionClass.showToast(view: view, message: "운동을 선택해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        } else {
            if categoryBool, exerciseNameBool {
                customExerciseList.append(selectExerciseList)//customExerciseList에 값추가해주기
                
                customClassListCollectionview.performBatchUpdates({
                    self.customClassListCollectionview.insertItems(at: [IndexPath(item: customExerciseList.count - 1, section: 0)])
                }, completion: { _ in
                    self.categoryBool = false
                    self.exerciseNameBool = false
                    self.activateTextField(textField: self.categoryTextField, bool: self.categoryBool)
                    self.activateTextField(textField: self.exerciseNameTextField, bool: self.exerciseNameBool)
                    self.arrowImage2.image = #imageLiteral(resourceName: "white_bottom")
                    self.arrowImage3.image = #imageLiteral(resourceName: "white_bottom")
                    
                    self.eventTextField.text = "종목"
                    self.categoryTextField.text = "대분류"
                    self.exerciseNameTextField.text = "동작명"
                    self.selectExerciseList.removeAll()//리스트의 값으로 0,1,2 index를 유지하기 위해 모두 삭제
                    self.selectExerciseList = ["","",""]
                    extensionClass.showToast(view: self.view, message: "운동이 추가 되었습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                })
                
                
            } else {
                extensionClass.showToast(view: view, message: "운동을 선택해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
        }
    }
    @objc
    func resetBtnAction(){
        self.customExerciseList.removeAll()
        self.selectExerciseList = ["","",""]
        customClassListCollectionview.reloadData()
    }
}

extension selfClassCustomViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == eventPickerView {
            return eventList.count
        } else if pickerView == categoryPickerView {
            return categoryList.count
        } else {
            return exerciseNameList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == eventPickerView {
            return eventList[row]
        } else if pickerView == categoryPickerView {
            return categoryList[row]
        } else {
            return exerciseNameList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == eventPickerView {
            eventTextField.text = eventList[row]
            selectExerciseList[0] = eventTextField.text!
            categoryBool = true
            if categoryBool{
                arrowImage2.image = #imageLiteral(resourceName: "blue_bottom")
                activateTextField(textField: categoryTextField, bool: categoryBool)
            } else {
                activateTextField(textField: categoryTextField, bool: categoryBool)
            }
            
            
            
            
        } else if pickerView == categoryPickerView {
            categoryTextField.text = categoryList[row]
            
            selectExerciseList[1] = categoryTextField.text!
            exerciseNameBool = true
            if exerciseNameBool {
                arrowImage3.image = #imageLiteral(resourceName: "blue_bottom")
                activateTextField(textField: exerciseNameTextField, bool: exerciseNameBool)
            } else {
                activateTextField(textField: exerciseNameTextField, bool: exerciseNameBool)
            }
            
            
        } else {
            exerciseNameTextField.text = exerciseNameList[row]
            selectExerciseList[2] = exerciseNameTextField.text!
            
            
            
        }
    }
    
    
}

//MARK: -
extension selfClassCustomViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, customClassListCellDelegate {
    
    func deleteItem(number: Int) {
        print(customExerciseList)
        print(number)
        self.customExerciseList.remove(at: number)
        
    
        customClassListCollectionview.performBatchUpdates({
            
            self.customClassListCollectionview.deleteItems(at: [IndexPath(item: number, section: 0)])
            
        }, completion:  {_ in
            self.customClassListCollectionview.reloadData()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customExerciseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customClassListCell", for: indexPath) as! customClassListCell
        cell.delegate = self
        let title : [String] = customExerciseList[indexPath.row]
        cell.titleLable.text = "[\(title[0])][\(title[1])][\(title[2])]"
        cell.cellNumber = indexPath.row
        //cell.sideMenuFotterContent = self.sideMenuFotterContent
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.width / 4.1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    
}

extension selfClassCustomViewController {
    
    func setupLayout(){
        _eventTextField(textField: eventTextField, text: "종목")
        _categoryTextField(textField: categoryTextField, text: "대분류")
        _exerciseNametextField(textField: exerciseNameTextField, text: "동작명")
        
        _addBtn(button: addBtn, text: "추가하기")
        
        _garyLine1(uiview: garyLine1)
        
        
        
        _resetBtn(button: resetBtn, text : "초기화")
        _resultBtn(button: resultBtn, text: "수업 결과 확인")
        _startClassBtn(button: startClassBtn, text: "수업시작")
        _grayLine2(uiview: garyLine2)
        
        _customClassListCollectionview(collectioniew: customClassListCollectionview)
        
        _arrowImage(imageview: arrowImage1, textField: eventTextField)
        _arrowImage(imageview: arrowImage2, textField: categoryTextField)
        _arrowImage(imageview: arrowImage3, textField: exerciseNameTextField)
        
        createPickerView(pickerView: eventPickerView, textField: eventTextField)
        createPickerView(pickerView: categoryPickerView, textField: categoryTextField)
        createPickerView(pickerView: exerciseNamePickerView, textField: exerciseNameTextField)
        
        dismissPickerView(textField: eventTextField)
        dismissPickerView(textField: categoryTextField)
        dismissPickerView(textField: exerciseNameTextField)
        
    }
    
    func _eventTextField(textField : UITextField, text : String){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.textColor = mainColor._3378fd
        textField.contentHorizontalAlignment = .left
        textField.setLeftPaddingPoints(10)
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = mainColor._3378fd.cgColor
        textField.layer.cornerRadius = 4
        textField.tintColor = .clear
        textField.inputView = eventPickerView
        
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.17).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    func _categoryTextField(textField : UITextField, text : String){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        textField.textColor = .white
        textField.contentHorizontalAlignment = .left
        textField.setLeftPaddingPoints(10)
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 4
        textField.tintColor = .clear
        textField.inputView = categoryPickerView
        
        textField.isEnabled = false
        
        
        
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: eventTextField.trailingAnchor, constant: 7).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.23).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    func _exerciseNametextField(textField : UITextField, text : String){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        textField.textColor = .white
        textField.contentHorizontalAlignment = .left
        textField.setLeftPaddingPoints(10)
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 4
        textField.inputView = exerciseNamePickerView
        textField.tintColor = .clear
        
        textField.isEnabled = false
        
        
        
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: categoryTextField.trailingAnchor, constant: 7).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.23).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    
    func createPickerView( pickerView : UIPickerView, textField : UITextField ) {
        //view.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
    }
    func dismissPickerView(textField : UITextField) {
        let toolBar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func _addBtn(button : UIButton, text : String){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor._3378fd
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        
        button.layer.cornerRadius = 4
        
        
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: exerciseNameTextField.trailingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    
    func _garyLine1(uiview : UIView){
        view.addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        view.addSubview(uiview)
        
        uiview.topAnchor.constraint(equalTo: self.addBtn.bottomAnchor, constant: 14).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    func _resetBtn(button :UIButton, text : String){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(resetBtnAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _resultBtn(button :UIButton, text : String){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        
        
        button.bottomAnchor.constraint(equalTo: resetBtn.topAnchor, constant: -20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _startClassBtn(button :UIButton, text : String){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.backgroundColor = mainColor._3378fd
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        button.layer.cornerRadius = 8
        
        
        
        button.bottomAnchor.constraint(equalTo: resultBtn.topAnchor, constant: -20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func _grayLine2(uiview : UIView){
        view.addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        view.addSubview(uiview)
        
        uiview.bottomAnchor.constraint(equalTo: startClassBtn.topAnchor, constant: -20).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
    func _arrowImage(imageview : UIImageView, textField : UITextField){
        view.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        if imageview == arrowImage2 || imageview == arrowImage3 {
            imageview.image = #imageLiteral(resourceName: "white_bottom")
        } else {
            imageview.image = #imageLiteral(resourceName: "blue_bottom")
        }
        
        
        imageview.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 10).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageview.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -7.5).isActive = true
        
    }
    func _customClassListCollectionview(collectioniew : UICollectionView){
        view.addSubview(collectioniew)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectioniew.backgroundColor = .white
        collectioniew.collectionViewLayout = layout
        collectioniew.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        
        collectioniew.translatesAutoresizingMaskIntoConstraints = false
        collectioniew.register(customClassListCell.self, forCellWithReuseIdentifier: "customClassListCell")
        
        collectioniew.delegate = self
        collectioniew.dataSource = self
        
        
        collectioniew.topAnchor.constraint(equalTo: garyLine1.bottomAnchor, constant: 10).isActive = true
        collectioniew.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectioniew.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectioniew.bottomAnchor.constraint(equalTo: garyLine2.topAnchor, constant: -10).isActive = true
        
        
        
        
    }
}
