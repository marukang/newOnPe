//
//  CollectionViewCell.swift
//  newNavigation
//
//  Created by Ik ju Song on 2021/01/12.
//

import UIKit
import SDWebImage
protocol sideMenuCellDelegate {
    func selectSideMenu(pagePosition : Int)
}

class sideMenuCell: UICollectionViewCell {
    let scrollView = UIScrollView()
    let topSpaceView = UIView()
    let backBtn = UIButton()
    let newNofiyBtn = UIButton()//새소식
    let newMessageBtn = UIButton()//메시지함
    
    let userProfileImage = UIImageView()//이용자 프로필
    let userNameLabel = UILabel()//이용자 이름
    let userLastJoinLabel = UILabel()//이용자가 마지막으로 운동한 날
    let classJoinLabel = UILabel()//수업 참여하기
    let classJoinArrowBtn = UIButton()// 수업 참여하기 리스트 올렸다 내렸다 하는 버튼
    var collectionviewIsHiden = false// false -> 수업 펼치기, true -> 수업 숨기기
    let classListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var collectionviewNC : NSLayoutConstraint?
    //중간에 수업 리스트 나오는 컬랙션뷰
    
    let classList : [String] = ["이지영 영어수업","홍길동 체육수업","김태희 수학수업","놀기","수영하기"]
    
    
    
    let totalClassBtn = UIButton()//전체수업 보기
    let mypageBtn = UIButton()//마이페이지
    let afterCalssBtn = UIButton()//self 체육수업
    let contentPlaygroundBtn = UIButton()//방과 후 활동
    
    let communityBtn = UIButton()//커뮤니티
    let settingBtn = UIButton()//환경설정
    let qnaBtn = UIButton()//자주 묻는 질문
    
    let fotterLabel = UILabel()
    
    var sideMenuFotterContent : CGFloat = 0
    
    
    var delegate : sideMenuCellDelegate?
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        overrideUserInterfaceStyle = .light
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
    
