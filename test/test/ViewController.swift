//
//  ViewController.swift
//  test
//
//  Created by Telepaty1 on 2/16/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "mylab1" , for: indexPath) as! TableViewCell
        cell.itemViewLabel.text=data[indexPath.row]
        return cell;
    }
    
    let data=["item1","item2","item3"]
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toogleButton: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor=#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        //self.tableView.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "mylab")
        tableView.dataSource=self
        tableView.delegate=self
        
        
        
    }

    @IBAction func stateChanged(_ sender: Any) {
        if toogleButton.isOn {
            label.text="test";
        }else{
            label.text="";
        }
    }
    
   
    
}

