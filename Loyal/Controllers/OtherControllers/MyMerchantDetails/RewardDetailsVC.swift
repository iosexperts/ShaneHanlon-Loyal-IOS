//
//  RewardDetailsVC.swift
//  Loyal
//
//  Created by user on 09/04/21.
//

import UIKit
import GoogleMaps
class RewardDetailsVC: UIViewController {
    
    @IBOutlet weak var ConAvialableRewardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ViewRedeemReward: ViewCustom!
  //  @IBOutlet weak var ConViewRedeemReward: NSLayoutConstraint!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var rewardViewHeightCon: NSLayoutConstraint!
   
    @IBOutlet weak var mapViw: GMSMapView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var ViewSummaryTbl: UIView!
    var isSummaryExpend = true
    var merchantId = ""
    var objMyMerchantsDetails = MyMerchantsDetailsViewModel()
   /*
    @IBOutlet weak var lblRewardDescription: UILabel!
    @IBOutlet weak var lblTitleReward: UILabel!
    @IBOutlet weak var ImgReward: UIImageView!
    */
    var Availbearr = ["Reward","Next Reward"]
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblMapAddress: UILabel!
    
    @IBOutlet weak var lblFavRewards: UILabel!
    @IBOutlet weak var lblRewards: UILabel!
    @IBOutlet weak var TblViwNextReward: UITableView!{
        didSet{TblViwNextReward.dataSource = self;TblViwNextReward.delegate = self
            TblViwNextReward.tableFooterView = UIView()
        }
    }
    var isDismissDetailsVC : ((Bool) -> Void)?
    @IBOutlet weak var lblVcTitle: UILabel!
    @IBOutlet weak var ViwNextHeightContstraint: NSLayoutConstraint!
    @IBOutlet weak var TblViewActivitySum: UITableView!{
        didSet{TblViewActivitySum.dataSource = self;TblViewActivitySum.delegate = self
            TblViewActivitySum.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var ViewActivityHeightConstraint: NSLayoutConstraint!
    var objLocalVM = VaultViewModel()
    @IBOutlet weak var ViewJoin: UIView!
    @IBOutlet weak var ViewAvialbleReward: ViewCustom!
    @IBOutlet weak var ViewNextRewardCount: ViewCustom!
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let color = ["015f40","014c5e","0B718a","11015f","5f0120","5f4001","40015f","8A8D91"]
        
        if let randomElement = color.randomElement() {
            self.view.backgroundColor = UIColor(hexFromString:randomElement)
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GetList()
        GetRewardsList()
        
    }

   
    func GetList(){
        
        objMyMerchantsDetails.GetMerchantDetails(merchantId: merchantId) { (status) in
            if status
            {
             
                self.setupUI()
                self.setupRewards()
            }
        }
    }
    
    
    func GetRewardsList(){
        
        objMyMerchantsDetails.GetUserRewardsList(Param:["merchant_id":merchantId]) { (status) in
            if status
            {
                self.setupUI()
                self.setupRewards()
              
            }
        }
    }
    
    @IBAction func BtnAddWalletAct(_ sender: Any) {
    }
    
    @IBAction func BtnfullScreenMapAct(_ sender: UIButton) {
        BtnAddressAct(sender)
    }
   
    
    func setupUI()  {
        
        guard let tempDict = objMyMerchantsDetails.MyMerchantDict else { return }
        // print("tempDict:",tempDict)
        lblVcTitle.text =  tempDict.name ?? ""
        lblPhone.text = format(with: "XXX-XXX-XXXX", phone: tempDict.contact_number ?? "")
        if let add = tempDict.address?.components(separatedBy: ",")
        {
        let Fadd: String? = add.count > 1 ? add[0] : tempDict.address
        lblAddress.text = "\(Fadd ?? ""), \(tempDict.suite ?? "")\n\(tempDict.city ?? ""), \(tempDict.state ?? "") \(tempDict.zip_code ?? "")"
        }
        lblMapAddress.text = tempDict.address ?? ""
        lblRewards.text = "\(tempDict.redeemed_rewards ?? 0)"
        
        if tempDict.is_joined == 0
         {
            ViewJoin.isHidden = false
            ViewNextRewardCount.isHidden = true
            ViewAvialbleReward.isHidden = true
           
            
        }
        else
        {
            ViewJoin.isHidden = true
            ViewNextRewardCount.isHidden = false
            ViewAvialbleReward.isHidden = false
            
            
       /* if tempDict.visits_until_next_reward ?? 0 < 0
        {
           
            ViewNextRewardCount.isHidden = true
        }
        else
        {
           
            ViewNextRewardCount.isHidden = false
        
        }*/
        }
        lblFavRewards.text = "\(tempDict.visits_until_next_reward ?? 0)"
        
        if let url = URL(string: "\(MerchantImageBaseUrl)\(tempDict.id ?? 0)/\(tempDict.image ?? "")")
            {
            self.imgProfile.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
            }
        
        let center = CLLocationCoordinate2D(latitude: Double(tempDict.latitude ?? "") ?? 0.0, longitude: Double(tempDict.longitude ?? "") ?? 0.0)
          
        let marker = GMSMarker(position: center)
        marker.map = self.mapViw
        let camera = GMSCameraPosition.camera(withTarget: center, zoom: 15)
        self.mapViw?.animate(to: camera)
        marker.title = tempDict.address ?? ""
       
       // marker.icon = #imageLiteral(resourceName: "checkinIcon")
    
        
        /*  let PointAnnotation = MKPointAnnotation()
        PointAnnotation.coordinate = CLLocationCoordinate2D(latitude: Double(tempDict?.latitude ?? "") ?? 0.0, longitude: Double(tempDict?.longitude ?? "") ?? 0.0)
        mapViw.addAnnotation(PointAnnotation)
                   
        let span = MKCoordinateSpan(latitudeDelta: 1.00, longitudeDelta: 1.00)
           let region = MKCoordinateRegion(center: PointAnnotation.coordinate, span: span)
           self.mapViw.setRegion(region, animated: true)*/
        
     

    }
    
    
    @IBAction func BtnJoinAct(_ sender: UIButton) {
        guard let tempDict = objMyMerchantsDetails.MyMerchantDict else { return }
        self.objLocalVM.JoinMerchant(Param: ["merchant_id":"\(tempDict.id ?? 0)"]){ (status) in
        if status
        {
            self.GetList()
            self.GetRewardsList()
            NotificationCenter.default.post(name:NSNotification.Name("AddNewBeacon"),
                         object: nil,
                         userInfo: nil)
            
            let ObjCustomPopView = JoinPopUp.shared
                let Subview = ObjCustomPopView.loadViewFromNib()
            Subview.frame = self.view.bounds
            let imageurl = "\(MerchantImageBaseUrl)\(tempDict.id ?? 0)/\(tempDict.image ?? "")"
            ObjCustomPopView.SetupUI(imageUrl:imageurl)
             ObjCustomPopView.isMoveNextTapped = {
                 Status in
                print(Status)
                Subview.removeFromSuperview()
             }
             self.view.addSubview(Subview)
            
            
        }}
        
    }
    
  func setupRewards()
    {
        if let rewardCount = objMyMerchantsDetails.UserRewardArr?.count
        {
            let AvailableHeight = rewardCount > 0 ? CGFloat((rewardCount * 135)) : 0
            
            let rewardCountVal = objMyMerchantsDetails.MyMerchantDict?.rewards?.count ?? 0
    
            let rewardHeight = rewardCountVal <= 0 ? 0 : 155
            
            
            ConAvialableRewardHeight.constant = AvailableHeight + CGFloat(rewardHeight) //rewardCount != 0 ? 135 : 0
        ViewRedeemReward.clipsToBounds = rewardCount != 0 ? false : true
        ViwNextHeightContstraint.constant = CGFloat(rewardCount * 120)
    //    rewardViewHeightCon.constant = rewardCount > 0 ? 30 : 0
        TblViwNextReward.reloadData()
        TblViewActivitySum.reloadData()
        }
        else
        {
            ViewRedeemReward.clipsToBounds = true
            ConAvialableRewardHeight.constant = 0
          //  rewardViewHeightCon.constant = 0
            ViwNextHeightContstraint.constant = 0
        }
   
    
  /*  if let TempDict = objMyMerchantsDetails.UserRewardArr?.first
    {
        lblRewardDescription.text = TempDict.description
    if let url = URL(string: "\(rewardBaseUrl)\(TempDict.id ?? 0)/\(TempDict.image ?? "")")
        {
        ImgReward.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
        }
    }*/
    }
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    @IBAction func BtnNextRewardAct(_ sender: Any) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RewardVC") as? RewardVC {
           
            self.navigationController?.pushViewController(viewController, animated: true)
               
           }
    }
    
    
    func BtnRedeemAct(reward_Id:String) {
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RewardVC") as? RewardVC {
            viewController.rewardId = reward_Id
            self.navigationController?.pushViewController(viewController, animated: true)
           }
        
        
        
        
        
    }
    
    
     func BtnRedeemAct(AvailDict:PendingRewardsFromRedeem) {
        
        
     let ObjredeemView1 = RedeemView1.shared
     let Subview = ObjredeemView1.loadViewFromNib()
        Subview.frame = self.view.bounds
        if objMyMerchantsDetails.UserRewardArr?.count != 0
        {// guard let tempDict = AvailDict else { return}
            ObjredeemView1.SetupUI(UserRewardDict:AvailDict,MercahntImg: objMyMerchantsDetails.MyMerchantDict?.image ?? "",MerchantId: "\(objMyMerchantsDetails.MyMerchantDict?.id ?? 0)",beaconId:objMyMerchantsDetails.MyMerchantDict?.beaconUUID ?? "")
        }
         ObjredeemView1.isMoveNextTapped = {
             Status in
            print(Status)
           
            Subview.removeFromSuperview()
            self.GetList()
            self.GetRewardsList()
         }
       
         self.view.addSubview(Subview)
    }
    @IBAction func BtnAddressAct(_ sender: UIButton) {
        guard let TempDict = objMyMerchantsDetails.MyMerchantDict else { return  }
        if let url = URL(string:"http://maps.apple.com/?daddr=\(TempDict.latitude ?? ""),\(TempDict.longitude ?? "")")
       {
      UIApplication.shared.open(url)
       }
    }
    
    @IBAction func BtnPhoneAct(_ sender: Any) {
        guard let number = URL(string: "tel://" + "\(lblPhone.text ?? "")") else { return }
        UIApplication.shared.open(number)
        
    }
    @IBAction func BtnBackAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.isDismissDetailsVC?(true)
       // Utility().PopVC()
        
    }
    @IBAction func BtnSummaryExpendableAct(_ sender: UIButton) {
//      if (objMyMerchantsDetails.MyMerchantDict?.visitDetails?.count == 0)
//      {
//        Utility().displayAlert(message: "No Visits, please stop by today:", control: ["Ok"])
//      }
//      else
//      {
        isSummaryExpend = !isSummaryExpend
        ViewSummaryTbl.isHidden = isSummaryExpend
    //  }
      }
    

}
extension RewardDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == TblViewActivitySum
        {
            if section == 0
            {
               /* if objMyMerchantsDetails.MyMerchantDict?.visitDetails?.count ?? 0 == 0 {
                    tableView.setEmptyMessage()
                    
                   } else {
                    tableView.restore()
                   }*/
                if objMyMerchantsDetails.MyMerchantDict?.visitDetails?.count ?? 0 == 0 {
                     return 1
                     
                    } else {
                        return objMyMerchantsDetails.MyMerchantDict?.visitDetails?.count ?? 0
                    }
                
               
            }
            else
            {
                if objMyMerchantsDetails.MyMerchantDict?.rewardRedemption?.count ?? 0 == 0 {
                     return 1
                     
                    } else {
                        return objMyMerchantsDetails.MyMerchantDict?.rewardRedemption?.count ?? 0
                    }
               
            }
            }
         else
        {
          if section == 0
          {
            let count = objMyMerchantsDetails.UserRewardArr?.count ?? 0
            if count == 0
            {
              return objMyMerchantsDetails.MyMerchantDict?.rewards?.count ?? 0 > 0 ? 1 : 0
            }
            else{
                return count
            }
            }
            else
          {
            return objMyMerchantsDetails.MyMerchantDict?.rewards?.count ?? 0 > 0 ? 1 : 0
         }
        }
   
    }
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
       if tableView == TblViewActivitySum
       {
        return 2
//        if objMyMerchantsDetails.MyMerchantDict?.visitDetails?.count ?? 0 == 0
//        {
//       return 1
//        }
//        else
//        {
//            return 2
//        }
        }
        else
       {
       // print("Val1:",objMyMerchantsDetails.MyMerchantDict?.rewards?.count ,"\n","Val2:",objMyMerchantsDetails.UserRewardArr?.count)
        if objMyMerchantsDetails.MyMerchantDict?.rewards?.count ?? 0 > 0 && objMyMerchantsDetails.UserRewardArr?.count ?? 0 > 0
        {
            return 2
        }
        else
        {
            return 1
        }
        
     
       }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == TblViewActivitySum
        {
            if section == 0
          {
            guard let View = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") else {
                return UIView()
            }
            
            
            
            
            return View
          }
            else
          {
            guard let View = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? headerCell  else {
                return UIView()
            }
            
            View.lblHeadertitle.text = "Recent Reward Redemptions"
            View.lblHeadertitle.textAlignment = .center
            
            return View
          }
    }
        else
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? headerCell  else {
                return UIView()
                
                
                
            }

