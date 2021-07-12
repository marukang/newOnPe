//
//  contentsListCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/27.
//

import UIKit
import YoutubePlayer_in_WKWebView

class contentsListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        //https://www.youtube.com/watch?v=lS6jQ8dBjdw
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let writerLabel = UILabel()//작성자 : 홍길동
    let uploadLabel = UILabel()//작성일 : 2021-01-13
    let playerView = WKYTPlayerView()
    let grayline1 = UIView()
    var contentBool = false
    var content : Content?{
        didSet{
            //setupContent()
            
        }
    }
    
    public func setupContent(){
        let youtubeUrl = content?.content_youtube_url
        //https://youtu.be/daZ8pPgnCPw
        guard let id = content?.content_id else { return }
        guard let date = content?.content_date else { return }
        var youtubeId : [String] = []
        youtubeId.removeAll()
        var idType : Int = 1
        for value in youtubeUrl ?? ""{
            if value == "="{
                idType = 0
                break
            }
        }
        let playVarsDic = ["playsinline": 1]
        if idType == 0 {
            
            playerView.load(withVideoId: "\(extensionClass.youtubeUrlId(url: youtubeUrl!))", playerVars: playVarsDic)
            
        } else {
            playerView.load(withVideoId: "\(youtubeUrl!.split(separator: "/")[2])", playerVars: playVarsDic)
        }
        
        writerLabel.text = "작성자 : \(id)"
        uploadLabel.text = "작성일 : \(extensionClass.DateToString(date: date,type: 0))"
        //let youtubeId = youtubeUrl?.split(separator: "=")
        
    }
}

extension contentsListCell {
    func setupLayout(){
        _writerLabel(label: writerLabel)//작성자 : 홍길동
        _uploadLabel(label: uploadLabel)//작성일 : 2021-01-13
        _playerView()
        _grayline1(view : grayline1)
    }
    
    func _writerLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "작성자 : 홍길동"
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.textAlignment = .left
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
    }//작성자 : 홍길동
    func _uploadLabel(label : UILabel){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "작성일 : 2021-01-13"
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 13)
        label.textAlignment = .right
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }//작성일 : 2021-01-13
    func _playerView(){
        addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.topAnchor.constraint(equalTo: uploadLabel.bottomAnchor, constant: 10).isActive = true
        playerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: frame.width * 0.5625).isActive = true
    }
    func _grayline1(view : UIView){
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        view.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
}
