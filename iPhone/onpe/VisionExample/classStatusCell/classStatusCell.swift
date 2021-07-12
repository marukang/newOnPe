//
//  classStatusCellCollectionViewCell.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/21.
//

import UIKit

//차시별 수업 현황
class classStatusCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        _label()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label = UITextView()
    var indexpathRow : Int = 0
    var setUnitList : [UnitList]?{
        didSet{
            if setUnitList != nil {
                //var unitType = 0
                
                if let data = setUnitList![0].content_code_list?.data(using: .utf8){
                    do {
                        var textStr = "출석 : Y\n"
                        let getResult = try JSONDecoder().decode([unitContent].self, from: data)
                        for value in getResult{
                            if let name = value.content_name{
                                textStr = textStr + name + " : Y" + "\n"
                            }
                            
                            //print(contentCodeList)
                        }
                        let style = NSMutableParagraphStyle()
                        style.lineSpacing = 20
                        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)]
                        label.attributedText = NSAttributedString(string: textStr, attributes: attributes as [NSAttributedString.Key : Any])
                        //label.text = textStr
                        
                    } catch let error {
                        print(error)
                    }
                }
            }
            
        }
    }
    func _label(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "출석 Y"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        label.textColor = mainColor.hexStringToUIColor(hex: "#595959")
        label.isEditable = false
    
        label.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    }
    
    
}
