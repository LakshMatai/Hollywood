//
//  MovieVC.swift
//  project
//
//  Created by Laksh on 31/03/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MovieVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    var selectedMovieName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = selectedMovieName
        tryAlamo()
        bgImage.image = UIImage(named: "3")
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    var overviewText:String = ""
    var genreText = [String]()
    var genreT: String = "Genres: "
    
    func tryAlamo(){
        
        request("https://inf551-aecfc.firebaseio.com/movies_metadata.json?orderBy=%22title%22&equalTo=%22The%20Avengers%22").responseJSON{ response in
            if let JSONtext = response.result.value{
                var jsonObject = JSONtext as! [String:AnyObject]
                for(key,value) in jsonObject{
                    self.overviewLabel.text = jsonObject[key]!["overview"] as! String
                   // self.ratings.text = "\(jsonObject[key]!["vote_average"])"
                   self.ratings.text = String( describing: jsonObject[key]!["vote_average"] as! NSNumber)
                    print(self.overviewText)
                    var genres = jsonObject[key]!["genres"] as! String
                    //var genArray = [Dictionary<String,AnyObject>]
                    genres = genres.replacingOccurrences(of: "'", with: "\"",options: .literal, range: nil)
                   print(genres)
                    if let dataFromString = genres.data(using: String.Encoding.utf8,allowLossyConversion: false){
                       let genresArray = JSON(data: dataFromString)
                        for (key,subJson):(String,JSON) in genresArray{
                            
                            self.genreT += "\(subJson["name"])"
                            self.genreT += ", "
                            //print("\(subJson["name"])")
                        }
                    }
                    self.genreT = self.genreT.substring(to: self.genreT.index(before: self.genreT.endIndex))
                    self.genreT = self.genreT.substring(to: self.genreT.index(before: self.genreT.endIndex))
                    self.genreLabel.text = self.genreT
                    var filePath = jsonObject[key]!["poster_path"] as! String
                    if let imgUrl = URL(string: "https://image.tmdb.org/t/p/w500"+filePath){
                        self.downloadImage(url: imgUrl)
                    }
                }
            }
            
            
        }
        
    }
    func downloadImage(url: URL){
        print("Download Started")
        getDataFromUrl(url: url){ data,response,error in
            guard let data = data, error == nil else {return}
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.bgImage.image = UIImage(data: data)
            }
            
        }
       
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url){ data,response,error in
            completion(data,response,error)
        }.resume()
    }
        
    }

