// RUN: not --crash %swift %s -parse -verify
// Test case submitted to project by https://github.com/practicalswift (practicalswift)
// http://www.openradar.me/18061131

protocol a {
    func c(b: b)
}
 
protocol b {
    func d(a: a)
}
