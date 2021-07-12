//
//  qnaViewController.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/27.
//
import UIKit

class faqListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AF.appCommunityGetStudentFaq(student_id: userInformationClass.student_id, student_token: userInformationClass.access_token, url: "app/community/get_student_faq")
        AF.delegate10 = self
        setupLayout()
        
        // Do any additional setup after loading the view.
    }
    var faqStructList : [Faq]?
    let AF = ServerConnectionLegacy()
    let searchTextField = UITextField()//검색 텍스트필드
    let searchImageview = UIImageView()//돋보기 이미지
    let grayLine1 = UIView()
    
    let qnaListCollectionview = UICollectionView(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let myclassList = ["고성고 1학년","고성고 2학년"]
}
extension faqListViewController : appCommunityGetStudentFaqDelegate{
    func appCommunityGetStudentFaq(result: Int, faq: [Faq]?) {
        if result == 0 {
            faqStructList = faq!
            qnaListCollectionview.reloadData()
        } else if result == 1 {
            extensionClass.showToast(view: view, message: extensionClass.wrongConnectErrotText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            extensionClass.showToast(view: view, message: extensionClass.connectErrorText, font: UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize4))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
}
//MARK: - @obj 함수
extension faqListViewController {
    @objc
    func action(){
        self.view.endEditing(true)
    }

}

//MARK: - collectionview Delegate
extension faqListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, faqListCellDelegate {
    func getQnaCode(code: Int) {
        let vc = faqPostViewController()
        vc.faqcontent = faqStructList?[code]
        print(faqStructList?[code])
        vc.title = "자주 묻는 질문"
        vc.view.backgroundColor = .white
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return faqStructList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "faqListCell", for: indexPath) as! faqListCell
        cell.delegate = self
        
        cell.faqcontent = faqStructList?[indexPath.row]
        cell.setQnaCode = indexPath.row
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
extension faqListViewController {
    func setupLayout(){
        _searchTextField(textField: searchTextField)//검색
        _searchImageview(imageview: searchImageview)//돋보기 이미지
        
        _grayLine1(uiview: grayLine1)

        
        _qnaListCollectionview(collectionview : qnaListCollectionview)
    }
    
    func _searchTextField(textField : UITextField){
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.NotoSansCJKkr(type: .normal, size: extensionClass.textSize2)
        textField.placeholder = "검색어를 입력해주세요."
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = mainColor._3378fd.cgColor
        textField.layer.cornerRadius = 8
        
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }//검색
    func _searchImageview(imageview : UIImageView){
        view.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = #imageLiteral(resourceName: "asdfasdg")
        imageview.contentMode = .scaleAspectFit
        
        imageview.topAnchor.constraint(equalTo: searchTextField.topAnchor,constant: 10).isActive = true
        imageview.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor,constant: -20).isActive = true
        imageview.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor ,constant: -10).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
    }//돋보기 이미지
    
    func _grayLine1(uiview : UIView){
        view.addSubview(uiview)
        
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = mainColor.hexStringToUIColor(hex: "#f9f9f9")
        
        uiview.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 10).isActive = true
        uiview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        uiview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        uiview.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    


    
    
    func _qnaListCollectionview(collectionview : UICollectionView){
        view.addSubview(collectionview)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionview.backgroundColor = .white
        collectionview.collectionViewLayout = layout
        collectionview.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(faqListCell.self, forCellWithReuseIdentifier: "faqListCell")
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        collectionview.topAnchor.constraint(equalTo: grayLine1.bottomAnchor, constant: 10).isActive = true
        collectionview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}



