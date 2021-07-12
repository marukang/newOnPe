//
//  asdfasdfasdf.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/06.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class classListCellCollectionViewHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        if ViewController1.getsubmitAdressList.count > 0 {
            
            
            for value in ViewController1.getsubmitAdressList {
                print("호호 : ",value)
                switch value.type {
                case "오픈채팅":
                    self.label5.text = ": " + (value.link ?? "-")
                    break
                case "이메일":
                    self.label6.text = ": " + (value.link ?? "-")
                    break
                case "N드라이브":
                    self.label7.text = ": " + (value.link ?? "-")
                    break
                case "직접입력":
                    self.label8.text = ": " + (value.link ?? "-")
                    break
                default:
                    break
                }
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let bounderView = UIView()
    let title = UILabel()//학기 수업 정보
    let label1 = UILabel()//오픈 채팅
    let label2 = UILabel()//이메일
    let label3 = UILabel()//N드라이브
    let label4 = UILabel()//기타
    let label5 = UILabel()
    let label6 = UILabel()
    let label7 = UILabel()
    let label8 = UILabel()
    
    func setupLayout(){
        _bounderView(uiview : bounderView)
        _title(label : title)
        _label1(label : label1)
        _label2(label : label2)
        _label3(label : label3)
        _label4(label : label4)
        
        _label5(label : label5)
        _label6(label : label6)
        _label7(label : label7)
        _label8(label : label8)
        
        
    }
    func _bounderView(uiview : UIView){
        addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.layer.borderWidth = 1
        uiview.layer.borderColor = mainColor._3378fd.cgColor
        uiview.layer.cornerRadius = 8
        
        uiview.topAnchor.constraint(equalTo: topAnchor,constant: 0).isActive = true
        uiview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        uiview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
    }
    func _title(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "학기 수업 정보"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .bold, size: 18)
        label.textAlignment = .center
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label1(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "오픈 채팅"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label2(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 7.5).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label3(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N드라이브"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 7.5).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label4(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "기타"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 7.5).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label5(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ": -"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: label1.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label6(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ": -"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: label2.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label7(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ": -"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: label3.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func _label8(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ": -"
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: label4.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
}
