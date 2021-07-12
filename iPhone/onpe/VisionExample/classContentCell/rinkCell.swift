//
//  rinkCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/21.
//

import UIKit
protocol rinkCellDelegate {
    func rinkCellClick(getRinkUrl : String)
}
class rinkCell: UICollectionViewCell {
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
    
    let imageview = UIImageView()
    let label = UILabel()
    var RinkTitle : String?
    var indexrow : Int?{
        didSet{
            label.text = "\(indexrow! + 1). \(RinkTitle!)(수업 관련 영상)"
        }
    }
    var getRinkUrl : String?
    var delegate : rinkCellDelegate?
    
    @objc
    func click(){
        if let url = getRinkUrl {
            delegate?.rinkCellClick(getRinkUrl: url)
        }
    }
    
    func setupLayout(){
        _imageview()
        _label()
    }
    func _imageview(){
        addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        imageview.image = #imageLiteral(resourceName: "file_image")
        
        imageview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
    }
    func _label(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = mainColor.hexStringToUIColor(hex: "#9f9f9f")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: 12).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 10).isActive = true
        
        
    }
    
    
}
