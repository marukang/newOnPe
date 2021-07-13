//
//  totalNoticeViewController.swift
//  VisionExample
//
//  Created by Ik ju Song on 2021/03/12.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
protocol totalNoticeViewControllerDelegate {
    func totalNoticeViewWillAppear(result : Int)
}
class totalNoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        delegate?.totalNoticeViewWillAppear(result: 0)
        
        AF.appMemberGetMyNews(student_id: UserInformation.student_id, student_token: UserInformation.access_token, type: "push", class_code: nil, url: "app/member/get_my_news", completion : {
            [weak self] result, result1 in
            
            self?.getTotalNoticeList.removeAll()
            
            if result == 0 {
                if let result1 = result1 {
                    let getTotalNoticeList = result1.filter({
                        (value : pushList) -> Bool in
                        if value.push_state == "1" {
                            return false
                        }
                        return true
                    })
                    print(getTotalNoticeList)
                    self?.getTotalNoticeList = getTotalNoticeList
                    
                    self?.totalNoticeListCollectionview.reloadData()
                }
                
            } else if result == 1 {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            } else {
                extensionClass.showToast(view: (self?.view!)!, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            }
            
            
        })
    }
    
    var delegate : totalNoticeViewControllerDelegate?
    
    let totalNoticeListCollectionview = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    let AF = ServerConnectionLegacy()
    
    var getTotalNoticeList : [pushList] = []

}

extension totalNoticeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, totalNoticeListCellDelegate {
    func noticeListCellGesture(setPushList: pushList) {
        let vc = totalNoticePostViewController()
        vc.title = "전체 공지사항"
        vc.getPushList = setPushList
        vc.view.backgroundColor = .white
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getTotalNoticeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalNoticeListCell", for: indexPath) as! totalNoticeListCell
        cell.delegate = self
        cell.setmessageNumber = indexPath.row + 1
        cell.setPushList = getTotalNoticeList[indexPath.row]
        
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

extension totalNoticeViewController {
    func setupLayout(){
        
        _totalNoticeListCollectionview(collectionview : totalNoticeListCollectionview)
    }
    
    func _totalNoticeListCollectionview(collectionview : UICollectionView){
        view.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        collectionview.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(totalNoticeListCell.self, forCellWithReuseIdentifier: "totalNoticeListCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        collectionview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
}
