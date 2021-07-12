//
//  proFileCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/22.
//

import UIKit

protocol proFileCellDelegate {
    func btnAction(number : Int)
}

class proFileCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label = UILabel()
    let photoBtn = UIButton()
    let albumBtn =  UIButton()
    var delegate : proFileCellDelegate?
    
    @objc
    func photoBtnAction(){
        delegate?.btnAction(number: 0)
    }
    
    @objc
    func albumBtnAction(){
        delegate?.btnAction(number: 1)
    }
    
    func setupLayout(){
        _label()
        _photoBtn()
        _albumBtn()
    }
    
    func _label(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "사진 가져오기"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textColor = mainColor._404040
        label.textAlignment = .center
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: self.frame.width * 0.15).isActive = true
    }
    func _photoBtn(){
        addSubview(photoBtn)
        photoBtn.translatesAutoresizingMaskIntoConstraints = false
        photoBtn.setTitle("사진촬영", for: .normal)
        photoBtn.setTitleColor(.black, for: .normal)
        photoBtn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        
        photoBtn.layer.borderWidth = 1.5
        photoBtn.layer.cornerRadius = 10
        photoBtn.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        photoBtn.addTarget(self, action: #selector(photoBtnAction), for: .touchUpInside)
        
        photoBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0).isActive = true
        photoBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        photoBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        photoBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    func _albumBtn(){
        addSubview(albumBtn)
        albumBtn.translatesAutoresizingMaskIntoConstraints = false
        albumBtn.setTitle("앨범에서 가져오기", for: .normal)
        albumBtn.setTitleColor(.black, for: .normal)
        albumBtn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        
        albumBtn.layer.borderWidth = 1.5
        albumBtn.layer.cornerRadius = 10
        albumBtn.layer.borderColor = mainColor.hexStringToUIColor(hex: "#ebebeb").cgColor
        albumBtn.addTarget(self, action: #selector(albumBtnAction), for: .touchUpInside)
        
        albumBtn.topAnchor.constraint(equalTo: photoBtn.bottomAnchor, constant: 10).isActive = true
        albumBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        albumBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        albumBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
}
