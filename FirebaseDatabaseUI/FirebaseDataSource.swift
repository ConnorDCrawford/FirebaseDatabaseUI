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

import FirebaseDatabase

open class FirebaseDataSource<T: FirebaseModel>: NSObject, FirebaseArrayDelegate {
    
    open var array: FirebaseArray<T>
    open var cancelBlock: ((Error)->Void)?
    
    lazy var sections = [String : [T]]()
    lazy var sectionNames = [String]()
    
    public init(array: FirebaseArray<T>) {
        self.array = array
        super.init()
        
        self.array.delegate = self
    }
    
    // MARK: - API methods
    
    open var count: Int {
        return self.array.count
    }
    
    open func object(at indexPath: IndexPath) -> T? {
        if indexPath.row < self.array.count {
            return self.array[indexPath.row]
        }
        return nil
    }
    
    open func ref(for indexPath: IndexPath) -> FIRDatabaseReference? {
        if indexPath.row < self.array.count {
            return self.array.ref(for: indexPath.row)
        }
        return nil
    }
    
    open func cancel(with block: ((Error)->Void)?) {
        self.cancelBlock = block
    }
    
    // MARK: - FirebaseArrayDelegate methods
    
    open func update(with block: (() -> Void)?) {}
    open func initialized() {}
    open func added<Model : FirebaseModel>(child: Model, at index: Int) {}
    open func changed<Model : FirebaseModel>(child: Model, at index: Int) {}
    open func removed<Model : FirebaseModel>(child: Model, at index: Int) {}
    open func moved<Model : FirebaseModel>(child: Model, from oldIndex: Int, to newIndex: Int) {}
    open func changedSortOrder() {}
    
    open func cancelled(with error: Error) {
        cancelBlock?(error)
    }
    
}
