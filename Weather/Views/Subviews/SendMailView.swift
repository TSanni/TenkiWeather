//
//  SwiftUIView2.swift
//  Weather
//
//  Created by Tomas Sanni on 5/15/22.
//

import SwiftUI
import SwiftUIMailView


struct SendMailView: View {
    
    @State private var mailData = ComposeMailData(subject: "Feedback from iOS",
                                                  recipients: ["tenkiweather7@gmail.com"],
                                                  message: "Ask a question or submit feedback.",
                                                  attachments: [])
    @State private var showMailView = false

     var body: some View {
         Button(action: {
             showMailView.toggle()
         }) {
             Label("Send feedback", systemImage: "message")

                 .foregroundColor(.primary)
         }
         .disabled(!MailView.canSendMail)
         .sheet(isPresented: $showMailView) {
             MailView(data: $mailData) { result in
                 
             }
         }
     }
}

struct SendMailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            SendMailView()
        }
            
    }
}
