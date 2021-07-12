//
//  termListViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/26.
//

import UIKit

class termListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    
    let serviceTermBtn = UIButton()
    let personalTermBtn = UIButton()
    
    let grayLine1 = UIView()
    let grayLine2 = UIView()
    
    let imageview1 = UIImageView()
    let imageview2 = UIImageView()
    
    @objc
    func serviceTermBtnAciton(){
        let vc = termContentViewController()
        vc.title = "서비스 이용약관"
        vc.view.backgroundColor = .white
        vc.getType = false
            
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func personalTermBtnAction(){
        let vc = termContentViewController()
        vc.title = "개인정보 처리 방침"
        vc.view.backgroundColor = .white
        vc.getType = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension termListViewController {
    func setupLayout(){
        _serviceTermBtn(button: serviceTermBtn)
        _grayLine1(uiview: grayLine1)
        
        _personalTermBtn(button: personalTermBtn)
        _grayLine2(uiview: grayLine2)
        
        _imageview1(imageview: imageview1)
        _imageview2(imageview: imageview2)
    }
    
    func _serviceTermBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("서비스 이용약관", for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(serviceTermBtnAciton), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.heightAnchor.constraint(equalToConstant:  60).isActive = true
    }
    func _personalTermBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("개인정보 처리 방침", for: .normal)
        button.setTitleColor(mainColor._404040, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(personalTermBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: grayLine1.topAnchor,constant: 0).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.heightAnchor.constraint(equalToConstant:  60).isActive = true
    }
    
    func _grayLine1(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: serviceTermBtn.bottomAnchor, constant: 0).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    func _grayLine2(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: personalTermBtn.bottomAnchor, constant: 0).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    func _imageview1(imageview : UIImageView){
        view.addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "blue_left")
        imageview.contentMode = .scaleAspectFit
        
        imageview.centerYAnchor.constraint(equalTo: serviceTermBtn.centerYAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: serviceTermBtn.trailingAnchor, constant: -10).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    func _imageview2(imageview : UIImageView){
        view.addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "blue_left")
        imageview.contentMode = .scaleAspectFit
        
        imageview.centerYAnchor.constraint(equalTo: personalTermBtn.centerYAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: personalTermBtn.trailingAnchor, constant: -10).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}
