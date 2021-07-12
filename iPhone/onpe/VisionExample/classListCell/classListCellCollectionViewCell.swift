//
//  classListCellCollectionViewCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/21.
//

import UIKit

protocol classListCellCollectionViewCellDelegate {
    func classCode(unitCode : String, classCode : String, title : String, deadLine: Bool)
    func classCodeReport(unitCode : String, classCode : String, title : String)
}

class classListCellCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.overrideUserInterfaceStyle = .light
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func click(){
        
        if let unitCode = unitCode, let title  = classTitleLabel.text {
            delegate?.classCode(unitCode: unitCode, classCode: classCode!, title: title, deadLine: clickBool)
        }
    }
    
    @objc
    func classReportBtnAction(){
        delegate?.classCodeReport(unitCode: unitCode!, classCode: classCode!, title: classTitleLabel.text ?? "nil")
        print("수업현황")
    }
    let uploadTimeLabel = UILabel()
    let classTitleLabel = UILabel()
    let classReportBtn = UIButton()
    let rightArrowImageview = UIImageView()
    var delegate : classListCellCollectionViewCellDelegate?
    var indexrow : Int = 0
    var classCode : String?// 1학기, 2학기와 같은 클래스 코드
    var unitCode : String? //차시별 수업 코드
    var clickBool = true
    var getClassList : ClassList?{
        didSet{
            unitCode = getClassList?.unit_code
            
            if let title = getClassList?.unit_class_name {
                classTitleLabel.text = "[\(indexrow + 1)]차시 " + title
            }
            
            
            if let deadLine = getClassList?.unit_end_date, let startLine = getClassList?.unit_start_date{
                let nowTime : Int = Int(extensionClass.nowTimw2()) ?? 0
                let deadLineInt = Int(deadLine) ?? 0
                let startLineInt = Int(startLine) ?? 0
                if startLineInt <= nowTime || nowTime <= deadLineInt {
                    clickBool = true
                    self.backgroundColor = .white
                    
                    
                    self.layer.borderWidth = 1
                    self.layer.cornerRadius = 8
                    self.layer.borderColor = mainColor._3378fd.cgColor
                } else {
                    
                    clickBool = false
                    self.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
                    self.layer.borderWidth = 1
                    self.layer.cornerRadius = 8
                    
                }
            }
            
            
            if let startTime  = getClassList?.unit_start_date, let endTime = getClassList?.unit_end_date {
                uploadTimeLabel.text = "\(extensionClass.DateToString(date: startTime, type: 1)) ~ \(extensionClass.DateToString(date: endTime, type: 1))"
            }
            
            
            
        }
    }
    
}

extension classListCellCollectionViewCell {
    func setupLayout(){
        _uploadTimeLabel(label: uploadTimeLabel)
        _classTitleLabel(label: classTitleLabel)
        _classReportBtn(button: classReportBtn)
        _rightArrowImageview(imageview: rightArrowImageview)
    }
    
    func _uploadTimeLabel(label : UILabel){
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "2021.05.04 18:00"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
        label.textColor = mainColor.hexStringToUIColor(hex: "#3f3f3f")
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }
    func _classTitleLabel(label : UILabel){
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "[1차시] 공다루기 수업"
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textColor = mainColor._3378fd
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: uploadTimeLabel.bottomAnchor, constant: 2).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.frame.width * 0.8).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _classReportBtn(button : UIButton){
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" 수업현황", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 12)
        button.setImage(#imageLiteral(resourceName: "asdfasdg"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        //button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
        button.addTarget(self, action: #selector(classReportBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 9).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        button.widthAnchor.constraint(equalToConstant: 78).isActive = true
        button.heightAnchor.constraint(equalToConstant: 23).isActive = true
    }
    func _rightArrowImageview(imageview : UIImageView){
        addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "blue_left")
        imageview.contentMode = .scaleAspectFit
        
        imageview.centerYAnchor.constraint(equalTo: self.classTitleLabel.centerYAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: classReportBtn.trailingAnchor, constant: -10).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
}


