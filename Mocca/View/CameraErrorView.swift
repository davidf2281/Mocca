//
//  CameraErrorView.swift
//  Mocca
//
//  Created by David Fearon on 28/09/2020.
//

import SwiftUI

struct CameraErrorView: View {
    
    let text = "Oh, hey!\n\nLooks like something went wrong\nand your camera failed to start. Sorry.\n\nTry restarting the app."
        
    var body: some View {

        Text(text)
            .font(.system(size: 17))
            .fontWeight(.semibold)
            .lineSpacing(7)
            .foregroundColor(Color(.sRGB, red: 0.3, green: 0.3, blue: 0.3, opacity: 1)).multilineTextAlignment(.center)
            .frame(maxWidth:275, maxHeight: .infinity)
            .offset(x: 0, y: -75)
    }
}

struct CameraErrorView_Previews: PreviewProvider {
    static var previews: some View {
        CameraErrorView()
    }
}
