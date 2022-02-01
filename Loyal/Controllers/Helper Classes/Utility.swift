//
//  UrlConstant.swift
//  ScanReport
//
//  Created by user on 23/08/18.
//  Copyright © 2018 RVTechnologies Softwares PVT. LTD. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import SVProgressHUD

import CoreBluetooth

class Utility : NSObject{
var Indicatiortimer = Timer()
    let topController = UIApplication.topViewController()
 // let topController = UIApplication.topMostViewController()
    var isBluetoothPermissionGranted: Bool {
       if #available(iOS 13.1, *) {
           return CBCentralManager.authorization == .allowedAlways
       } else if #available(iOS 13.0, *) {
           return CBCentralManager().authorization == .allowedAlways
       }
       // Before iOS 13, Bluetooth permissions are not required
       return true
   }
    func pushViewControl(ViewControl:String){
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let controller = storyboard.instantiateViewController(withIdentifier: ViewControl)
           let topVC = UIApplication.topViewController()
           topVC?.navigationController?.pushViewController(controller, animated: true)
       }
       
    func PopVC()  {
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
    }
    /* func show_loader(userInteraction:Bool = false) {
           
           SKActivityIndicator.spinnerColor(UIColor.darkGray)
           SKActivityIndicator.statusTextColor(UIColor.black)
           let myFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
           SKActivityIndicator.statusLabelFont(myFont!)
           SKActivityIndicator.spinnerStyle(.spinningFadeCircle)
           SKActivityIndicator.show("Loading...", userInteractionStatus: userInteraction)
       }
        func hide_loader() {
           
          SKActivityIndicator.dismiss()
       }*/
    func show_loader(userInteraction:Bool = false) {
        Indicatiortimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.hide_loader), userInfo: nil, repeats: false)
          
        SVProgressHUD.show()
    }
    @objc func hide_loader() {
        Indicatiortimer.invalidate()
        SVProgressHUD.dismiss()
         }
    
    
    //check Notification services enabled or not

              func checkNotificationPermission(completion: @escaping (Bool) -> ()) {
                
                let current = UNUserNotificationCenter.current()
//                var NotiStatus = Bool()
                current.getNotificationSettings(completionHandler: { (settings) in
                    if settings.authorizationStatus == .notDetermined {
                        // Notification permission has not been asked yet, go for it!
                   
                        completion(false)
                    } else if settings.authorizationStatus == .denied {
                        // Notification permission was previously denied, go to settings & privacy to re-enable
                    
                        completion(false)
                    } else if settings.authorizationStatus == .authorized {
                        // Notification permission was already granted
                       // NotiStatus = true
                        completion(true)
                    }
                })
                 
              }
    
    
    
    //MARK:-Check/Set is user Already Login-
    func setAlreadyLogin(_ status:Bool)  {
           UserDefaults.standard.set(status, forKey: "AlreadyLogin")
           UserDefaults.standard.synchronize()
       }
       func isAlreadyLogin() -> Bool {
           return UserDefaults.standard.bool(forKey: "AlreadyLogin")
       }
      
    
    
    //MARK:- Convert timestamp to Date
    func timestampToDate(TimeStamp:Int) -> String {
       
            let date = Date(timeIntervalSince1970:Double(TimeStamp))
            let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-YYYY"
//            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
//            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        return localDate
        
        
    }
    
    //MARK:- Display alert with completion
    
    func displayAlertWithCompletion(title:String,message:String,control:[String],completion:@escaping (String)->()){
        
        let alertController = UIAlertController(title: title, message: message.uppercased() , preferredStyle: .alert)
        
        for str in control{
            
            let alertAction = UIAlertAction(title: str, style: .default, handler: { (action) in
                
                completion(str)
            })
            
            alertController.addAction(alertAction)
        }
        
        
        // let topController = UIApplication.topViewController()
        topController?.present(alertController, animated: true, completion: nil)
       
    }
    
    func showAlert(mesg:String) {
        displayAlert(message: mesg.uppercased(), control: ["Ok"])
    }
    
    //MARK:- Display alert without completion
   /*
    func displayAlert(title:String = "" , message:String, control:[String]){
        
        let alertController = UIAlertController(title: title, message: message.uppercased() , preferredStyle: .alert)
        
        for str in control{
            
            let alertAction = UIAlertAction(title: str, style: .default, handler: nil)
            
            alertController.addAction(alertAction)
        }
        DispatchQueue.main.async {
            
        
            self.topController?.present(alertController, animated: true, completion: nil)
        }
    }*/
    
    func displayAlert(title:String = "" , message:String, control:[String]){
        
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        for str in control{
            
            let alertAction = UIAlertAction(title: str, style: .default, handler: nil)
            
            alertController.addAction(alertAction)
        }
        DispatchQueue.main.async {
            
        
            self.topController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func openActionSheet(title: String = "", mesg:String = "", control:[String], completion:@escaping (String,Int)->()) {
        
        let optionMenu = UIAlertController(title:title, message: mesg , preferredStyle: .actionSheet)
        
        for str in control {
            if str != "Cancel"{
                let saveAction = UIAlertAction(title: str, style: .default, handler:
                {
                    (action) in
                    
                    if let index = optionMenu.actions.firstIndex(where: { $0 === action })
                    {
                    completion(str,index)
                    }
                })
                
                optionMenu.addAction(saveAction)
            }else{
                let delAction = UIAlertAction(title: str, style: .cancel, handler:
                {
                    (action) in
                    completion(str,Int())
                })
        
                optionMenu.addAction(delAction)
            }
        }
        UIApplication.topViewController()?.present(optionMenu, animated: true, completion: nil)
    }
   
    func toJSON(array: [[String: Any]]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        return String(data: data, encoding: .utf8)!
    }
func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isValidPassword(value: String) -> Bool {
       if value.count >= 6 {
           return true
       }
       else{
           return false
       }
   }
    
func isPasswordStrong(testStr:String) -> Bool {
       let passRegEx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"
       
       let pass = NSPredicate(format:"SELF MATCHES %@", passRegEx)
       return pass.evaluate(with: testStr)
   }
       
func isValidCode(_ code : String) -> Bool {
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    if code.rangeOfCharacter(from: characterset.inverted) != nil {
        print("string contains special characters")
        return false
    }
    else{
        return true
    }
}



//phone validation

func myMobileNumberValidate(_ number: String?) -> Bool {
    let numberRegEx = "[0-9]{10}"
    let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
    if numberTest.evaluate(with: number) == true {
        return true
    }
    else {
        return false
    }
}

   /*func getFormattedDate(string: String,currentFor:String , outPutformatter:String) -> String{
       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = currentFor
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as TimeZone?
       let dateFormatterPrint = DateFormatter()
       dateFormatterPrint.dateFormat = outPutformatter
        dateFormatterPrint.timeZone = TimeZone.current
       let date: Date? = dateFormatterGet.date(from: string)
      // print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
      return dateFormatterPrint.string(from: date!);
   }*/

   func getFormattedDate(string: String,currentFor:String , outPutformatter:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFor//"H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: string) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = outPutformatter//"h:mm a"
        
            return dateFormatter.string(from: date)
        }
        return ""
    }

//pincode validation

func isValidPincode(value: String) -> Bool {
    if value.count == 6{
        return true
    }
    else{
        return false
    }
}

//Password Validation

func isPasswordSame(password: String , confirmPassword : String) -> Bool {
    if password == confirmPassword{
        return true
    }else{
        return false
    }
}

    var currentDate: String {
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy-MM-dd"
        return dFormatter.string(from: Date())
    }


//Password length validation

func isPwdLenth(password: String , confirmPassword : String) -> Bool {
    if password.count <= 7 && confirmPassword.count <= 7{
        return true
    }else{
        return false
    }
}

}

