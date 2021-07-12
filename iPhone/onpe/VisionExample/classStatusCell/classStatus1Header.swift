//
//  classStatus1Header.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/02/22.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class classStatus1Header: UICollectionReusableView {
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
