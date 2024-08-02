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
    @IBOutlet weak var photosTableView: UITableView!
    
    var url : URL?
    var urlRequest : URLRequest?
    var urlSession : URLSession?
    var photos : [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        registerCellWithTableView()
        parseJSON()
        //bindImages()
    }
    
    private func registerCellWithTableView(){
        let uiNib = UINib(nibName: Constants.reuseIdentifierForPhotoTableViewCell, bundle: nil)
        photosTableView.register(uiNib, forCellReuseIdentifier: Constants.reuseIdentifierForPhotoTableViewCell)
    }
    
    private func initializeViews(){
        photosTableView.delegate = self
        photosTableView.dataSource = self
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
            
            DispatchQueue.main.async {
                self.photosTableView.reloadData()
            }
            
            print(self.photos)
        })
        photosDataTask?.resume()
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoTableViewCell = self.photosTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
        
        //binding imageUrl with imageView by using SDWebImage pod.
        photoTableViewCell.photoImageView.sd_setImage(with:URL(string: photos[indexPath.row].url), placeholderImage: UIImage(named:"test_image"))
        
        photoTableViewCell.albumIdLabel.text = String(photos[indexPath.row].albumId)
        photoTableViewCell.idLabel.text = String(photos[indexPath.row].id)
        photoTableViewCell.titleLabel.text = photos[indexPath.row].title
        
        photoTableViewCell.albumIdLabel.backgroundColor = .lightGray
        photoTableViewCell.idLabel.backgroundColor = .lightGray
        photoTableViewCell.titleLabel.backgroundColor = .lightGray
        
        return photoTableViewCell
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137.0
    }
}
