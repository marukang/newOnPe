//
//  tpwViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/13.
//


import UIKit

/**
 현재 페이지  : 인증 번호 입력하기
 다음 페이지 :  changePwViewController
 */
class tpwViewController: UIViewController {
    
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
        
        self.title = "PW 찾기"
        self.navigationController?.navigationBar.barTintColor = .white //- 상단 네비게이션 바 흰색으로 바꾸기
        self.navigationController?.navigationBar.tintColor = .black//뒤로가기 버튼 색 검은색
        self.valid_again_timer = myOperation2(minute: 1)
        self.timer.delegate = self
        self.valid_again_timer?.delegate = self
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBottomBorderColor(color: .systemGray6, height: 1)// 상단에 네비게이션 틀의 bottom에 색깔주기 이유
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer.start()
        valid_again_timer?.start()
        //timeThread(minute: 5)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.queue_toggle = true// operation 멈추기위해서 사용
        valid_again_timer?.queue_toggle = true// operation 멈추기 위해서 사용
        self.view.window?.endEditing(true)
        
        
        
    }
    //MARK: - ui 변수
    let uilabel = UILabel()//text.이메일로 전송 된 임시 비밀번호를 입력해주세요
    let timer_label = UILabel()
    let email_text_field = UITextField()
    let valid_code_again_btn = UIButton()
    
    let complete_btn = UIButton()//확인 버튼
    
    //MARK: - 일반변수
    var get_encrypt : String?
    {
        didSet
        {
            self.uilabel.text = "이메일로 전송 된 인증번호 6자리를 입력해주세요.\n\n\(self.get_encrypt ?? "")"
        }
    }
    var get_id : String?
    var get_name : String?
    var get_email : String?
    let timer = myOperation(minute: 5)// 인증번호 기입 제한 시간 설정
    var timer_toggler : Bool = false //해당 변수가 true가 된다면 올바른 인증번호를 입력하더라도 재시간 초과로 이전 페이지에서 다시 아이디, 이름, 이메일을 입력해야한다.
    var valid_again_timer : myOperation2?//인정번호 다시 보내기 버튼의 제한 시간 설정
    var valid_time_toggle : Bool = false
    
    
    
    
}
extension tpwViewController : myOperationDelegate, myOperationDelegate2
{
    func validTimeResult(time: String) {
        print(time)
        if time == "00:00"
        {
            //1분이 지나가면 valid_time_toggle = true을 입력시켜서 인증번호 재발급 받기 가능하게 만든다.
            self.valid_time_toggle = true
            self.valid_again_timer?.cancel()
        }
    }
    
    func timeResult(time: String) {
        OperationQueue().addOperation{
            OperationQueue.main.addOperation {
                self.timer_label.text = time
            }
        }
        if time == "00:00"
        {
            self.timer_toggler = true
        }
        
    }
    
