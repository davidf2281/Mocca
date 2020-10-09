//
//  PreviewWrapper.swift
//  Mocca
//
//  Created by David Fearon on 03/10/2020.
//

import Foundation
import SwiftUI

// StatefulPreviewWrapper from https://developer.apple.com/forums/thread/118589
public struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    
    public var body: some View {
        content($value)
    }
    
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
