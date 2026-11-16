//
//  CommonFunctions.swift
//  MountCarmel
//
//  Created by Sandip on 28/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation
class CommonFunctions: NSObject {
    
    //MARK:-GETCURRENTDATETIME
    class func getCurrentDateTimeInString(isTime:Bool)->String{
        
        let formatter = DateFormatter()
        let date = Date()
        
        if !isTime {
            formatter.dateFormat = DateFormat.ddMMMyyyy
        } else {
            formatter.dateFormat = DateFormat.ddMMyyyyhhMMSS
        }
        
        return formatter.string(from: date)
    }
    
    
    //MARK:- GETDATEINSTRING
    class func getDateInString(date: Date, strDateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "GMT")
        formatter.dateFormat = strDateFormat
         formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    class func getStringToDate(Format:String,strDate:String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "GMT")
        formatter.dateFormat = Format
        formatter.timeZone = TimeZone.current
        return strDate != "" ? formatter.date(from: strDate) ?? Date() : Date()
    }
    
    class func localToUTC(date:String, fromFormat: String, toFormat: String) -> String {
        
     /*   let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = toFormat*/
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = toFormat
        
        guard let dateValue = dt else { return date }
        return dateFormatter.string(from: dateValue)
    }
    
    class func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
       /* let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
       // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale.current*/
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = toFormat
        
        guard let dateValue = dt else { return date }
        return dateFormatter.string(from: dateValue)
    }
    
    class func getDateString(date:String, fromFormat: String, toFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = toFormat
        
        guard let dateValue = dt else { return date }
        return dateFormatter.string(from: dateValue)
    }
    
    class func downloadfile(viewcontroller : UIViewController,url : URL, mimeType:String, fileName: String, completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        /*
         var pathExtension = ""
         if mimeType == MimeTypes.jpg {
         pathExtension = ".jpeg"
         }else if mimeType == MimeTypes.jpeg{
         pathExtension = ".jpg"
         }else if mimeType == MimeTypes.doc {
         pathExtension = ".doc"
         }else if  mimeType == MimeTypes.docx{
         pathExtension = ".docx"
         }else if mimeType == MimeTypes.xlsx {
         pathExtension = ".xlsx"
         }else if mimeType == MimeTypes.xls{
         pathExtension = ".xls"
         }else if mimeType == MimeTypes.pdf{
         pathExtension = ".pdf"
         }else {
         let arrMimeType = mimeType.components(separatedBy: "/")
         if arrMimeType.count > 0 {
         pathExtension = arrMimeType[1]
         }
         }
         */
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("\(fileName)")
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            do {
                try FileManager.default.removeItem(atPath: destinationUrl.path)
            } catch {
            }
            // if the file doesn't exist
        }
        //else {
            
            
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    
                    DispatchQueue.main.async {
                        completion(true, destinationUrl)
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        //}
    }
    
    class func downloadfileWithTempLocation(viewcontroller : UIViewController,url : URL, mimeType:String, fileName: String, completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else {
                    completion(false, nil)
                    return
                }
                    DispatchQueue.main.async {
                        completion(true, tempLocation)
                    }
                
            }).resume()
    }
    
    
    class func logOutFromAPP(){
        APP_DELEGATE.RemoveAllDefaults()
    }
    
    //MARK: - Save PDF in Local
       
        class func download_and_save_file(str_url:String,completion:@escaping(String)->()){
            
            if let File_Url = URL(string: str_url) {
                // create your document folder url
                let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                // your destination file url
                let destination = documentsUrl.appendingPathComponent(File_Url.lastPathComponent)
                print(destination)
                // check if it exists before downloading it
                if FileManager().fileExists(atPath: destination.path) {
                    completion("The file already exists at path")
                } else {
                    //  if the file doesn't exist
                    //  just download the data from your url
                  ///  Indicator.shared().start(msg: "Downloading File")
                    URLSession.shared.downloadTask(with: File_Url, completionHandler: { (location, response, error) in
                        // after downloading your data you need to save it to your destination url
                   
                        guard
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                          //  let mimeType = response?.mimeType, mimeType.hasPrefix("jpg"),
                            let location = location, error == nil
                            else {
                                completion("Error in downloading")
                                return
                        }
                        do {
                            try FileManager.default.moveItem(at: location, to: destination)
                            completion("File saved successfully in 'FILES' app")
                        } catch {
                            completion(error.localizedDescription)
                            print(error)
                        }
                    }).resume()
                }
            }
        }
    
}
extension String{
     func thumbnail() -> UIImage? {

        guard let url = URL(string: self) else {return nil}
        let asset: AVAsset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)

            do {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
                return UIImage(cgImage: thumbnailImage)
            } catch let error {
                print(error)
            }

            return nil
}

}
