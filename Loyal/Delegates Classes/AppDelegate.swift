//
//  AppDelegate.swift
//  Loyal
//
//  Created by user on 07/04/21.
//



import UIKit
import FluidTabBarController
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import UserNotifications
import MTBeaconPlus
import CoreLocation
import BackgroundTasks
import GoogleMaps
import Toast_Swift

var PerDeviceARR = [MTPeripheral]()
@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    var navCon = UINavigationController()
    var window: UIWindow?
    var manager = MTCentralManager.sharedInstance()
    var TempPerDeviceARR = [MTPeripheral]()
    var objNearByMerchantViewModel = NearByMerchantViewModel()
    var objJoinedMerchantBeacon = JoinedMerchantBeacon()
    var locationManager:CLLocationManager? = nil
    var beaconRegions = [CLBeaconRegion]()
    var FiredAlertArr = [BeaconArr]()
 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

       GMSServices.provideAPIKey(k_GoogleKey)
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.loyalfoundry.theloyalapp.db_cleaning", using: nil) { task in
            
            // Downcast the parameter to a processing task as this identifier is used for a processing request
         
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
     
        FirebaseApp.configure()
        setFCM()
      
       // GetBeacons()
        GenerateLogs(msg: "App Initialized -- (from cold start)")
        
   
        NotificationCenter.default.addObserver(self,selector: #selector(GetBeacons),name: NSNotification.Name ("AddNewBeacon"),object: nil)

            return true
    }
    
    
    func GenerateLogs(msg:String) {
        if Utility().isAlreadyLogin()
        {
        self.objNearByMerchantViewModel.CommonPostMethod(url:K_appInitialized,Param: ["message":msg
        ]){ (status) in
        if status
        {
         print("App Initialized -- (from cold start)")
        }
    }
    }
    }
    
    
    @objc func GetBeacons()
    {
        if Utility().isAlreadyLogin()
        {
        self.objJoinedMerchantBeacon.GetJoinedBeacons(url: K_return_joined_uid)
        { status in
            print("----------------beacons List -----")
            
            print(self.objJoinedMerchantBeacon.beaconArr)
            print("----------------beacons list finsh-----")
            self.rangeBeacons()
        
        }
        }
        
    }
    
    @objc func StartupdateLocation() {
        guard locationManager == nil else {return}
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
       locationManager?.desiredAccuracy = kCLLocationAccuracyBest
       locationManager?.requestAlwaysAuthorization()
       locationManager?.distanceFilter = 5
       locationManager?.startMonitoringSignificantLocationChanges()
        if !CLLocationManager.locationServicesEnabled() {
            print("Location services are not enabled")
            self.createSettingsAlertController()
        }
    }
    
    
    
    
    func StopLocationManager() {
        
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .restricted, .denied:
               self.createSettingsAlertController()
               break;
           case .authorizedWhenInUse,.authorizedAlways:
            locationManager?.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self.startBeaconScan()
            }
               break;
           case .notDetermined:
               print("Not determined")
               break;
           @unknown default:
               break;
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.last
       {
        print("Location:",location)
        /* you can use these values*/
        UserDefaultController.shared.currentLatitude = location.coordinate.latitude
        UserDefaultController.shared.currentLongitude  = location.coordinate.longitude
        UserDefaultController.shared.horizontalAccuracy = location.horizontalAccuracy
        UserDefaultController.shared.verticalAccuracy  = location.verticalAccuracy
         
       }
   
     }
    
   
 
   

    func rangeBeacons(){
        for beacon in objJoinedMerchantBeacon.beaconArr {
            
            if let beaconUUID = UUID(uuidString: beacon.beaconUUID)
            {
         //   let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: CLBeaconMajorValue(0), minor: CLBeaconMinorValue(0), identifier: beacon.name ?? "")
            
                let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: CLBeaconMajorValue(0), minor: CLBeaconMinorValue(0), identifier: beacon.name ?? "")
                
                
                
            beaconRegion.notifyOnEntry = true
            beaconRegion.notifyOnExit = true
            beaconRegion.notifyEntryStateOnDisplay = true
            GenerateLogs(msg: "Register Beacon \(beacon.beaconUUID)")
                
            self.beaconRegions.append(beaconRegion)
            }
            else
            {
                GenerateLogs(msg: "Wrong beacon ID \(beacon.beaconUUID)")
            }
        }
        self.startBeaconScan()
        }
  
    func startBeaconScan(){
    
            for beaconRegion in beaconRegions {
                locationManager?.startMonitoring(for: beaconRegion)
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
                }
              
          
                
            
        }
    }
    
 
   
 

    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
       print("*********************")
          let knownBeacons = beacons.filter(){ $0.proximity != .unknown }
            if knownBeacons.count > 0 {
                guard let beaconObj = knownBeacons.first else { return  }
                
              checkBeaconForProximity(beaconRegion: beaconObj, identifierRegion: region)
            } else {
              // print("unknown")
            }
        }
   
    //MARK:- Recent Funcation
   func checkBeaconForProximity(beaconRegion: CLBeacon, identifierRegion: CLBeaconRegion){
     
        let rssiValue = abs(Int(beaconRegion.rssi))
     print("-------------------- check Beacon For Proximity Call--------------------")
     
        
        if( beaconRegion.proximity == CLProximity.unknown) {
          //  print("-------------------- unknown IN--------------------")
                        return;
                    }
       else {
        
      
        
        
        guard let dict = objJoinedMerchantBeacon.rangeDict else { return  }
        
     
  if (rssiValue >= abs(Int(dict.near?.min ?? "0") ?? 0)) && (rssiValue <= abs(Int(dict.near?.max ?? "0") ?? 0)) //Near beacon   -66 to -95 80
        {
            NotificationCenter.default.post(name:Notification.Name("nearFarNotification"), object: "myObject", userInfo: ["state": "near","uid":"\(beaconRegion.uuid)"])
            if checkifITExist(beaconID: "\(beaconRegion.uuid)")
            {
                  for (index,value) in FiredAlertArr.enumerated()
                   {
//                    print("value",value)
//                    print("uuid:",beaconRegion.uuid)
                     if value.beaconUUID ?? "" == "\(beaconRegion.uuid)" && value.beaConState ?? "" != "near"
                     {
                       FiredAlertArr[index].beaConState = "near"
                       BeaconWithNotification(state: "near", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
                     }
                     else
                     {
                      //  BeaconWithNotification(state: "near", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
                       print("same near state")
                     }
            
                   }
            }
            else
           {
//               print("near")
//               print("uuid:",beaconRegion.uuid)
          
            FiredAlertArr.append(BeaconArr(beaConState: "near", beaconUUID: "\(beaconRegion.uuid)"))
            BeaconWithNotification(state: "near", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
           }
        }
       else if (rssiValue >= abs(Int(dict.here?.min ?? "0") ?? 0)) && (rssiValue <= abs(Int(dict.here?.max ?? "0") ?? 0))  //Here  43 to 65
       {
        NotificationCenter.default.post(name:Notification.Name("nearFarNotification"), object: "myObject", userInfo: ["state": "hear","uid":"\(beaconRegion.uuid)"])
        if checkifITExist(beaconID: "\(beaconRegion.uuid)")
        {
         
              for (index,value) in FiredAlertArr.enumerated()
               {
//                print("value",value)
//                print("uuid:",beaconRegion.uuid)
                 if value.beaconUUID ?? "" == "\(beaconRegion.uuid)" && value.beaConState ?? "" != "here"
                 {
                 
                   FiredAlertArr[index].beaConState = "here"
                    BeaconWithNotification(state: "here", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
                  
                 }
                 else
                 {
                   // BeaconWithNotification(state: "here", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
                   print("same here state")
                 }
        
               }
        }
        else
       {
//        print("here")
//        print("uuid:",beaconRegion.uuid)
      
        FiredAlertArr.append(BeaconArr(beaConState: "here", beaconUUID: "\(beaconRegion.uuid)"))
        BeaconWithNotification(state: "here", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
       }
       }
        else
       {
     //   print("Unknown")
      
        if (rssiValue > abs(Int(dict.near?.max ?? "0") ?? 0))
        {
        BeaconWithNotification(state: "abc", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
        }
        }
        
        
      /*  if (rssiValue >= abs(Int(dict.leaving?.min ?? "0") ?? 0)) //state leaving
        {
            BeaconWithNotification(state: "leaving", uid: "\(beaconRegion.uuid)", rssi: beaconRegion.rssi)
           }*/
        }

        
        
    
    }
 
    
    func BeaconWithNotification(state:String,uid:String,rssi:Int) {
 
               
        let params = [     "uid":uid,
                           "state":state,
                         "lat":"\(UserDefaultController.shared.currentLatitude)",
                         "lng":"\(UserDefaultController.shared.currentLongitude)","beacon_range":rssi,"horizontal_accuracy":"\(UserDefaultController.shared.horizontalAccuracy)","vertical_accuracy":"\(UserDefaultController.shared.verticalAccuracy)"
        ] as [String : Any]
        print("Hit K_SendNearNotificationWithBeacon:",K_SendNearNotificationWithBeacon)
        print("Hit Parms:",params)
        self.objNearByMerchantViewModel.CommonPostMethod(url:K_SendNearNotificationWithBeacon,Param: params){ (status) in
        if status
        {
         print("Sucessfully update Beacon")
        }
    }
    }
    
    
    func checkifITExist(beaconID:String) -> Bool   {
        
        if FiredAlertArr.contains(where: { arr in
            return arr.beaconUUID ?? "" == beaconID
        })
        {
            
           return true
            
        }
         else
        {
            return false
        }
        
    }
    
    
    func checkifITSameState(beaconState:String) -> Bool   {
        
        if FiredAlertArr.contains(where: { arr in
            return arr.beaConState ?? "" == beaconState
        })
        {
            
           return true
            
            
        }
         else
        {
            return false
        }
        
    }
    
    
  
    
    
    func postNotification(withBody title: String,body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    /*  Beacon detection with sdk
  //MARK:- Finsh ===================
     func setupBeaconDecter()   {
        // get sharedInstance
       // let manager = MTCentralManager.sharedInstance()

        // listen the change of iPhone bluetooth
        // *** also get from "state" property.
        // *** this SDK will work normally only while state == PowerStatePoweredOn!
        manager?.stateBlock = { state in

            if state == .poweredOn
            {
             //   Utility().displayAlert(message: "Current bluetooth state ON", control: ["Ok"])
                
                print("current bluetooth state ON")
            }
            else if state == .poweredOff
                {
            //   Utility().displayAlert(message: "Current bluetooth state OFF", control: ["Ok"])
                Utility().displayAlert(message: "Please enable Bluetooth to find this near by Beacon", control: ["OK"])
                print("current bluetooth state OFF")
                }
            else //UNKNOWN
            {
                Utility().displayAlert(message: "Please enable Bluetooth to find this near by Beacon", control: ["OK"])
          //     Utility().displayAlert(message: "Current bluetooth state UNKNOWN", control: ["Ok"])
            print("current bluetooth state：\(state)")
            }
            if Utility().isAlreadyLogin()
             {
            self.StartScan()
             }
    }
    }
    
 
   @objc func StartScan()  {
    manager?.startScan({ (perArr) in
        
       // self.postNotification(withBody: "test", body: "asxasc")
        self.TempPerDeviceARR.removeAll()
        if let devices = perArr
        {
            

            for (indexVal,peri) in devices.enumerated()
            {
                if !(PerDeviceARR.contains(peri))
                {
                    self.TempPerDeviceARR.append(peri)
                    PerDeviceARR.append(peri)
                    
                }
        
            
              
                if indexVal == devices.count - 1
                {
                    var tempArr = [String]()
            for (_,peri) in self.TempPerDeviceARR.enumerated()
             {
              if let beaconId = peri.framer?.mac
              {
                tempArr.append(beaconId)
              }
               }
           let beaconID = tempArr.joined(separator: ",")
          // print("Detected devices beacon ID IN temp arr :::",tempArr)
            if beaconID != ""
            {
            print("Detected devices beacon ID :::",beaconID)
           // self.UpdateBeacons(beaconId: beaconID)
            }
            }
            }
         /*   for (_,peri) in devices.enumerated()
            {
                let framer = peri.framer
                let name = framer?.name // name of device, may nil
                let rssi = framer?.rssi ?? 0 // rssi
                let battery = framer?.battery ?? 0 // battery,may nil
                let mac = framer?.mac // mac address,may nil
                let framesval = framer?.advFrames // all data frames of device（such as:iBeacon，UID，URL...）
                print("Detected frame:",framer)
                print("Detected name:",name)
                print("Detected rssi:",rssi)
                print("Detected battery:",battery)
                print("===================================================")
                print("Detected mac:",mac)
                print("===================================================")
                print("Detected device:",peri)
                print("Detected frames res:",framesval)
            }*/
        }
        })
    print("Detected devices count:",PerDeviceARR.count)
    }
    */
    
    func UpdateBeacons(beaconId:String) {
     
        let params = [     "beaconId":beaconId,
                           "userId":"\(UserDefaultController.shared.signUpTempData?.id ?? 0)","deviceToken":"\(UserDefaultController.shared.FCMToken ?? "")"
        ] as [String : Any]
        
     //   print("Parms:",params)
        self.objNearByMerchantViewModel.UpdateNearByMercahnts(url:K_SendNearNotification,Param: params){ (status) in
        if status
        {
         print("Sucessfully update beacon")
        }
    }
    }
    
    
    
    
    
    
    func UpdateUserLocation() {
       
        let params = [
                           "uid":"\(UserDefaultController.shared.signUpTempData?.id ?? 0)",
                         "lat":"\(UserDefaultController.shared.currentLatitude)",
                          "lng":"\(UserDefaultController.shared.currentLongitude)"
        ] as [String : Any]
        
       print("Parms:",params)
        self.objNearByMerchantViewModel.CommonPostMethod(url:K_UpdateLocation,Param: params){ (status) in
        if status
        {
        print("Sucessfully update location")
        }
    }
    }
    
    
    func setFCM() {
    
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
            if error != nil {
                print(error?.localizedDescription ?? "some error in requesting auth for notifications")
            }
        }
        
        
        
        //get application token
        Messaging.messaging().token { token, error in
           // Check for error. Otherwise do what you will with token here
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let Token = token {
              //  print("Remote instance ID token: \(Token)")
                UserDefaultController.shared.FCMToken = Token
               // self.updateFcm()
            }
            
        }
                
        UIApplication.shared.registerForRemoteNotifications()
    }
   
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("response:",userInfo)
      _ = handleNotification(usrInfo:userInfo, sendToVC: false)
   
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("response:",response.notification.request.content.userInfo)

        _ = handleNotification(usrInfo: response.notification.request.content.userInfo, sendToVC: true)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    //MARK:- Did Register For Remote Notifications With Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       // print("enter deviceToken:")
         
        //Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #else
         Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #endif
        
 let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    //    print("deviceTokenString :", deviceTokenString)
        
       
        
        
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       // print("will present")
         print("response:",notification.request.content.userInfo)
        
      let status = handleNotification(usrInfo: notification.request.content.userInfo, sendToVC: false)
        
        if status == "silent"
        {
            completionHandler([])
        }
        else
        {
        if #available(iOS 14.0, *) {
            
            completionHandler([.list, .banner, .sound])
             } else {
                completionHandler([.alert, .badge, .sound])
             }
        }
     
    }
 
 
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
//MARK:- HANDLE NOTIFICATIONS-
    func handleNotification(usrInfo: [AnyHashable : Any], sendToVC: Bool)->String {
        print(usrInfo)
        
        if let apsDictStr = (usrInfo["aps"] as? [String:Any])
        {
            if ((apsDictStr["content-available"] as? String) == "1")
            {
              
                print("enter")
                return("silent")
            }
           else if let type = (apsDictStr["category"] as? String){
            
            print("notification type:",type)
          
            guard let topVC = Utility().topController else {
                return ""
            }
                switch type {
                case "visitNotification":
                    
                    if topVC.isKind(of:LocalsVC.self)
                    {
                         print("Opened local vc")
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLocalVC"), object: nil, userInfo: nil)
                        
                    }
                    else
                    {
                        print("Not open local vc")
                    }
                    
                    break
                case "gotRewardNotification":
                    
                    
                    if let apsDictStr = (usrInfo["gcm.notification.data"] as? String)
                     {
                      
                        guard let apsDict = convertToDictionary(text:apsDictStr) else { return("")  }
                    
                        guard let rewardId = apsDict["rewardId"] as? Int else { return("")  }
                        
                    
                        if (topVC.isKind(of:RewardVC.self) == false)
                        {
                            print("Not open")
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = mainStoryboard.instantiateViewController(withIdentifier: "RewardVC") as! RewardVC
                    navCon.isNavigationBarHidden = true
                    VC.rewardId = "\(rewardId)"
                    self.navCon.pushViewController(VC, animated:false)
                        }
                        else
                        {
                            print("already open RewardVC vc")
                        }
                        
                   
                   
                      }
                    
                break
                    
                case "someOneIsNearYou":
                    
                    break
                    
                default:
                    break
                }
                
                
            }
        }
        return("")
    
         
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
     print("Firebase registration token: \(fcmToken)")
//        Indicator.shared.fcmToken = fcmToken
        if let token = fcmToken
        {
        UserDefaultController.shared.FCMToken = token
        }
      
    
    }
    

    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }

    func createSettingsAlertController() {
      let alertController = UIAlertController(title: "This app requires us to use your location.", message: "We do not save your location or share it with third parties.", preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
      let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
      }
      alertController.addAction(cancelAction)
      alertController.addAction(settingsAction)
        guard let topVC = Utility().topController else {
            return
        }
        topVC.present(alertController, animated: true, completion: nil)
   }
}
