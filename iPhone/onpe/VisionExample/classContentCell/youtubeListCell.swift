//
//  youtubeListCell.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/03.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
class youtubeListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var getUrl : String?{
        didSet{
            //32~43
            if !youtubeLoadingBool{
                youtubeLoadingBool = true
                var idType :Int = 1
                for value in getUrl ?? "" {
                    if value == "="{
                        idType = 0
                        break
                    }
                }
                if idType == 0 {
                    getUrl = extensionClass.youtubeUrlId(url: getUrl ?? "")
                    let playVarsDic = ["playsinline": 1]
                    print(getUrl!)
                    youtbuePlayer.load(withVideoId: getUrl!, playerVars: playVarsDic)
                } else {
                    if let url = getUrl {
                        getUrl = "\(url.split(separator: "/")[2])"
                        let playVarsDic = ["playsinline": 1]
                        print(getUrl!)
                        youtbuePlayer.load(withVideoId: getUrl!, playerVars: playVarsDic)
                    }
                    
                }
                
            }
        }
    }
    var youtubeLoadingBool = false
    let youtbuePlayer = WKYTPlayerView()//유뷰트 영상 뷰
    
    func setupLayout(){
        _youtbuePlayer()
    }
    func _youtbuePlayer(){
        addSubview(youtbuePlayer)
        
        youtbuePlayer.translatesAutoresizingMaskIntoConstraints = false
        
        youtbuePlayer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        youtbuePlayer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        youtbuePlayer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        youtbuePlayer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
}
