//
//  ApiClient.swift
//  Webkeyz hotels
//
//  Created by Amr Fawzy on 1/27/21.
//

import Foundation
import Alamofire

class APIClient {
    
    //MARK:- GetHotels
    
    func GetHotels(onSuccess: @escaping ([Hotel]) -> Void, onError: @escaping (_ error: String)-> Void) {
        
        // Cashing
        var request = URLRequest(url: URL(string: Constants.ProductionServer.baseURL)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !NetworkReachability.isConnectedToNetwork() {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        //ALamofire request
        AF.request(request).responseData {
            response in
            switch response.result {
            case .success(let jsonData):
                do {
                    let data = try JSONDecoder().decode(Hotels.self, from: jsonData)
                    print(data)
                    onSuccess(data.hotel)
                } catch {
                    print("ParseError",error.localizedDescription)
                    onError(error.localizedDescription)
                }
                break
            case .failure(let error):
                print("Request error: \(error)")
                onError(error.localizedDescription)
                break
            }
        }
    }
}
