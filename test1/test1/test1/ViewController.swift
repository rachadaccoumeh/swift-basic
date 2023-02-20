//
//  ViewController.swift
//  test1
//
//  Created by Telepaty1 on 2/16/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell" , for: indexPath) as! TableViewCell
        cell.idLabel.text=String(photos[indexPath.row].id)
        cell.photo=photos[indexPath.row]
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBOutlet weak var tableView: UITableView!
    var activityIndicator:UIActivityIndicatorView?
    @IBAction func notificationButton(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ (granted,error) in
            
        }
        let content=UNMutableNotificationContent()
        content.title="title test"
        content.body="Hello, world!"
        content.sound=UNNotificationSound.default
        
        let request=UNNotificationRequest(identifier: "notidication identifier", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler:{ (error) in
          if error != nil{
          print("error with notification")
          }
        }
        )
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showToast(message: String(indexPath.row))
    }
    
    var photos:[Photo]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self;
        tableView.dataSource=self;
//        tableView.isHidden = true;
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
        URLSession.shared.fetchData(at: url) { result in
            switch result {
            case .success(let toDos):
                self.photos=toDos
                DispatchQueue.main.async {
                self.tableView.reloadData()
//                    self.tableView.isHidden=false
                    self.activityIndicator?.stopAnimating()
//                    self.LoadingStop()
                    
                }
            case .failure(let error):
                print("error: ",error)
            }
        }
        
       
    }

    override func viewDidAppear(_ animated: Bool) {
//        self.LoadingStart()
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator!.color = .gray
//        activityIndicator.centerXAnchor.constraint(equalTo: )
//        tableView.backgroundView=activityIndicator
        tableView.addSubview(activityIndicator!)
        activityIndicator!.center=tableView.center
    
        activityIndicator!.startAnimating()
        
    }
}


func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        //toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
extension URLSession {
    func fetchData(at url: URL, completion: @escaping (Result<[Photo], Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let toDos = try JSONDecoder().decode([Photo].self, from: data)
                    completion(.success(toDos))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}



struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url:String
    let thumbnailUrl:String
    
    enum CodingKeys: String, CodingKey {
        case albumId, id, title,url,thumbnailUrl
    }
}





extension UIViewController{
    
    
   func LoadingStart(){
    let alert=UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    //alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)

    
  }

  func LoadingStop(){
    dismiss(animated: true, completion: nil)
   
  }
}
