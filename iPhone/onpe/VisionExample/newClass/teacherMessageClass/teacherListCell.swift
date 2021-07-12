//
//  teacherListCell.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/12.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
protocol teacherListCellDelegate {
    func teacherListCellGesture(setPushList : pushList)
}

class teacherListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticeListCellGesture(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let postingNumberLabel = UILabel()
    let titleLabel = UILabel()
    let writerLabel = UILabel()
    let replyLabel = UILabel()
    let grayLine1 = UIView()
    
    var delegate : teacherListCellDelegate?
    var messageNumber : Int?
    
    var setPushList : pushList?{
        didSet{
            if let setPushList = setPushList {
                postingNumberLabel.text = "\(setPushList.name ?? "") 선생님"
                titleLabel.text = setPushList.message_content
                writerLabel.text = "\(extensionClass.DateToString(date: setPushList.message_date!, type: 0))"
                
            }
        }
    }
    @objc
    func noticeListCellGesture(_ : UITapGestureRecognizer){
        print("touch")
        if let setPushList = setPushList {
            delegate?.teacherListCellGesture(setPushList: setPushList)
        }
        
        
    }
    
    
    func setupLayout(){
        _postingNumberLabel(label: postingNumberLabel)
        _titleLabel(label: titleLabel)
        _writerLabel(label: writerLabel)
        
        _grayLine1(uiview : grayLine1)
    }
    
    func _postingNumberLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        
        label.textColor = mainColor._3378fd
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        label.heightAnchor.constraint(equalToConstant: (frame.height / 3) - 5 ).isActive = true
    }
    func _titleLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
        //label.text = "전체공지합니다."
        label.textColor = mainColor._404040
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: postingNumberLabel.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: (frame.height / 3) ).isActive = true
    }
    func _writerLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        //label.text = "홍길동 ・ 2021-01-13"
        label.textColor = mainColor._404040
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
    }
    
    func _grayLine1(uiview : UIView){
        addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f1f1f1")
        
        uiview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        uiview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        uiview.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
}