//            if objMyMerchantsDetails.UserRewardArr?.count ?? 0 > 0
//           {
//                cell.lblHeadertitle.text = "Reward"
//                return cell
//           }
//            else if objMyMerchantsDetails.MyMerchantDict?.rewards?.count ?? 0 > 0
//            {
             //   cell.lblHeadertitle.text = "Next Reward"
           // }
            return cell
          /*  else
            {
            return UIView()
            }*/
            }
      }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      
       if tableView == TblViewActivitySum
        {
        if objMyMerchantsDetails.MyMerchantDict?.visitDetails?.count == 0 && section == 0
        {
            return 0
        }
        else
        {
        return 30
        }
        }
         else
        {
        if section == 0 && objMyMerchantsDetails.UserRewardArr?.count ?? 0 > 0
            {
                return 0
            }
            else
            {
         return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == TblViewActivitySum
        {
        let TempDict = objMyMerchantsDetails.MyMerchantDict
            if indexPath.section == 0
            {
               if TempDict?.visitDetails?.count == 0
               {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? headerCell else { return UITableViewCell()}
                
                cell.lblHeadertitle.text = "No Visits, please stop by today:"
                cell.lblHeadertitle.textAlignment = .center
                cell.lblHeadertitle.font = UIFont(name: "Montserrat Medium", size: 18)
                return cell
               }
                else
               {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid") as? ActivitySummeryTblCell else {
                    return UITableViewCell()
                }
                    guard let TempDict = objMyMerchantsDetails.MyMerchantDict?.visitDetails?[indexPath.row] else { return UITableViewCell()}
                   
                 
                    cell.lblDate.text = Utility().getFormattedDate(string: TempDict.created_at ?? "", currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "MM-dd-yy")
                    cell.lblVisitNo.text = "\(indexPath.row + 1)"
                   cell.lbltime.text = Utility().getFormattedDate(string: TempDict.created_at ?? "", currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "h:mm a")
                   return cell
               }
                
            }
           else
            {
            if TempDict?.rewardRedemption?.count == 0
            {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? headerCell else { return UITableViewCell()}
            
                cell.lblHeadertitle.text = "No Redemption reward yet"
                cell.lblHeadertitle.textAlignment = .center
                cell.lblHeadertitle.font = UIFont(name: "Montserrat Medium", size: 18)
            return cell
            }
            else
            {
             guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid") as? ActivitySummeryTblCell else { return UITableViewCell()  }
                
                 guard let TempDict = objMyMerchantsDetails.MyMerchantDict?.rewardRedemption?[indexPath.row] else { return UITableViewCell()}
                
              
                 cell.lblDate.text = Utility().getFormattedDate(string: TempDict.redeem_at ?? "", currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "MM-dd-yy")
                 cell.lblVisitNo.text = "\(indexPath.row + 1)"
                cell.lbltime.text = Utility().getFormattedDate(string: TempDict.redeem_at ?? "", currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "h:mm a")
                
                
                return cell
            }
            }
            
        }
        else
        {
            
            if indexPath.section == 0 && objMyMerchantsDetails.UserRewardArr?.count ?? 0 != 0
            {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableRewardCell") as? AvailableRewardCell else {
                    return UITableViewCell()}
                cell.selectionStyle = .none
                
                guard let TempDict = objMyMerchantsDetails.UserRewardArr?[indexPath.row] else { return UITableViewCell()}
                
                cell.lbltitle.text = "\(TempDict.description ?? "")"//"\(visits) Visits"
                
                if let url = URL(string: "\(rewardBaseUrl)\(TempDict.id ?? 0)/\(TempDict.image ?? "")")
                    {
                    cell.imgViw.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
                    }
            
            cell.buttonRedeemAction = {
                cell in
               // self.BtnRedeemAct(AvailDict: TempDict)
                self.BtnRedeemAct(reward_Id: "\(TempDict.id ?? 0)")
                
            }
            
                    return cell
            }
            else
            {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid") as? NextRewardTblCell else {
                return UITableViewCell()}
                
            cell.selectionStyle = .none
            guard let TempDict = objMyMerchantsDetails.MyMerchantDict?.rewards?[indexPath.row] else { return UITableViewCell()}

            cell.lbltitle.text = "\(TempDict.number_of_visits ?? "") Visits"//"\(visits) Visits"
            cell.lblDescription.text = TempDict.description

            if let url = URL(string: "\(rewardBaseUrl)\(TempDict.id ?? 0)/\(TempDict.image ?? "")")
                {
                cell.imgViw.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
                }
                //cell.backgroundColor = .clear
                
                cell.viewBack.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == TblViewActivitySum
        {
        return UITableView.automaticDimension
        }
        else
        {
        return  135
        }
           
    }
    
}

class headerCell:UITableViewCell{
    @IBOutlet weak var lblHeadertitle: UILabel!
}




class AvailableRewardCell:UITableViewCell{
    @IBOutlet weak var lblHeadertitle: UILabel!
    @IBOutlet weak var imgViw: UIImageView!
    
    @IBOutlet weak var lbltitle: UILabel!
    var buttonRedeemAction : ((AvailableRewardCell) -> Void)?
  
     
     @IBAction func BtnRedeemAct(_ sender: UIButton) {
         self.buttonRedeemAction?(self)
     }
     
  
}

class NextRewardTblCell:UITableViewCell{
    
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgViw: UIImageView!
    
    @IBOutlet weak var lblLikes: UILabel!

  
   @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
  
}


class ActivitySummeryTblCell:UITableViewCell{
    
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblVisitNo: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}
extension UITableView {

    func setEmptyMessage() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = "No Visits, please stop by today:"
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Montserrat Medium", size: 18)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt64 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt64(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
