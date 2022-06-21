//
//  SnapCarousel.swift
//  FilmsCarousel
//
//  Created by Eduardo Martin Lorenzo on 21/6/22.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    
    @Binding var index: Int
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let width = (proxy.size.width - (trailingSpace - spacing))
            // Sirve para hacer el calculo necesario para que los elementos del carousel, a partir del segundo elemento (incluido), se queden centrados en la pantalla
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                    // Eliminar el offset si no se quiere el efecto de que se suba hacia arriba el elemento central
                        .offset(y: getOffset(item: item, width: width))
                }
            }
            .padding(.horizontal, spacing)
            // Si no se hace la comprobacion del adjustMentWidth se queda demasiado hueco blanco a la izquierda del primer elemento
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        // Con estos calculos se consigue que se haga autoscroll al siguiente elemento si se ha hecho el suficiente scroll, para que nunca se quede entre dos elementos
                        let offsetX = value.translation.width
                        
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        
                        // Permite controlar que no se pueda hacer mas scroll mas alla del ultimo elemento, o antes del primer elemento
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                    })
                    .onChanged({ value in
                        // Con estos calculos se consigue que se haga autoscroll al siguiente elemento si se ha hecho el suficiente scroll, para que nunca se quede entre dos elementos
                        let offsetX = value.translation.width
                        
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        
                        // Permite controlar que no se pueda hacer mas scroll mas alla del ultimo elemento, o antes del primer elemento
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
    
    // Con las siguientes dos funciones se consigue que el elemento que estamos viendo del carousel este mas arriba que los de los laterales
    func getOffset(item: T, width: CGFloat) -> CGFloat {
        let progress = ((offset < 0 ? offset : -offset) / width) * 60
        
        let topOffset = -progress < 60 ? progress : -(progress + 120)
        
        let previous = getIndex(item: item) - 1 == currentIndex ? (offset < 0 ? topOffset : -topOffset) : 0
        
        let next = getIndex(item: item) + 1 == currentIndex ? (offset < 0 ? -topOffset : topOffset) : 0
        
        let checkBetween = currentIndex >= 0 && currentIndex < list.count ? (getIndex(item: item) - 1 == currentIndex ? previous : next) : 0
        
        return getIndex(item: item) == currentIndex ? -60-topOffset : checkBetween
    }
    
    func getIndex(item: T) -> Int {
        let index = list.firstIndex { currentItem in
            return currentItem.id == item.id
        } ?? 0
        
        return index
    }
}

