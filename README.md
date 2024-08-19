# Project Setup Guide

## Setting Up the Environment

### 1. Register for API Keys:
   - **UPSTAGE API Key:** Register and obtain your API key from the [Upstage website](https://www.upstage.com).
   - **Google API Key:** Register and obtain your API key from the [Google Cloud Console](https://console.cloud.google.com).

### 2. Create an Environment File:
   - In the root folder of your project, create a file named `.env`.
   - Open the `.env` file and paste your API keys as follows:

   ```env
   UPSTAGE_API_KEY=your-upstage-api-key
   GOOGLE_API_KEY=your-google-api-key
   ```

### 3. Run the Project:
   - To launch your Flutter application, use the following command:

   ```bash
   flutter run
   ```

 ### 4. Clone the Backend Server
   - [Jejom Backend](https://github.com/PIEthonista/Jejom)
   - Follow the instruction in the backend to set up the server

 ### 5. Clone the Murder Mystery Game Script Generator Model
   - This model is trained solely for generating the game script that is presented in the app.
   - Go to [Jejom Backend](https://github.com/PIEthonista/Jejom) and switch to *jubensha8 branch.
   - Follow the instruction to set up the server


## Upstage API Utilization
Our application leverages several APIs provided by Upstage to enhance user experience across different modules. Below is a detailed breakdown of how each API is utilized:

### 1. Chat API
- **Purpose:** Central to the menu chat and allergen detector functionalities within the food module.
- **Model Used:** `solar-1-mini-chat`
- **Functionality:**
  - **Menu Chat:** Facilitates user interaction with menu items, providing recommendations and detecting potential allergens based on user preferences.
  - **Allergen Detector:** Analyzes menu items to identify ingredients that may trigger allergies, ensuring a safer dining experience for users.
  - **Explore Module:** This model is also used to filter tourist destinations based on the user's interests, ensuring personalized and relevant recommendations.

### 2. Document OCR API
- **Purpose:** Converts Korean menu images into text, enabling subsequent translation and allergen detection, which enhances accessibility and interaction with foreign language content.
- **Model Used:** `ocr-2.2.1`
- **Functionality:**
  - **Food Module:** Extracts text from Korean menu images, allowing the application to process and translate the content into English. This step is crucial for users who may not understand Korean, ensuring they can navigate menus with ease.

### 3. Translation API
- **Purpose:** Translates Korean text into English, ensuring that users can understand menus and other relevant content.
- **Model Used:** `solar-1-mini-translate-koen`
- **Functionality:**
  - **Menu Chat:** Within the food module, this API translates the extracted Korean text from menus into English. This translation allows users to understand menu items and make informed decisions about their dining options.