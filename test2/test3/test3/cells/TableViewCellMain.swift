//
//  TableViewCellMain.swift
//  test3
//
//  Created by Telepaty1 on 2/20/23.
//

import UIKit

class TableViewCellMain: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var post:Post?{
        didSet{
            
               
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/"+String(post!.id)+"/comments")!
            
            
            let session=URLSession.shared
            task=session.dataTask(with: url) {(data,response,error) in
                if let data=data{
                    do{try self.post?.comment = JSONDecoder().decode([Comment].self, from: data )}
                
                catch let decodeError {
                    print(decodeError)
                }}
                DispatchQueue.main.async {
                    self.commentCollection.reloadData()
                }
            }
            if post?.comment == nil {
                task!.resume()
            }
        }
    }
    var task:URLSessionDataTask?
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelUserId: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var commentCollection: UICollectionView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.commentCollection.dataSource=self
        self.commentCollection.delegate=self
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.post?.comment?.count ?? 0
     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = commentCollection.dequeueReusableCell(withReuseIdentifier: "collComment" , for: indexPath) as! CollectionViewCell
        cell.nameLabel.text="name: "+String((post?.comment![indexPath.row].name)!)
        cell.bodyLabel.text="body: "+String((post?.comment![indexPath.row].body)!)
        
        
        
        return cell;
    }
    override func prepareForReuse() {
//        post?.comment=nil
        labelId.text=nil
        labelUserId.text=nil
        labelTitle.text=nil
        labelContent.text=nil
        labelContent.text=nil
        task?.cancel()
        
    }
}

