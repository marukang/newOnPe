//
//  loginViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/12.
//

import UIKit
import Alamofire
class loginViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "온체육"

        let deviceType = UIDevice().type
        let deviceModel = deviceType.rawValue
        sizetheFitsControlByDevice(deviceType: deviceModel)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        AF.delegate0 = self
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.window?.endEditing(true)
         
    }
    //MARK: - 레이아웃 오브젝트
    let scroll_view : UIScrollView = UIScrollView()
    let app_title_label = UIImageView()
    let notice_label = UILabel()
    let id_label = UIButton()
    let id_text_field = UITextField()
    let password_label = UIButton()
    let password_text_field = UITextField()
    let find_id_btn = UIButton()
    let grey_line3 = UIView()
    let find_password_btn = UIButton()
    let login_recommend_label = UILabel()
    let login_btn = UIButton()
    let join_btn = UIButton()
    var labelTopContent : CGFloat = 0
    
    //let session = KOSession.shared()
    //MARK: - 일반변수
    var joiner_id : String?
    
    var location_result_dic : [[String : CGFloat]] = [[:]]
    var user_image_url_array : [String] = []
    var like_produdct_key_list : [String] = []
    var favorite_shop_list : [String] = []
    
    let AF = ServerConnectionLegacy()
    
    
    func sizetheFitsControlByDevice(deviceType : String)
    {
        
        if deviceType == "iPhone 8" || deviceType == "iPhone 7" || deviceType == "iPhone 6" || deviceType == "iPhone 6S"
        {
            
            labelTopContent = 16
            
        } else if deviceType == "iPhone 11" || deviceType == "iPhone XR"  {
            
            labelTopContent = 20
        } else if deviceType == "iPhone 6 Plus" || deviceType == "iPhone 6S Plus" || deviceType == "iPhone 7 Plus" || deviceType == "iPhone 8 Plus" {
            
            labelTopContent = 20
        } else if deviceType == "iPhone 11 Pro Max" || deviceType == "iPhone XS Max" {
            
            labelTopContent = 20
        } else if deviceType == "iPhone 11 Pro" || deviceType == "iPhone X" || deviceType == "iPhone XS"  {
            
            labelTopContent = 20
        } else {
            let device : String = UIDevice.current.name
            print(device)
            if device == "iPhone 12 Pro" || device == "iPhone 12" || device == "iPhone 12 Pro Max" || deviceType == "iPhone 12 mini"{
            
                labelTopContent = 20
            } else {
            
                labelTopContent = 10
            }
        }
    }

}
extension loginViewController : AppLoginDelegate {
    func appLogin(result: Int) {
        print(result)
        
    }
}

extension loginViewController {
    
