//
//  faqListCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/27.
//

import UIKit
protocol faqListCellDelegate {
    func getQnaCode(code : Int)
}

class faqListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(faqListCellGesture(_:))))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let postingNumberLabel = UILabel()
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    
    let grayLine1 = UIView()
    
    
    var delegate : faqListCellDelegate?
    var setQnaCode : Int?
    var faqcontent : Faq?{
        didSet{
            setupContent()
        }
    }// 서버로 부터 받은 json 값들
    
    public func setupContent(){
        titleLabel.text = faqcontent?.faq_title
        categoryLabel.text = faqcontent?.faq_type
        
        
    }
    @objc
    func faqListCellGesture(_ : UITapGestureRecognizer){
        if let setQnaCode = self.setQnaCode{
            delegate?.getQnaCode(code: setQnaCode)
        }
        
    }
}

extension faqListCell{
    func setupLayout(){
        _postingNumberLabel(label: postingNumberLabel)
        _titleLabel(label: titleLabel)
        _categoryLabel(label: categoryLabel)
        
        _grayLine1(uiview : grayLine1)
    }
    
    func _postingNumberLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.text = "공지"
        label.textColor = mainColor._3378fd
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: (frame.height / 3) - 5 ).isActive = true
    }
    func _titleLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
        label.text = "전체공지합니다."
        label.textColor = mainColor._404040
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: postingNumberLabel.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: (frame.height / 3) ).isActive = true
    }
    func _categoryLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.text = "콘텐츠관 관련"
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
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
