//
//  IntImage.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import Foundation

enum Color: Int {
    case black = 0
    case white = 1
    case transparent = 2
    
    var outputString: String? {
        switch self {
        case .black:
            return " "
        case .white:
            return "X"
        case .transparent:
            return nil
        }
    }
}

class IntImage {
    struct Layer {
        var width: Int
        var height: Int
        var pixels: [Color]

        private func getIndex(x: Int, y: Int) -> Int {
            return y * width + x
        }

        func getPixel(x: Int, y: Int) -> Color {
            return self.pixels[self.getIndex(x: x, y: y)]
        }

        func getNumPixels(matching color: Color) -> Int {
            return self.pixels.filter({$0 == color}).count
        }

        func asText() -> String {
            var finalText = "\n"
            for y in 0..<self.height {
                for x in 0..<self.width {
                    if let outputString = self.getPixel(x: x, y: y).outputString {
                        finalText.append(outputString)
                    }                }
                finalText.append("\n")
            }
            return finalText
        }
    }

    var width: Int
    var height: Int
    var layers: [Layer]

    convenience init(width: Int, height: Int, data: [Int]) {
        self.init(width: width, height: height, pixels: data.map({Color(rawValue: $0)!}))
    }

    init(width: Int, height: Int, pixels: [Color]) {
        let pixelsPerLayer = width * height
        let numLayers = pixels.count / pixelsPerLayer
        var pixelsToUse = pixels
        var layers = [Layer]()
        for _ in 0..<numLayers {
            let layerData = Array(pixelsToUse.prefix(pixelsPerLayer))
            pixelsToUse = Array(pixelsToUse.dropFirst(pixelsPerLayer))
            layers.append(Layer(width: width, height: height, pixels: layerData))
        }

        self.width = width
        self.height = height
        self.layers = layers
    }

    func getLayerIndexWithFewestMatching(color: Color) -> Int {
        var fewestSoFar = self.width * self.height
        var bestIndex = -1
        for (index, layer) in self.layers.enumerated() {
            let matchingInLayer = layer.getNumPixels(matching: color)
            if matchingInLayer < fewestSoFar {
                fewestSoFar = matchingInLayer
                bestIndex = index
            }
        }
        return bestIndex
    }

    func getNumMatchingPixelsInLayer(layerIndex: Int, color: Color) -> Int {
        return self.layers[layerIndex].getNumPixels(matching: color)
    }

    lazy var rasterized: Layer = {
        var rasterizedData = [Color]()
        for y in 0..<self.height {
            for x in 0..<self.width {
                rasterizedData.append(self.findPixel(x: x, y: y)!)
            }
        }
        return Layer(width: self.width, height: self.height, pixels: rasterizedData)
    }()

    private func findPixel(x: Int, y: Int) -> Color? {
        for layer in self.layers {
            let color = layer.getPixel(x: x, y: y)
            switch color {
            case .transparent:
                break
            default:
                return color
            }
        }

        return nil
    }
}
