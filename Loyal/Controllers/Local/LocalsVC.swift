//
//  LocalsVC.swift
//  Loyal
//
//  Created by user on 07/04/21.
//

import UIKit
import Kingfisher
import CoreLocation
import FluidTabBarController
import CoreBluetooth

class LocalsVC: UIViewController {
    var objNearByMerchantViewModel = NearByMerchantViewModel()
    
    var objLocalVM = VaultViewModel()
    var locationManager: CLLocationManager!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!{
        didSet{tblView.dataSource = self;tblView.delegate = self
            tblView.tableFooterView = UIView()
        }
    }
   var CheckPermissionTimer = Timer()
var manager = CBCentralManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateFCM()
        let appdel = UIApplication.shared.delegate as? AppDelegate
        appdel?.StartupdateLocation()
       // if  Utility().isBluetoothPermissionGranted == false
       // {
       // CheckPermissionTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(CheckBlueToothPermission), userInfo: nil, repeats: true)
       // }
        
        NotificationCenter.default.post(name:NSNotification.Name("AddNewBeacon"),object: nil,userInfo: nil)
       
        NotificationCenter.default
                                 .addObserver(self,
                                              selector: #selector(getVaultsList),
                                name: NSNotification.Name ("updateLocalVC"),                                           object: nil)
        
    }
    
    
  
    
    @objc func CheckBlueToothPermission()   {
        
      if  Utility().isBluetoothPermissionGranted
            {
        CheckPermissionTimer.invalidate()
        CheckPermissionTimer = Timer()
        NotificationCenter.default                .post(name:NSNotification.Name("TriggerDetectBeacon"),
                     object: nil,
                     userInfo: nil)
            }
        else
      {
        print("CheckBlueToothPermission:",Utility().isBluetoothPermissionGranted)
        print("Blue False")
       
        
      }
       
        
        
    }
    
 
   
    override func viewWillAppear(_ animated: Bool) {
        
      
        
        if let LoginUserData = UserDefaultController.shared.signUpTempData
               {
            if let url = URL(string: "\(UserImageBaseUrl)\(LoginUserData.id ?? 0)/\(LoginUserData.image ?? "")")
                {
                self.imgViewProfile.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
                }
        }
        
    //    getVaultsList()
        getLocation()
  
      
    }
    
    func UpdateFCM() {
        
        let params = [     "deviceType":"ios",
                           "userId":"\(UserDefaultController.shared.signUpTempData?.id ?? 0)","deviceToken":"\(UserDefaultController.shared.FCMToken ?? "")"
        ] as [String : Any]
        
     //   print("Parms:",params)
        self.objNearByMerchantViewModel.UpdateFCMToken(Param: params){ (status) in
        if status
        {
         print("Sucessfully update Token")
        }
    }
    }
    
    
    
    //MARK: Set Up Get Location -
    func getLocation()
     {
         if CLLocationManager.locationServicesEnabled() {
                    locationManager = CLLocationManager()
                    locationManager.requestAlwaysAuthorization()
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.startUpdatingLocation()
                    locationManager.delegate = self
                    locationManager.startUpdatingHeading()
                }
     }
    //MARK:-
    
    //MARK: get NearBy Locals List -
    @objc func getVaultsList() {
        let params = [     "latitude":UserDefaultController.shared.currentLatitude,
                           "longitude":UserDefaultController.shared.currentLongitude,"radius":97.8 //10000
        ] as [String : Any]
        self.objLocalVM.LocalList(Param: params){ (status) in
        if status
        {
          self.tblView.reloadData()
        }
    }
    }
    
    //MARK:-

}
extension LocalsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return objLocalVM.LocalListArr?.count ?? 0
    }
         
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cellid")as! HomeTblCell
       

        cell.selectionStyle = .none
        let TempDict = objLocalVM.LocalListArr?[indexPath.row]
        
        let imageurl = "\(MerchantImageBaseUrl)\(TempDict?.id ?? 0)/\(TempDict?.image ?? "")"
        if let url = URL(string:imageurl)
        {
            cell.imgViw.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "dummy_banne"))
        }
        if TempDict?.gotRewardOrNot == true
        {
            cell.ConHeightReward.constant =  25
        }
        else
        {
            cell.ConHeightReward.constant =  0
        }
        cell.buttonJoinAction = {
            cell in
            
            self.objLocalVM.JoinMerchant(Param: ["merchant_id":"\(TempDict?.id ?? 0)"]){ (status) in
            if status
            {
                NotificationCenter.default.post(name:NSNotification.Name("AddNewBeacon"),
                             object: nil,
                             userInfo: nil)
                
                
            self.removeObjPerDeviceARR(BeaconID: TempDict?.beacon_id ?? "")
              //  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getVaultsList()
              //  }
            let ObjCustomPopView = JoinPopUp.shared
                let Subview = ObjCustomPopView.loadViewFromNib()
            Subview.frame = self.view.bounds
            ObjCustomPopView.SetupUI(imageUrl:imageurl)
             ObjCustomPopView.isMoveNextTapped = {
                 Status in
                print(Status)
                Subview.removeFromSuperview()
             }
             self.view.addSubview(Subview)
                }
            }
        }
        
        
        if TempDict?.is_joined == 0
        {
            cell.ViewJoin.isHidden = false
            cell.ViewLike.isHidden = true
        }
        else
        {
            cell.ViewJoin.isHidden = true
            cell.ViewLike.isHidden = false
        }
        cell.lblFav.text = "\(TempDict?.visits_until_next_reward ?? 0)"
        cell.lbltitle.text = TempDict?.name ?? ""
       // cell.lblDescription.text = "\(TempDict?.city ?? ""), \(TempDict?.state ?? "")"
       //  cell.lblDescription.text = "1 Large Fry"
       
        
      //let distancess = Double(TempDict?.distance ?? 0)
       
        cell.lblLikes.text = "\(String(format: "%.1f", TempDict?.distance ?? 0.0)) \(TempDict?.distance_unit ?? "")"
       
      
        return cell
    }
    
    func removeObjPerDeviceARR(BeaconID:String)  {
        
       
        if let indexOfPerDevice = PerDeviceARR.firstIndex(where: {$0.framer.mac == BeaconID})
       {
            print("index:",indexOfPerDevice)
            print("Count:",PerDeviceARR.count)
            PerDeviceARR.remove(at: indexOfPerDevice)
            print("Count:",PerDeviceARR.count)
            print("Count:",PerDeviceARR)
       }
        
        
    }
 
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // return 195
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TempDict = objLocalVM.LocalListArr?[indexPath.row]
  
       if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RewardDetailsVC") as? RewardDetailsVC {
            viewController.merchantId = "\(TempDict?.id ?? 0)"
        let navi = UINavigationController(rootViewController: viewController)
        navi.navigationBar.isHidden = true
        viewController.isDismissDetailsVC = { state in
           
            self.getLocation()
                
        }
           // self.navigationController?.pushViewController(viewController, animated: true)
        navi.modalPresentationStyle = .overFullScreen
        self.present(navi, animated: true, completion: nil)
           }
        
        
      //  Utility().pushViewControl(ViewControl: "RewardDetailsVC")
        
    }
    
}
class HomeTblCell:UITableViewCell{
    
    
    @IBOutlet weak var ConHeightReward: NSLayoutConstraint!
    @IBOutlet weak var lblFav: UILabel!
    @IBOutlet weak var imgViw: UIImageView!
    
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var ViewLike: UIView!
    @IBOutlet weak var ViewJoin: ViewCustom!
   // @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
  //  var buttonDeleteVaultAction : ((HomeTblCell) -> Void)?
   // var buttonEditVaultAction : ((HomeTblCell) -> Void)?
   var buttonJoinAction : ((HomeTblCell) -> Void)?
    //@IBOutlet weak var ViewMore: ViewCustom!
    
