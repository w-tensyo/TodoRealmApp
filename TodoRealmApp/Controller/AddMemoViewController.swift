//
//  AddMemoViewController.swift
//  TodoRealmApp
//
//  Created by 渡邉天彰 on 2020/06/11.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class AddMemoViewController: UIViewController,UITextFieldDelegate {
    
    let todoItem = TodoItem()
    //Realmをインスタンス化
    let realm = try! Realm()
    @IBOutlet weak var toDoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTextField.delegate = self
        
        toDoTextField.returnKeyType = .done

    }
    
    //キーパッドの"決定"ボタンをタップした時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTodoAction()
        
        return true
    }
    
    //"登録"ボタンをタップした時の処理
    @IBAction func addMemoButton(_ sender: Any) {
        addTodoAction()
    }
    
    //Realmへのデータ追加処理をまとめる
    func addTodoItem(title: String){
        try! realm.write{
            realm.add(TodoItem(value: ["title": title]))
        }
    }
    
    //"登録"ボタン or キーパッドの"決定"ボタンをタップした時に実行するアクション
    func addTodoAction(){
        //TextField内に値が入力されているか判定
        if toDoTextField.text != ""{
            todoItem.title = toDoTextField.text!
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
