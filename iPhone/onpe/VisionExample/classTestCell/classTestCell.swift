//
//  classTestCell.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/03.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
protocol classTestCellDelegate{
    func classTestCellClick(submitType : Int, subjectTitle : String, subjectType : String, subjectIndex : String ,contentCode : String, practiceBool : Bool)
}
class classTestCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.borderColor = mainColor._3378fd.cgColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc
    func click(){
        //delegate?.classCode(classCodeNumber: classCode ?? "nill")
        if let titleStr = titleLabel.text, let contentCode = contentCode, let getRecordDic = self.getRecordDic  {
            var title : String = ""
            
            var i = 0
            for value in titleStr {
                if -1 < i, i < 2 {
                    title = title + String(value)
                } else {
                    break
                }
                i += 1
                    
            }
            switch title {
            case "실습":
                if getRecordDic.class_practice != nil{
                    practiceBool = true
                }
                break
            case "평가":
                if getRecordDic.evaluation_practice != nil{
                    practiceBool = true
                }
                break
            case "이론":
                if getRecordDic.task_practice != nil{
                    practiceBool = true
                }
                break
            default:
                print("오류")
            }
            print(practiceBool)
            delegate?.classTestCellClick(submitType : submitType ?? 0, subjectTitle : titleStr, subjectType : title, subjectIndex: subjectIndex ?? "0", contentCode: contentCode, practiceBool: practiceBool)
        }
        
        
        
        //print("하이")
    }
    
    let exerciseNameLabel = UILabel()
    let blueLine = UIView()
    let titleLabel = UILabel()//실습, 과제 평가
    var delegate : classTestCellDelegate?
    let rightArrowImageview = UIImageView()
    var practiceBool = false // false 운동 기록 없을때, true 운동 기록 있을때
    var getRecordDic : recordDic?{
        didSet{
            print(getRecordDic)
        }
    }
    var contentCode : String?
    
    var contentTitle : String?{
        didSet{
            exerciseNameLabel.text = contentTitle!
        }
    }
    var subjectIndex : String?{
        didSet{
            
        }
    }
    var contentNameText : String?{
        didSet{
            
            
            print("제목 : ",contentNameText)
            print("제목의 번호 : ",subjectIndex)
            if contentNameText == "실습수업"{
                if let data = getRecordDic?.class_practice?.data(using: .utf8){
                    do {
                        let getResult = try JSONDecoder().decode([[recordList]].self, from:  data)
                        
                        if getResult[Int(subjectIndex ?? "0") ?? 0].count != 0 {
                            titleLabel.text = contentNameText! + "(완료)"
                        } else {
                            titleLabel.text = contentNameText!
                        }
                        print(getResult[Int(subjectIndex ?? "0") ?? 0].count)
                        
                        
                    } catch let error {
                        print(error)
                    }
                } else {
                    titleLabel.text = contentNameText!
                }
            } else if contentNameText == "평가수업"{
                if let data = getRecordDic?.evaluation_practice?.data(using: .utf8){
                    do {
                        let getResult = try JSONDecoder().decode([[recordList]].self, from:  data)
                        if getResult[Int(subjectIndex ?? "0") ?? 0].count != 0 {
                            titleLabel.text = contentNameText! + "(완료)"
                        } else {
                            titleLabel.text = contentNameText!
                        }
                        
                    } catch let error {
                        print(error)
                    }
                } else {
                    titleLabel.text = contentNameText!
                }
            }
            
        }
    }
    var submitType : Int?
    
    
}

extension classTestCell {
    func setupLayout(){
        _exerciseNameLabel(label : exerciseNameLabel)
        _blueLine(line : blueLine)
        _titleLabel(label: titleLabel)
        
        _rightArrowImageview(imageview: rightArrowImageview)
    }
    func _exerciseNameLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = mainColor._3378fd
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _blueLine(line : UIView){
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = mainColor._3378fd
        
        line.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor , constant: 4).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    func _titleLabel(label : UILabel){
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        label.textColor = mainColor._3378fd
        label.textAlignment = .center
        
        label.topAnchor.constraint(equalTo: blueLine.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func _rightArrowImageview(imageview : UIImageView){
        addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "blue_left")
        imageview.contentMode = .scaleAspectFit
        
        imageview.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
}


