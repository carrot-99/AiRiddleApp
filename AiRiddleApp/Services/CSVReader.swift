//  CSVReader.swift

import Foundation

class CSVReader {
    func readCSV(fileName: String) -> [Riddle] {
        var riddles = [Riddle]()

        if let filePath = Bundle.main.path(forResource: fileName, ofType: "csv"),
           let contents = try? String(contentsOfFile: filePath) {
//            print("CSV File Found: \(filePath)")
            let rows = contents.components(separatedBy: "\n")
            for row in rows {
//                print("Row: \(row)")
                let columns = row.components(separatedBy: ",")
                if columns.count == 3 {
                    let riddle = Riddle(question: columns[0], aiAnswer: columns[1], trueAnswer: columns[2])
                    riddles.append(riddle)
                }
            }
        } else {
            print("CSV File NOT Found: \(fileName)")
        }

        return riddles
    }
}
