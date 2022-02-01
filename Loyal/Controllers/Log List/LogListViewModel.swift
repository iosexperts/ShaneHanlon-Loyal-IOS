//
//  LogListViewModel.swift
//  Loyal
//
//  Created by user on 14/12/21.
//

struct LogListwModelData: Codable {
    let status: Bool?
    let message: String?
   let data: [LogListArr]?
}

// MARK: - DataClass
struct LogListArr: Codable {
    var beacon_lat,beacon_long,user_lat,user_long,created_at,deleted_at,distance: String?
    var beacon_range,beacon_uuid,beacon_status,message,merchant_name,horizontal_accuracy,
        vertical_accuracy: String?
    var id,user_id: Int?
 
}
import Foundation
class LogListViewModel  {
    var LogListwModelDict : LogListwModelData?
    var LogListArr : [LogListArr]?
    func GetLogsDetails(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {

        HitApi.shared.GetRequest(api: k_Get_Log_Data, showLoader: false) { (modal:LogListwModelData) in
                 
                  if (modal.status == true)
                  {
                    self.LogListArr = modal.data
                    completion(true)
                   
                  }else {
                    Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
    func ClearLogsDetails(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
             
                HitApi.shared.GetRequest(api: k_Clear_Log_Data, showLoader: false) { (modal:CommanModel) in
                 
                  if (modal.status == true)
                  {
                    Utility().displayAlertWithCompletion(title: "", message: modal.message ?? "", control: ["Ok"]) { _ in
                        completion(true)
                    }
                   
                  }else {
                          Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
    
}
