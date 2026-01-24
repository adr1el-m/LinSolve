import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(sub value: Int) {
        let subscriptMap: [Int: String] = [
            0: "₀", 1: "₁", 2: "₂", 3: "₃", 4: "₄",
            5: "₅", 6: "₆", 7: "₇", 8: "₈", 9: "₉"
        ]
        let str = String(value)
        let result = str.compactMap { char in
            if let intVal = Int(String(char)) {
                return subscriptMap[intVal]
            }
            return String(char)
        }.joined()
        appendLiteral(result)
    }
}