class Utility2 : NSObject{
    
    let topController = UIApplication.topViewController()
    
    func displayAlert(title:String = "" , message:String, control:[String]){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for str in control{
            
            let alertAction = UIAlertAction(title: str, style: .default, handler: nil)
            
            alertController.addAction(alertAction)
        }
        
        topController?.present(alertController, animated: true, completion: nil)
        
    }
}


// for action sheet icon
extension UIImage {
    
    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

extension String {
    func widthOfString() -> CGFloat {
        let font = UIFont.systemFont(ofSize: 29)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
   class func topMostViewController() -> UIViewController? {
   
        
    
            
        return UIWindow.key?.rootViewController?.topMostViewController()
    
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            print("1")
            if let vc = navigationController.visibleViewController as? UIViewController{
                 print("1.1")
              return topViewController(controller: vc)
            }
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                 print("2")
                return topViewController(controller: selected)
            }
             print("2.1")
        }
        if let presented = controller?.presentedViewController {
             print("3")
            return topViewController(controller: presented)
            
        }
        
        if controller == nil {
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
           
            return  appdelegate?.window?.rootViewController ?? UIApplication.shared.windows.last?.rootViewController
        }
         print("4")
        return controller
    }
}
/*
extension UIApplication {
    class func topViewController(controller: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
         
        
       let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if let topController = keyWindow?.rootViewController {
           while let presentedViewController = topController.presentedViewController {
               
            if let vc = topViewController(controller: presentedViewController){
                return vc
            }
            }
        }
        
        if let vc = (UIApplication.shared.windows.first?.rootViewController as? UINavigationController)?.viewControllers.last{
            return vc
        }
            
        
        
        return controller
    }
}*/





//Mark: Check Reachability

protocol Utilities {
}
extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }}


    
