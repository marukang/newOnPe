//
//  newsViewController.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/12.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class newsViewController: UIPageViewController, MyPageViewControllerDelegate {
    func currentViewCheck(result: Int) {
        print("스크롤 이동 : ",result)
        for btn in btnList{
            if result == btn.tag {
                //thePageVC.nextPageByIndex(index: sender.tag)
                btn.setTitleColor(mainColor._3378fd, for: .normal)
                btn.titleLabel?.font =  UIFont.NotoSansCJKkr(type: .medium, size: 15)
            } else {
                btn.setTitleColor(mainColor.hexStringToUIColor(hex: "404040"), for: .normal)
                btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        thePageVC.delegate1 = self
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    let totalNoticeBtn = UIButton()//관리자가 보낸 전체 공지사항
    let classNoticeBtn = UIButton()//클래스 공지사항
    let messageBtn = UIButton()//선생님이 학생에게 보낸 메세지
    let grayLine3 = UIView()
    
    var btnList : [UIButton] = []
    
    private let pageViewController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    //private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    var myContainerView = UIView()
    var thePageVC: MyPageViewController = MyPageViewController()
    
}
//MARK: - @objc 관련 함수
extension newsViewController {
    
    @objc
    func totalNoticeBtnAction(_ sender : UIButton){
        clickBtn(sender: sender)
        
    }
    @objc
    func classNoticeBtnAction(_ sender : UIButton){
        clickBtn(sender: sender)
    }
    @objc
    func messageBtnAction(_ sender : UIButton){
        clickBtn(sender: sender)
    }
    
    //클릭한 버튼만 시그니쳐 색이고 나머진 회색으로 변환
    func clickBtn(sender : UIButton){
        for btn in btnList{
            if sender == btn {
                thePageVC.nextPageByIndex(index: sender.tag)
                sender.setTitleColor(mainColor._3378fd, for: .normal)
                sender.titleLabel?.font =  UIFont.NotoSansCJKkr(type: .medium, size: 15)
            } else {
                btn.setTitleColor(mainColor.hexStringToUIColor(hex: "404040"), for: .normal)
                btn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
            }
        }
    }
    
}



extension newsViewController {
    func setupLayout(){
        
        
        _totalNoticeBtn(button : totalNoticeBtn)
        _classNoticeBtn(button : classNoticeBtn)
        _messageBtn(button : messageBtn)
        _grayLine3(uiview : grayLine3)
        
        btnList.removeAll()
        btnList.append(totalNoticeBtn)
        btnList.append(classNoticeBtn)
        btnList.append(messageBtn)
        _myContainerView()
        
    }
    
    
    
    func _totalNoticeBtn(button : UIButton){
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체 공지사항", for: .normal)
        button.setTitleColor(mainColor._3378fd, for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 15)
        button.addTarget(self, action: #selector(totalNoticeBtnAction), for: .touchUpInside)
        button.tag = 0
        
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _classNoticeBtn(button : UIButton){
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("학급 공지사항", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "404040"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
        button.addTarget(self, action: #selector(classNoticeBtnAction), for: .touchUpInside)
        button.tag = 1
        
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: totalNoticeBtn.trailingAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _messageBtn(button : UIButton){
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("선생님의 메시지", for: .normal)
        button.setTitleColor(mainColor.hexStringToUIColor(hex: "404040"), for: .normal)
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .normal, size: 15)
        button.addTarget(self, action: #selector(messageBtnAction), for: .touchUpInside)
        button.tag = 2
        
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: classNoticeBtn.trailingAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _grayLine3(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.messageBtn.bottomAnchor, constant: 0).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    func _myContainerView(){
        view.addSubview(myContainerView)
        myContainerView.backgroundColor = .white
        myContainerView.translatesAutoresizingMaskIntoConstraints = false
        // constrain it - here I am setting it to
        //  40-pts top, leading and trailing
        //  and 200-pts height
        NSLayoutConstraint.activate([
            myContainerView.topAnchor.constraint(equalTo: grayLine3.bottomAnchor, constant: 0),
            myContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            myContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            myContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
        // instantiate MyPageViewController and add it as a Child View Controller
        thePageVC = MyPageViewController()
        addChild(thePageVC)
        
        // we need to re-size the page view controller's view to fit our container view
        thePageVC.view.translatesAutoresizingMaskIntoConstraints = false
        thePageVC.view.backgroundColor = .white
        // add the page VC's view to our container view
        myContainerView.addSubview(thePageVC.view)
        
        // constrain it to all 4 sides
        NSLayoutConstraint.activate([
            thePageVC.view.topAnchor.constraint(equalTo: myContainerView.topAnchor, constant: 0.0),
            thePageVC.view.bottomAnchor.constraint(equalTo: myContainerView.bottomAnchor, constant: 0.0),
            thePageVC.view.leadingAnchor.constraint(equalTo: myContainerView.leadingAnchor, constant: 0.0),
            thePageVC.view.trailingAnchor.constraint(equalTo: myContainerView.trailingAnchor, constant: 0.0),
        ])
        
        thePageVC.didMove(toParent: self)
    }
    
}
protocol MyPageViewControllerDelegate {
    func currentViewCheck(result : Int)
}
// example Page View Controller
class MyPageViewController: UIPageViewController, totalNoticeViewControllerDelegate, teacherMessageViewControllerDelegate, classNoticeViewControllerDelegate {
    func totalNoticeViewWillAppear(result: Int) {
        delegate1?.currentViewCheck(result: result)
    }
    
    func teacherViewWillAppear(result: Int) {
        delegate1?.currentViewCheck(result: result)
    }
    
    func classNoticeViewWillAppear(result: Int) {
        delegate1?.currentViewCheck(result: result)
    }
    
    
    
    var pages: [UIViewController] = [UIViewController]()
    let totalNoticeView = totalNoticeViewController()
    let classNoticeView = classNoticeViewController()
    let teacherMessageView = teacherMessageViewController()
    var before_page : Int = 0//처음 선택한 변수(before_page)와 그다음 선택한변수(after_page)의 차이를 비교하기 위해 사용되는 변수
    var after_page : Int = 0//그다음 변수
    var delegate1 : MyPageViewControllerDelegate?
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        pages.removeAll()
        totalNoticeView.view.tag = 0
        classNoticeView.view.tag = 1
        teacherMessageView.view.tag = 2
        totalNoticeView.delegate = self
        classNoticeView.delegate = self
        teacherMessageView.delegate = self
        pages.append(self.totalNoticeView)
        pages.append(self.classNoticeView)
        pages.append(self.teacherMessageView)
        
        
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    func nextPageByIndex(index: Int)//pageViewController에 넣은 뷰컨트롤러 중 특정 컨트롤러로 이동하는 메서드.(didSelectItemAt 델리게이트에 사용됨)
    {
        //실행 예시 : 컬랙션뷰의 0,1,2 아이탬이 있을때 선택되어있는 셀이 0번이고, 이후에 1번 셀을 터치 했을때 페이지가 화면의 오른쪽에서 중앙으로 전환되고
        // 1번 셀이 선택되어있을때 0번 셀을 선택하면 페이지가 화면의 왼쪽에서 중앙으로 나타난다.
        //print("index : ",index)
        
        self.after_page = index
        print("갈 페이지 : ",after_page)
        print("이전 페이지 : ",before_page)
        if self.before_page == self.after_page {//category_collection_view의 같은 아이템을 클릭햇을 경우
        
            if before_page == 0, after_page == 0 {
                let nextWalkthroughVC = pages[0]
                setViewControllers([nextWalkthroughVC], direction: .reverse, animated: true, completion: nil)
            } else if before_page == 1, after_page == 1 {
                let nextWalkthroughVC = pages[1]
                setViewControllers([nextWalkthroughVC], direction: .reverse, animated: true, completion: nil)
            } else if before_page == 2, after_page == 2 {
                let nextWalkthroughVC = pages[2]
                setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
            }
        } else if self.before_page > self.after_page {//예) outer가 포커스되있는 상태에서 all을 선택했을 경우
            
            let nextWalkthroughVC = pages[index]
            setViewControllers([nextWalkthroughVC], direction: .reverse, animated: true, completion: nil)
            self.before_page = self.after_page
            //print("1")
        } else if self.before_page < self.after_page {//예) outer가 포커스 되있는 상태에서 top을 선택했을 경우
            
            let nextWalkthroughVC = pages[index]
            setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
            self.before_page = self.after_page
            //print("2")
        }
        

    }
    
}
// typical Page View Controller Data Source
extension MyPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {


        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            
            if viewControllerIndex == 0 {
                
                print("맨처음")
            } else {
                
                print("이전으로 가기 (before_page) : ",before_page)
                print("이전으로 가기 (after_page) : ",after_page)
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        

        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            
            
            if viewControllerIndex < self.pages.count - 1 {
                
                return self.pages[viewControllerIndex + 1]
            } else {
                
                print("맨끝")
                // wrap to first page in array
                
            }
        }
        return nil
    }
    
    
}
