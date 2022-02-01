//
//  redeemView1.swift
//  Loyal
//
//  Created by user on 13/04/21.
//

import UIKit
import Kingfisher
class RedeemView1: UIView {

    // Our custom view from the XIB file
static let shared = RedeemView1()
    var view: UIView!
    var isMoveNextTapped : ((Bool) -> Void)?
    var merchantBeaconId = String()
    @IBOutlet weak var lblBanner: UILabel!
    @IBOutlet weak var imgRibbion: UIImageView!
    @IBOutlet weak var ViewImg1: ViewCustom!
    @IBOutlet weak var RedeemConHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRedeemShow: ViewCustom!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnRedeemShow: UIButton!
    @IBOutlet weak var ViewBottomLbl: UIView!
    var objMyMerchantsDetails = MyMerchantsDetailsViewModel()
    var objReward = Reward()
    var RewardDict : PendingRewardsFromRedeem?
    @IBOutlet weak var ImgViwReward: UIImageView!
    @IBOutlet weak var ImgViwUser: UIImageView!
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
//        self.view = loadViewFromNib() as! CustomView
    }
    
    
    func SetupUI(UserRewardDict:PendingRewardsFromRedeem,MercahntImg:String,MerchantId:String,beaconId:String)  {
      //  lblBottom.text = "To redeem reward,push the button and show it to the merchant"
       // viewRedeemShow.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.4)
        viewRedeemShow.backgroundColor = #colorLiteral(red: 0.8, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
        btnRedeemShow.isEnabled = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.nearFarNotification),
            name: Notification.Name("nearFarNotification"),
            object: nil)
        merchantBeaconId = beaconId
       // lblBottom.text = ""
       // ViewBottomLbl.isHidden = true
        self.RewardDict = UserRewardDict
        if let url = URL(string: "\(rewardBaseUrl)\(UserRewardDict.id ?? 0)/\(UserRewardDict.image ?? "")")
            {
            ImgViwReward.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
            }
                
        if let url = URL(string: "\(MerchantImageBaseUrl)\(MerchantId)/\(MercahntImg)")
            {
            self.ImgViwUser.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
            }
        lblHeader.text = "Earned: \(Utility().getFormattedDate(string: UserRewardDict.created_at ?? "", currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "MM-dd-yy"))"
        
        
    }
    @objc private func nearFarNotification(notification: NSNotification){

        print(notification.object ?? "") //myObject
        print(notification.userInfo ?? "") //[AnyHashable("key"): "Value"]
        
        guard let TempDict = notification.userInfo as? [String:Any] else {
            return
        }
        
        if let state = TempDict["state"] as? String , let uid = TempDict["uid"] as? String  {
    if merchantBeaconId == uid
    {
       if state == "near" || state == "here"
       {
        self.lblBottom.text = self.RewardDict?.description ?? ""
        btnRedeemShow.isEnabled = true
        viewRedeemShow.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        }
        else if state == "far"
        {
        self.lblBottom.text = "Get close to register to redeem reward."
      //  viewRedeemShow.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.4)
        viewRedeemShow.backgroundColor = #colorLiteral(red: 0.8, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
        btnRedeemShow.isEnabled = false
         }
    }
    }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func BtnCancelAct(_ sender: UIButton) {
     //   print("BtnCancelAct")
        isMoveNextTapped?(false)
    }
 
  
    func RedeemReward() {
        
       let parm = ["user_rewardId":"\(RewardDict?.mainUserRewardId ?? 0)"]
        print("parms:",parm)
        objReward.RedeemRewards(Param:parm) { (status) in
            if status
            {
                self.UpdateView()
            }
        }
    }
    
    func UpdateView()
        {
         lblBanner.text = "Redeemed"
       //  lblBottom.text = "Show The Merchant This Screen To Recieve Your Reward"
       // lblHeader.text = "Redeemed: \(Utility().getFormattedDate(string: objReward.commondict?.redeem_at ?? "",currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "MM-dd-yy"))"
        lblHeader.text = "Show The Merchant This Screen To Recieve Your Reward"
      //lblBottom.text = "Redeemed: \(Utility().getFormattedDate(string: objReward.commondict?.redeem_at ?? "",currentFor: "yyyy-MM-dd HH:mm:ss", outPutformatter: "MM-dd-yy"))"
        lblBottom.text =  self.RewardDict?.description ?? ""
        lblBottom.textAlignment = .center
     //  RedeemConHeight.constant = 0.0
        viewRedeemShow.isHidden = true
         viewRedeemShow.clipsToBounds = true
         imgRibbion.isHidden = false
         ViewImg1.isHidden = true
         
        
    }
    
    @IBAction func BtnRedeemShowMerchantAct(_ sender: UIButton) {
        RedeemReward()
       // viewRedeemShow.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
      //  lblBottom.text = "To redeem reward,push the button and show it to the merchant"
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: "RedeemView1", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
