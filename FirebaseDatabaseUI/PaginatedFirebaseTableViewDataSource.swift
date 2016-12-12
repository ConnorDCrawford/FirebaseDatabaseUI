//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import FirebaseDatabase

class PaginatedFirebaseTableViewDataSource<T : FirebaseModel>: FirebaseTableViewDataSource<T> {
    
    var paginatedArray: PaginatedFirebaseArray<T>
    override var array: FirebaseArray<T> {
        get {
            return paginatedArray
        } set {
            assert(array is PaginatedFirebaseArray)
            if let array = array as? PaginatedFirebaseArray {
                paginatedArray = array
            }
        }
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            cellClass: AnyClass?,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortOrderBlock: sortOrderBlock,
                                     filterBlock: filterBlock)
        tableView?.register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            prototypeReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortOrderBlock: sortOrderBlock,
                                     filterBlock: filterBlock)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortOrderBlock: sortOrderBlock,
                                     filterBlock: filterBlock)
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            cellClass: AnyClass?,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortDescriptors: sortDescriptors,
                                     filterBlock: filterBlock)
        tableView?.register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            prototypeReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortDescriptors: sortDescriptors,
                                     filterBlock: filterBlock)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortDescriptors: sortDescriptors,
                                     filterBlock: filterBlock)
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            predicate: NSPredicate?,
                            cellClass: AnyClass?,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortOrderBlock: sortOrderBlock,
                                     predicate: predicate)
        tableView?.register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            predicate: NSPredicate?,
                            prototypeReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortOrderBlock: sortOrderBlock,
                                     predicate: predicate)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            predicate: NSPredicate?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortOrderBlock: sortOrderBlock,
                                     predicate: predicate)
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            predicate: NSPredicate?,
                            cellClass: AnyClass?,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortDescriptors: sortDescriptors,
                                     predicate: predicate)
        tableView?.register(cellClass, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            predicate: NSPredicate?,
                            prototypeReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                     sortKey: sortKey,
                                     pageSize: pageSize,
                                     startValue: startValue,
                                     sortDescriptors: sortDescriptors,
                                     predicate: predicate)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, tableView: tableView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            predicate: NSPredicate?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            tableView: UITableView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortDescriptors: sortDescriptors,
                                              predicate: predicate)
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, tableView: tableView)
    }
    
    public init(array: PaginatedFirebaseArray<T>, reuseIdentifier: String, tableView: UITableView?) {
        self.paginatedArray = array
        super.init(array: array, reuseIdentifier: reuseIdentifier, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check if the object is the last element of the last page
        if let object = object(at: indexPath), object.key == paginatedArray.lastLoadedObject?.key {
            paginatedArray.load(pageNumber: paginatedArray.numberOfPages)
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    
    
}
