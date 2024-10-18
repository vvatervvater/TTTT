//
//  Notification+Ext.swift
//  Tier
//
//  Created by Denis Ravkin on 15.10.2024.
//

import Foundation

extension NotificationCenter {
    static func postTierListSavingNotification(tierListId: String, saving: Bool) {
        NotificationCenter.default.post(name: Notification.Name("TierListSaving"), object: (tierListId, saving))
    }
    
    static func observeTierListSavingNotification(completion: @escaping ((String, Bool)) -> Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("TierListSaving"), object: nil, queue: nil) { notification in
            guard let fetched = notification.object as? (String, Bool) else { return }
            completion(fetched)
        }
    }
}
