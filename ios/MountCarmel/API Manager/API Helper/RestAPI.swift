//
// RestAPI.swift
//  SingleltonDemo
//
//  Created by Nick on 19/06/18.
//  Copyright © 2018 Himanshu. All rights reserved.
//


import UIKit
import Alamofire

class APITest<T:Decodable> : NSObject {
    func requestforGET(url: String, parameter: Parameters?, withCompletionHandler completion:@escaping(_ response:Response<T>?, _ error: Error?) -> Void) {
        let urlString            = url
        guard let url = URL(string: urlString) else { return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print( "this is token ===========================",APP_DELEGATE.token)
       
        if APP_DELEGATE.token == ""{
            print("token was nil")
            print("token in json == ",APP_DELEGATE.loginAPIResponse?.metaData?.token)
            print(UserDefaults.standard.value(forKey: "qwerty123"))
           
        }
        
        request.setValue("Bearer \(APP_DELEGATE.token)", forHTTPHeaderField: "Authorization")
        print("API : ===\(urlString)")
        print("Request : ===\(request.allHTTPHeaderFields)")
        print("Request Parameter : ===\(parameter)")
        
        if let parameter = parameter {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameter as Any)
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
        
        Alamofire.request(request).responseData{ (dataResponse) in
            guard dataResponse.result.isSuccess else {
                completion(nil , dataResponse.result.error)
                return
            }
            
            guard let data = dataResponse.result.value, !data.isEmpty else {
                completion(nil, ErrorResponse.error(-1, nil, AlamofireDecodableRequestBuilderError.emptyDataResponse))
                return
            }
            
            guard let httpResponse = dataResponse.response else {
                completion(nil, ErrorResponse.error(-2, nil, AlamofireDecodableRequestBuilderError.nilHTTPResponse))
                return
            }
            
            
            var responseObj: Response<T>? = nil
            var error : Error? = nil
            do {
                print(try JSONSerialization.jsonObject(with: data, options: []) as AnyObject)
                let decodeResult: (decodableObj: T?, error: Error?) = CodableHelper.decode(T.self, from: data)
                error = decodeResult.error
                if decodeResult.error == nil {
                    responseObj = Response(response: httpResponse, body: decodeResult.decodableObj)
                }
            }
            catch {
                completion(nil, ErrorResponse.error(-2, nil, error))
                return
            }
            
            completion(responseObj, error)
        }
    }
    
    
    //MARK:- Request for Post
    
    func requestforPOST(url: String, parameter: Parameters?, withCompletionHandler completion:@escaping(_ response:Response<T>?, _ error: Error?) -> Void) {
        let urlString            = url
        guard let url = URL(string: urlString) else { return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if APP_DELEGATE.token != ""{
            request.setValue("Bearer \(APP_DELEGATE.token)", forHTTPHeaderField: "Authorization")
        }
        
        print( "this is token ===========================",APP_DELEGATE.token)
        if APP_DELEGATE.token == ""{
            print("token was nil")
            print("token in json == ",APP_DELEGATE.loginAPIResponse?.metaData?.token)
        }
        print("API : ===\(urlString)")
        print("Request : ===\(request.allHTTPHeaderFields)")
        print("Request Parameter : ===\(parameter)")
        if let parameter = parameter {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameter as Any)
                debugPrint(String(data: jsonData, encoding: .utf8) ?? "")
                request.httpBody = jsonData
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
                
        Alamofire.request(request).responseData{ (dataResponse) in
            guard dataResponse.result.isSuccess else {
                completion(nil , dataResponse.result.error)
                return
            }
            
            guard let data = dataResponse.result.value, !data.isEmpty else {
                completion(nil, ErrorResponse.error(-1, nil, AlamofireDecodableRequestBuilderError.emptyDataResponse))
                return
            }
            
            
            guard let httpResponse = dataResponse.response else {
                completion(nil, ErrorResponse.error(-2, nil, AlamofireDecodableRequestBuilderError.nilHTTPResponse))
                return
            }
            
            
            var responseObj: Response<T>? = nil
            var error : Error? = nil
            do {
                print(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject)
                let decodeResult: (decodableObj: T?, error: Error?) = CodableHelper.decode(T.self, from: data)
                error = decodeResult.error
                if decodeResult.error == nil {
                    responseObj = Response(response: httpResponse, body: decodeResult.decodableObj)
                }
            }
            catch {
                completion(nil, ErrorResponse.error(-2, nil, error))
                return
            }
            
            completion(responseObj, error)
        }
    }
    
    func requestforPOSTArray(url: String, parameter: [Parameters], withCompletionHandler completion:@escaping(_ response:Response<T>?, _ error: Error?) -> Void) {
        let urlString            = url
        guard let url = URL(string: urlString) else { return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APP_DELEGATE.token)", forHTTPHeaderField: "Authorization")
        print("API : ===\(urlString)")
        print("Request : ===\(request.allHTTPHeaderFields)")
        print("Request Parameter : ===\(parameter)")
        print( "this is token ===========================",APP_DELEGATE.token)
        if APP_DELEGATE.token == ""{
            print("token was nil")
            print("token in json == ",APP_DELEGATE.loginAPIResponse?.metaData?.token)
        }
       
        if parameter.count > 0 {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameter as Any)
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
        
        Alamofire.request(request).responseData{ (dataResponse) in
            guard dataResponse.result.isSuccess else {
                completion(nil , dataResponse.result.error)
                return
            }
            
            guard let data = dataResponse.result.value, !data.isEmpty else {
                completion(nil, ErrorResponse.error(-1, nil, AlamofireDecodableRequestBuilderError.emptyDataResponse))
                return
            }
            
            
            guard let httpResponse = dataResponse.response else {
                completion(nil, ErrorResponse.error(-2, nil, AlamofireDecodableRequestBuilderError.nilHTTPResponse))
                return
            }
            
            
            var responseObj: Response<T>? = nil
            var error : Error? = nil
            do {
                print(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject)
                let decodeResult: (decodableObj: T?, error: Error?) = CodableHelper.decode(T.self, from: data)
                error = decodeResult.error
                if decodeResult.error == nil {
                    responseObj = Response(response: httpResponse, body: decodeResult.decodableObj)
                }
            }
            catch {
                completion(nil, ErrorResponse.error(-2, nil, error))
                return
            }
            
            completion(responseObj, error)
        }
    }
    
    func requestforPUT(url: String, parameter: Parameters?, withCompletionHandler completion:@escaping(_ response:Response<T>?, _ error: Error?) -> Void) {
        let urlString            = url
        guard let url = URL(string: urlString) else { return}

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APP_DELEGATE.token)", forHTTPHeaderField: "Authorization")
        print( "this is token ===========================",APP_DELEGATE.token)
       
        print("API : ===\(urlString)")
        print("Request : ===\(request.allHTTPHeaderFields)")
        print("Request Parameter : ===\(parameter)")
        if let parameter = parameter {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameter as Any)
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
        
        Alamofire.request(request).responseData{ (dataResponse) in
            guard dataResponse.result.isSuccess else {
                completion(nil , dataResponse.result.error)
                return
            }
            
            guard let data = dataResponse.result.value, !data.isEmpty else {
                completion(nil, ErrorResponse.error(-1, nil, AlamofireDecodableRequestBuilderError.emptyDataResponse))
                return
            }
            
            
            guard let httpResponse = dataResponse.response else {
                completion(nil, ErrorResponse.error(-2, nil, AlamofireDecodableRequestBuilderError.nilHTTPResponse))
                return
            }
            
            
            var responseObj: Response<T>? = nil
            var error : Error? = nil
            do {
                print(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject)
                let decodeResult: (decodableObj: T?, error: Error?) = CodableHelper.decode(T.self, from: data)
                error = decodeResult.error
                if decodeResult.error == nil {
                    responseObj = Response(response: httpResponse, body: decodeResult.decodableObj)
                }
            }
            catch {
                completion(nil, ErrorResponse.error(-2, nil, error))
                return
            }
            
            completion(responseObj, error)
        }
    }
    
    func requestforDELETE(url: String, parameter: Parameters?, withCompletionHandler completion:@escaping(_ response:Response<T>?, _ error: Error?) -> Void) {
        let urlString            = url
        guard let url = URL(string: urlString) else { return}

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APP_DELEGATE.token)", forHTTPHeaderField: "Authorization")
        print( "this is token ===========================",APP_DELEGATE.token)
       
        print("API : ===\(urlString)")
        print("Request : ===\(request.allHTTPHeaderFields)")
        print("Request Parameter : ===\(parameter)")
        if let parameter = parameter {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameter as Any)
            } catch let error {
                print("Error : \(error.localizedDescription)")
            }
        }
        
        Alamofire.request(request).responseData{ (dataResponse) in
            guard dataResponse.result.isSuccess else {
                completion(nil , dataResponse.result.error)
                return
            }
            
            guard let data = dataResponse.result.value, !data.isEmpty else {
                completion(nil, ErrorResponse.error(-1, nil, AlamofireDecodableRequestBuilderError.emptyDataResponse))
                return
            }
            
            
            guard let httpResponse = dataResponse.response else {
                completion(nil, ErrorResponse.error(-2, nil, AlamofireDecodableRequestBuilderError.nilHTTPResponse))
                return
            }
            
            
            var responseObj: Response<T>? = nil
            var error : Error? = nil
            do {
                print(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject)
                let decodeResult: (decodableObj: T?, error: Error?) = CodableHelper.decode(T.self, from: data)
                error = decodeResult.error
                if decodeResult.error == nil {
                    responseObj = Response(response: httpResponse, body: decodeResult.decodableObj)
                }
            }
            catch {
                completion(nil, ErrorResponse.error(-2, nil, error))
                return
            }
            
            completion(responseObj, error)
        }
    }
    
    //MARK:- Upload file
    func requestforFileUpload(
        url: String,
        fileURL: URL,
        uploadProgressHandler: @escaping Request.ProgressHandler,
        withCompletionHandler completion: @escaping(_ response:Response<T>?, _ error: Error?) -> Void
    ) {
        let urlString = url
        guard let url = URL(string: urlString) else {
            return
        }

        var headers : Alamofire.HTTPHeaders = [:]
        
        print("this is token ===========================", APP_DELEGATE.token)
        if APP_DELEGATE.token != "" {
            headers["Authorization"] = "Bearer \(APP_DELEGATE.token)"
        } else {
            print("token was nil")
            print("token in json == ", APP_DELEGATE.loginAPIResponse?.metaData?.token ?? "")
        }

        print("API : === \(url.absoluteString)")
        print("Headers : === \(headers.debugDescription)")
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "attachment")
            },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let uploadRequest, let _streamingFromDisk, let _streamingFileUrl):
                    uploadRequest.responseData { dataResponse in
                        guard dataResponse.result.isSuccess else {
                            completion(nil, dataResponse.result.error)
                            return
                        }
                        
                        guard let data = dataResponse.result.value, !data.isEmpty else {
                            completion(nil, ErrorResponse.error(-1, nil, AlamofireDecodableRequestBuilderError.emptyDataResponse))
                            return
                        }
                        guard let httpResponse = dataResponse.response else {
                            completion(nil, ErrorResponse.error(-2, nil, AlamofireDecodableRequestBuilderError.nilHTTPResponse))
                            return
                        }
                        do {
                            print(try JSONSerialization.jsonObject(with: data, options: []) as AnyObject)
                        } catch {
                            debugPrint(error)
                        }
                        let decodeResult: (decodableObj: T?, error: Error?) = CodableHelper.decode(T.self, from: data)
                        
                        let responseObj: Response<T>? = if decodeResult.error == nil {
                            Response(response: httpResponse, body: decodeResult.decodableObj)
                        } else {
                            nil
                        }
                        completion(
                            responseObj,
                            decodeResult.error
                        )
                    }
                    uploadRequest.uploadProgress(closure: uploadProgressHandler)
                case .failure(let encodingError):
                    print(encodingError)
                    completion(nil, encodingError)
                }
            }
        ) // Alamofire.upload method call
    }
}


