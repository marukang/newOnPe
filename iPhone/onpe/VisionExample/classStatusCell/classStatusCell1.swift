//
//  classStatusCell1.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/21.
//

import UIKit

//동작별 현황
class classStatusCell1: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        _label()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label = UILabel()
    var indexpath : Int? {
        didSet{
            if let indexpath = indexpath {
                print("\(indexpath % 7)")
                print("\(getRecordList?.content_average_score!)")
            }
        }
    }
    var getRecordList : recordList?{
        didSet{
            
        }
    }
    
    
    func setLabelText(number : Int, getRecordList : recordList){
        if -1 < number, number < 6{
            switch number{
            case 0:
                label.text = "순서"
                break
            case 1:
                label.text = "종목"
                break
            case 2:
                label.text = "대분류"
                break
            case 3:
                label.text = "동작명"
                break
            case 4:
                //label.text = "평균점수"
                label.text = "개수"
                break
            case 5:
                //label.text = "개수"
                label.text = "이용시간(초)"
                break
                /*
            case 6:
                label.text = "이용시간"
                break
                */
            default:
                
                break
                
            }
        } else {
            if number % 6 == 0 {
                //순서
                label.text = "\(number / 6)"
            } else if number % 6 == 1{
                //종목
                label.text = "\(getRecordList.content_name!)"
            } else if number % 6 == 2 {
                //대분류
                label.text = "\(getRecordList.content_category!)"
            } else if number % 6 == 3 {
                //동작명
                label.text = "\(getRecordList.content_detail_name!)"
            } else if number % 6 == 4 {
                //평균 점수
                //label.text = "\(getRecordList.content_average_score!)"
                label.text = "\(getRecordList.content_count!)개"
            } else if number % 6 == 5 {
                //개수
                //label.text = "\(getRecordList.content_count!)개"
                label.text = "\(getRecordList.content_time!)"
            }/* else if number % 6 == 6 {
                //이용시간
                label.text = "\(getRecordList.content_time!)"
            }
            */
        }
        
        
    }
    
    
    func _label(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "순서"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 11)
        label.textColor = mainColor.hexStringToUIColor(hex: "#595959")
        label.textAlignment = .center
        label.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        label.layer.borderColor = mainColor.hexStringToUIColor(hex: "#dddddd").cgColor
        label.layer.borderWidth = 0.5
        label.clipsToBounds = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    }
}
