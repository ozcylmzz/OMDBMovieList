//
//  String.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 13.09.2023.
//

import Foundation

extension String {
    func splitIntoChunks(ofLength length: Int) -> String {
        var result: [String] = []
        var startIndex = self.startIndex
        
        while startIndex < self.endIndex {
            var endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            
            if endIndex != self.endIndex {
                while endIndex > startIndex && !self[endIndex].isWhitespace {
                    endIndex = self.index(before: endIndex)
                }
                
                if self[endIndex].isWhitespace {
                    endIndex = self.index(after: endIndex)
                }
            }
            
            let chunk = self[startIndex..<endIndex]
            result.append(String(chunk) + "\n")
            
            startIndex = endIndex
        }
        
        return result.joined()
    }
}

