//
//  LogListVC.swift
//  Loyal
//
//  Created by user on 14/12/21.
//

import UIKit

class LogListVC: UIViewController {
    
    // MARK: - Properties
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.black], lineWidth: 2)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    @IBOutlet weak var TblViewLog: UITableView!{
        didSet{TblViewLog.dataSource = self;TblViewLog.delegate = self
            TblViewLog.tableFooterView = UIView()
        }
    }
    var objLogListViewModel = LogListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.loadingIndicator.isAnimating = false
        GetLogs()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
        
    }
    
    func GetLogs() {
        loadingIndicator.isAnimating = true
        self.objLogListViewModel.GetLogsDetails { status in
            if status
            {
                self.TblViewLog.reloadData()
                self.loadingIndicator.isAnimating = false
                
                if self.objLogListViewModel.LogListArr?.count ?? 0 <= 0
                {
                    Utility().displayAlertWithCompletion(title: "", message:"Log list is empty", control: ["Ok"]) { str in
                    }
                }
                 
            }else
            {
               // DispatchQueue.main.async {
                self.loadingIndicator.isAnimating = false
              //  }
                }
        }
        
    }
    
    
    
    
    @IBAction func BtnRefreshAct(_ sender: Any) {
        GetLogs()
    }
    
    
    @IBAction func BtnBackAct(_ sender: UIButton) {
        Utility().PopVC()
    }
    
    @IBAction func BtnClearLogAct(_ sender: Any) {
        
        Utility().displayAlertWithCompletion(title: "", message:"Are you sure want to clear Logs?", control: ["Ok","Cancel"]) { str in
            if str == "Ok"
            {
            self.loadingIndicator.isAnimating = true
            self.objLogListViewModel.ClearLogsDetails { status in
            self.loadingIndicator.isAnimating = false
            self.BtnBackAct(UIButton())
            }
            }
        }
    }
}

extension LogListVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return objLogListViewModel.LogListArr?.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let TempDict = objLogListViewModel.LogListArr?[indexPath.row] else { return UITableViewCell() }
        if TempDict.message == "App Initialized -- (from cold start)" || ((TempDict.message?.contains("Register Beacon ")) != nil) || ((TempDict.message?.contains("Wrong beacon ID ")) != nil)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppInitiCell")as! LogsTblCell
            cell.selectionStyle = .none
            if let mess = TempDict.message, mess != ""
            {
                cell.ViewMessage.isHidden = false
                cell.lblMessage.text = "Message : \(TempDict.message ?? "")"
            }
            else
            {
                cell.ViewMessage.isHidden = true
            }
                cell.lblCreatedAt.text = "Created At : \(TempDict.created_at ?? "")"
          
                    
            return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellid")as! LogsTblCell
        cell.selectionStyle = .none
        
        cell.lblBeaconUdid.text = "Beacon UDID : \(TempDict.beacon_uuid ?? "")"
        cell.lblUserLatLong.text = "User Lat and Long : \(TempDict.user_lat ?? "") , \(TempDict.user_long ?? "")"
        cell.lblBeaconLatLong.text = "Beacon Lat and Long : \(TempDict.beacon_lat ?? "") , \(TempDict.beacon_long ?? "")"
        cell.lblBeaconRange.text = "Beacon Range : \(TempDict.beacon_range ?? "")"
        cell.lblMerchantName.text = "Merchant Name : \(TempDict.merchant_name ?? "")"
            if let Distance = Float(TempDict.distance ?? "0.0")
            {
            let km = Distance / Float (3280.84)
            let StrKm = String(format:"%0.2f",km)
            cell.lblDifference.text = "Distance Between Beacon and user Latitude & Longitutde : \(Distance)(In foot), \(StrKm) (In Km)"
            }
        
        if let mess = TempDict.message, mess != ""
        {
            cell.ViewMessage.isHidden = false
            cell.lblMessage.text = "Message : \(TempDict.message ?? "")"
        }
        else
        {
            cell.ViewMessage.isHidden = true
        }
            cell.lblCreatedAt.text = "Created At : \(TempDict.created_at ?? "")"
            cell.lblAcu.text = "User horizontal and vertical accuracy : \(TempDict.horizontal_accuracy ?? "") , \(TempDict.vertical_accuracy ?? "")"
                
        return cell
        }
    }
    
 
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // return 195
        return UITableView.automaticDimension
    }
    
    
}
class LogsTblCell:UITableViewCell{
    @IBOutlet weak var lblBeaconUdid: UILabel!
    @IBOutlet weak var lblUserLatLong: UILabel!
    @IBOutlet weak var lblBeaconLatLong: UILabel!
    @IBOutlet weak var lblBeaconRange: UILabel!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var lblDifference: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var ViewMessage: UIView!
    
    @IBOutlet weak var lblAcu: UILabel!
    @IBOutlet weak var lblMerchantName: UILabel!
}
