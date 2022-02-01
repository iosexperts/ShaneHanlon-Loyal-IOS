//
//  AppSceneDelegate.swift
//  Loyal
//
//  Created by user on 15/02/21.
//

import Foundation
import UIKit
import FluidTabBarController
extension SceneDelegate{
    
    func LoginExist_or_New(){
           print("Call")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let delegate = UIApplication.shared.delegate as? AppDelegate  else {
               return
           }
        
           if Utility().isAlreadyLogin(){
            //   guard let vc = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as? PhoneNumberVC else {return}
            
            let TabCon = self.createTabBarController()
            delegate.navCon = UINavigationController(rootViewController:TabCon)
                
           }else{
    
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVC") as? PhoneNumberVC else {return}
            delegate.navCon = UINavigationController(rootViewController: vc)
          }
        
            delegate.navCon.isNavigationBarHidden = true
            window?.rootViewController = delegate.navCon
            window?.makeKeyAndVisible()
        }
    
    
    
    
     func createTabBarController() -> UITabBarController {
       let tabBarController = FluidTabBarController()
       // tabBarController.tabBar.tintColor = UIColor(red: 0.2431372549, green: 0.4235294118, blue: 1, alpha: 1)
        
       let viewControllers = [
            ("Nearby", #imageLiteral(resourceName: "locals"),"LocalsVC"),
            ("My Merchants", #imageLiteral(resourceName: "merchants"),"MyMerchantsVC"),
            ("Profile", #imageLiteral(resourceName: "profile"),"ProfileVC")
       ].map(createSampleViewController)
      //  tabBarController.setViewControllers(viewControllers, animated: true)
        
       tabBarController.viewControllers = viewControllers
       tabBarController.tabBar.tintColor = #colorLiteral(red: 0.1021752581, green: 0.3338658512, blue: 0.2234536707, alpha: 1)
       return tabBarController
    }

    private func createSampleViewController(title: String,icon: UIImage,Controller:String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       
        let vc = storyBoard.instantiateViewController(withIdentifier: Controller)
        let item = FluidTabBarItem(title: title, image: icon, tag: 0)
     
        item.imageColor = #colorLiteral(red: 0.7960784314, green: 0.8078431373, blue: 0.8588235294, alpha: 1)
        vc.tabBarItem = item
        return vc
    }
    
    
    
 /*   func getVC(ViewControl:String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch ViewControl {
        case "LocalsVC":
            return storyboard.instantiateViewController(withIdentifier: ViewControl)
            
        default:
            break;
        }
    }*/
    
    
   /* private func createSampleViewController(title: String, icon: UIImage) -> UIViewController {
           let viewController = UIStoryboard(name: "main", bundle: nil).instantiateViewController(withIdentifier: "LocalsVC") as! LocalsVC
        //   viewController.view.backgroundColor =  colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.968627451, alpha: 1)
           let item = FluidTabBarItem(title: title, image: icon, tag: 0)
           item.imageColor = #colorLiteral(red: 0.7960784314, green: 0.8078431373, blue: 0.8588235294, alpha: 1)
           viewController.tabBarItem = item
           return viewController
       }*/
    
    
}
