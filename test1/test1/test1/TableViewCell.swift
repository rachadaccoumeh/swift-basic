//
//  TableViewCell.swift
//  test1
//
//  Created by Telepaty1 on 2/16/23.
//

import UIKit

class TableViewCell: UITableViewCell {

   
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    var task:URLSessionDataTask?
    var photo:Photo?=nil {
        didSet{
            let url=URL(string: self.photo!.url)!
            let session=URLSession.shared
            task=session.dataTask(with: url){
                (data,response,error) in
                if let imageData=data{
                    let image=UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.myImageView.image=image
                        //self.tableView.reloadData()
                    }
                }
            }
            task!.resume()
            
        }
    }
    override func prepareForReuse() {
        task!.cancel()
        self.myImageView.image=nil
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        self.myImageView.image=nil
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}


