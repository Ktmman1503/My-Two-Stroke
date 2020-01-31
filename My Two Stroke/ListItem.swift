//
//  ListItem.swift
//  My Two Stroke
//
//  Created by Craig  Karen Shine on 28/1/20.
//  Copyright © 2020 Craig  Karen Shine. All rights reserved.
//

import SwiftUI

struct ListItem: View {
  
  @Binding var value1 : String
  
  
  
    var body: some View {
      VStack {
        Text("\(value1)")
      }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
      ListItem(value1: .constant("test"))
    }
}
