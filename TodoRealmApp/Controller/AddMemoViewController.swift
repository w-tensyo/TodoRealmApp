//
//  AddMemoViewController.swift
//  TodoRealmApp
//
//  Created by 渡邉天彰 on 2020/06/11.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class AddMemoViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate {
    
    //Realmをインスタンス化
    let realm = try! Realm()
    
    
    let todoItem = TodoItem()
    var todoDetailString:String = "タスク詳細を入力"
    
    //Todoのタイトルを入力
    @IBOutlet weak var toDoTextField: UITextField!
    //Todoの詳細を入力
    @IBOutlet weak var toDoDetailTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーパッドの決定ボタンの種類を指定.done(決定）
        toDoTextField.returnKeyType = .done
        toDoDetailTextView.returnKeyType = .done
        
        //Delegateメソッドを設定
        toDoDetailTextView.delegate = self
        
        //toDoTextFieldのview設定
        toDoTextField.layer.borderColor = UIColor.systemGray.cgColor
        //toDoDetailTextViewのview設定
        toDoDetailTextView.layer.borderWidth = 1.0
        toDoDetailTextView.layer.cornerRadius = 5.0
        toDoDetailTextView.layer.borderColor = UIColor.systemGray3.cgColor
        
        //TextViewのDefault値を設定
        toDoDetailTextView.text = todoDetailString
        
    }
    

    //入力画面 or キーパットの外をタップした時にキーパットを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(toDoDetailTextView.isFirstResponder){
            self.toDoDetailTextView.resignFirstResponder()
        }
    }
    
    @IBAction func registButton(_ sender: Any) {
        addTodoAction()
    }
    
    //textViewの編集内容を反映させるための処理
    func textViewDidChange(_ textView: UITextView) {
        todoDetailString = self.toDoDetailTextView.text
    }

    
    //Realmへのデータ追加処理をまとめる
    func addTodoItem(title: String,detail :String){
        try! realm.write{
            realm.add(TodoItem(value: ["title": title, "todoDetail": detail,"checked": false]))
        }
    }
    
    //"登録"ボタン or キーパッドの"決定"ボタンをタップした時に実行するアクション
    func addTodoAction(){
        //TextField内に値が入力されているか判定
        if toDoTextField.text != ""{
            todoItem.title = toDoTextField.text!
            if todoDetailString != "" && todoDetailString != "タスク詳細を入力"{
                todoItem.todoDetail = todoDetailString
            }else{
                todoItem.todoDetail = "詳細なし"
            }
            //入力されていた場合、Realmへのデータ追加処理を実施
            try! realm.write {
                realm.add(todoItem)
                
                //テキストフィールドの値を空にして、キーボードを閉じる
                toDoTextField.text = ""
                toDoTextField.endEditing(true)
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            //UIAlertControllerに切り替える予定。今はとりあえずこれ
            alertDisplay()
        }
    }

    
    //alertを実装
    func alertDisplay(){
        let alert:UIAlertController = UIAlertController(title: "未入力の項目があります", message: "タイトルを入力してください", preferredStyle: .alert)
        
        let okAlert:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAlert)
        
        present(alert, animated: true, completion: nil)
    }
}
