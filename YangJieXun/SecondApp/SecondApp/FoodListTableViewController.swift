//
//  FoodListTableViewController.swift
//  SecondApp
//
//  Created by Apple on 2019/10/15.
//  Copyright © 2019 Nic. All rights reserved.
//

import UIKit

class FoodListTableViewController: UITableViewController {

    var foodList:[Food] = [Food]()
    
    func initFoodList(){
        let temp = loadFoodFile()
        if(temp == nil){
            foodList.append(Food(name: "cake", description:"sweet", foodAvatar: nil))
            foodList.append(Food(name: "peach", description:"delicious", foodAvatar: nil))
            foodList.append(Food(name: "grape", description: "nice", foodAvatar: nil))
        
        }else{
            foodList = temp!
        }
        
    }

    //持久化保存foodList文件
    func saveFoodFile(){
        //把foodList保存到指定路径
        let success = NSKeyedArchiver.archiveRootObject(foodList, toFile: Food.ArchiveURL.path)
        //保存不成功的话
        if !success{
            print("Failed ...")
        }
    }
    //加载持久化保存的数据
    func loadFoodFile() -> [Food]? {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Food.ArchiveURL.path) as? [Food])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let defaultFoodList = loadFoodFile(){
            foodList = defaultFoodList
        }else{
            initFoodList()
        }
        self.tableView.rowHeight = 80
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func cancelToList (segue: UIStoryboardSegue){}

    @IBAction func saveToList(segue: UIStoryboardSegue){
        if let addFoodVC = segue.source as? FoodItemViewController{
            if let addFood = addFoodVC.foodForEdit{
                //如果是修改已有的日记项，则保存新的值
                //先在数组中修改数据，再传到表格中
                if let selectedIndexPath = tableView.indexPathForSelectedRow{
                    foodList[(selectedIndexPath as NSIndexPath).row] = addFood
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                //否则，增加一条值
                //先在数组中增加数据，再在表格中增加
                else{
                    foodList.append(addFood)
                    let newIndexPath = IndexPath(row: foodList.count-1, section:0)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
        //持久化保存数据
        saveFoodFile()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodList.count
    }

    //表示图的cell内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodTableViewCell
        // Configure the cell...
        cell.foodName.text = foodList[indexPath.row].foodName
        cell.foodDes.text = foodList[indexPath.row].foodDescription
        cell.foodImage.image = foodList[indexPath.row].foodAvatar
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    //重写以编辑表示图
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            foodList.remove(at: indexPath.row)
            saveFoodFile()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //页面跳转到item页面之前传数据
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //声明一个目标页面的代理
        let descriptionVC = segue.destination as! FoodItemViewController
        //如果跳转标识符是showDetail，则将当前cell的对应数据传给目标页面
        if(segue.identifier == "showDetail"){
            if let selectedCell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: selectedCell)!
                let selectedFood = foodList[(indexPath as NSIndexPath).row]
                descriptionVC.foodForEdit = selectedFood
            }
            print("show detail view")
        }
        //否则，创建一个新的空白对象传给目标页面
        else{
            descriptionVC.foodForEdit = Food(name:"", description:"",foodAvatar: nil)
            print("add new food")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
