//
//  sefClassViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/23.
//

import UIKit

class selfClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "SELF 체육수업"
        setupLayout()
        
    }
    
    let todayClassBtn = UIButton()
    let todatLabel = UILabel()//오늘의 수업
    let recommendLabel = UILabel()//교육부 추천
    
    let customClassBtn = UIButton()
    let customLabel = UILabel()//나만의 조합 만들기
    

    let imageview1 = UIImageView()
    let imageview2 = UIImageView()
    
    
    @objc
    func todayClassBtnAction(){
        let vc = selfClassContentViewController()
        vc.title = "오늘의 수업"
        vc.view.backgroundColor = .white
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func customClassBtnAction(){
        let vc = selfClassCustomViewController()
        vc.title = "나만의 조합 만들기"
        vc.view.backgroundColor = .white
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension selfClassViewController{
    func setupLayout(){
        _todayClassBtn(button : todayClassBtn)
        _recommendLabel(label: recommendLabel)//교육부 추천
        
        _customClassBtn(button: customClassBtn)
        
        setLabel(label: todatLabel, button: todayClassBtn, text: "오늘의 수업", width: 100)
        setLabel(label: customLabel, button: customClassBtn, text: "나만의 조합 만들기", width: 150)
        
        _arrowImageview(imageview: imageview1, button: todayClassBtn)
        _arrowImageview(imageview: imageview2, button: customClassBtn)
        
    }
    
    func _todayClassBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(todayClassBtnAction), for: .touchUpInside)
        button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    func _recommendLabel(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "교육부 추천"
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 11)
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.backgroundColor = mainColor._3378fd
        label.layer.cornerRadius = 8
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        label.topAnchor.constraint(equalTo: self.todayClassBtn.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: self.todayClassBtn.leadingAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalToConstant: 90).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }//교육부 추천
    
    func _customClassBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(customClassBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.todayClassBtn.bottomAnchor,constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    func setLabel(label : UILabel, button : UIButton ,text : String, width : CGFloat){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = mainColor._3378fd
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        
        label.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 25).isActive = true
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    func _arrowImageview(imageview : UIImageView, button : UIButton){
        view.addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "arrow_right_box")
        imageview.contentMode = .scaleAspectFit
        
        imageview.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
        imageview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
