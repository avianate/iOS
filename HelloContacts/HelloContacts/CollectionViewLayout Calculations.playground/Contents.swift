import UIKit

let collectionViewHeight = 667
let itemHeight = 90
let itemWidth = 100
let itemSpacing = 10

let numberOfItems = 60

let numRows = (collectionViewHeight + itemSpacing) / (itemHeight + itemSpacing)
let numColumns = numberOfItems / numRows

var allFrames = [CGRect]()

for i in 0 ..< numberOfItems {
    let row = i % numRows
    let column = i / numRows
    
    var xPos = column * (itemWidth + itemSpacing)
    
    if row % 2 == 1 {
        xPos += itemWidth / 2
    }
    
    let yPos = row * (itemHeight + itemSpacing)
    
    allFrames.append(CGRect(x: xPos, y: yPos, width: itemWidth, height: itemHeight))
}

print(allFrames)

