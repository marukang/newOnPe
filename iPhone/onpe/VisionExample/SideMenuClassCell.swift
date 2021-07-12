//
//  SideMenuClassCellCollectionViewCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/13.
//

import UIKit

class SideMenuClassCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let classNameLabel = UILabel()
    let classJoinBtn = UIButton()
    
    func setupLayout(){
        _classNameLabel()
        _classJoinBtn(button: classJoinBtn)
        
    }
    func _classNameLabel(){
        addSubview(classNameLabel)
        classNameLabel.translatesAutoresizingMaskIntoConstraints = false
        classNameLabel.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        classNameLabel.textColor = mainColor.hexStringToUIColor(hex: "#595959")
        classNameLabel.textAlignment = .left
        
        classNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        classNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        classNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        classNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    func _classJoinBtn(button : UIButton){
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = mainColor._3378fd
        button.setImage(#imageLiteral(resourceName: "arrow_right_box"), for: .normal)
        //button.setImage(UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 4
        //button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        button.centerYAnchor.constraint(equalTo: self.classNameLabel.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    
}
