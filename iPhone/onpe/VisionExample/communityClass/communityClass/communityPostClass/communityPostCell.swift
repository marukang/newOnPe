//
//  communityPostCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/26.
//

import UIKit
protocol communityPostCellDelegate {
    func deleteBtnAction(row : Int, indexpath : Int)
}
class communityPostCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let userNameLabel = UILabel()
    let replayDateLabel = UILabel()
    let contentTextView = UITextView()
    let grayLine = UIView()
    
    let deleteBtn = UIButton()
    var indexpath : Int?
    var row : Int?
    var delegate : communityPostCellDelegate?
    var getReplayText : String?
    var getCommentStruct : CommentList?{
        didSet{
            setupText()
        }
    }
    
    @objc
    func deleteBtnAction(){
        if let row  = self.row {
            delegate?.deleteBtnAction(row: row,indexpath: indexpath!)
        }
    }
    func setupText(){
        guard let name = getCommentStruct?.comment_name else { return }
        if getCommentStruct?.comment_id == userInformationClass.student_id {
            deleteBtn.isHidden = false
        } else {
            deleteBtn.isHidden = true
        }
        userNameLabel.text = name
        guard let data = getCommentStruct?.comment_date else { return }
        replayDateLabel.text = extensionClass.DateToString(date: data,type: 0)
        guard let comment = getCommentStruct?.comment_content else { return }
        contentTextView.text = comment
        row = Int(getCommentStruct?.comment_number ?? "0")
    }
}

extension communityPostCell {
    func setupLayout(){
        _userNameLabel(label: userNameLabel)
        _replayDateLabel(label: replayDateLabel)
        _contentTextView(textview: contentTextView)
        _grayLine(view: grayLine)
        _deleteBtn(button : deleteBtn)
    }
    
    func _userNameLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "송진우"
        label.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: topAnchor,constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    func _replayDateLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "2021-01-13"
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.textAlignment = .left

        label.topAnchor.constraint(equalTo: topAnchor,constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 15).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    func _contentTextView(textview : UITextView){
        addSubview(textview)
        textview.translatesAutoresizingMaskIntoConstraints = false
        
        textview.textColor = mainColor.hexStringToUIColor(hex: "#404040")
        textview.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        textview.textAlignment = .left
        textview.isEditable = false
        textview.isScrollEnabled = false
        textview.sizeToFit()
        
        textview.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 10).isActive = true
        textview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        textview.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20).isActive = true
        textview.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -20).isActive = true
    }
    func _deleteBtn(button : UIButton){
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        button.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        button.isHidden = true
        
        button.topAnchor.constraint(equalTo: userNameLabel.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func _grayLine(view: UIView){
        addSubview(view)
       
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
       
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
       
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}
