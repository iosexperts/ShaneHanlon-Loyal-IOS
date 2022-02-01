//
//  HitApi.swift
//  Care Pack
//
//  Created by user on 12/12/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import SystemConfiguration

class HitApi {
    
    private init() {}
    static let shared = HitApi()
    
    func sendRequest<T: Decodable>(api: String, parameters: [String: Any]? = nil, showLoader:Bool = true, outputBlock: @escaping (T) -> () ) {
        
        print("hitting:" , api)
        print("parameters:",parameters ?? ["":""])
      
        if !isConnectedToNetwork(){
            Utility().displayAlert(title: "", message: "You are not connected with internet", control: ["Ok"])
            return
        }
        
        guard let url = URL(string: api) else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        
        if let token = UserDefaultController.shared.accessToken {
          print("Token:",token)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        if let parameters = parameters {
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpBody
        }
        if showLoader {
            Utility().show_loader()
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            Utility().hide_loader()
            
            DispatchQueue.main.async {
                
              /*  if let err = error {
                    Utility().showAlert(mesg: err.localizedDescription)
                    return
                }*/
                
                guard let data = data else {
                  //  Utility().showAlert(mesg: "Getting Data nil from Server")
                    return
                }
                
                let abc = try? JSONSerialization.jsonObject(with: data, options: [])
                print("Response:",abc as Any)
                
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    outputBlock(obj)
                } catch let jsonErr {
                    print("jsonErr:",jsonErr.localizedDescription)
                 //  Utility().showAlert(mesg: jsonErr.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    func GetRequest<T: Decodable>(api: String, showLoader:Bool = true, outputBlock: @escaping (T) -> () ) {
          
          print("hitting:" , api)
        
          if !isConnectedToNetwork(){
              Utility().displayAlert(title: "", message: "You are not connected with internet", control: ["Ok"])
              return
          }
          
          guard let url = URL(string: api) else {return}
          var request = URLRequest(url: url)
          request.setValue("application/json", forHTTPHeaderField: "Accept")
          
          if let token = UserDefaultController.shared.accessToken {
            print("Token:","Bearer",token)
              request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
          }
             request.httpMethod = "GET"
        
          if showLoader {
              Utility().show_loader()
          }
          URLSession.shared.dataTask(with: request) { (data, response, error) in
              
              Utility().hide_loader()
              
              DispatchQueue.main.async {
                  
                /*  if let err = error {
                      Utility().showAlert(mesg: err.localizedDescription)
                      return
                  }*/
                  
                  guard let data = data else {
                     // Utility().showAlert(mesg: "Getting Data nil from Server")
                      return
                  }
                  
                  let abc = try? JSONSerialization.jsonObject(with: data, options: [])
                 // print("JsonRes:",abc as Any)
                  
                  do {
                      let obj = try JSONDecoder().decode(T.self, from: data)
                      outputBlock(obj)
                  } catch let jsonErr {
                    print("jsonErr:",jsonErr.localizedDescription)
                   //   Utility().showAlert(mesg: jsonErr.localizedDescription)
                  }
              }
          }.resume()
      }
    
    
    
    func sendRequestWithImages<T: Decodable>(api: String, parameters: [String: Any] = [:], video: [String:Data]? = [:], document: [String:Data]? = [:], extensionDocumentType:String? = "", outputBlock: @escaping (T) -> () ) {
        print("hitting:" , api)
        print("parameters:",parameters)
        if !isConnectedToNetwork(){
            Utility().displayAlert(title: "", message: "You are not connected with internet", control: ["Ok"])
            return
        }
        
        guard let url = URL(string: api) else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = UserDefaultController.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBody(parameters: parameters, video: video ?? [:],
                                      document: document ?? [:],
                                      boundary: boundary,
                                      extensionDocument: extensionDocumentType ?? "",
                                      mimeType: "image/jpg")
        
        Utility().show_loader()
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                Utility().hide_loader()
                
               /* if let err = error {
                    Utility().showAlert(mesg: err.localizedDescription)
                    return
                }*/
                
                guard let data = data else {
                  //  Utility().showAlert(mesg: "Getting Data nil from Server")
                    return
                }
                
                let abc = try? JSONSerialization.jsonObject(with: data, options: [])
                print(abc as Any)
                
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    outputBlock(obj)
                } catch let jsonErr {
                    print("jsonErr:",jsonErr.localizedDescription)
                   // Utility().showAlert(mesg: jsonErr.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    
    //MARK: - Check Internet
    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        if(defaultRouteReachability == nil){
            return false
        }
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    private func createBody(parameters: [String: Any],
                            video:[String:Data],
                            document:[String:Data],
                            boundary: String,
                            extensionDocument:String,
                            mimeType: String) -> Data {
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        
        
        for case let (key, value as String) in parameters{
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        for case let (key, value as Int) in parameters{
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        for case let (key, value as UIImage) in parameters {
            
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(UUID().uuidString).jpg\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(value.compressImage())
            body.append("\r\n")
            body.append("--".appending(boundary.appending("--\r\n")))
        }
        
        for case let (key, value as [UIImage]) in parameters {
            for (ind,image) in value.enumerated()
            {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)[\(ind)]\"; filename=\"\(UUID().uuidString).jpg\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(image.compressImage())
            body.append("\r\n")
            body.append("--".appending(boundary.appending("--\r\n")))
            }
            }
        
        
        
        for case let (key, value) in video {
            
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(UUID().uuidString).mp4\"\r\n")
            body.append("Content-Type: application/octet-stream\r\n\r\n")
            body.append(value)
            body.append("\r\n\r\n")
            body.append("--".appending(boundary.appending("--")))
        }
        
        for case let (key, value) in document {
      
            
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(UUID().uuidString).\(extensionDocument)\"\r\n")
            body.append("Content-Type: text/csv\r\n\r\n")
            body.append(value)
            body.append("\r\n\r\n")
            body.append("--".appending(boundary.appending("--")))
            
        }
        
        return body
    }
}


extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension UIImage {
    
    func compressImage() -> Data {
        
        if let imgageData = self.pngData() {
            let jpegSizee: Int = imgageData.count
            let fileSizeKb = Double(jpegSizee) / 1024.0
            
            if fileSizeKb < 700 {
                //Reduce the image size
                return self.jpegData(compressionQuality: 0.8 ) ?? Data()
            }else if fileSizeKb < 1000 {
                return self.jpegData(compressionQuality: 0.7 ) ?? Data()
            }else if fileSizeKb < 2000 {
                return self.jpegData(compressionQuality: 0.6) ?? Data()
            }else if fileSizeKb < 3000 {
                return self.jpegData(compressionQuality: 0.5) ?? Data()
            }else if fileSizeKb < 4000 {
                return self.jpegData(compressionQuality: 0.4) ?? Data()
            }else if fileSizeKb < 5000 {
                return self.jpegData(compressionQuality: 0.3) ?? Data()
            }else if fileSizeKb < 6000 {
                return self.jpegData(compressionQuality: 0.25) ?? Data()
            }else if fileSizeKb < 10000 {
                return self.jpegData(compressionQuality: 0.2) ?? Data()
            }else {
                return self.jpegData(compressionQuality: 0.15) ?? Data()
            }
        }
        return Data()
    }
}
