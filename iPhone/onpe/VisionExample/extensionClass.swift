//
//  extensionClass.swift
//  newOnProject
//
//  Created by Ik ju Song on 2021/01/12.
//

import Foundation
import UIKit

public class extensionClass{
    // textField 위의 글자 크기
    static let textSize1 : CGFloat = 13
    //textField의 글자크기
    static let textSize2 : CGFloat = 16
    //화면의 맨밑의 버튼 글자크기 //예) 저장하기, 회원가입하기, 로그인하기
    static let textSize3 : CGFloat = 18
    //토스트 글자 크기
    static let textSize4 : CGFloat = 15
    
    
    static let fotterText = "ⓒ주식회사 컴플렉시온, Inc All Rights Reverved."
    static let wrongConnectErrotText = "잘못된 접근 방법입니다."
    static let connectErrorText = "서버와의 연결이 불안정 합니다."
    
    
    public static func arrayToJsonString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public static func jsonToArray4(jsonString : String) -> [[[String : String]]]{
        var result : [[[String : String]]] = [[[:]]]
        if let data = jsonString.data(using: .utf8){
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[[String : String]]]{
                    result = jsonDic
                }
            } catch let error {
              print(error)
            }
        }
        return result
    }
    public static func jsonToArray3(jsonString : String) -> [[String : String]]{
        var result : [[String : String]] = [[:]]
        result.removeAll()
        if let data = jsonString.data(using: .utf8){
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : String]]{
                    result = jsonDic
                }
            } catch let error {
                result.append(["result" : "nil"])
                print(error)
            }
        }
        return result
    }
    public static func jsonToArray2(jsonString : String) -> [Int]{
        var result : [Int] = []
        if let data = jsonString.data(using: .utf8){
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String]{
                    print(jsonDic)
                    for value in jsonDic.reversed(){
                        result.append(Int(value) ?? 0)
                    }
                    
                }
            } catch let error {
              print(error)
            }
        }
        
        
        return result.reversed()
    }
    
    public static func jsonToArray(jsonString : String) -> [String]{
        var result : [String] = []
        if let data = jsonString.data(using: .utf8){
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String]{
                    result = jsonDic
                }
            } catch let error {
              print(error)
            }
        }
        
        
        return result
    }
    
    public static func youtubeUrlId(url : String) -> String {
        var result = ""//https://www.youtube.com/watch?v=mPymRFeTJa4&t=4414s
        var i = 0
        for value in url {
            if 31 < i, i < 43 {
                result = result + String(value)
            }
            i += 1
        }
        return result//mPymRFeTJa4 만 리턴
    }
    //현재 시간을 20210130으로 변환해주는 함수
    public static func nowTimw2() -> String{
        var result = "0"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let current_date_string = formatter.string(from: Date())
        result = current_date_string
        return result
    }
    //현재 시간을 20210130171200으로 변환해주는 함수
    public static func nowTimw() -> String{
        var result = "0"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let current_date_string = formatter.string(from: Date())
        result = current_date_string
        return result
    }
    //20210130171200 년+월+일+시간+분+초 14자리 수를 올리면 2021-01-30 으로 변환하는 함수
    public static func DateToString(date : String, type : Int) -> String{
        var result : String = ""
        var year : String = ""
        var month : String = ""
        var day : String = ""
        var i = 0
        for value in date {
            if -1 < i, i < 4 {
                year = year + String(value)
            }
            if 3 < i, i < 6 {
                month = month + String(value)
            }
            if 5 < i, i < 8 {
                day = day + String(value)
            }
            i += 1
        }
        if type == 0 {
            result = year + "-" + month + "-" + day
        } else {
            result = year + "." + month + "." + day
        }
        
        return result
        
    }
    //이용자의 정보를 변경하고 쉐어드의 토큰과 스테틱의 토큰 변경하는 함수
    public static func setTokenChange(token : String){
        
        UserInformation.access_token = token
        print("변경 토큰 : ",token)
        
        let autoPramater : [String : String] = ["student_id" : UserInformation.student_id, "student_token" : token, "fcm_token" : UserInformation.fcm_token]
        UserInformation.preferences.set(autoPramater, forKey: UserInformation.autoLoginKey)
        //print(userInformationClass.access_token)
    }
    //변수의 자료형 타입 확인하는 함수
    public static func printInfo(_ value: Any) {
        let t = type(of: value)
        print("'\(value)' of type '\(t)'")
    }
    
    public static func showToast(view : UIView, message : String, font: UIFont)
    {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        
        toastLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  view.frame.width * 0.5).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.8).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: view.frame.width * 0.1).isActive = true
        
        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseOut, animations:
            {
                toastLabel.alpha = 0.0
        }, completion: { ( isCompleted ) in
            
            toastLabel.removeFromSuperview()
            
        })
    }
}

