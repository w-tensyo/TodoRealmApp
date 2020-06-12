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

    
    @IBOutlet weak var selectTaskSegmentedController: UISegmentedControl!
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    
    var todoList: Results<TodoItem>!
    
    //DBの作成
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        
        //TodoItemのDBに登録された全てのレコードを取得する処理
        self.todoList = realm.objects(TodoItem.self)
        
        // "checked"カラムがfalseだった場合（つまり、Todoが終わっていないもの）のみを拾ってくる
        //self.todoList = realm.objects(TodoItem.self).filter("checked == true")

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
    
    //cellを右→左へスワイプして表示するDeleteボタンの表示と、その処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let realm = try! Realm()

        let item: TodoItem = self.todoList[(indexPath as NSIndexPath).row];
        
        
        try! realm.write{
            realm.delete(item)
            
            //todoListTableViewを再描画する
            todoListTableView.reloadData()
        }
    }
    
    
    @IBAction func tasckSelectSegmentAction(_ sender: Any) {
        
        let selectedIndex = selectTaskSegmentedController.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            // "checked"カラムがfalseだった場合（つまり、Todoが終わっていないもの）のみを拾ってくる
            self.todoList = realm.objects(TodoItem.self).filter("checked == false")
            todoListTableView.reloadData()
            break
        case 1:
            self.todoList = realm.objects(TodoItem.self)
            todoListTableView.reloadData()
            break
        case 2:
            // "checked"カラムがtrueだった場合（つまり、Todoが終わっているもの）のみを拾ってくる
            self.todoList = realm.objects(TodoItem.self).filter("checked == true")
            todoListTableView.reloadData()
            break
        default:
            break
        }
    }
    
}
