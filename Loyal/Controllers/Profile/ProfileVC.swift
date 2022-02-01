//
//  ProfileVC.swift
//  Loyal
//
//  Created by user on 07/04/21.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    var objProfile = ProfileViewModel()
    var notifications_status = String()
    var isImagePicker = Bool()
    @IBOutlet weak var NotiFiSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SetupUI()
        
        print(isImagePicker)
        
    }
    
    func SetupUI()  {
        if let LoginUserData = UserDefaultController.shared.signUpTempData
               {
            if let url = URL(string: "\(UserImageBaseUrl)\(LoginUserData.id ?? 0)/\(LoginUserData.image ?? "")")
                {
                self.imgProfile.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "userPlaceHolder"))
                }
            
            txtFirstName.text = LoginUserData.first_name ?? ""
            txtLastName.text = LoginUserData.last_name ?? ""
            txtEmail.text =  LoginUserData.email ?? ""
            lblPhone.text =  LoginUserData.contact_number ?? ""
           let isOn = LoginUserData.notifications_status == "off" ? false : true
            notifications_status = LoginUserData.notifications_status ?? "off"
            self.NotiFiSwitch.setOn(isOn, animated: false)
        }
    }

    
    
    @IBAction func BtnLogListAct(_ sender: UIButton) {
        Utility().pushViewControl(ViewControl: "LogListVC")
        
    }
    @IBAction func BtnLogoutAct(_ sender: Any) {
        
        objProfile.Logout { (status) in
            let appdel = UIApplication.shared.delegate as? AppDelegate
            appdel?.StopLocationManager()
        PerDeviceARR.removeAll()
        Utility().setAlreadyLogin(false)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
          else {
            return
          }
        sceneDelegate.LoginExist_or_New()
        
        }
        
        
    }
    
    @IBAction func SwitchToggleAct(_ sender: UISwitch) {
        if sender.isOn
        {
            notifications_status = "on"
        }
        else
        
        {
            notifications_status = "off"
        }
        
    }
    @IBAction func BtnUpdateProfile(_ sender: Any) {
        
        if txtFirstName.text?.isEmpty ?? true {
             Utility().showAlert(mesg: "Please enter first name")
         }else if txtLastName.text?.isEmpty ?? true {
             Utility().showAlert(mesg: "Please enter last name")
         }else if txtEmail.text?.isEmpty ?? true {
            Utility().showAlert(mesg: "Please enter email")
         }else if !Utility().isValidEmail(testStr: txtEmail.text ?? "") {
            Utility().showAlert(mesg: "Please enter valid email address")
        }else if imgProfile.image == #imageLiteral(resourceName: "userPlaceHolder")  {
            Utility().showAlert(mesg: "Please Choose profile image")
        }
        else{
                   
            let params = [  "user_id":UserDefaultController.shared.signUpTempData?.id ?? "",
                            "first_name":txtFirstName.text ?? "",
                            "last_name":txtLastName.text ?? "",
                            "email":txtEmail.text ?? "",
                            "profile_completion_status":1
                            ,"profile_image": imgProfile.image ?? UIImage(),
                            "notifications_status":notifications_status
            ] as [String : Any]
        
            objProfile.UpdateProfile(Param: params) { (status) in
                  if status
                {
                    self.SetupUI()
                }
                
                
            }
            
            
        
        }
    }
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    @IBAction func BtnCameraAct(_ sender: Any) {
        self.showAlert()
     /*   AttachmentHandler.shared.showPhotoAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (imagefile) in
//        self.objProfileViewModel.UpdateProfile(Param:["images":imagefile],extDocumentType: "") { (status) in
//            if status
//            {
               self.imgProfile.image = imagefile
           // }
        //}
        }*/
    }
    
}
//MARK:- Image Picker
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //This is the tap gesture added on my UIImageView.
    @IBAction func didTapOnImageView(sender: UITapGestureRecognizer) {
        //call Alert function
        self.showAlert()
    }

    //Show alert to selected the media source type.
    private func showAlert() {

        let alert = UIAlertController(title: "Add a File", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
           self.isImagePicker = true
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
          //  self.isImagePicker = true
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in
           // self.isImagePicker = false
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) { [weak self] in

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            //self?.isImagePicker = false
            self?.imgProfile.image = image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
