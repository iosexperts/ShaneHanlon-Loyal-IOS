//
//  RewardDetailViewModel.swift
//  Loyal
//
//  Created by user on 15/04/21.
//
struct MyMerchantDetailsModal: Codable {
    let status: Bool?
    let message: String?
   let data: MyMercahntRes?
}

struct UserReward: Codable {
    let status: Bool?
    let message: String?
   let UserRewardData: [PendingRewardsFromRedeem]?
    
    enum CodingKeys: String, CodingKey {
         case status = "status"
         case message = "message"
         case UserRewardData = "data"
        
        
     }
    
}




struct PendingRewardsFromRedeem:Codable {
    var description,image,number_of_visits,created_at,beaconUUID :String?
    var id,merchant_id,user_id,reward_id,user_rewardId,mainUserRewardId: Int?
}
struct RewardById: Codable {
    let status: Bool?
    let message: String?
   let UserRewardData: PendingRewardsFromRedeem?
    
    enum CodingKeys: String, CodingKey {
         case status = "status"
         case message = "message"
         case UserRewardData = "data"
        
        
     }
    
}


import Foundation
class MyMerchantsDetailsViewModel  {
    var MyMerchantDict : MyMercahntRes?
    var UserRewardArr : [PendingRewardsFromRedeem]?
    var UserRewardDict : PendingRewardsFromRedeem?
    func GetMerchantDetails(merchantId:String,Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
       
             
                HitApi.shared.GetRequest(api: "\(k_Get_Merchant_By_id)/\(merchantId)", showLoader: true) { (modal:MyMerchantDetailsModal) in
                 
                  if (modal.status == true)
                  {
                    self.MyMerchantDict = modal.data
                
                        completion(true)
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
    func GetUserRewardsList(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
       
                HitApi.shared.sendRequest(api: k_Get_UserRewardsList, parameters: Param,  showLoader: true) { (modal:UserReward) in
                 
                  if (modal.status == true)
                  {
                    self.UserRewardArr = modal.UserRewardData
                
                        completion(true)
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
    
    func GetRewardsById(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
        
                HitApi.shared.sendRequest(api: k_Get_rewardById, parameters: Param,  showLoader: true) { (modal:RewardById) in
                 
                  if (modal.status == true)
                  {
                    self.UserRewardDict = modal.UserRewardData
                
                        completion(true)
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
    
    
    
    
}


struct CommanModel: Codable {
    let status: Bool?
    let message: String?
    let redeem_at: String?
}

class Reward  {
    
    var commondict : CommanModel?
    
    func RedeemRewards(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
        
                HitApi.shared.sendRequest(api: k_RedeemRewards, parameters: Param,  showLoader: true) { (modal:CommanModel) in
                    
                  if (modal.status == true)
                  {
                    self.commondict = modal
                 //   Utility().displayAlertWithCompletion(title: "", message: modal.message ?? "", control: ["OK"]) { (str) in
                        completion(true)
                   // }
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
    
}
