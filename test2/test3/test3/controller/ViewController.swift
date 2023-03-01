//
//  ViewController.swift
//  test3
//
//  Created by Telepaty1 on 2/17/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MyDelegate {
   
    
    @IBOutlet weak var mainTableView: UITableView!
    var posts:[Post] = []
    var index:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource=self
        mainTableView.delegate=self
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        URLSession.shared.fetchData(at: url) { (result: Result<[Post], Error>) in
            switch result {
            case .success(let posts):
                self.posts=posts
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
                
            case .failure(let error):
                // Ohno, an error, let's handle it
                print(error)
            }
        }
        
        
        let floatingButton = UIButton()
        floatingButton.setTitle("Add", for: .normal)
        floatingButton.backgroundColor = .black
        floatingButton.layer.cornerRadius = 25
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        
        floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Post", message: "Message", preferredStyle: .alert)
        
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter text"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            let textField = alertController.textFields![0] as UITextField
            if textField.text != nil
            { let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let  text=textField.text!
                let params = ["userId": 1, "id": 1,"title":"test title","body":text] as [String : Any]
                let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let session = URLSession.shared
                DispatchQueue.main.async {self.LoadingStart()}
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.LoadingStop()
                            self.showToast(message: error.localizedDescription)
                        }
                        
                        return
                    }
                    if data != nil {
                        DispatchQueue.main.async {
                            self.LoadingStop()
                            if let httpResponse = response as? HTTPURLResponse {
                                print("Status code: \(httpResponse.statusCode)")
                            }
                            self.showToast(message: "Done")
                        }
                        
                    }
                }
                task.resume()}
            
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count * 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2==0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell" , for: indexPath) as! TableViewCellMain
            let index=Int(ceil(Double(indexPath.row/2)))
            cell.labelId.text=String(posts[index].id)
            cell.labelUserId.text="user id: "+String(posts[index].userId)
            cell.labelTitle.text="title: "+String(posts[index].title)
            cell.labelContent.text="content: "+String(posts[index].body)
            cell.mainIndex=indexPath
            cell.post=posts[indexPath.row]
            cell.delegate=self
            return cell;
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell1" , for: indexPath) as! TableViewCellMain1
            cell.indexLabel.text = String(indexPath.row)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2==0 {
            if indexPath.row == index {
                return 250
            }else{
                return 250
            }
        }else {
            return 75
        }
    }
    
    func update(indexPath: IndexPath) {
        if indexPath.row != index{
            if index != nil{
                guard let cell = mainTableView.cellForRow(at: IndexPath(item: index!, section: 0)) as? TableViewCellMain else{return}
                cell.commentCollection.heightAnchor.constraint(equalToConstant: 50).isActive=true
            }
        }
        index=indexPath.row
        mainTableView.beginUpdates()
        mainTableView.endUpdates()
    }
    func updateCollection(index: IndexPath) {
        guard let cell = mainTableView.cellForRow(at: index) as? TableViewCellMain else{return}
        //cell.commentCollection.heightAnchor.constraint(equalToConstant: 50).isActive=true
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}


class Post:Decodable {
    let userId: Int
    let id:Int
    let title:String
    let body:String
    var comment:[Comment]?
}

struct Comment:Decodable {
    var postId:Int
    var id:Int
    var name:String
    var email:String
    var body:String
}

extension URLSession {
    func fetchData<T: Decodable>(at url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
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



protocol collectionDelagate {
    func updateCollection(indexpath:IndexPath)
}