    func textFieldDoneBtnMake(text_field : UITextField)
    {//텍스트 입력할시 키보드 위에 done 기능 구현
        let ViewForDoneButtonOnKeyboard = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        ViewForDoneButtonOnKeyboard.translatesAutoresizingMaskIntoConstraints = false
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    @objc func doneBtnFromKeyboardClicked(sender: Any)
    {//키보드 위에 done을 클릭하면 화면이 내려간다.
        self.view.endEditing(true)
    }
    @objc func completeButtonAction(_ sender : UIButton)
    {//이메일로 전송되 임시비밀번호를 입력하는 페이지로이동
        
        let vc = changePwViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        vc.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        if !self.timer_toggler{
            guard let id = self.get_id else { return }
            guard let certification_number = self.email_text_field.text else { return }
            
            /*
            let url = "https://fit-me.kr/for_mobile/mobile/email_certification_server_for_mobile.php"
            let parameter : Parameters = ["id": id, "certification_number": certification_number]
            AF.request(url, method: .post, parameters: parameter, headers: nil )
                .responseJSON
                {
                    response in
                    //debugPrint(response)
                    switch response.result
                    {
                    case .success(let value):
                        do {
                            let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let getInstanceData = try JSONDecoder().decode(memberCheck.self, from: dataJSon)
                            
                            if getInstanceData.result == "0"
                            {
                                extensionClass.showToast(message: "인증번호가 일치하지 않습니다.", font: .boldSystemFont(ofSize: 15), view: self.view)
                                
                            } else if getInstanceData.result == "1" {
                                let vc = changePasswordViewController()
                                let backItem = UIBarButtonItem()
                                backItem.title = ""
                                vc.navigationItem.backBarButtonItem = backItem
                                vc.get_id = self.get_id
                                vc.get_certification_number = certification_number
                                self.navigationController?.pushViewController(vc, animated: true)
                                print("일치.")
                            }
                        } catch {
                            
                        }
                        break
                    case .failure(let error):
                        print("error : ", error)
                        break
                    }
                }
            */
        } else {
            let alert = UIAlertController(title: "입력시간을 초과하셨습니다.", message: "다시 시도해주세요.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "뒤로가기", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true)
        }
    }
    @objc func validCodeAgainButtonAction(_ sender: UIButton)
    {
        if self.valid_time_toggle {
            guard let id = self.get_id else { return }
            guard let name = self.get_name else { return }
            guard let email = self.get_email else { return }
            /*
            let url = "https://fit-me.kr/for_mobile/mobile/find_pw_server_for_mobile.php"
            let parameter : Parameters = ["id": id, "name": name, "email" : email]
            AF.request(url, method: .post, parameters: parameter, headers: nil )
                .responseJSON
                {
                    response in
                    //debugPrint(response)
                    switch response.result
                    {
                    case .success(let value):
                        do {
                            let dataJSon = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                            let getInstanceData = try JSONDecoder().decode(findpw.self, from: dataJSon)
                            
                            if getInstanceData.result == "0"
                            {
                                extensionClass.showToast(message: "서버와의 연결이 불안합니다.", font: .boldSystemFont(ofSize: 15), view: self.view)
                                self.navigationController?.popViewController(animated: true)
                            } else if getInstanceData.result == "1" {
                                extensionClass.showToast(message: "서버와의 연결이 불안합니다.", font: .boldSystemFont(ofSize: 15), view: self.view)
                                self.navigationController?.popViewController(animated: true)
                                
                                
                            } else if getInstanceData.result == "2" {
                                self.valid_time_toggle = false
                                let valid_again_timer = myOperation2(minute: 1)
                                valid_again_timer.delegate = self
                                valid_again_timer.start()
                                extensionClass.showToast(message: "인증번호가 재발급 되었습니다.", font: .boldSystemFont(ofSize: 15), view: self.view)
                            }
                        } catch {
                            
                        }
                        break
                    case .failure(let error):
                        print("error : ", error)
                        break
                    }
                }
            */
            
            
            
        } else {
            extensionClass.showToast(view: self.view, message: "이메일을 다시 확인해주세요.", font: .boldSystemFont(ofSize: 15))
        }
    }
    
    
}

extension tpwViewController
{
    func setupLayout()
    {
        uiLabel ()//text.이메일로 전송 된 임시 비밀번호를 입력해주세요
        timerLabel()
        emailTextField ()
        validCodeAgainBtn()
        completeBtn ()//확인 버튼
    }
    func uiLabel ()//text.이메일로 전송 된 임시 비밀번호를 입력해주세요
    {
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.textColor = .black
        uilabel.numberOfLines = 0
        uilabel.textAlignment = .center
        
        uilabel.font = .boldSystemFont(ofSize: 15)
        
        self.view.addSubview(uilabel)
        uilabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.width * 0.08).isActive = true
        uilabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.05).isActive = true
        uilabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: self.view.frame.width * -0.05).isActive = true
        uilabel.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.25).isActive = true
        
    }
    func timerLabel()
    {
        timer_label.translatesAutoresizingMaskIntoConstraints = false
        timer_label.textAlignment = .center
        timer_label.textColor = .black
        timer_label.font = .boldSystemFont(ofSize: 20)
        timer_label.text = "05:00"
        self.view.addSubview(timer_label)
        
        timer_label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        timer_label.topAnchor.constraint(equalTo: self.uilabel.bottomAnchor,constant: 0).isActive = true
        
    }
    func emailTextField ()
    {
        email_text_field.translatesAutoresizingMaskIntoConstraints = false
        email_text_field.isSecureTextEntry = true
        email_text_field.textContentType = .newPassword
        email_text_field.textAlignment = .left
        email_text_field.textColor = .black
        email_text_field.font = .boldSystemFont(ofSize: 15)
        email_text_field.setLeftPaddingPoints(10)
        email_text_field.setRightPaddingPoints(10)
        email_text_field.layer.borderWidth = 1.5
        email_text_field.layer.cornerRadius = 10
        email_text_field.autocapitalizationType = .none
        email_text_field.layer.borderColor = UIColor.black.cgColor
        email_text_field.textAlignment = .center
        
        email_text_field.placeholder = "인능번호 6자리를 입력해주세요."
        textFieldDoneBtnMake(text_field: email_text_field)
        email_text_field.text = ""
        self.view.addSubview(email_text_field)
        
        email_text_field.topAnchor.constraint(equalTo: self.timer_label.bottomAnchor, constant: self.view.frame.width * 0.06).isActive = true
        email_text_field.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.08).isActive = true
        email_text_field.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: self.view.frame.width * -0.08).isActive = true
        email_text_field.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.125).isActive = true
        
    }
    func validCodeAgainBtn()
    {
        valid_code_again_btn.translatesAutoresizingMaskIntoConstraints = false
        valid_code_again_btn.setTitle("인증번호 다시 보내기", for: .normal)
        valid_code_again_btn.setTitleColor(.systemBlue, for: .normal)
        valid_code_again_btn.titleLabel?.font = .systemFont(ofSize: 13)
        valid_code_again_btn.addTarget(self, action: #selector(validCodeAgainButtonAction(_:)), for: .touchUpInside)
        view.addSubview(valid_code_again_btn)
        
        valid_code_again_btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        valid_code_again_btn.topAnchor.constraint(equalTo: self.email_text_field.bottomAnchor,constant: 15).isActive = true
    }
    func completeBtn ()//확인 버튼
    {
        complete_btn.translatesAutoresizingMaskIntoConstraints = false
        complete_btn.backgroundColor = .black
        complete_btn.setTitleColor(.white, for: .normal)
        complete_btn.setTitle("확인", for: .normal)
        complete_btn.titleLabel?.font = .systemFont(ofSize: 15)
        complete_btn.layer.cornerRadius = 10
        complete_btn.addTarget(self, action: #selector(completeButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(complete_btn)
        
        complete_btn.topAnchor.constraint(equalTo: valid_code_again_btn.bottomAnchor, constant: 15).isActive = true
        complete_btn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant : self.view.frame.width * 0.08).isActive = true
        complete_btn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant : self.view.frame.width * -0.08).isActive = true
        complete_btn.heightAnchor.constraint(equalToConstant: self.view.frame.width * 0.125).isActive = true
    }
}

