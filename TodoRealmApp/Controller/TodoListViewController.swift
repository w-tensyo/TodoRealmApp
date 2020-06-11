//
//  TodoMakeViewController.swift
//  TodoRealmApp
//
//  Created by 渡邉天彰 on 2020/06/11.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    @IBOutlet weak var todoListTableView: UITableView!
    
    
    var todoList: Results<TodoItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        let realm = try! Realm()
        
        self.todoList = realm.objects(TodoItem.self)

        //NavigationBarの背景色と文字色を変更
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0, green:0.4, blue: 0.8, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    //画面遷移で戻ってきた時の再表示処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //todoListTableViewを再描画する
        todoListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(todoList.count)
        return self.todoList.count
    }
    
    //セル一つ一つの実装について記述
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item: TodoItem = self.todoList[(indexPath as NSIndexPath).row];
        print("ToDoItemのDBの値は\(item.title)")
        
        cell.textLabel?.text = item.title
        
        return cell
        
    }
    
    

    //"メモを追加"ボタンをタップした時の処理
    @IBAction func moveAddMemoVCButton(_ sender: Any) {
        let addMemoVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMemoVC") as! AddMemoViewController
        self.navigationController?.pushViewController(addMemoVC, animated: true)
    }

    
    //セルの編集を可能にする
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let realm = try! Realm()

        let item: TodoItem = self.todoList[(indexPath as NSIndexPath).row];
        
        
        try! realm.write{
            realm.delete(item)
            
            //todoListTableViewを再描画する
            todoListTableView.reloadData()
        }
    }
}
