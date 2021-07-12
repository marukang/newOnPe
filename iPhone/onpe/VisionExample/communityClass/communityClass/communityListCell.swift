//
//  communityListCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/25.
//

import UIKit
protocol communityListCellDelegate {
    func getPostCode(code : Int)
}

class communityListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(communityListCellGesture(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let postingNumberLabel = UILabel()
    let titleLabel = UILabel()
    let writerLabel = UILabel()
    let replyLabel = UILabel()
    let grayLine1 = UIView()
    var delegate : communityListCellDelegate?
    var indexpathrow : Int?{
        didSet{
            postingNumberLabel.text = String(indexpathrow!)
        }
    }
    var setPostCode : Int?
    var getCommunityListStruct : CommunityList?{
        didSet{
            setupText()
        }
    }
    
    @objc
    func communityListCellGesture(_ : UITapGestureRecognizer){
        if let setPostCode = self.setPostCode {
            delegate?.getPostCode(code: setPostCode)
        }
        
    }
    
    func setupText(){
        titleLabel.text = getCommunityListStruct?.community_title
        
        guard let name = getCommunityListStruct?.community_name else { return  }
        guard let date = getCommunityListStruct?.community_date else { return  }
        guard let replyCount = getCommunityListStruct?.community_count else { return  }
        writerLabel.text = "\(name) ・ \(extensionClass.DateToString(date: date,type: 0))"
        replyLabel.text = "댓글 \(replyCount)개"
        setPostCode = Int(getCommunityListStruct?.community_number ?? "0")
    }
    
    func setupLayout(){
        _postingNumberLabel(label: postingNumberLabel)
        _titleLabel(label: titleLabel)
        _writerLabel(label: writerLabel)
        _replyLabel(label: replyLabel)
        _grayLine1(uiview : grayLine1)
    }
    
    func _postingNumberLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        //label.text = "공지"
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
    func _replyLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "댓글 2개"
        label.textAlignment = .center
        label.textColor = mainColor._3378fd
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
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
