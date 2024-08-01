//
//  ViewController.swift
//  19_06_24_WebServicesDemoVersion2
//
//  Created by Vishal Jagtap on 01/08/24.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var url : URL?
    var urlRequest : URLRequest?
    var urlSession : URLSession?
    var photos : [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
        //bindImages()
    }
    
    private func bindImages(){
        let url = URL(string: "https://via.placeholder.com/600/24f355")
        imageView.sd_setImage(with: url)
    }
    
    private func parseJSON(){
        url = URL(string: Constants.photosUrl)
        
        urlRequest = URLRequest(url: url!)
        urlRequest?.httpMethod = "GET"
        
        urlSession = URLSession(configuration: .default)
        
        let photosDataTask = urlSession?.dataTask(with: urlRequest!, completionHandler: { 
            data, response, error in
            let photosAPIResponse = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            for eachPhoto in photosAPIResponse{
                let eachPhotoAlbumId = eachPhoto["albumId"] as! Int
                let eachId = eachPhoto["id"] as! Int
                let eachPhotoTitle = eachPhoto["title"] as! String
                let eachPhotoURL = eachPhoto["url"] as! String
                let eachPhotoThumbnailURL = eachPhoto["thumbnailUrl"] as! String
                
                self.photos.append(Photo(albumId: eachPhotoAlbumId, id: eachId, title: eachPhotoTitle, url: eachPhotoURL, thumbnailUrl: eachPhotoThumbnailURL))
            }
            
            print(self.photos)
        })
        
        photosDataTask?.resume()
        
    }
}
