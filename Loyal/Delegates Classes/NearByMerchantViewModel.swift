//
//  NearByMerchantViewModel.swift
//  Loyal
//
//  Created by user on 02/06/21.
//

import Foundation
class NearByMerchantViewModel {
   
    
    func UpdateNearByMercahnts(url:String,Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
             
        HitApi.shared.sendRequest(api:url, parameters: Param, showLoader: true){ (modal:CommonModal) in
        
                  if (modal.status == true)
                  {
                   
                
                        completion(true)
                   
                  }else {
                        //  Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    func CommonPostMethod(url:String,Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
             
        HitApi.shared.sendRequest(api:url, parameters: Param, showLoader: false){ (modal:CommonModal) in
        
                  if (modal.status == true)
                  {
                   // Utility().topController?.view.makeToast("Distance from Lat/Long of beacon: \(modal.footDistance ?? 0)", duration: 1.5, position: .bottom)
                
                        completion(true)
                   
                  }else {
                        // Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
   
    
    
    func UpdateFCMToken(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
             
        HitApi.shared.sendRequest(api: K_UpdateFCMNotification, parameters: Param, showLoader: true){ (modal:CommonModal) in
        
                  if (modal.status == true)
                  {
                   
                
                        completion(true)
                   
                  }else {
                        //  Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
}
