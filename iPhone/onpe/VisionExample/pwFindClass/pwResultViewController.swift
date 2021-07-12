//
//  pwResultViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/13.
//

import UIKit
/**
 현재 페이이지 : 비밀번호 입력완료
 다음 페이지 ->  loginViewController
 */
class pwResultViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //블랙모드 방지
        overrideUserInterfaceStyle = .light
        /*
         - 무슨 기기인지 알아보는 코드
         */
        let deviceType = UIDevice().type
        let _ = deviceType.rawValue
        self.navigationController?.navigationBar.barTintColor = .white //- 상단 네비게이션 바 흰색으로 바꾸기
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)// 상단에 네비게이션 틀의 bottom에 색깔주기 이유
        self.navigationController?.navigationBar.tintColor = .black//뒤로가기 버튼 색 검은색
        setupLayout()
    }
    
    let imageview = UIImageView()
    let label1 = UILabel()//회원가입이 완료되었습니다.
    let label2 = UILabel()//온 국민이 즐기는 인공지능 체육수업
    let goTologinBtn = UIButton()//로그인 하러 가기
    
}
extension pwResultViewController {
    @objc func joinButtonAction()
    {
        let vc = loginViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
        /*
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        */
    }
}
extension pwResultViewController
{
    func setupLayout(){
        
        _imageview(imageview1: imageview)
        _label1(label: label1)//회원가입이 완료되었습니다.
        _label2(label: label2)//온 국민이 즐기는 인공지능 체육수업
        _goTologinBtn(button: goTologinBtn)//로그인 하러 가기
        
    }
    func _imageview(imageview1 : UIImageView){
        view.addSubview(imageview1)
        imageview1.translatesAutoresizingMaskIntoConstraints = false
        imageview1.image = #imageLiteral(resourceName: "circle_blue_check")
        imageview1.contentMode = .scaleAspectFit
        
        imageview1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        imageview1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageview1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageview1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func _label1(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "비밀번호 변경이 완료되었습니다."
        label.textAlignment = .center
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 25)
        label.textColor = mainColor._3378fd
        
        label.topAnchor.constraint(equalTo: self.imageview.bottomAnchor, constant: 45).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 420).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }//회원가입이 완료되었습니다.
    func _label2(label : UILabel){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "회원님의 아이디는 test입니다."
        label.textAlignment = .center
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        
        label.topAnchor.constraint(equalTo: self.label1.bottomAnchor, constant: 12).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }//온 국민이 즐기는 인공지능 체육수업
    func _goTologinBtn(button : UIButton){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인하러 가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor._3378fd
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize3)
        button.addTarget(self, action: #selector(joinButtonAction), for: .touchUpInside)
        
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
    }//로그인 하러 가기
}

