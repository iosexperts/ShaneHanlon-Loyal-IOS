//
//  MyMerchantsViewModel.swift
//  Loyal
//
//  Created by user on 15/04/21.
//

struct MyMerchantModal: Codable {
    let status: Bool?
    let message: String?
   let data: [MyMercahntRes]?
}

// MARK: - DataClass
struct MyMercahntRes: Codable {
    var address,city,country,description,created_at,deleted_at,email: String?
    var facebook_url,website_url,name,state,image,contact_number,suite,distance_unit: String?
    var latitude,longitude,zip_code,beaconUUID: String?
    
    var id,is_joined,available_rewards,visits_until_next_reward,redeemed_rewards: Int?
    var distance:Double?
    var rewards:[rewards]?
    
    var gotRewardOrNot:Bool?
    var visitDetails :[visitDetails]?
    var rewardRedemption :[rewardRedemption]?
}
struct rewardRedemption: Codable {
    var redeem_at :String?
}
struct visitDetails: Codable {
   var created_at :String?
}
struct rewards:Codable {
    var description,image,number_of_visits :String?
    var id,merchant_id: Int?

}

import Foundation
class MyMerchantsViewModel  {
    var MyMerchantArr : [MyMercahntRes]?
  
    func GetMerchantList(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
       
        
        HitApi.shared.sendRequest(api: k_Get_Joined_Merchant, parameters:Param, showLoader: true) { (modal:MyMerchantModal) in
                 
                  if (modal.status == true)
                  {
                    self.MyMerchantArr = modal.data
                
                        completion(true)
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
    
    
    
    func DeleteJoinedMerchantFromList(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
       
        
        HitApi.shared.sendRequest(api: k_Delete_Joined_Merchant, parameters:Param, showLoader: true) { (modal:CommonModal) in
                 
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