   // @IBOutlet weak var BtnMoreAct: UIButton!
    
    @IBAction func BtnJoinAct(_ sender: UIButton) {
        self.buttonJoinAction?(self)
    }
    
    
   /* @IBAction func BtnTabDeleteAct(_ sender: UIButton) {
        self.buttonDeleteVaultAction?(self)
    }
    
    
    @IBAction func BtnTabEditAct(_ sender: UIButton) {
        self.buttonEditVaultAction?(self)
    }*/
}
//MARK:- CL Location Manager Delegate
extension LocalsVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let userLocation = locations.last
       {
        UserDefaultController.shared.currentLatitude = userLocation.coordinate.latitude
        UserDefaultController.shared.currentLongitude = userLocation.coordinate.longitude
      
        getVaultsList()
//        NotificationCenter.default.post(name:NSNotification.Name("TriggerUpdateLoc"),
//                     object: nil,
//                     userInfo: nil)
       locationManager.stopUpdatingLocation()
       }
        
        
       
    }
    
   
  /*  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        rangeBeacons()

    }

   
    func rangeBeacons1(){
        let uuid = UUID(uuidString: "3e1d7817-4eac-4b27-b809-deee2f246c46")
        //let uuid = UUID(uuidString: "8492E75F-4FD6-469D-B132-043FE94921D8")
        let major:CLBeaconMajorValue = 1000
        let minor:CLBeaconMinorValue = 200
        let identifier = "myBeacon"
        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyEntryStateOnDisplay = true
        region.notifyOnExit = true
        locationManager.startRangingBeacons(in: region)
        locationManager.startMonitoring(for: region)
    }*/

   
    
}
