//
//  exerciseCountCell.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/07.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class exerciseCountCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupLayout()
    }
    var labelStr : String? {
        didSet{
            label.text = labelStr
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let lineView = UIView()//운동중 빨간색, 운동전 회색
    let label = UILabel()
    var indexpathRow : Int = 0
    var exercisePosition : Int?{
        didSet{
            if exercisePosition == indexpathRow {
                lineView.backgroundColor = mainColor.hexStringToUIColor(hex: "#f70103")
                label.textColor = mainColor._3378fd
                label.layer.borderColor = mainColor._3378fd.cgColor
            } else {
                lineView.backgroundColor = mainColor.hexStringToUIColor(hex: "#d6d6d6")
                label.textColor = .black
                label.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func setupLayout(){
        _lineView(line : lineView)
        
        _label(label : label)
    }
    func _lineView(line : UIView){
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = mainColor.hexStringToUIColor(hex: "#f70103")
        
        line.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func _label(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.text = "동작"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        label.textColor = mainColor.hexStringToUIColor(hex: "#f70103")
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        
        label.topAnchor.constraint(equalTo: lineView.bottomAnchor,constant: 2).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
