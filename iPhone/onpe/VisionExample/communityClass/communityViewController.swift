//
//  communityViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/25.
//

import UIKit

class communityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "SELF 체육수업"
        setupLayout()
        
    }
    
    let commnuintyListBtn = UIButton()
    let commnuintyListLabel = UILabel()//커뮤니티
    
    let messageListBtn = UIButton()
    let messageListLabel = UILabel()//메세지
    

    let imageview1 = UIImageView()
    let imageview2 = UIImageView()
    
    
    @objc
    func commnuintyListBtnAction(){
        if userInformationClass.student_classcodeNameList.count == 0 {
            let alert = UIAlertController(title: "온체육", message: "먼저 클래스에 가입해주세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            let vc = communityListViewController()
            vc.title = "학급 커뮤니티"
            vc.view.backgroundColor = .white
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc
    func messageListBtnAction(){
        if userInformationClass.student_classcodeNameList.count == 0 {
            let alert = UIAlertController(title: "온체육", message: "가입한 클래스가 없습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            let vc = messageListViewController()
            vc.title = "학급 메세지"
            vc.view.backgroundColor = .white
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}

extension communityViewController{
    
    func setupLayout(){
        _commnuintyListBtn(button : commnuintyListBtn)
        _messageListBtn(button: messageListBtn)
        
        setLabel(label: commnuintyListLabel, button: commnuintyListBtn, text: "학급 커뮤니티", width: 150)
        setLabel(label: messageListLabel, button: messageListBtn, text: "메세지", width: 60)
        
        _arrowImageview(imageview: imageview1, button: commnuintyListBtn)
        _arrowImageview(imageview: imageview2, button: messageListBtn)
        
    }
    
    func _commnuintyListBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(commnuintyListBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    
    
    func _messageListBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(messageListBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.commnuintyListBtn.bottomAnchor,constant: 20).isActive = true
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
