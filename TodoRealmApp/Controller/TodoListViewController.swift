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
    
    //Segumentの選択しているステータスを判定するための変数を用意
    var segmentStatus:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        
        //TodoItemのDBに登録された全てのレコードを取得する処理
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
        
        return self.todoList.count
    }
    
    //セル一つ一つの実装について記述
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item: TodoItem = self.todoList[(indexPath as NSIndexPath).row];
        
        cell.textLabel?.text = item.title
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat?
        if segmentStatus == 0{
            if self.todoList[(indexPath as NSIndexPath).row].checked == false{
                height = 44
            }else{
                height = 0
            }
        }else if segmentStatus == 1{
            self.todoList = realm.objects(TodoItem.self)
            height = 44
        
        }else{
            if self.todoList[(indexPath as NSIndexPath).row].checked == true{
                height = 44
            }else{
                height = 0
            }
        }
        return height!
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailTodoVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailTodoVC") as! DetailTodoViewController
        
        //DBのレコードのindex番号を元に、遷移先で情報を取得したい。
        //そのため。detailTodoVCのindexNumberにindexPath.rowを格納している
        detailTodoVC.indexNumber = indexPath.row
        detailTodoVC.titleLabel = self.todoList[indexPath.row].title

        
        self.navigationController?.pushViewController(detailTodoVC, animated: true)
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
    
    
    
    //Segumentごとに表示するリストを切り分ける(全件 or 未完了 or 完了済み)
    @IBAction func tasckSelectSegmentAction(_ sender: Any) {
        
        let selectedIndex = selectTaskSegmentedController.selectedSegmentIndex
        switch selectedIndex {
        case 0: //未完了タスクのみ
            // "checked"カラムがfalseだった場合（つまり、Todoが終わっていないもの）のみを拾ってくる
            segmentStatus = 0
            todoListTableView.reloadData()
            break
        case 1: //すべてのタスク
            
            segmentStatus = 1
            todoListTableView.reloadData()
            break
        case 2: //完了済みタスクのみ
            // "checked"カラムがtrueだった場合（つまり、Todoが終わっているもの）のみを拾ってくる
            
            segmentStatus = 2
            todoListTableView.reloadData()
            break
        default: //何かあった時のデフォルト値として、未完了タスクを設定
            todoListTableView.reloadData()
            break
        }
    }
    
}
