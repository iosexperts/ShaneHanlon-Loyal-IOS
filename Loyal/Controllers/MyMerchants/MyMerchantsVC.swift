//
//  MyMerchantsVC.swift
//  Loyal
//
//  Created by user on 07/04/21.
//

import UIKit

class MyMerchantsVC: UIViewController {
    @IBOutlet weak var tblViewMerchant: UITableView!{
        didSet{tblViewMerchant.dataSource = self;tblViewMerchant.delegate = self
            tblViewMerchant.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var imgViewProfile: UIImageView!
    var objMyMerchantsViewModel = MyMerchantsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default
                                 .addObserver(self,
                                              selector: #selector(GetList),
                                name: NSNotification.Name ("updateLocalVC"),                                           object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let LoginUserData = UserDefaultController.shared.signUpTempData
               {
            if let url = URL(string: "\(UserImageBaseUrl)\(LoginUserData.id ?? 0)/\(LoginUserData.image ?? "")")
                {
                self.imgViewProfile.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
                }
        }
        
        
        GetList()
    }
    
    @objc func GetList(){
        let params = [     "latitude":UserDefaultController.shared.currentLatitude,
                           "longitude":UserDefaultController.shared.currentLongitude,"radius":97.8
        ] as [String : Any]
        objMyMerchantsViewModel.GetMerchantList(Param: params) { (status) in
            if status
            {
                self.tblViewMerchant.reloadData()
                
                
            }
        }
    }
   

    func UnJoinedMerchant(MerChantID:String){
        
        objMyMerchantsViewModel.DeleteJoinedMerchantFromList(Param: ["merchantId":MerChantID
        ]) { (status) in
            if status
            {
                
                self.GetList()
                
            }
        }
    }
    
    
}
extension MyMerchantsVC:UITableViewDelegate,UITableViewDataSource{
    /*
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            UnJoinedMerchant(MerChantID: "\(self.objMyMerchantsViewModel.MyMerchantArr?[indexPath.row].id ?? 0)")
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objMyMerchantsViewModel.MyMerchantArr?.count ?? 0
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid") as! MyMerchantTblCell
       
        cell.selectionStyle = .none
        
        
        
        let  TempDict = self.objMyMerchantsViewModel.MyMerchantArr?[indexPath.row]
        
        cell.lbltitle.text = TempDict?.name ?? ""
     //   cell.lblDescription.text = "\(TempDict?.city ?? ""), \(TempDict?.state ?? "")"
       // cell.lblDescription.text = "Description"
        if TempDict?.gotRewardOrNot == true
        {
            cell.ConHeightReward.constant =  25
        }
        else
        {
            cell.ConHeightReward.constant =  0
        }
        if let url = URL(string: "\(MerchantImageBaseUrl)\(TempDict?.id ?? 0)/\(TempDict?.image ?? "")")
        {
            cell.imgViw.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "dummy_banne"))
         
                 }
        
        
        cell.lblFav.text = "\(TempDict?.visits_until_next_reward ?? 0)"
        cell.lblLikes.text = "\(String(format: "%.1f", TempDict?.distance ?? 0.0)) \(TempDict?.distance_unit ?? "")"
      
      /*cell.buttonJoinAction = {
            cell in
         /*   let ObjCustomPopView = JoinPopUp.shared
            let Subview = ObjCustomPopView.loadViewFromNib()
             ObjCustomPopView.isMoveNextTapped = {
                 Status in
                print(Status)
               
               
                Subview.removeFromSuperview()
               
             }
             
             self.view.addSubview(Subview)
            */
     
           
          
        }*/
        
        
   
        return cell
    }
    
    /*
    func EditVault(vaultId:String) {
    
        if let viewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "AddVaultVC") as? AddVaultVC {
            viewController.isEditVault = true
            viewController.VaultId = vaultId
            self.navigationController?.pushViewController(viewController, animated: true)
               
           }
    
    }
    
    func DeleteVault(vaultId:String) {

        Utility().displayAlertWithCompletion(title: "", message: "Are you Sure want to delete vault?", control: ["Cancel","Ok"]) { (str) in
        if str == "Ok"
        {
            self.objvaultsVM.DeleteVault(Param: ["vaultId":vaultId]) { (status) in
             
             if status
             {
                self.getVaultsList()
             }
         }
        }
        }
    }
    
    
   */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TempDict = self.objMyMerchantsViewModel.MyMerchantArr?[indexPath.row]
  
       if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RewardDetailsVC") as? RewardDetailsVC {
            viewController.merchantId = "\(TempDict?.id ?? 0)"
       // self.navigationController?.pushViewController(viewController, animated: true)
        let navi = UINavigationController(rootViewController: viewController)

        viewController.isDismissDetailsVC = { state in
            
            self.GetList()
                
        }
        navi.navigationBar.isHidden = true
        navi.modalPresentationStyle = .overFullScreen
        self.present(navi, animated: true, completion: nil)
           }
        
        
      //  Utility().pushViewControl(ViewControl: "RewardDetailsVC")
        
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // return 195
        return UITableView.automaticDimension
    }
    
}
class MyMerchantTblCell:UITableViewCell{
    
    
    @IBOutlet weak var imgViw: UIImageView!
    
    @IBOutlet weak var lblFav: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var ViewLike: UIView!
    @IBOutlet weak var ViewJoin: ViewCustom!
    @IBOutlet weak var ConHeightReward: NSLayoutConstraint!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
  //  var buttonDeleteVaultAction : ((HomeTblCell) -> Void)?
   // var buttonEditVaultAction : ((HomeTblCell) -> Void)?
   var buttonJoinAction : ((MyMerchantTblCell) -> Void)?
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
