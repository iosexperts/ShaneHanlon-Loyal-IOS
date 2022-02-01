//
//  TabController.swift
//  Loyal
//
//  Created by user on 07/04/21.
//

import UIKit
import FluidTabBarController

class TabController: FluidTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let delegate = UIApplication.shared.delegate as? AppDelegate  else {
               return
           }
        
        
     
            createTabBarController()
           
            
        
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBarController = FluidTabBarController()
        tabBarController.tabBar.tintColor = UIColor(red: 0.2431372549, green: 0.4235294118, blue: 1, alpha: 1)
        let viewControllers = [
            ("Locals", #imageLiteral(resourceName: "locals"),0),
            ("My Merchants", #imageLiteral(resourceName: "merchants"),1),
            ("Profile", #imageLiteral(resourceName: "profile"),2)
        ].map(createSampleViewController)
      //  tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.viewControllers = viewControllers
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.1021752581, green: 0.3338658512, blue: 0.2234536707, alpha: 1)
        return tabBarController
    }

    private func createSampleViewController(title: String, icon: UIImage,tagVal:Int) -> UIViewController {
       
        let ControllerArr = [EnterPhoneNumberVC(),MyMerchantsVC(),ProfileVC()]
    
        let vc = ControllerArr[tagVal]
       // vc.view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9529411765, blue: 0.968627451, alpha: 1)
        let item = FluidTabBarItem(title: title, image: icon, tag: tagVal)
        item.imageColor = #colorLiteral(red: 0.7960784314, green: 0.8078431373, blue: 0.8588235294, alpha: 1)
        vc.tabBarItem = item
        return vc
    }
  

}
