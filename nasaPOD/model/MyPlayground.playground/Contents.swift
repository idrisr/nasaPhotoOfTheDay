//: Playground - noun: a place where people can play

import Foundation

let startDate = NSDateComponents()
startDate.year = 2016
startDate.month = 1
startDate.day = 1
let calendar = NSCalendar.currentCalendar()
let startDateNSDate = calendar.dateFromComponents(startDate)!

let offsetComponents: NSDateComponents = NSDateComponents()
offsetComponents.day = 1
var nd:NSDate = startDateNSDate

//for i in 1...1000 {
//    nd = calendar.dateByAddingComponents(offsetComponents, toDate: nd, options: .MatchStrictly)!;
//    print(nd)
//}

print(nd)
while nd.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {
    print(nd)
}
