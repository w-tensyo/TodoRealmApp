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
    var todoDetailString:String = ""
    
    //Todoのタイトルを入力
    @IBOutlet weak var toDoTextField: UITextField!
    //Todoの詳細を入力
    @IBOutlet weak var toDoDetailTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoTextField.returnKeyType = .next
        
        toDoDetailTextView.delegate = self
        toDoDetailTextView.returnKeyType = .done

    }
    
//    //キーパッドの"決定"ボタンをタップした時の処理
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        addTodoAction()
//
//        return true
//    }
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
            if todoDetailString != ""{
                todoItem.todoDetail = todoDetailString
            }else{
                todoItem.todoDetail = "詳細なし"
            }
            //入力されていた場合、Realmへのデータ追加処理を実施
            try! realm.write {
                realm.add(todoItem)
                print("書き込みに成功しているはずです")
                print(Realm.Configuration.defaultConfiguration.fileURL!)
                
                //テキストフィールドの値を空にして、キーボードを閉じる
                toDoTextField.text = ""
                toDoTextField.endEditing(true)
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            //UIAlertControllerに切り替える予定。今はとりあえずこれ
            print("エラーです")
        }
    }

}
