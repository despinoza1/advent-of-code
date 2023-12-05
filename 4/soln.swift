import Foundation

struct Card {
    let id: Int
    let matches: Int
    let points: Int

    init(_ text: String) {
        let card = text.components(separatedBy:  ":")

        self.id = Int(
            card[0]
            .components(separatedBy: " ")
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }[1])!

        let nums = card[1].components(separatedBy:  "|")
        let winningNums = Set(
            nums[0]
            .components(separatedBy: " ")
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { Int($0.trimmingCharacters(in: .whitespaces)) }) 
        let ourNums = Set(
            nums[1]
            .components(separatedBy: " ")
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { Int($0.trimmingCharacters(in: .whitespaces)) }) 

        self.matches = ourNums.intersection(winningNums).count
        self.points = 1 << (self.matches - 1)
    }
}

let args = CommandLine.arguments
if CommandLine.argc != 2 {
    print(String(format: "Usage %s <filename>", args[0]))
}

let path = URL(fileURLWithPath: args[1])
let text = (try? String(contentsOf: path))!
let lines = text.trimmingCharacters(in: .newlines).components(separatedBy:  .newlines)
var total = 0


/* for line in lines {
    print(line)

    let round = line.components(separatedBy:  ":")
    let nums = round[1].components(separatedBy:  "|")
    
    let winningNums = Set(
        nums[0]
        .components(separatedBy: " ")
        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        .map { Int($0.trimmingCharacters(in: .whitespaces)) }) 
    let ourNums = Set(
        nums[1]
        .components(separatedBy: " ")
        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        .map { Int($0.trimmingCharacters(in: .whitespaces)) }) 

    let matches = ourNums.intersection(winningNums).count
    total += 1 << (matches - 1)
}

print("Total: ", total) */

let cards = lines.map { Card($0) }
print("Total: ", cards.map { $0.points } .reduce(0, +))

var copies: [Int] = [Int](repeating: 1, count: cards.count + 1)
copies[0] = 0

for card in cards {
    if card.matches == 0 {
        continue
    }

    for id in card.id + 1 ... card.id + card.matches {
        copies[id] += copies[card.id]
    }
}

print("Total: ", copies.reduce(0, +))
