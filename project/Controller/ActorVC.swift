//
//  ActorVC.swift
//  project
//
//  Created by Laksh on 22/04/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ActorVC: UIViewController {

    //Variables
    var actorName:String = ""
    var parameterString = "%22"
    //Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var birthPlaceLbl: UILabel!
    @IBOutlet weak var birthDateLbl: UILabel!
    @IBOutlet weak var biographyLbl: UILabel!
    
    @IBOutlet weak var bgImg: UIImageView!
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = actorName
        actorName = actorName.replacingOccurrences(of: " ", with: "%20")
        parameterString = parameterString+actorName+"%22"
        getActorData()
    }

    func getActorData(){
        request("https://inf551-aecfc.firebaseio.com/people.json?orderBy=%22name%22&equalTo=\(parameterString)").responseJSON{ response in
            if let JSONtext = response.result.value{
                var jsonObject = JSONtext as! [String:AnyObject]
                for(key,value) in jsonObject{
                    self.biographyLbl.text = "\(jsonObject[key]!["biography"] as! String)"
                    self.birthDateLbl.text = "\(jsonObject[key]!["birthday"] as! String)"
                    self.birthPlaceLbl.text = "\(jsonObject[key]!["place_of_birth"] as! String) "
                    var filePath = jsonObject[key]!["profile_path"] as! String
                    if let imgUrl = URL(string: "https://image.tmdb.org/t/p/w500"+filePath){
                        self.downloadImage(url: imgUrl)
                    }
                }
            }
        }
    }
    func downloadImage(url: URL){
        // print("Download Started")
        getDataFromUrl(url: url){ data,response,error in
            guard let data = data, error == nil else {return}
            //   print(response?.suggestedFilename ?? url.lastPathComponent)
            // print("Download Finished")
            DispatchQueue.main.async() {
                self.bgImg.image = UIImage(data: data)
            }
            
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url){ data,response,error in
            completion(data,        response,error)
            }.resume()
        
    }

    
    
}