/*
 - 하단에 tabBar 흰색으로 칠하기
 */
extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
extension UICollectionView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPadding(padding : CGRect){
        self.textRect(forBounds: padding)
        self.placeholderRect(forBounds: padding)
        self.editingRect(forBounds: padding)
        
    }
}
extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
extension UIFont {
    class func NotoSansCJKkr(type: NotoSansCJKkrType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }

    public enum NotoSansCJKkrType {
        case normal
        case bold
        case light
        case medium
        var name: String {
            switch self {
            case .medium:
                return "NotoSansCJKkr-Medium"
            case .normal:
                return "NotoSansCJKkr-Regular"
                
            case .light:
                return "NotoSansCJKkr-Light"
                
            case .bold:
                return "NotoSansCJKkr-Bold"
                
            }
        }
    }
}
public class mainColor
{
    /*
     - signtureColor를 수정 또는 사용할때 signture_color 변수를 새롭게 설정 하거나 수정한다.
     */
    //static let signture_color = hexStringToUIColor(hex: "#9370DB")
    
    //라벨 글자색
    static let _404040 : UIColor = hexStringToUIColor(hex: "#404040")
    //메인 색
    static let _3378fd : UIColor = hexStringToUIColor(hex: "#3378fd")// 메인 컬러
    //textField 불충분 조건 색
    static let _ebebeb : UIColor = hexStringToUIColor(hex: "#ebebeb")
    
    //버튼 비활성화 이미지 색
    static let _9f9f9f : UIColor = hexStringToUIColor(hex: "#9f9f9f")
    
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UICollectionView {
    func scrollToNextItem(total : Int) -> Int{
        let pageControl : Int = (Int(self.contentOffset.x) / Int(self.frame.width)) + 1
        if total > pageControl{
            let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
            
            self.moveToFrame(contentOffset: contentOffset)
        }
        return pageControl
    }

    func scrollToPreviousItem(total : Int) -> Int {
        let pageControl : Int = (Int(self.contentOffset.x) / Int(self.frame.width)) - 1
        
        if total > pageControl && total != 0 {
            let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
            self.moveToFrame(contentOffset: contentOffset)
        }
        
        return pageControl
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

public enum Model : String {
    
    //Simulator
    case simulator     = "simulator/sandbox",
    
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPadAir3           = "iPad Air 3",
    iPad5              = "iPad 5", //iPad 2017
    iPad6              = "iPad 6", //iPad 2018
    
    //iPad Mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    iPadMini5          = "iPad Mini 5",
    
    //iPad Pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro11          = "iPad Pro 11\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro3_12_9      = "iPad Pro 3 12.9\"",
    
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6Plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6SPlus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7Plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8Plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    iPhone11           = "iPhone 11",
    iPhone11Pro        = "iPhone 11 Pro",
    iPhone11ProMax     = "iPhone 11 Pro Max",
    
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}

public extension UIDevice {
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        let modelMap : [String: Model] = [
            
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            
            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            
            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            
            //iPad Air
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            
            //Apple TV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}

extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }

    
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
