//
//  EditView.swift
//  BucketList
//
//  Created by Vegesna, Vijay V EX1 on 9/2/20.
//  Copyright © 2020 Vegesna, Vijay V. All rights reserved.
//
import MapKit
import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placeMark: MKPointAnnotation
   
    @State private var state = LoadingState.loading
    @State private var pages = [Page]()
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $placeMark.wrappedTitle)
                    TextField("Description", text: $placeMark.wrappedSubtitle)
                }
                Section(header: Text("Nearby...")) {
                    if state == .loaded {
                        List(pages, id: \.pageid) { page in
                            Text(page.title).font(.headline)
                            + Text(":") +
                                Text(page.description)
                            .italic()
                        }
                    } else if state == .loading {
                        Text("Loading...")
                    } else {
                        Text("Please try again later.")
                    }
                }
            }
            .navigationBarTitle("Edit Place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: fetchNearbyPlaces) 
        }
    }
    
    func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placeMark.coordinate.latitude)%7C\(placeMark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("bad URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Result.self, from: data) {
                    self.pages = Array(items.query.pages.values).sorted()
                    self.state = .loaded
                    return
                }
            }
            self.state = .failed
        }.resume()
        
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placeMark: MKPointAnnotation.example)
    }
}
