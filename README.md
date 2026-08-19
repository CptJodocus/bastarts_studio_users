# BastArts Studio - Student Registration Web App

A streamlined, responsive web portal for dance class discovery and registration. This application serves as the primary gateway for students to join classes at BastArts Studio.

## 🔥 Core Functionality
* **Live Class Schedule:** Synchronizes with Firestore to provide real-time availability and class details.
* **Streamlined Registration:** A validated, user-friendly form designed to convert visitors into students with minimal friction.
* **Automated Confirmation:** Triggers professional confirmation emails via Firebase Extensions immediately upon successful registration.
* **Marketing Integration:** Connects to **EmailOctopus** via Firebase Cloud Functions for automated mailing list management.
* **Responsive Design:** Optimized for a seamless experience across mobile, tablet, and desktop devices.

## 🛠 Technical Implementation
* **State Management:** `Riverpod` for clean, reactive UI updates.
* **Backend:** Firebase ecosystem (Hosting, Firestore, Cloud Functions).
* **UI/UX:** Built with Flutter Web, focusing on high-performance rendering across all modern browsers.

## 🔒 Security & Architecture
This project implements professional security patterns:
* **API Key Protection:** Sensitive credentials for EmailOctopus are stored in Firebase Environment Variables and accessed via Cloud Functions, ensuring no secrets are exposed to the frontend.
* **Data Integrity:** Implements server-side validation logic to ensure registration data remains consistent and accurate.

## 📈 Impact
* **Production Ready:** Actively powering the registration flow for a local dance studio.
* **Reliability:** Successfully processed **150+ registrations** to date with zero data loss.
* **Performance:** Dramatically simplified the registration process compared to the previous manual/email-based system.

## 🖼️ Screenshots

### Desktop
<img width="600" alt="Desktop Home" src="https://github.com/user-attachments/assets/9bce3dc8-e840-4d4a-931a-ed3b4ec0c5c3" />
<img width="600" alt="Desktop Registration" src="https://github.com/user-attachments/assets/5bfdc980-7225-47fc-afc6-ec3f05fba930" />


### Mobile
<img width="300"  alt="Mobile Home" src="https://github.com/user-attachments/assets/3f19a180-f801-4738-b59d-08c62ba2a9f0" />
<img width="300" alt="Mobile Registration" src="https://github.com/user-attachments/assets/5b382ce7-2ec6-4343-8404-7ac79011181e" />


## 📂 Companion Project
This user-facing app is managed via the **Admin Management Console**:  
[View Admin Console Repository](https://github.com/CptJodocus/bastarts_studio)
