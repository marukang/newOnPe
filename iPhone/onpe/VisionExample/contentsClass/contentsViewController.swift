//
//  contentsListViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/27.
//

import UIKit

class contentsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        // Do any additional setup after loading the view.
    }
    let contentsListBtn = UIButton()
    let contentsListLabel = UILabel()//커뮤니티
    
    let imageview1 = UIImageView()
    
    @objc
    func contentsListBtnAction(){
        let vc = contentsListViewController()
        vc.view.backgroundColor = .white
        vc.title = "콘텐츠관"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension contentsViewController {
    func setupLayout(){
        _contentsListBtn(button : contentsListBtn)
        
        setLabel(label: contentsListLabel, button: contentsListBtn, text: "콘텐츠관", width: 100)
        
        _arrowImageview(imageview: imageview1, button: contentsListBtn)
    }
    func _contentsListBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor._3378fd.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(contentsListBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
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
