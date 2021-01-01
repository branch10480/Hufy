//
//  String+.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    var jpEncoded: String {
        let characterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "/?-._~"))
        return self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? self
    }
}
