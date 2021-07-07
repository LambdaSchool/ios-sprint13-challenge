//
//  Helper.swift
//  Test
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

struct Helper {
    static func alert(on view: UIViewController, _ title: String, _ message: String) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        view.present(popup, animated: true)
    }
    static func getMemories() -> [Memory]{
        if let data = UserDefaults.standard.data(forKey: "Memories") {
            let decoder = JSONDecoder()
            if let array = try? decoder.decode([Memory].self, from: data) {
                return array
            }
        }
        return []
    }
    
    static func setMemories(_ memories: [Memory]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(memories) {
            UserDefaults.standard.set(data, forKey: "Memories")
        }
    }
}