//시간이 흘러간 값을 temporaryPasswordVidwController로 보내주는 프로토콜
protocol myOperationDelegate {
    func timeResult(time : String)
}
//시간초 타이머 오퍼레이션
class myOperation : Operation {
    
    var minute : Int?
    var result : String?
    var delegate : myOperationDelegate?
    var queue_toggle : Bool = false
    
    init(minute : Int) {
        self.minute = minute
    }
    
    override func main() {
        var minute : Int = self.minute ?? 1
        let seconds : Int = 60 * (self.minute ?? 1)
        let minute_down : Int = 1
        var seconds_down : Int = 60
        
        if self.isCancelled {return}
        
        OperationQueue().addOperation {
            for i in 0...seconds {
                Thread.sleep(forTimeInterval: 1)
                let countDown = seconds - i
                seconds_down = seconds_down - 1
                if countDown % 60 == 0 {
                    minute = minute - minute_down
                    if i == seconds
                    {
                        self.result = "00:00"
                        
                    } else if seconds_down == 0 {
                        self.result = "0\(minute):00"
                    } else {
                        
                        self.result = "0\(minute):\(seconds_down)"
                    }
                    seconds_down = 60
                    
                } else {
                    if seconds_down < 10 {
                        
                        self.result = "0\(minute):0\(seconds_down)"
                    } else {
                        
                        self.result = "0\(minute):\(seconds_down)"
                    }
                    
                }
                if self.queue_toggle {
                    print("queue1 멈춤")
                    return
                }
                self.delegate?.timeResult(time: self.result ?? "00:00")
                
                if self.result == "00:00"{ return }
                //print("op2 (🐶) working....")
                
            }//for문
        }
    }
}// class
//시간이 흘러간 값을 temporaryPasswordVidwController로 보내주는 프로토콜
protocol myOperationDelegate2 {
    func validTimeResult(time : String)
}
//시간초 타이머 오퍼레이션
class myOperation2 : Operation {
    
    var minute : Int?
    var result : String?
    var delegate : myOperationDelegate2?
    var queue_toggle : Bool = false
    
    init(minute : Int) {
        self.minute = minute
    }
    
    override func main() {
        var minute : Int = self.minute ?? 1
        let seconds : Int = 60 * (self.minute ?? 1)
        let minute_down : Int = 1
        var seconds_down : Int = 60
        
        if self.isCancelled {return}
        
        OperationQueue().addOperation {
            for i in 0...seconds {
                Thread.sleep(forTimeInterval: 1)
                let countDown = seconds - i
                seconds_down = seconds_down - 1
                if countDown % 60 == 0 {
                    minute = minute - minute_down
                    if i == seconds
                    {
                        self.result = "00:00"
                        
                    } else if seconds_down == 0 {
                        self.result = "0\(minute):00"
                    } else {
                        
                        self.result = "0\(minute):\(seconds_down)"
                    }
                    seconds_down = 60
                    
                } else {
                    if seconds_down < 10 {
                        
                        self.result = "0\(minute):0\(seconds_down)"
                    } else {
                        
                        self.result = "0\(minute):\(seconds_down)"
                    }
                    
                }
                if self.queue_toggle {
                    print("queue2 멈춤")
                    return
                }
                self.delegate?.validTimeResult(time: self.result ?? "00:00")
                
                if self.result == "00:00"{ return }
//                print("op2 (🐶) working....")
                
            }//for문
        }
    }
}// class

