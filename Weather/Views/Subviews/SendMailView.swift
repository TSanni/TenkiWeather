//
//  SwiftUIView2.swift
//  Weather
//
//  Created by Tomas Sanni on 5/15/22.
//

import SwiftUI
import MessageUI
//import SwiftUIMailView


struct SendMailView: View {
    
    @State private var isShowingMailView = false
    
     var body: some View {
         
         Button {
             self.isShowingMailView = true
         } label: {
             Label("Send feedback", systemImage: "message")
                 .foregroundColor(.primary)
         }
         .sheet(isPresented: $isShowingMailView) {
             MailComposerViewController(recipients: ["tenkiweather7@gmail.com"], subject: "Feedback from iOS", messageBody: "Ask a question or submit feedback:\n")
         }
     }
}

struct MailComposerViewController: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var recipients: [String]
    var subject: String
    var messageBody: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients(recipients)
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        return mailComposer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposerViewController

        init(_ parent: MailComposerViewController) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.dismiss()
        }
    }
}

#Preview {
    SendMailView()
}
