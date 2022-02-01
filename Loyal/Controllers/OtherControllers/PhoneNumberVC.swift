//
//  PhoneNumberVC.swift
//  Loyal
//
//  Created by user on 07/04/21.
//

import UIKit

class PhoneNumberVC: UIViewController {
    @IBOutlet weak var lblSubmit: UILabel!
    var isFromEnterVC = Bool()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnEnterPhone: UIButton!
    @IBOutlet weak var lblCenter: UILabel!
    
    @IBOutlet weak var ImgViewBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if isFromEnterVC
        {
            setupUI()
        }
        
        
    }
    
    func setupUI()  {
         ImgViewBackground.image = #imageLiteral(resourceName: "BirdseyeTableofFood")
        lblCenter.text =  "Join Loyalty programs, from multiple merchants, in seconds..."
        //btnEnterPhone.setTitle("Ok, Let's Go!", for: .normal)
        lblSubmit.text = "Ok, Let's Go!"
    }
    
    
    
    
    @IBAction func BtnEnterPhoneNumberAct(_ sender: UIButton) {
        if isFromEnterVC
        {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
          else {
            return
          }
        sceneDelegate.LoginExist_or_New()
        }
        else
        {
        Utility().pushViewControl(ViewControl: "EnterPhoneNumberVC")
        }
        }
    
    
}
