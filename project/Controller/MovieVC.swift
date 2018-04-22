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

class MovieVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource  {

    //Outlets
    
    var movieId:String = ""
    var actorArray = [String]()
    var characterArray = [String]()
    var actorImagesArray = [UIImage]()
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    
    var selectedMovieName:String = ""
    var parameterString = "%22"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = selectedMovieName
        selectedMovieName = selectedMovieName.replacingOccurrences(of: " ", with: "%20")
        parameterString = parameterString + selectedMovieName + "%22"
        print(parameterString)
        getMovieData()
        
        
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    var overviewText:String = ""
    var genreText = [String]()
    var genreT: String = "Genres: "
    
    func getMovieData(){
        
        request("https://inf551-aecfc.firebaseio.com/movies_metadata.json?orderBy=%22title%22&equalTo=\(parameterString)").responseJSON{ response in
            if let JSONtext = response.result.value{
                var jsonObject = JSONtext as! [String:AnyObject]
                for(key,value) in jsonObject{
                    self.movieId = jsonObject[key]!["id"] as! String
                    self.overviewLabel.text = jsonObject[key]!["overview"] as! String
                   // self.ratings.text = "\(jsonObject[key]!["vote_average"])"
                   self.ratings.text = String( describing: jsonObject[key]!["vote_average"] as! NSNumber)
                  //  print(self.overviewText)
                    var genres = jsonObject[key]!["genres"] as! String
                    //var genArray = [Dictionary<String,AnyObject>]
                    genres = genres.replacingOccurrences(of: "'", with: "\"",options: .literal, range: nil)
                 // print(genres)
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
           self.getCast()
            
        }
        
    }
    func downloadImage(url: URL){
       // print("Download Started")
        getDataFromUrl(url: url){ data,response,error in
            guard let data = data, error == nil else {return}
         //   print(response?.suggestedFilename ?? url.lastPathComponent)
           // print("Download Finished")
            DispatchQueue.main.async() {
                self.bgImage.image = UIImage(data: data)
            }
            
        }
       
    }
    
    func downloadActorImage(url: URL){
        // print("Download Started")
        getDataFromUrl(url: url){ data,response,error in
            guard let data = data, error == nil else {
                print("image didnt download")
                return}
            //   print(response?.suggestedFilename ?? url.lastPathComponent)
            // print("Download Finished")
            DispatchQueue.main.sync() {
                
                if let actor = UIImage(data: data){
                    self.actorImagesArray.append(actor)
                }
                else{
                    self.actorImagesArray.append(UIImage(named: "menuProfileIcon")!)
                }
                self.actorCollectionView.reloadData()
                
            }
            
        }
        
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url){ data,response,error in
            completion(data,response,error)
        }.resume()
        
    }
    
    func getCast(){
        request("https://inf551-aecfc.firebaseio.com/credits.json?orderBy=%22id%22&equalTo="+movieId).responseJSON{ response in
            if let JSONtext = response.result.value{
                var jsonObject = JSONtext as! [String:AnyObject]
                for(key,value) in jsonObject{
                    var castArray = jsonObject[key]!["cast"] as! String
                    var crewArray = jsonObject[key]!["crew"] as! String
                    crewArray = crewArray.replacingOccurrences(of: "None", with: "null", options: .literal, range: nil)
                    crewArray = crewArray.replacingOccurrences(of: "{'", with: "{\"", options: .literal, range: nil)
                    crewArray = crewArray.replacingOccurrences(of: "':", with: "\":", options: .literal, range: nil)
                    crewArray = crewArray.replacingOccurrences(of: " '", with: " \"", options: .literal, range: nil)
                    crewArray = crewArray.replacingOccurrences(of: "',", with: "\",", options: .literal, range: nil)
                    crewArray = crewArray.replacingOccurrences(of: "'}", with: "\"}", options: .literal, range: nil)
                    
                  
                    if let dataFromString = crewArray.data(using: String.Encoding.utf8,allowLossyConversion: false){
                        let crewJSON = JSON(data: dataFromString)
                      
                        for (key,subJson):(String,JSON) in crewJSON{
                            //print("\(subJson["job"])")
                            //print("\(subJson["name"])")
                            if "\(subJson["job"])" == "Director"{
                                self.directorLabel.text = "Directed by: \(subJson["name"])"
                                 break
                            }
                        }
                    }
                    var tim = "\\\" cssd"
                    print(tim)
                    tim = tim.replacingOccurrences(of: "\\\"", with:"", options: .literal, range:nil)
                    print(tim)
                    
                  //  castArray = castArray.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
                    castArray = castArray.replacingOccurrences(of: "'Virginia \"Pepper\" Potts'", with: "\"Pepper\"", options: .literal, range: nil)
                    castArray = castArray.replacingOccurrences(of: "None", with: "null", options: .literal, range: nil)
                    castArray = castArray.replacingOccurrences(of: "{'", with: "{\"", options: .literal, range: nil)
                    castArray = castArray.replacingOccurrences(of: "':", with: "\":", options: .literal, range: nil)
                    castArray = castArray.replacingOccurrences(of: " '", with: " \"", options: .literal, range: nil)
                    castArray = castArray.replacingOccurrences(of: "',", with: "\",", options: .literal, range: nil)
                    castArray = castArray.replacingOccurrences(of: "'}", with: "\"}", options: .literal, range: nil)
                    
                    
                    if let castDataFromString = castArray.data(using: String.Encoding.utf8, allowLossyConversion: false){
                        let castJson = JSON(data: castDataFromString)
                        var i:Int = 0
                        print (castArray)
                        for (key, subJson):(String,JSON) in castJson{
                            self.characterArray.append("\(subJson["character"])")
                            self.actorArray.append("\(subJson["name"])")
                            if let imgUrl = URL(string: "https://image.tmdb.org/t/p/w500"+"\(subJson["profile_path"])"){
                                self.downloadActorImage(url: imgUrl)
                            }
                            else{
                                self.actorImagesArray.append(UIImage(named: "menuProfileIcon")!)
                            }
                            
                           // print(subJson["character"])
                           // print(subJson["name"])
                           // print(subJson["profile_path"])
                            if i==10{
                                break
                            }
                            i+=1
                        }
                    }
                    
                    
                }
            }
            print(self.actorArray)
            print(self.actorImagesArray.count)
            self.actorCollectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actorImagesArray.count
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCollectionViewCell", for: indexPath) as! castCollectionViewCell
        
        cell.actorCharacter.text = characterArray[indexPath.row]
        cell.actorName.text = actorArray[indexPath.row]
        cell.actorImage.image = actorImagesArray[indexPath.row]
        return cell
    }
    
    
}

