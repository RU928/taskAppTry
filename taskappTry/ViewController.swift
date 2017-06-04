//
//  ViewController.swift
//  taskappTry
//
//  Created by 田村崚 on 2017/04/30.
//  Copyright © 2017年 ryo.tamura. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var categoryArray = try! Realm().objects(CategoryData.self).sorted(byKeyPath: "date", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoryArray.count == 0{
            return 0
        }else{
        return categoryArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if categoryArray.count == 0{
            return cell
        }else{
        cell.textLabel?.text = categoryArray[indexPath.row].categoryName
        return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
///後で処理する
        var chatViewController: ChatViewController = segue.destination as! ChatViewController

        if segue.identifier == "cellSegue"{
        let indexPath = self.tableView.indexPathForSelectedRow
        chatViewController.category = categoryArray[(indexPath?.row)!].categoryName
        }else{
            chatViewController.category = "2"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil) // ←追加する
    }



}

