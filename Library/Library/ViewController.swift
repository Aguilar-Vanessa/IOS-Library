//
//  ViewController.swift
//  Library
//
//  Created by Vanessa Aguilar on 11/24/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate{

  
    var coreDataStack: CoreDataStack!
    var book: [BookInfo] = []
    var fetchedResultsController: NSFetchedResultsController<BookInfo>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }



    
    @IBAction func addBook(_ sender: UIBarButtonItem) {
       
        
        let alert = UIAlertController(title: "New Book", message: "Please add the following information", preferredStyle: .alert)
        
        
      alert.addTextField {
            textField in
            textField.placeholder = "Book Title"
        }
        
        alert.addTextField {
                   textField in
                   textField.placeholder = "Author"
        }
        alert.addTextField {
            textField in
            textField.placeholder = "MM/YYYY"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
 
            
         guard let bookTextField = alert.textFields?.first,
            let authorTextField = alert.textFields?[1],
            let releaseTextField = alert.textFields?.last else {
                return
            }
            
            
            guard let titlesave = bookTextField.text, let authorsave = authorTextField.text, let releasesave = releaseTextField.text else {
                return
            }
             if titlesave.isEmpty || authorsave.isEmpty || releasesave.isEmpty{
                self.showAlert("Cannot Save Missing information")
                return
            }
            
            
            self.save(author: authorsave, bookTitle: titlesave, releaseYear: releasesave)
            
            self.coreDataStack.saveContext()
            self.tableView.reloadData() //update the table view once its saved
        }
        
        
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
              
        
              alert.addAction(saveAction) //save option displyed in alert
              alert.addAction(cancelAction) //cancel option included in alert
              present(alert, animated: true)
    
        
}
    
    func showAlert(_ message: String) {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    
    
    //!!!** Where we put this name into the data base**!!!
    func save(author: String, bookTitle: String, releaseYear: String){
        
    
        //This is creating a new instance of NSEntityDescription, from this we can make a new book
        let entity = NSEntityDescription.entity(forEntityName: "BookInfo", in: coreDataStack.managedContext)
        
        let bookData = BookInfo(entity: entity!, insertInto: coreDataStack.managedContext)
        
        bookData.author = author
        bookData.bookTitle = bookTitle
        bookData.releaseYear = releaseYear
        
        do{ // try an save it
            try coreDataStack.managedContext.save()
            book.append(bookData)
        }catch let error as NSError{ //if this doesnt save we will be saving a message error to the console
            print ("Save Error: \(error), description: \(error.userInfo)")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest<BookInfo>(entityName: "BookInfo")
   
        do{
            book = try coreDataStack.managedContext.fetch(fetchRequest)
        }catch let error as NSError{
             print ("Fetch Error: \(error), description: \(error.userInfo)")
        }
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return book.count
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
                configure(cell: cell, for: indexPath)
  
         return cell
     }
  

    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
         guard let cell = cell as? TableViewCell else {
             return
         }
             
               let bookData = book[indexPath.row]
                        
                         cell.authorCell.text = bookData.author
                         cell.titleCell.text = bookData.bookTitle
                         cell.releaseCell.text = bookData.releaseYear
                        
                 
    
    }

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
       }
       
    
    //Function will be used for being able to delete a person from the data base
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let bookToremove = book[indexPath.row]   //graving a reference to the book, from the row that was swiped, aka book we are trying to delete
        
            coreDataStack.managedContext.delete(bookToremove)
            
            do{ //this will throw an exception b/c you are deleting it from the managed context
                try coreDataStack.managedContext.save()
                
                book.remove(at: indexPath.row) //this will delete them from the array
                tableView.deleteRows(at:[indexPath], with: .fade)  //we could also remove them from the table view itself
                
                
            }catch let error as NSError{ ///if this doesnt save we will be saving a message error to the console
                      print ("Remove Error: \(error), description: \(error.userInfo)")
            }
        
        }
        
    }
    

}