    func setupLayout(){
        _scrollView()
        _topSpaceView()
        _backBtn()
        _newMessageBtn()
        _newNofiyBtn()
        
        _userProfileImage()
        _userNameLabel(label: userNameLabel)
        _userLastJoinLabel(label: userLastJoinLabel)
        _classJoinLabel(label : classJoinLabel)
        //_classJoinArrowBtn()
        //_classListCollectionview()
        
        
        
        //_totalClassBtn()//전체수업 보기
        _mypageBtn()//마이페이지
        //_afterCalssBtn()//self 체육수업
        //_contentPlaygroundBtn()//방과 후 활동
        _communityBtn(button : self.communityBtn)
        _settingBtn(button: self.settingBtn)
        //_qnaBtn(button: self.qnaBtn)
        _fotterLabel(label: fotterLabel)
        
        
    }
    func _scrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        self.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        scrollView.contentSize = .init(width: self.frame.width, height: self.frame.height * 1.1)
    }
    
    func _topSpaceView(){
        scrollView.addSubview(topSpaceView)
        
        topSpaceView.translatesAutoresizingMaskIntoConstraints = false
        topSpaceView.backgroundColor = .white
        
        topSpaceView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        topSpaceView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topSpaceView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topSpaceView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    func _backBtn(){
        scrollView.addSubview(backBtn)
        
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        
        backBtn.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backBtn.contentMode = .scaleAspectFit
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        backBtn.topAnchor.constraint(equalTo: topSpaceView.bottomAnchor).isActive = true
        backBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func _newMessageBtn(){
        self.scrollView.addSubview(newMessageBtn)
        newMessageBtn.translatesAutoresizingMaskIntoConstraints = false
        
        newMessageBtn.backgroundColor = .white
        newMessageBtn.clipsToBounds = true
        newMessageBtn.layer.cornerRadius = 4
        newMessageBtn.setImage(#imageLiteral(resourceName: "sidemenu_message"), for: .normal)
        newMessageBtn.addTarget(self, action: #selector(newMessageBtnAction), for: .touchUpInside)
        
        newMessageBtn.topAnchor.constraint(equalTo: self.self.topSpaceView.bottomAnchor).isActive = true
        newMessageBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        newMessageBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        newMessageBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    func _newNofiyBtn(){
        self.scrollView.addSubview(newNofiyBtn)
        newNofiyBtn.translatesAutoresizingMaskIntoConstraints = false
        newNofiyBtn.clipsToBounds = true
        newNofiyBtn.layer.cornerRadius = 4
        newNofiyBtn.setImage(#imageLiteral(resourceName: "sidemenu_news"), for: .normal)
        newNofiyBtn.addTarget(self, action: #selector(newNofiyBtnAction), for: .touchUpInside)
        newNofiyBtn.isHidden = true
        
        newNofiyBtn.topAnchor.constraint(equalTo: self.topSpaceView.bottomAnchor).isActive = true
        newNofiyBtn.trailingAnchor.constraint(equalTo: self.newMessageBtn.leadingAnchor,constant: -10).isActive = true
        newNofiyBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        newNofiyBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
    }
    
    func _userProfileImage(){
        scrollView.addSubview(userProfileImage)
        
        userProfileImage.translatesAutoresizingMaskIntoConstraints = false
        
        if userInformationClass.student_image_url != "" {
            
            self.userProfileImage.sd_setImage(with: URL(string: userInformationClass.student_image_url), completed: nil)
        } else {
            self.userProfileImage.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal)
        }
        userProfileImage.contentMode = .scaleAspectFill
        
        userProfileImage.clipsToBounds = true
        userProfileImage.layer.masksToBounds = true
        userProfileImage.backgroundColor = .systemGray4
        userProfileImage.layer.cornerRadius = 10
        userProfileImage.layer.shadowColor = UIColor.black.cgColor
        //userProfileImage.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.systemGray2, radius: 2.0, opacity: 0.35)
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        userProfileImage.topAnchor.constraint(equalTo: self.newNofiyBtn.bottomAnchor, constant: 15).isActive = true
        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func _userNameLabel(label : UILabel){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = userInformationClass.student_name
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 16)
        label.textColor = mainColor._404040
        
        label.topAnchor.constraint(equalTo: self.userProfileImage.topAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.userProfileImage.trailingAnchor, constant: 15).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    func _userLastJoinLabel(label : UILabel){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "최근 운동일 \(extensionClass.DateToString(date: userInformationClass.student_recent_exercise_date, type: 0))"
        label.font = UIFont.NotoSansCJKkr(type: .normal, size: 14)
        label.textColor = mainColor.hexStringToUIColor(hex: "#777777")
        
        label.bottomAnchor.constraint(equalTo: self.userProfileImage.bottomAnchor, constant: -5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.userProfileImage.trailingAnchor, constant: 15).isActive = true
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    func _classJoinLabel(label : UILabel){
        scrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "수업 참여하기"
        label.font = UIFont.NotoSansCJKkr(type: .medium, size: 20)
        label.textColor = mainColor._3378fd
        
        label.topAnchor.constraint(equalTo: self.userProfileImage.bottomAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func _classJoinArrowBtn(){
        scrollView.addSubview(classJoinArrowBtn)
        
        classJoinArrowBtn.translatesAutoresizingMaskIntoConstraints = false
        classJoinArrowBtn.setImage(#imageLiteral(resourceName: "arrow_up_down"), for: .normal)
        classJoinArrowBtn.contentMode = .scaleAspectFit
        classJoinArrowBtn.contentHorizontalAlignment = .right
        classJoinArrowBtn.addTarget(self, action: #selector(classJoinArrowBtnAction), for: .touchUpInside)
        
        classJoinArrowBtn.topAnchor.constraint(equalTo: self.classJoinLabel.topAnchor).isActive = true
        classJoinArrowBtn.leadingAnchor.constraint(equalTo: leadingAnchor,constant:  20).isActive = true
        classJoinArrowBtn.trailingAnchor.constraint(equalTo: trailingAnchor,  constant: -20).isActive = true
        classJoinArrowBtn.bottomAnchor.constraint(equalTo: self.classJoinLabel.bottomAnchor).isActive = true
        
    }
    
    
    
    
    func _classListCollectionview(){
        self.scrollView.addSubview(classListCollectionview)
        classListCollectionview.translatesAutoresizingMaskIntoConstraints = false
        classListCollectionview.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        classListCollectionview.collectionViewLayout = layout
        classListCollectionview.isPagingEnabled = true
        classListCollectionview.showsHorizontalScrollIndicator = false
        classListCollectionview.delegate = self
        classListCollectionview.dataSource = self
        classListCollectionview.register(SideMenuClassCell.self, forCellWithReuseIdentifier: "SideMenuClassCell")
        
        
        classListCollectionview.topAnchor.constraint(equalTo: self.classJoinLabel.bottomAnchor, constant: 15).isActive = true
        classListCollectionview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        classListCollectionview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        classListCollectionview.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    func _totalClassBtn(){
        self.scrollView.addSubview(totalClassBtn)
        totalClassBtn.translatesAutoresizingMaskIntoConstraints = false
        totalClassBtn.setTitle("전체수업 보기", for: .normal)
        totalClassBtn.backgroundColor = .white
        totalClassBtn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        totalClassBtn.contentHorizontalAlignment = .left
        totalClassBtn.setTitleColor(mainColor._404040, for: .normal)
        totalClassBtn.addTarget(self, action: #selector(totalClassAciton), for: .touchUpInside)
        
        //collectionviewNC = totalClassBtn.topAnchor.constraint(equalTo: self.classListCollectionview.bottomAnchor, constant: 40)
        //collectionviewNC?.isActive = true
        totalClassBtn.topAnchor.constraint(equalTo: self.classJoinLabel.bottomAnchor, constant: 20).isActive = true
        totalClassBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        totalClassBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        totalClassBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        _arrowRight(button: totalClassBtn)
        
        
    }
    func _mypageBtn(){
        self.scrollView.addSubview(mypageBtn)
        mypageBtn.translatesAutoresizingMaskIntoConstraints = false
        mypageBtn.setTitle("마이페이지", for: .normal)
        mypageBtn.backgroundColor = .white
        mypageBtn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        mypageBtn.contentHorizontalAlignment = .left
        mypageBtn.setTitleColor(mainColor._404040, for: .normal)
        mypageBtn.addTarget(self, action: #selector(mypageBtnAction), for: .touchUpInside)
        
        mypageBtn.topAnchor.constraint(equalTo: self.classJoinLabel.bottomAnchor, constant: 20).isActive = true
        mypageBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        mypageBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        mypageBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        _arrowRight(button: mypageBtn)
    }
    func _afterCalssBtn(){
        self.scrollView.addSubview(afterCalssBtn)
        afterCalssBtn.translatesAutoresizingMaskIntoConstraints = false
        afterCalssBtn.setTitle("방과 후 활동", for: .normal)
        afterCalssBtn.backgroundColor = .white
        afterCalssBtn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        afterCalssBtn.contentHorizontalAlignment = .left
        afterCalssBtn.setTitleColor(mainColor._404040, for: .normal)
        afterCalssBtn.addTarget(self, action: #selector(afterCalssBtnAction), for: .touchUpInside)
        
        afterCalssBtn.topAnchor.constraint(equalTo: self.mypageBtn.bottomAnchor, constant: 20).isActive = true
        afterCalssBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        afterCalssBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        afterCalssBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        _arrowRight(button: afterCalssBtn)
    }
    func _contentPlaygroundBtn(){
        self.scrollView.addSubview(contentPlaygroundBtn)
        contentPlaygroundBtn.translatesAutoresizingMaskIntoConstraints = false
        contentPlaygroundBtn.setTitle("방과 후 활동", for: .normal)
        contentPlaygroundBtn.backgroundColor = .white
        contentPlaygroundBtn.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        contentPlaygroundBtn.contentHorizontalAlignment = .left
        contentPlaygroundBtn.setTitleColor(mainColor._404040, for: .normal)
        contentPlaygroundBtn.addTarget(self, action: #selector(contentPlaygroundBtnAction), for: .touchUpInside)
        contentPlaygroundBtn.isHidden = true
        
        contentPlaygroundBtn.topAnchor.constraint(equalTo: self.mypageBtn.bottomAnchor, constant: 20).isActive = true
        contentPlaygroundBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        contentPlaygroundBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        contentPlaygroundBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        _arrowRight(button: contentPlaygroundBtn)
    }
    
    func _communityBtn(button : UIButton){
        self.scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("학급 커뮤니티", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(mainColor._404040, for: .normal)
        button.addTarget(self, action: #selector(communityBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.mypageBtn.bottomAnchor, constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        _arrowRight(button: button)
    }
    func _settingBtn(button : UIButton){
        self.scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("환경설정", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(mainColor._404040, for: .normal)
        button.addTarget(self, action: #selector(settingBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.communityBtn.bottomAnchor, constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        _arrowRight(button: button)
    }
    func _qnaBtn(button : UIButton){
        self.scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("자주 묻는 질문", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.NotoSansCJKkr(type: .medium, size: 18)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(mainColor._404040, for: .normal)
        button.addTarget(self, action: #selector(qnaBtnAction), for: .touchUpInside)
        
        button.topAnchor.constraint(equalTo: self.settingBtn.bottomAnchor, constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        _arrowRight(button: button)
    }
    
    func _arrowRight(button : UIButton){
        let arrowRight = UIImageView()
        scrollView.addSubview(arrowRight)
        arrowRight.translatesAutoresizingMaskIntoConstraints = false
        arrowRight.image = #imageLiteral(resourceName: "arrow_right")
        arrowRight.contentMode = .scaleAspectFit
        
        arrowRight.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        arrowRight.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        arrowRight.widthAnchor.constraint(equalToConstant: 17).isActive = true
        arrowRight.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }
    func _fotterLabel(label : UILabel){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0){
            self.scrollView.addSubview(self.fotterLabel)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = extensionClass.fotterText
            label.font = UIFont.NotoSansCJKkr(type: .medium, size: 12)
            label.textColor = mainColor.hexStringToUIColor(hex: "#ababab")
            label.textAlignment = .center
            
            
            
            
            self.sideMenuFotterContent = self.frame.width * 1
            label.topAnchor.constraint(equalTo: self.settingBtn.bottomAnchor, constant: self.sideMenuFotterContent).isActive = true
            
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        
        
        
    }
    
    
    
    
    

    
    
}
//MARK: @objc 함수
extension sideMenuCell {
    @objc
    func classJoinArrowBtnAction(){
        if(collectionviewIsHiden){
            
            UIView.animate(withDuration: 0.7, animations: {
                self.classJoinArrowBtn.imageView?.transform = .init(rotationAngle: .pi * 2)
                self.collectionviewIsHiden = false
                self.classListCollectionview.isHidden = false
                self.collectionviewNC?.constant = 40
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.7, animations: {
                self.classJoinArrowBtn.imageView?.transform = .init(rotationAngle: .pi)
                self.collectionviewIsHiden = true
                self.classListCollectionview.isHidden = true
                self.collectionviewNC?.constant = -100
            }, completion: nil)//animate
            
        }
    }
    @objc
    func backBtnAction(){
        delegate?.selectSideMenu(pagePosition: 1)
    }
    @objc
    func newNofiyBtnAction(){
        delegate?.selectSideMenu(pagePosition: 2)
    }
    @objc
    func newMessageBtnAction(){
        delegate?.selectSideMenu(pagePosition: 3)
    }
    @objc
    func totalClassAciton(){
        delegate?.selectSideMenu(pagePosition: 4)
    }
    @objc
    func mypageBtnAction(){
        delegate?.selectSideMenu(pagePosition: 5)
    }
    @objc
    func afterCalssBtnAction(){
        delegate?.selectSideMenu(pagePosition: 6)
    }
    @objc
    func contentPlaygroundBtnAction(){
        delegate?.selectSideMenu(pagePosition: 7)
    }
    @objc
    func communityBtnAction(){
        delegate?.selectSideMenu(pagePosition: 8)
    }
    @objc
    func settingBtnAction(){
        delegate?.selectSideMenu(pagePosition: 9)
    }
    @objc
    func qnaBtnAction(){
        delegate?.selectSideMenu(pagePosition: 10)
    }
    
}


//MARK: collectionview Delegate
extension sideMenuCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SideMenuClassCell", for: indexPath) as! SideMenuClassCell
        cell.classNameLabel.text = classList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

extension sideMenuCell {
    
}
