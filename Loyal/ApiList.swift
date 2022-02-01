//
//  ApiList.swift
//  Water Waze
//
//  Created by Sonu on 03/09/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit


//MARK:- Base Url-
let BaseUrl = "http://54.205.63.142/api/"

let UserImageBaseUrl = "http://54.205.63.142/profile_images/"
let MerchantImageBaseUrl = "http://54.205.63.142/merchants_images/"
let rewardBaseUrl = "http://54.205.63.142/rewards_images/"
//MARK:- Basic Api's-
let k_Login_Signup = BaseUrl + "login_or_signup" //Done


let k_Logout = BaseUrl + "logout"


//MARK:- Profile Api's-

let k_updateProfilePhoto = BaseUrl + "update_user_profile"

//MARK:- Vault Api's-
let k_LocalsNearBy = BaseUrl + "get_nearby_merchants" //Done

//MARK:- Beneficries Api's-
let k_Join_Merchant = BaseUrl + "join_merchant"  //Done
let k_Get_Joined_Merchant = BaseUrl + "get_nearby_joined_merchants" //Done
let k_Get_Merchant_By_id = BaseUrl + "get_merchant_by_id"
let k_DeleteBeneficiary = BaseUrl + ""
let k_EditBeneficiary = BaseUrl + ""
let k_Delete_Joined_Merchant = BaseUrl + "deleteJoinedMerchant" //Done
let K_contactUs = BaseUrl + ""

let K_SendNearNotification = BaseUrl + "sendNearNotification"

let K_UpdateFCMNotification = BaseUrl + "updateToken"

let K_UpdateLocation = BaseUrl + "finalNotification"

let k_Get_UserRewardsList = BaseUrl + "getUserRewardsList"

let k_Get_rewardById = BaseUrl + "rewardById"
let k_RedeemRewards = BaseUrl + "redeemRewards"

let k_Get_Log_Data = BaseUrl + "get-log-data"
let k_Clear_Log_Data = BaseUrl + "delete-log-data"

let k_GoogleKey = "AIzaSyCinghIa9T51-A5IrXqcXTs_AoRACHN6Xo"



let K_SendNearNotificationWithBeacon = BaseUrl + "sendNotificationWithBeacon"
let K_return_joined_uid = BaseUrl + "return-joined-uid"


let K_appInitialized = BaseUrl + "appInitialized"
