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

class PaginatedFirebaseCollectionViewDataSource<T : FirebaseModel>: FirebaseCollectionViewDataSource<T> {
    
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
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortOrderBlock: sortOrderBlock,
                                              filterBlock: filterBlock)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            prototypeReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortOrderBlock: sortOrderBlock,
                                              filterBlock: filterBlock)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortOrderBlock: sortOrderBlock,
                                              filterBlock: filterBlock)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            cellClass: AnyClass?,
                            cellReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortDescriptors: sortDescriptors,
                                              filterBlock: filterBlock)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            prototypeReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortDescriptors: sortDescriptors,
                                              filterBlock: filterBlock)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            filterBlock: PaginatedFirebaseArray<T>.FilterBlock?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortDescriptors: sortDescriptors,
                                              filterBlock: filterBlock)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            predicate: NSPredicate?,
                            cellClass: AnyClass?,
                            cellReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortOrderBlock: sortOrderBlock,
                                              predicate: predicate)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            predicate: NSPredicate?,
                            prototypeReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortOrderBlock: sortOrderBlock,
                                              predicate: predicate)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortOrderBlock: PaginatedFirebaseArray<T>.SortOrderBlock?,
                            predicate: NSPredicate?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortOrderBlock: sortOrderBlock,
                                              predicate: predicate)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            predicate: NSPredicate?,
                            cellClass: AnyClass?,
                            cellReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortDescriptors: sortDescriptors,
                                              predicate: predicate)
        collectionView?.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            predicate: NSPredicate?,
                            prototypeReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortDescriptors: sortDescriptors,
                                              predicate: predicate)
        self.init(array: array, reuseIdentifier: prototypeReuseIdentifier, collectionView: collectionView)
    }
    
    public convenience init(query: FIRDatabaseQuery,
                            sortKey: String?,
                            pageSize: UInt,
                            startValue: Any?,
                            sortDescriptors: [NSSortDescriptor]?,
                            predicate: NSPredicate?,
                            nibNamed nibName: String,
                            cellReuseIdentifier: String,
                            collectionView: UICollectionView?) {
        
        let array = PaginatedFirebaseArray<T>(query: query,
                                              sortKey: sortKey,
                                              pageSize: pageSize,
                                              startValue: startValue,
                                              sortDescriptors: sortDescriptors,
                                              predicate: predicate)
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.init(array: array, reuseIdentifier: cellReuseIdentifier, collectionView: collectionView)
    }
    
    public init(array: PaginatedFirebaseArray<T>, reuseIdentifier: String, collectionView: UICollectionView?) {
        self.paginatedArray = array
        super.init(array: array, reuseIdentifier: reuseIdentifier, collectionView: collectionView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Check if the object is the last element of the last page
        if let object = object(at: indexPath), object.key == paginatedArray.lastLoadedObject?.key {
            paginatedArray.load(pageNumber: paginatedArray.numberOfPages + 1)
        }
        
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    
    
}
