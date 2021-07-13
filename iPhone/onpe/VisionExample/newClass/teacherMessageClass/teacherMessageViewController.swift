//
//  teacherMessageViewController.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/12.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
protocol teacherMessageViewControllerDelegate {
    func teacherViewWillAppear(result : Int)
}
class teacherMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        //view.backgroundColor = .brown
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillAppear")
        delegate?.teacherViewWillAppear(result : 2)
        AF.appMemberGetMyNews(student_id: UserInformation.student_id, student_token: UserInformation.access_token, type: "message", class_code: nil, url: "app/member/get_my_news", completion : {
            [weak self] result, result1 in
            
            self?.getMessageNoticeList.removeAll()
            
            if result == 0 {
                if let result1 = result1 {
                 
                    self?.getMessageNoticeList = result1
                    self?.teacherMessageListCollectionview.reloadData()
                }
                
            } else if result == 1 {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            } else {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
            
            
        })
    }
    
    let AF = ServerConnectionLegacy()
    var delegate : teacherMessageViewControllerDelegate?
    let teacherMessageListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    var getMessageNoticeList : [pushList] = []
   

}

extension teacherMessageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, teacherListCellDelegate {
    func teacherListCellGesture(setPushList: pushList) {
        let vc = teacherMessagePostViewController()
        vc.title = "선생님의 메시지"
        vc.getPushList = setPushList
        vc.view.backgroundColor = .white
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getMessageNoticeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teacherListCell", for: indexPath) as! teacherListCell
        cell.delegate = self
        cell.setPushList = getMessageNoticeList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 0.205)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension teacherMessageViewController {
    func setupLayout(){
        
        _totalNoticeListCollectionview(collectionview : teacherMessageListCollectionview)
    }
    
    func _totalNoticeListCollectionview(collectionview : UICollectionView){
        view.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        collectionview.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(teacherListCell.self, forCellWithReuseIdentifier: "teacherListCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        collectionview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
}
