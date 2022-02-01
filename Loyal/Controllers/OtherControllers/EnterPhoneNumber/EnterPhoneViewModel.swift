//
//  EnterPhoneViewModel.swift
//  Loyal
//
//  Created by user on 14/04/21.
//

struct LoginSignUpModal: Codable {
    let status: Bool?
    let message: String?
   let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var access_token : String?
    var first_name : String?
    var last_name,contact_number : String?
    var email,image,latitude : String?
    var longitude,notifications_status,device_type: String?
    var id,is_new_user: Int?
    let updatedAt,createdAt: String?
   
  /*  enum CodingKeys: String, CodingKey {
        case name = "name"
        case gender = "gender"
        case phone, dob, image
        case id
        case email
        case updatedAt = "updated_at"
        case createdAt = "created_at"
       
    }*/
}



import Foundation

class EnterPhoneViewModel {
    
func doLogin(Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
 
    HitApi.shared.sendRequest(api: k_Login_Signup, parameters: Param, showLoader: true) { (modal:LoginSignUpModal) in
     
        if (modal.status == true)
        {
          UserDefaultController.shared.signUpTempData = modal.data
          UserDefaultController.shared.accessToken = modal.data?.access_token
           
          
            Utility().setAlreadyLogin(true)
              completion(true)
            
         
        }else {
                Utility().showAlert(mesg: modal.message ?? "")
                    completion(false)
        }
        
    }
}
}