    func textFieldDoneBtnMake(text_field : UITextField)
    {//텍스트 입력할시 키보드 위에 done 기능 구현
        let ViewForDoneButtonOnKeyboard = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        ViewForDoneButtonOnKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnFromKeyboardClicked(_:)))
        
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        ViewForDoneButtonOnKeyboard.sizeToFit()
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    @objc
    func doneBtnFromKeyboardClicked(_ sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
        
        self.view.endEditing(true)
    }
    
    @objc
    func loginButtonAction(_ sender : UIButton){
        
        //let url : String = "https://lllloooo.shop/app/login"
        //let parameters : [String : String] = ["id" : id, "password" : password]
        let id = id_text_field.text ?? ""
        let pw = password_text_field.text ?? ""
        
        if 3 < password_text_field.text?.count ?? 0 {
            
            AF.appLogin(student_id: id, student_password: pw, url: "app/login", { result in
                weak var strongSelf = self
                
                if let result = result {
                    if result == 0 {
                        
                        let vc = ViewController1()
                        let navController = UINavigationController(rootViewController: vc)
                        navController.modalPresentationStyle = .fullScreen
                        strongSelf?.present(navController, animated: true, completion: nil)
                        
                    } else if result == 1 {
                        extensionClass.showToast(view: strongSelf?.view ?? self.view, message: "아이디 또는 패스워드가 일치하지 않습니다.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                    } else {
                        extensionClass.showToast(view: strongSelf?.view ?? self.view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
                    }
                }
                
            })
        } else {
            extensionClass.showToast(view: view, message: "아이디 또는 비밀번호를 입력해주세요.", font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
        }
        
    }
    
    @objc
    func joinButtonAction(){
        
        let vc = join1ViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @objc
    func findIdButtonAction(){
        
        let vc = idFindViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated : true)
        
    }
    @objc
    func findPasswordButtonAction(){
        
        let vc = pwFindViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated : true)
    }
}

extension loginViewController{
    func setupLayout()
    {
        scrollView()
        appTitleImageview()
        noticeLabel()
        
        idTextField()
        idLabel()
        
        
        passwordTextField()
        passwordLabel()
        
        
        
        
        findPasswordBtn()
        greyLine3()
        findIdBtn()
        
        loginRecommendLabel()
        
        joinBtn()
        
        loginBtn()
        
    }
    func scrollView()
    {
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        scroll_view.showsVerticalScrollIndicator = false
        scroll_view.isScrollEnabled = true
        view.addSubview(scroll_view)
        
        scroll_view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll_view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scroll_view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scroll_view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scroll_view.contentSize = .init(width: self.view.frame.width, height: self.view.frame.height * 1.1)
    }
    func appTitleImageview()
    {
        
        app_title_label.translatesAutoresizingMaskIntoConstraints = false
        /*
        app_title_label.text = "온체육"
        app_title_label.textAlignment = .left
        app_title_label.textColor = mainColor._3378fd
        app_title_label.font = UIFont.NotoSansCJKkr(type: .medium, size: 40)
        */
        app_title_label.image = #imageLiteral(resourceName: "login_logo")
        app_title_label.contentMode = .scaleAspectFit
        scroll_view.addSubview(app_title_label)
        
        app_title_label.topAnchor.constraint(equalTo: self.scroll_view.topAnchor, constant: self.view.frame.width * 0.15).isActive = true
        app_title_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.08).isActive = true
        app_title_label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        app_title_label.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func noticeLabel(){
        
        notice_label.translatesAutoresizingMaskIntoConstraints = false
        notice_label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        notice_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 20)
        notice_label.textAlignment = .left
        notice_label.text = "온 국민이 즐기는 인공지능 체육수업"
        scroll_view.addSubview(notice_label)
        
        notice_label.topAnchor.constraint(equalTo: self.app_title_label.bottomAnchor).isActive = true
        notice_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.08).isActive = true
        notice_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: self.view.frame.width * -0.08).isActive = true
    }
    
    func idTextField(){
        id_text_field.translatesAutoresizingMaskIntoConstraints = false
        id_text_field.textAlignment = .left
        id_text_field.textColor = mainColor._3378fd
        id_text_field.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        id_text_field.layer.borderWidth = 1.5
        id_text_field.layer.borderColor = mainColor._3378fd.cgColor
        id_text_field.layer.cornerRadius = 10
        id_text_field.setLeftPaddingPoints(20)
        id_text_field.setRightPaddingPoints(20)
        
        
        textFieldDoneBtnMake(text_field: id_text_field)
        id_text_field.returnKeyType = .done
        
        scroll_view.addSubview(id_text_field)
        
        id_text_field.topAnchor.constraint(equalTo: self.notice_label.bottomAnchor, constant: 71).isActive = true
        id_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.08).isActive = true
        id_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: self.view.frame.width * -0.08).isActive = true
        id_text_field.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.14).isActive = true
    }
    
    func idLabel(){
        id_label.translatesAutoresizingMaskIntoConstraints = false
        id_label.setTitle("아이디 입력", for: .normal)
        id_label.backgroundColor = .white
        id_label.setTitleColor(mainColor._3378fd, for: .normal)
        id_label.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        id_label.setImage(#imageLiteral(resourceName: "blue_person"), for: .normal)
        id_label.imageView?.contentMode = .scaleAspectFit
        id_label.imageEdgeInsets = .init(top: 10, left: -5, bottom: 10, right: 0)
        id_label.sizeToFit()
        scroll_view.addSubview(id_label)
        
        id_label.bottomAnchor.constraint(equalTo: self.id_text_field.topAnchor, constant: labelTopContent).isActive = true
        id_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.12).isActive = true
        id_label.widthAnchor.constraint(equalToConstant: 94).isActive = true
        id_label.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.05).isActive = true
    }
    
    
    func passwordTextField()
    {
        password_text_field.translatesAutoresizingMaskIntoConstraints = false
        password_text_field.textAlignment = .left
        password_text_field.textColor = mainColor._3378fd
        password_text_field.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        password_text_field.layer.borderWidth = 1.5
        password_text_field.layer.borderColor = mainColor._3378fd.cgColor
        password_text_field.layer.cornerRadius = 10
        password_text_field.setLeftPaddingPoints(20)
        password_text_field.setRightPaddingPoints(20)
        password_text_field.isSecureTextEntry = true
        password_text_field.textContentType = .newPassword
        textFieldDoneBtnMake(text_field: password_text_field)
        password_text_field.returnKeyType = .done
        scroll_view.addSubview(password_text_field)
        
        password_text_field.topAnchor.constraint(equalTo: self.id_text_field.bottomAnchor, constant: 36).isActive = true
        password_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.08).isActive = true
        password_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: self.view.frame.width * -0.08).isActive = true
        password_text_field.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.14).isActive = true
    }
    func passwordLabel()
    {
        password_label.translatesAutoresizingMaskIntoConstraints = false
        password_label.setTitle("비밀번호 입력", for: .normal)
        password_label.backgroundColor = .white
        password_label.setTitleColor(mainColor._3378fd, for: .normal)
        password_label.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        password_label.setImage(#imageLiteral(resourceName: "login_page_lock"), for: .normal)
        password_label.imageView?.contentMode = .scaleAspectFit
        password_label.imageEdgeInsets = .init(top: 10, left: -5, bottom: 10, right: 0)
        password_label.sizeToFit()
        scroll_view.addSubview(password_label)

        password_label.bottomAnchor.constraint(equalTo: self.password_text_field.topAnchor, constant: labelTopContent).isActive = true
        password_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.12).isActive = true
        password_label.widthAnchor.constraint(equalToConstant: 110).isActive = true
        password_label.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.05).isActive = true
    }
    
    func loginBtn()
    {
        login_btn.translatesAutoresizingMaskIntoConstraints = false
        login_btn.setTitle("로그인", for: .normal)
        login_btn.backgroundColor = mainColor._3378fd
        login_btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        login_btn.setTitleColor(.white, for: .normal)
        
        login_btn.addTarget(self, action: #selector(loginButtonAction(_:)), for: .touchUpInside)
        
        scroll_view.addSubview(login_btn)
        login_btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        login_btn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        login_btn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        login_btn.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.18).isActive = true
    }
    
    func findPasswordBtn()
    {
        find_password_btn.translatesAutoresizingMaskIntoConstraints = false
        find_password_btn.setTitle("비밀번호 찾기", for: .normal)
        find_password_btn.backgroundColor = .white
        find_password_btn.setTitleColor(mainColor.hexStringToUIColor(hex: "#797979"), for: .normal)
        find_password_btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
        find_password_btn.addTarget(self, action: #selector(findPasswordButtonAction), for: .touchUpInside)
        
        
        scroll_view.addSubview(find_password_btn)
        find_password_btn.topAnchor.constraint(equalTo: self.password_text_field.bottomAnchor, constant : self.view.frame.width * 0.02).isActive = true
        
        find_password_btn.trailingAnchor.constraint(equalTo: self.password_text_field.trailingAnchor, constant: 0).isActive = true
        find_password_btn.widthAnchor.constraint(equalToConstant: 90).isActive = true
        find_password_btn.heightAnchor.constraint(equalToConstant: 23).isActive = true
    }
    func greyLine3()
    {
        grey_line3.translatesAutoresizingMaskIntoConstraints = false
        grey_line3.backgroundColor = mainColor.hexStringToUIColor(hex: "#797979")
        grey_line3.layer.cornerRadius = 0.5 * 4
        scroll_view.addSubview(grey_line3)
        
        
        grey_line3.centerYAnchor.constraint(equalTo: self.find_password_btn.centerYAnchor).isActive = true
        grey_line3.trailingAnchor.constraint(equalTo: self.find_password_btn.leadingAnchor, constant: -5).isActive = true
        grey_line3.widthAnchor.constraint(equalToConstant: 4).isActive = true
        grey_line3.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    func findIdBtn()
    {
        find_id_btn.translatesAutoresizingMaskIntoConstraints = false
        find_id_btn.setTitle("아이디 찾기", for: .normal)
        find_id_btn.backgroundColor = .white
        find_id_btn.setTitleColor(mainColor.hexStringToUIColor(hex: "#797979"), for: .normal)
        find_id_btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
        find_id_btn.addTarget(self, action: #selector(findIdButtonAction), for: .touchUpInside)
        
        scroll_view.addSubview(find_id_btn)
        find_id_btn.topAnchor.constraint(equalTo: self.find_password_btn.topAnchor, constant : 0).isActive = true
        find_id_btn.bottomAnchor.constraint(equalTo: self.find_password_btn.bottomAnchor).isActive = true
        find_id_btn.trailingAnchor.constraint(equalTo: self.grey_line3.leadingAnchor, constant: -1).isActive = true
        find_id_btn.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    func loginRecommendLabel(){
        login_recommend_label.translatesAutoresizingMaskIntoConstraints = false
        login_recommend_label.text = "아직 회원이 아니신가요?"
        login_recommend_label.textAlignment = .center
        login_recommend_label.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        login_recommend_label.textColor = mainColor._3378fd
        
        scroll_view.addSubview(login_recommend_label)
        
        login_recommend_label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        login_recommend_label.topAnchor.constraint(equalTo: self.find_id_btn.bottomAnchor,constant: 80).isActive = true
        login_recommend_label.widthAnchor.constraint(equalToConstant: 170).isActive = true
        login_recommend_label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    func joinBtn()
    {
        join_btn.translatesAutoresizingMaskIntoConstraints = false
        join_btn.setTitle("회원가입", for: .normal)
        join_btn.backgroundColor = .white
        join_btn.setTitleColor(mainColor._3378fd, for: .normal)
        join_btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 16)
        join_btn.layer.cornerRadius = 8
        join_btn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.systemGray2, radius: 2.0, opacity: 0.35)
        join_btn.addTarget(self, action: #selector(joinButtonAction), for: .touchUpInside)
        
        scroll_view.addSubview(join_btn)
        join_btn.topAnchor.constraint(equalTo: self.login_recommend_label.bottomAnchor, constant : 15).isActive = true
        join_btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        join_btn.widthAnchor.constraint(equalToConstant: 140).isActive = true
        join_btn.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
}
