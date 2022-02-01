//
//  BeaconModel.swift
//  Loyal
//
//  Created by user on 06/07/21.
//

import Foundation

struct JoinBeacon:Codable {
    let status: Bool?
    let message: String?
    let data: [Beacon]?
    var range: range?
}


struct Beacon: Codable, Equatable {
    var name: String?
    var beacon_id: String?
    var beaconUUID: String
  //  var major: Int?
  //  var minor: Int?
   
}

struct range: Codable {
    var far: Values?
    var near: Values?
    var here: Values?
    var leaving: Values?
}

struct Values: Codable {
    var min: String?
    var max: String?
}


extension Beacon {
    //This method for comparison of 2 Beacon
    static func ==(lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.beaconUUID == rhs.beaconUUID && lhs.beacon_id == rhs.beacon_id && lhs.name == rhs.name
    }
}



class JoinedMerchantBeacon {
    var beaconArr = [Beacon]()
    var rangeDict: range?
    
    func GetJoinedBeacons(url:String,Param: [String: Any]? = nil, completion: @escaping (Bool) -> ()) {
     
     
        HitApi.shared.GetRequest(api:url, showLoader: false){ (model:JoinBeacon) in
        
                  if (model.status == true)
                  {
                    if let data = model.data
                    {
                        self.beaconArr = data
                    }
                    if let dict = model.range
                    {
                        self.rangeDict = dict
                    }
                        completion(true)
                   
                  }else {
                        //  Utility().showAlert(mesg: modal.message ?? "")
                              completion(false)
                  }
     
        }

    }
    
    
}




struct BeaconArr: Codable, Equatable {
    var beaConState: String?
    var beaconUUID: String?
   }

extension BeaconArr {
    //This method for comparison of 2 Beacon
    static func ==(lhs: BeaconArr, rhs: BeaconArr) -> Bool {
        return lhs.beaconUUID == rhs.beaconUUID && lhs.beaConState == rhs.beaConState
    }
}
