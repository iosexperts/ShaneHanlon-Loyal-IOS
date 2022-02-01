//
//  RewardVC.swift
//  Loyal
//
//  Created by user on 12/04/21.
//

import UIKit
import SwiftConfettiView



class RewardVC: UIViewController {

    @IBOutlet weak var BottomShadow: ShadowView!
    @IBOutlet weak var TopShadowView: ShadowView!
    @IBOutlet weak var viewBottom: ViewCustom!
    @IBOutlet weak var imgViewRedeemRibbion: UIImageView!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var ViewShowRedeem: ViewCustom!
    @IBOutlet weak var confettiView: SwiftConfettiView!
    var objMyMerchantsDetails = MyMerchantsDetailsViewModel()
    @IBOutlet weak var ViewTop: ViewCustom!
    @IBOutlet weak var btnRedeemShow: UIButton!
    var count = 0
    var rewardId = ""
    var objReward = Reward()
    @IBOutlet weak var ImgRedeem: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PlayConfetti()
        GetRewardsByNotiId()
       
        SetupUI()
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.nearFarNotification),
            name: Notification.Name("nearFarNotification"),
            object: nil)
    }
    func SetupUI()  {
        TopShadowView.shadowColor = .clear
        ViewTop.backgroundColor = .clear
        lblTop.attributedText = NSAttributedString(string:"Your visit earned you a \nfree reward.")
      //  self.lblBottom.text = "Alert! Get close to the register to redeem reward."
        lblBottom.attributedText =  NSMutableAttributedString().underlined("Alert!").normal(" Get close to the register to redeem reward.")
        ViewShowRedeem.backgroundColor = #colorLiteral(red: 0.8, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
        btnRedeemShow.isEnabled = false
        BottomShadow.shadowColor = .clear
        
        lblDescription.text = objMyMerchantsDetails.UserRewardDict?.description ?? ""
        
    }
    
   @objc private func nearFarNotification(notification: NSNotification){
    
    print(notification.object ?? "") //myObject
    print(notification.userInfo ?? "") //[AnyHashable("key"): "Value"]
    
    guard let TempDict = notification.userInfo as? [String:Any] else {
        return
    }
    
    if let state = TempDict["state"] as? String , let uid = TempDict["uid"] as? String  {
        if objMyMerchantsDetails.UserRewardDict?.beaconUUID == uid
    {
   if state == "near" || state == "here"
   {
  //  self.lblBottom.text = objMyMerchantsDetails.UserRewardDict?.description ?? ""
    btnRedeemShow.isEnabled = true
    ViewShowRedeem.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
    }
    else if state == "far"
    {
       // self.lblBottom.text = "Get close to register to redeem reward."
       // ViewShowRedeem.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.4)
     ViewShowRedeem.backgroundColor = #colorLiteral(red: 0.8, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
     btnRedeemShow.isEnabled = false
     }
    }
    }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func GetRewardsByNotiId(){
        
        objMyMerchantsDetails.GetRewardsById(Param:["reward_Id":rewardId]) { (status) in
            if status
            {
             
                self.SetupRewardImage()
                
            }
        }
    }
    
    func SetupRewardImage()  {
        
        
        if let TempDict = objMyMerchantsDetails.UserRewardDict
        {
           
        if let url = URL(string: "\(rewardBaseUrl)\(TempDict.id ?? 0)/\(TempDict.image ?? "")")
            {
            ImgRedeem.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
            }
        }
        
        
    }
    @IBAction func BtnBackAct(_ sender: Any) {
        Utility().PopVC()
    }
    func PlayConfetti() {
       
        self.confettiView.intensity = 1
        
        self.confettiView.startConfetti()

        
    }
    
    func RedeemReward() {
        objReward.RedeemRewards(Param:["user_rewardId":"\(objMyMerchantsDetails.UserRewardDict?.user_rewardId ?? 0)"]) { (status) in
            if status
            {
               
               
                self.UpdateUI()
            }
        }
    }
    
    func UpdateUI()  {
        imgViewRedeemRibbion.image = #imageLiteral(resourceName: "RedeemRibbion")
        BottomShadow.shadowColor = .clear
        viewBottom.backgroundColor = .clear
       // lblTop.text = "Alert! Show merchant this screen to receive your reward."
        
        lblTop.attributedText =  NSMutableAttributedString().underlined("Alert!").normal(" Show merchant this screen to receive your reward.")
       
        
        lblBottom.text = "Redeemed: \(Utility().getFormattedDate(string: objReward.commondict?.redeem_at ?? "",currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "MM-dd-yy"))"
        lblBottom.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        lblDescription.text = objMyMerchantsDetails.UserRewardDict?.description ?? ""
        ViewShowRedeem.isHidden = true
      //  ViewTop.borderColor = #colorLiteral(red: 0.108172901, green: 0.3747162223, blue: 0.2473882437, alpha: 1)
      //  ViewTop.borderWidth = 1
       
    }
    @IBAction func BtnRedeemMerchantAct(_ sender: Any) {
        
        
        self.RedeemReward()
        TopShadowView.shadowColor = .black
      //  ViewTop.backgroundColor = .white
       // ViewShowRedeem.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
     //   lblTop.text = "Your visit earned you free doughtnut of your choice"
       // lblBottom.text = "To Reedeem Reward, Push the Button And Show It To The Merchant"
          
        }
}
extension NSMutableAttributedString {
    var fontSize:CGFloat { return 17 }
    var boldFont:UIFont { return UIFont(name: "Montserrat-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "Montserrat-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    var MediumItalicFont:UIFont { return UIFont(name: "Montserrat-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
   
    func MediumItalic(_ value:String) -> NSMutableAttributedString {
       
        let attributes:[NSAttributedString.Key : Any] = [
            .font : MediumItalicFont,.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,.foregroundColor :#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

