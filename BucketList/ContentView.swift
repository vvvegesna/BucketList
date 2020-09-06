//
//  ContentView.swift
//  BucketList
//
//  Created by Vegesna, Vijay V EX1 on 8/30/20.
//  Copyright © 2020 Vegesna, Vijay V. All rights reserved.
//
import LocalAuthentication
import SwiftUI
import MapKit

struct ContentView: View {
    @State var centerCoordinate = CLLocationCoordinate2D()
    @State var locations = [CodableMKPointAnnotation]()
    @State var selectedPlace: MKPointAnnotation?
    @State var showingDetails = false
    @State var showingEditSheet = false
    @State var unLocked = false
    
    var body: some View {
        ZStack {
            if unLocked {
                MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingDetails: $showingDetails, annotations: locations)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear(perform: loadData)
                Circle()
                    .fill(Color.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                AddButton(centerCoordinate: centerCoordinate,
                          locations: $locations,
                          selectedPlace: $selectedPlace,
                          showingEditSheet: $showingEditSheet)
            } else {
                Button("Autenticate") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .alert(isPresented: $showingDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown place"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("Ok")), secondaryButton: .default(Text("Edit"), action: {
                self.showingEditSheet = true
            }))
        }
        .sheet(isPresented: $showingEditSheet, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placeMark: self.selectedPlace!)
            }
        }
    }
    
    struct AddButton: View {
        
        var centerCoordinate: CLLocationCoordinate2D
        @Binding var locations: [CodableMKPointAnnotation]
        @Binding var selectedPlace: MKPointAnnotation?
        @Binding var showingEditSheet: Bool
        
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let location = CodableMKPointAnnotation()
                        location.title = "Example location"
                        location.coordinate = self.centerCoordinate
                        self.locations.append(location)
                        self.selectedPlace = location
                        self.showingEditSheet = true
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func loadData() {
        let fileName = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        do {
            let data = try Data(contentsOf: fileName)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data")
        }
    }
    
    func saveData() {
        let fileName = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please aunthenticate yourself to unloack your favorit places"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                DispatchQueue.main.async {
                    if success {
                        self.unLocked = true
                    } else {
                        //
                    }
                }
            }
        } else {
            // No Biometrics
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
