//
//  ContentView.swift
//  ParallaxHeader
//
//  Created by Matthias Zarzecki on 17.05.23.
//

import SwiftUI

struct ContentView: View {
  private enum CoordinateSpaces {
    case scrollView
  }

  var body: some View {
    ScrollView {
      ParallaxHeader(
        coordinateSpace: CoordinateSpaces.scrollView,
        defaultHeight: 200
      ) {
        ZStack {
          Image("flowers")
            .resizable()
            .scaledToFill()
          Text("This cool Header")
        }
      }
      Rectangle()
        .fill(.blue)
        .frame(height: 1000)
        .shadow(color: .black.opacity(0.8), radius: 10, y: -10)
        .offset(y: -10)
    }
    .coordinateSpace(name: CoordinateSpaces.scrollView)
    .edgesIgnoringSafeArea(.top)
  }
}

struct ParallaxHeader<Content: View, Space: Hashable>: View {
  let content: () -> Content
  let coordinateSpace: Space
  let defaultHeight: CGFloat

  init(
    coordinateSpace: Space,
    defaultHeight: CGFloat,
    @ViewBuilder _ content: @escaping () -> Content
  ) {
    self.content = content
    self.coordinateSpace = coordinateSpace
    self.defaultHeight = defaultHeight
  }

  var body: some View {
    GeometryReader { proxy in
      let offset = offset(for: proxy)
      let heightModifier = heightModifier(for: proxy)
      let blurRadius = min(
        heightModifier / 20,
        max(10, heightModifier / 20)
      )
      content()
        .edgesIgnoringSafeArea(.horizontal)
        .frame(
          width: proxy.size.width,
          height: proxy.size.height + heightModifier
        )
        .offset(y: offset)
        .blur(radius: blurRadius)
    }
    .frame(height: defaultHeight)
  }

  private func offset(for proxy: GeometryProxy) -> CGFloat {
    let frame = proxy.frame(in: .named(coordinateSpace))
    if frame.minY < 0 {
      return -frame.minY * 0.8
    }
    return -frame.minY
  }

  private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
    let frame = proxy.frame(in: .named(coordinateSpace))
    return max(0, frame.minY)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
