//
//  ColorListTableViewController.swift
//  ColorPK
//
//  Created by Zijian Guo on 7/2/18.
//  Copyright © 2018 Zijian Guo. All rights reserved.
//

import UIKit

class ColorListTableViewController: UITableViewController {

    private var colorList = [VPColor]()
    
    private func loadColors() {
        let backgroundQ = DispatchQueue.global(qos: .userInitiated)
        backgroundQ.async { [weak self] in
            self?.colorList = VPColor.getDummyColorList()
            
            let json: [String: Any] = ["_csrf": "9ovrfaV7-r-bTWhqbXZfK6yn5K0kS5_pAOoI"]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let url = URL(string: "http://react.colorpk.com/api/initColorList")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadColors()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return colorList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneColor", for: indexPath)
        let color = colorList[indexPath.row]
        cell.textLabel?.text = "id: \(color.id)"
        cell.detailTextLabel?.text = "\(color.color)"

        // Configure the cell...
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showOneColor" {
            let destCtr = segue.destination
            if let oneColorCtr = destCtr as? OneColorViewController {
                oneColorCtr.currentColor = colorList[2]
            }
        }
    }

}
