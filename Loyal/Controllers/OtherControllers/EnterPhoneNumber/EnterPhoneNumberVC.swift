//
//  EnterPhoneNumberVC.swift
//  Loyal
//
//  Created by user on 07/04/21.
//

import UIKit
import AnyFormatKit
class EnterPhoneNumberVC: UIViewController,UITextFieldDelegate {
    var objEnterPhoneViewModel = EnterPhoneViewModel()
    let phoneNumberInputController = TextFieldInputController()
    let phoneNumberFormatter = DefaultTextInputFormatter(textPattern: "###-###-####")
    @IBOutlet weak var txtPhone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupPhoneNumberController()
    }
    
    // MARK: - Setup phoneNumber
    private func setupPhoneNumberController() {
        phoneNumberInputController.formatter = phoneNumberFormatter
        self.txtPhone.delegate = phoneNumberInputController
    }
    @IBAction func BtnAddPhoneNumberAct(_ sender: UIButton) {
        
//        let Subview =  CustomPopView.shared.loadViewFromNib()
//        self.view.addSubview(Subview)
        txtPhone.resignFirstResponder()
        guard let phnNumber = phoneNumberFormatter.unformat(txtPhone.text ?? "") else {
            return
        }

        
        if validate(value:phnNumber)
        {
        let ObjCustomPopView = CustomPopView.shared
        let Subview = ObjCustomPopView.loadViewFromNib()
            Subview.frame = self.view.bounds
        ObjCustomPopView.SetupUI(phone: txtPhone.text ?? "")
         ObjCustomPopView.isMoveNextTapped = {
             Status in
            print(Status)
            Subview.removeFromSuperview()
           if Status
           {
            
            let params = [     "contact_number":phnNumber,
                               "device_id": "sfvfsvf","device_type":"ios"
                                ]

            self.objEnterPhoneViewModel.doLogin(Param: params) { (status) in
                
                if status
                {
               
                    if UserDefaultController.shared.signUpTempData?.is_new_user == 1
                    {
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVC") as? PhoneNumberVC {
                         viewController.isFromEnterVC = true
                         self.navigationController?.pushViewController(viewController, animated: true)
                                
                            }
                    }
                    else
                    {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let sceneDelegate = windowScene.delegate as? SceneDelegate
                      else {
                        return
                      }
                    sceneDelegate.LoginExist_or_New()
                    }
                
              }
                
            }
            
            
           
        
           }
           
         }
         
         self.view.addSubview(Subview)
        }
        else
        {
            Utility().displayAlert(message: "Please Enter Valid Phone Number", control: ["Ok"])
        }
    }
    
    func validate(value: String) -> Bool {
               //let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
                 let PHONE_REGEX = "^[0-9]{6,14}$";
               let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
               let result = phoneTest.evaluate(with: value)
               return result
           }
    
   
}
/*
 extension String {
     public var validPhoneNumber: Bool {
         let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
         guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
         if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count)).first?.phoneNumber {
             return match == self
         } else {
             return false
         }
     }
 }

 print("\("+96 (123) 456-0990".validPhoneNumber)") //returns false, smart enough to know if country phone code is valid as well 🔥
 print("\("+994 (123) 456-0990".validPhoneNumber)") //returns true because +994 country code is an actual country phone code
 print("\("(123) 456-0990".validPhoneNumber)") //returns true
 print("\("123-456-0990".validPhoneNumber)") //returns true
 print("\("1234560990".validPhoneNumber)") //returns true
 
 */
