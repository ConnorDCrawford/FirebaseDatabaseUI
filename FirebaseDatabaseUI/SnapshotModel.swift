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

open class SnapshotModel: FIRDataSnapshot, FirebaseModel {
    
    // Hidden variables for storing property values
    // Needed because Firebase made all values of FIRDataSnapshot immutable, so we must override
    private var innerValue: Any?
    private var innerChildrenCount: UInt
    private var innerRef: FIRDatabaseReference
    private var innerKey: String
    private var innerChildren: NSEnumerator
    private var innerPriority: Any?
    
    override open var value: Any? {
        return innerValue
    }
    
    override open var childrenCount: UInt {
        return innerChildrenCount
    }
    
    override open var ref: FIRDatabaseReference {
        return innerRef
    }
    
    override open var key: String {
        return innerKey
    }
    
    override open var children: NSEnumerator {
        return innerChildren
    }
    
    override open var priority: Any? {
        return innerPriority
    }
    
    required public init?(snapshot: FIRDataSnapshot) {
        innerValue = snapshot.value
        innerChildrenCount = snapshot.childrenCount
        innerRef = snapshot.ref
        innerKey = snapshot.key
        innerChildren = snapshot.children
        innerPriority = snapshot.priority
        super.init()
    }
    
}
