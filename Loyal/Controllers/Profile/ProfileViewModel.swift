//
//  ProfileViewModel.swift
//  Loyal
//
//  Created by user on 15/04/21.
//

import Foundation
class ProfileViewModel {
    
func UpdateProfile(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
    
    //HitApi.shared.sendRequest(api: k_updateProfilePhoto, parameters: Param, showLoader: true) {
    HitApi.shared.sendRequestWithImages(api: k_updateProfilePhoto, parameters: Param ?? [:], video: [:], document: [:], extensionDocumentType: ""){
        (modal:LoginSignUpModal) in
     
        if (modal.status == true)
        {
           Utility().displayAlert(message: modal.message ?? "", control: ["OK"])
           UserDefaultController.shared.signUpTempData = modal.data
           completion(true)
            
        }else {
           Utility().showAlert(mesg: modal.message ?? "")
           completion(false)
        }
    }
}
    
func Logout(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
             //   HitApi.shared.GetRequest(api: k_LocalsNearBy, showLoader: true) { (modal:LocalModal) in
        HitApi.shared.sendRequest(api: k_Logout, parameters: Param, showLoader: true){ (modal:CommonModal) in
        
           // if (modal.message == "Unauthenticated." || modal.message == "")
            if (modal.status == true)
            {
                        completion(true)
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
        }
    }
}
