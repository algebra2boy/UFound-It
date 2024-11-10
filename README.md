# Project Report

## Inspiration of UFound-It

The current lost and found system has several weaknesses that make it inconvenient and unreliable for students who need to retrieve lost items. Firstly, most items are stored in drawers, making them invisible to students who might not even realize their belongings have been turned in. This lack of visibility often results in items going unclaimed and accumulating over time. Secondly, the requirement to file reports and scan QR codes creates a time-consuming process, which is particularly inconvenient for retrieving emergency items such as wallets, car keys, or phones that may be needed immediately. Thirdly, in areas with minimal supervision, like the table near the entrance of Frank Dining Commons, there’s an increased risk of theft, as items are left unattended and vulnerable. Lastly, many campus buildings lack a designated lost and found system, making it challenging for students to know where to look for lost items in the first place. Together, these factors show that the current system fails to provide an efficient, accessible, and secure solution for managing lost belongings on campus.

## What It Does

UFound-It combines a mobile app with storage boxes to help students recover lost items. 

### For Students Who Found an Item

- **Report and catalog the found item** by uploading pictures and descriptions to help the rightful owner locate it.
- **Locate nearby lost and found locations** on campus.
- **Place the item in a secure lost and found box** and lock it through the app to ensure safe storage until claimed.

### For Students Who Lost an Item

- **Search the catalog of found items** and receive notifications when items matching their description are added.
- **Claim the lost item securely** by verifying identity through UMass credentials, ensuring accountability.
- **Retrieve the item from a secure box**, with traceability of who accessed it through app verification.

## How We Built It

The UFound-It system integrates software and hardware components to achieve a seamless user experience. We utilized:

- **Frontend**: Developed a mobile app using Swift and SwiftUI to provide an intuitive interface for students on iOS devices.
- **Backend**: Built an Express.js REST API that connects the mobile app with our MongoDB database and controls secure box functionality.
- **Database**: MongoDB stores user profiles, item details, and lost and found location data.
- **Image Storage**: We use **AWS S3** to store images of lost items securely, allowing efficient storage and retrieval.
- **Email Verification**: **Nodemailer** handles sending email verification, ensuring only UMass students with valid credentials can register.
- **Storage Box Control**: An additional server manages the locking/unlocking mechanism for the ESP32-powered lock on the secure storage boxes, integrating with the mobile app for real-time access control.

## Challenges We Ran Into

- **Database Consistency and Security**: Ensuring that only verified users can access the system required implementing secure authentication and data consistency checks across multiple endpoints.
- **Hardware Synchronization**: Integrating secure storage boxes controlled by an ESP32-powered lock required establishing reliable communication between the app and hardware, as well as managing the timing of lock and unlock commands.
- **AWS S3 Integration**: Storing item images on AWS S3 was a challenge, particularly processing the input image file properly.
- **Domain Name Service**: We ran into issues accessing the [https://ufound.tech](https://ufound.tech) domain due to slow DNS propagation speed, and had to switch all machine to use Google DNS before the record is fully populated on more DNS servers.
- **Ensuring Accountability**: To protect against unauthorized claims, we have to design a traceable, secure claiming and pickup system which required careful handling of user data and verification codes.

## Accomplishments That We’re Proud Of

- **Seamless Hardware and Software Integration**: Our system successfully combines physical security with digital controls, creating a smooth, user-friendly experience for item retrieval.
- **Enhanced Security and Verification**: By using email verification and secure storage, we provide a trustworthy lost and found solution that reduces the risk of unauthorized access.
- **Community-Centric Design**: UFound-It fosters a sense of community on campus, making it easier for students to help one another retrieve lost items.

## What We Learned

- **Full-Stack Development**: By integrating mobile app development, backend APIs, and database management, we enhanced our skills in creating end-to-end solutions.
- **Rapid Hardware Prototyping**: We efficiently designed and iterated multiple versions of the locking mechanism using CAD software and 3D printing technology, complemented by hands-on prototyping with traditional materials like cardboard and glue.
- **Hardware and Software Synchronization**: Connecting the ESP32-powered locking mechanism with the backend server through WebSocket has taught us how to coordinate hardware with software effectively for real-time functionality.
- **User-Centric Design**: We learned how to design features that address actual user pain points, focusing on simplicity, security, and accountability.

## What's Next for UFound-It

- **Enhanced Notification System**: Adding real-time pushed notification for lost item owners when an item is added that might match a user’s search history or specific preferences.
- **Web-Based Version**: Developing a web-based interface for broader access, allowing users without iOS devices to use the service.
- **Add JWT Authentication**: To further secure user access, we aim to implement JSON Web Tokens (JWT) for session management, enabling safer and more streamlined authentication.
- **Frontend UI/UX Enhancements**: Implementing error message instructions and loading animations so that the app has an more responsive user experience, making interactions feel more fluid and informative.

## Built With

- **Frontend**: Swift, SwiftUI for iOS development.
- **Backend**: Express.js and Node.js for API management, WebSocket for ESP32 connection.
- **Database**: MongoDB for storing user, item, and transaction data.
- **Image Storage**: AWS S3 for efficient and scalable image management.
- **Email Verification**: Nodemailer for sending verification codes to UMass emails.
- **Hardware**: An ESP32 and a standard 9g servo motor for the locking mechanism, and a box made of recycled poster board.
- **Deployment**: Backend hosted on AWS EC2, accessed via the ufound.tech domain with a secure TLS connection.
