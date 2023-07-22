# event_scanner

Scans QRs sent to event attendees and adds their details to google sheets

![WhatsApp Image 2023-07-23 at 00 47 19](https://github.com/AlexaSRM/Event-ScannerApp/assets/113231399/95e7ab61-b8a0-4bb4-8cdf-c2d97c54b05e)

the output sheet where the attendee details get added after their qr has been scanned successfully 

![WhatsApp Image 2023-07-23 at 00 47 06](https://github.com/AlexaSRM/Event-ScannerApp/assets/113231399/3b50e557-dd41-4561-8280-ef6eab02f593)

Success message displayed after checking if the decrypted data matches the attendee reg number and if the reg number doesnt already exist on the sheets

![WhatsApp Image 2023-07-23 at 00 46 48](https://github.com/AlexaSRM/Event-ScannerApp/assets/113231399/40a586cc-5777-450a-8288-fce8181fb0b8)

Error message displayed if the decrypted data matches the attendee reg number but the reg number already exists on the google sheet

![WhatsApp Image 2023-07-23 at 00 48 41](https://github.com/AlexaSRM/Event-ScannerApp/assets/113231399/fbf18304-a48f-4986-9267-46bc8bf42c65)

Error message displayed when the decrypted reg number doesnt match the attendees reg number 

This prevents people from creating their own qrs and entering events

![WhatsApp Image 2023-07-23 at 00 53 45](https://github.com/AlexaSRM/Event-ScannerApp/assets/113231399/22d2f254-a061-4bcf-a6a2-42cbfbb7daf3)

Error message displayed when an invalid qr code is scanned 

