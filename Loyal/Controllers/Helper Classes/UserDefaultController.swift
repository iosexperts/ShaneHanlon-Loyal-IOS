//
//  UserDefaultController.swift
//  Water Waze
//
//  Created by Sonu on 03/09/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

class UserDefaultController {
    
    static let shared = UserDefaultController()
    
    private init() {}
     
    var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }

    var userId: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "userId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
        }
    }
    
    
    var nearByType: String? {
        get {
            return UserDefaults.standard.string(forKey: "nearByType")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "nearByType")
        }
    }
    
    
    var signUpTempData: DataClass? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "signUpTempData") else { return nil }
            return try? JSONDecoder.init().decode(DataClass.self, from: data)
        }
        set {
            
            let data = try? JSONEncoder.init().encode(newValue)
            UserDefaults.standard.set(data, forKey: "signUpTempData")
            UserDefaults.standard.synchronize()
        }
    }
    
   
    func isNeedToRefresh() -> Bool {
//                    guard let newValue = newValue else { return }
        guard let lastAccessDate = UserDefaults.lastAccessDate else {
                        
                        return true
                    }
                    if !Calendar.current.isDateInToday(lastAccessDate) {
                        print("remove Persistent Domain")
                        return true
                    }else
                    {
                        return false
                    }
    }
    
    func ResetLocalStorage()  {
           UserDefaults.standard.removeObject(forKey: "accessToken")
           UserDefaults.standard.removeObject(forKey: "signUpTempData")
           Utility().setAlreadyLogin(false)
       }
    
    var currentLatitude: Double {
          get {
              return UserDefaults.standard.double(forKey: "lat")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "lat")
              UserDefaults.standard.synchronize()
          }
      }
      
    
    var horizontalAccuracy: Double {
          get {
              return UserDefaults.standard.double(forKey: "horizontal_accuracy")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "horizontal_accuracy")
              UserDefaults.standard.synchronize()
          }
      }
    
    var verticalAccuracy: Double {
          get {
              return UserDefaults.standard.double(forKey: "vertical_accuracy")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "vertical_accuracy")
              UserDefaults.standard.synchronize()
          }
      }
    
    
      var currentLongitude: Double {
          get {
              return UserDefaults.standard.double(forKey: "log")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "log")
              UserDefaults.standard.synchronize()
          }
      }
    
    
    var currentLatitude_RecordVc: Double {
             get {
                 return UserDefaults.standard.double(forKey: "lat")
             }
             set {
                 UserDefaults.standard.set(newValue, forKey: "lat")
                 UserDefaults.standard.synchronize()
             }
         }
         
         var currentLongitude_RecordVc: Double {
             get {
                 return UserDefaults.standard.double(forKey: "log")
             }
             set {
                 UserDefaults.standard.set(newValue, forKey: "log")
                 UserDefaults.standard.synchronize()
             }
         }
    
    
    var FCMToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "FCMTOKEN")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FCMTOKEN")
            UserDefaults.standard.synchronize()
        }
    }
    var MapType: Int? {
        get {
            return UserDefaults.standard.integer(forKey: "MapType")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "MapType")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
}
extension UserDefaults {

    static let defaults = UserDefaults.standard

    static var lastAccessDate: Date? {
        get {
            return defaults.object(forKey: "lastAccessDate") as? Date
        }
        set {
//            guard let newValue = newValue else { return }
//            guard let lastAccessDate = lastAccessDate else {
//                defaults.set(newValue, forKey: "lastAccessDate")
//                return
//            }
//            if !Calendar.current.isDateInToday(lastAccessDate) {
//                print("remove Persistent Domain")
//               // UserDefaults.reset()
//            }
            defaults.set(newValue, forKey: "lastAccessDate")
        }
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: "weatherBit")
    }
    
    
}
