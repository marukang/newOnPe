//
//  customClassListCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/24.
//

import UIKit

protocol customClassListCellDelegate {
    func deleteItem(number : Int)
}

class customClassListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.borderColor = mainColor._3378fd.cgColor
        setupLayout()
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let deleteBtn = UIButton()
    let titleLable = UILabel()
    
    var cellNumber : Int?
    var delegate : customClassListCellDelegate?
    

    
    
    @objc
    func deleteBtnAction(){
        delegate?.deleteItem(number: cellNumber ?? 0)
    }
}

extension customClassListCell {
    func setupLayout(){
        _deleteBtn(button: deleteBtn)
        _titleLable(label: titleLable)
       
    }
    
    func _deleteBtn(button : UIButton){
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor.hexStringToUIColor(hex: "#eeeeee")
        button.setTitle("삭제하기", for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
    
        
        button.topAnchor.constraint(equalTo: topAnchor, constant: 9).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -9).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    func _titleLable(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = mainColor.hexStringToUIColor(hex: "#595959")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        
        label.topAnchor.constraint(equalTo: deleteBtn.bottomAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    
}
