//
//  firstUnitListCheckCell.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/03.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
protocol unitlistCheckListCellDelegate {
    func confirmAction(type : Bool)
}

class unitlistCheckListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let scrollview = UIScrollView()
    let title = UILabel()
    let title2 = UILabel()
    
    let checklistBtn1 = UIButton()
    let checklistBtn2 = UIButton()
    let checklistBtn3 = UIButton()
    let checklistBtn4 = UIButton()
    let checklistBtn5 = UIButton()
    let checklistBtn6 = UIButton()
    let checklistBtn7 = UIButton()
    let confirmBtn = UIButton()
    var delegate : unitlistCheckListCellDelegate?
    var getUnitCode : String?
    
    @objc
    func checklistBtn1Action(_ sender : UIButton){
        sender.isSelected = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = mainColor._3378fd
        confirmBtnActivate()
    }
    @objc
    func checklistBtn2Action(_ sender : UIButton){
        sender.isSelected = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = mainColor._3378fd
        confirmBtnActivate()
    }
    @objc
    func checklistBtn3Action(_ sender : UIButton){
        sender.isSelected = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = mainColor._3378fd
        confirmBtnActivate()
    }
    @objc
    func checklistBtn4Action(_ sender : UIButton){
        sender.isSelected = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = mainColor._3378fd
        confirmBtnActivate()
    }
    @objc
    func checklistBtn5Action(_ sender : UIButton){
        sender.isSelected = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = mainColor._3378fd
        confirmBtnActivate()
    }
    @objc
    func checklistBtn6Action(_ sender : UIButton){
        sender.isSelected = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = mainColor._3378fd
        confirmBtnActivate()
    }
    @objc
    func checklistBtn7Action(_ sender : UIButton){
        sender.isSelected = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = mainColor._3378fd
        confirmBtnActivate()
    }
    @objc
    func confirmBtnAction(){
        var type = false // 해당 값이 true이면 유닛리스트를 쉐어드에 저장하고 운동화면으로 넘어아기, false이면 alert 코드 실행시키기
        if checklistBtn1.isSelected, checklistBtn2.isSelected, checklistBtn3.isSelected, checklistBtn4.isSelected, checklistBtn5.isSelected, checklistBtn6.isSelected, checklistBtn7.isSelected {
            type = true
            
            
            var joinUnitList : [String]? = UserInformation.preferences.object(forKey: UserInformation.unitListKey) as? [String]
            if joinUnitList != nil {
                joinUnitList?.append(getUnitCode!)
            } else {
                //최초 유닛리스트에 값을 넣을 경우
                joinUnitList = []
                joinUnitList?.removeAll()
                joinUnitList?.append(getUnitCode!)
            }
            //print(joinUnitList)
            UserInformation.preferences.set(joinUnitList, forKey: UserInformation.unitListKey)
        } else {
            type = false
        }
        
        delegate?.confirmAction(type: type)
        
    }
    func confirmBtnActivate(){
        if checklistBtn1.isSelected, checklistBtn2.isSelected, checklistBtn3.isSelected, checklistBtn4.isSelected, checklistBtn5.isSelected, checklistBtn6.isSelected, checklistBtn7.isSelected {
            confirmBtn.setTitleColor(.white, for: .normal)
            confirmBtn.backgroundColor = mainColor._3378fd
        }
    }
    
    func setupLayout(){
        _scrollview(scrollview : scrollview)
        _title(label : title)
        _title2(label : title2)
        _checklistBtn1(button : checklistBtn1)
        _checklistBtn2(button : checklistBtn2)
        _checklistBtn3(button : checklistBtn3)
        _checklistBtn4(button : checklistBtn4)
        _checklistBtn5(button : checklistBtn5)
        _checklistBtn6(button : checklistBtn6)
        _checklistBtn7(button : checklistBtn7)
        _confirmBtn(button : confirmBtn)
    }
    
    func _scrollview(scrollview : UIScrollView){
        addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
        scrollview.contentSize = .init(width: frame.width, height: frame.height * 1.4)
        
    }
    
    func _title(label : UILabel){
        scrollview.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.text = "운동 전 체크 리스트"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = mainColor._3378fd
        label.textAlignment = .center
        label.font = UIFont.NotoSansCJKkr(type: .bold, size: 20)
        
        label.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func _title2(label : UILabel){
        scrollview.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.text = "(모두 체크해주세요.)"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = mainColor._3378fd
        label.textAlignment = .center
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        
        label.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func _checklistBtn1(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("준비운동을 완료했나요?", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(checklistBtn1Action(_:)), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: self.title2.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
    func _checklistBtn2(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("발열 증상(37.5도 이상)이 없나요?", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(checklistBtn2Action(_:)), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: self.checklistBtn1.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
    func _checklistBtn3(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("코로나19 의심 증상이 없나요?", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(checklistBtn3Action(_:)), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: self.checklistBtn2.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
    func _checklistBtn4(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전신이 모두 카메라에 잡혀야 해요.", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(checklistBtn4Action(_:)), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: self.checklistBtn3.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
    func _checklistBtn5(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("나를 가리는 장애물이 없어야 해요.", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(checklistBtn5Action(_:)), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: self.checklistBtn4.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
    func _checklistBtn6(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("운동하는 순간을 캡처하여\n랜덤으로 선생님께 전송하는 것에 동의합니까?", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(checklistBtn6Action(_:)), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: self.checklistBtn5.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.25).isActive = true
    }
    func _checklistBtn7(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("운동복을 모두 입으셨습니까? (속옷 X)", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(checklistBtn7Action(_:)), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: self.checklistBtn6.bottomAnchor, constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
    
    func _confirmBtn(button : UIButton){
        scrollview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("운동하러 가기.", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: checklistBtn7.bottomAnchor, constant: 50).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
}
