//
//  LocalViewModel.swift
//  Loyal
//
//  Created by user on 14/04/21.
//

struct CommonModal: Codable {
    let status: Bool?
    let message: String?
    let footDistance: Int?
}


struct LocalModal: Codable {
    let status: Bool?
    let message: String?
   let data: [LocalArr]?
}

// MARK: - DataClass
struct LocalArr: Codable {
    var address,city,country,description,created_at,deleted_at,email,distance_unit,beacon_id: String?
    var facebook_url,name,state,image: String?
   var id,is_joined,is_new_user,visits_until_next_reward: Int?
    var distance:Double?
    var gotRewardOrNot:Bool?
   
 
}


import Foundation
import UIKit
class VaultViewModel  {
    var LocalListArr : [LocalArr]?
  
   
    
    func JoinMerchant(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
             
             //   HitApi.shared.GetRequest(api: k_LocalsNearBy, showLoader: true) { (modal:LocalModal) in
        HitApi.shared.sendRequest(api: k_Join_Merchant, parameters: Param, showLoader: true){ (modal:CommonModal) in
        
                  if (modal.status == true)
                  {
                   
                
                        completion(true)
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    func LocalList(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
       
             
             //   HitApi.shared.GetRequest(api: k_LocalsNearBy, showLoader: true) { (modal:LocalModal) in
        HitApi.shared.sendRequest(api: k_LocalsNearBy, parameters: Param, showLoader: true){ (modal:LocalModal) in
        
                  if (modal.status == true)
                  {
                    self.LocalListArr = modal.data
                
                        completion(true)
                   
                  }else {
                
                    if modal.message == "Unauthenticated."
                    {
                        Utility().setAlreadyLogin(false)
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                            let sceneDelegate = windowScene.delegate as? SceneDelegate
                          else {
                            return
                          }
                        sceneDelegate.LoginExist_or_New()
                    }
                    else
                    {
                    Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                    }
                    }
     
        }

    }
    
    
    
}
