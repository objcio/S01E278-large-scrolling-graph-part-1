//
//  ContentView.swift
//  ScrollingLargeGraph
//
//  Created by Chris Eidhof on 26.10.21.
//

import SwiftUI

func *(lhs: UnitPoint, rhs: CGSize) -> CGPoint {
    CGPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

struct Line: Shape {
    var from: UnitPoint
    var to: UnitPoint
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: rect.origin + from * rect.size)
            p.addLine(to: rect.origin + to * rect.size)
        }
    }
}

struct DayView: View {
    var day: Day
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { proxy in
                ZStack(alignment: .topLeading) {
                    let zipped = Array(zip(day.values, day.values.dropFirst()))
                    ForEach(zipped, id: \.0.id) { (value, next) in
                        Line(from: value.point(in: day), to: next.point(in: day))
                            .stroke(lineWidth: 1)
                    }
                    ForEach(day.values) { dataPoint in
                        let point = dataPoint.point(in: day)
                        Circle()
                            .frame(width: 5, height: 5)
                            .offset(x: -2.5, y: -2.5)
                            .offset(x: point.x * proxy.size.width, y: point.y * proxy.size.height)
                    }
                }
            }
            Text(day.startOfDay, style: .date)
        }
    }
}

struct ContentView: View {
    var model = Model.shared
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(model.days) { day in
                    DayView(day: day)
                        .frame(width: 300)
                        .border(Color.blue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
