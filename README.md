# Jejom

![Local Image](./assets/jejomlogo.png)

## Project Introduction

JeJom is a AI-powered app that rejuvenates tourism in Jeju Island by turning ordinary cafes into immersive murder mystery game venues (剧本杀). It also acts as a travel co-pilot, providing personalized itineraries, cultural experiences, and essential travel support, aiming to attract domestic and foreign tourist.

## Project Setup Guide

1. **Register for API Keys:**
   - **UPSTAGE API Key:** Register and obtain your API key from the [Upstage website](https://www.upstage.com).
   - **Google API Key:** Register and obtain your API key from the [Google Cloud Console](https://console.cloud.google.com).

2. **Create an Environment File:**
   - In the root folder of your project, create a file named `.env`.
   - Open the `.env` file and paste your API keys as follows:

   ```env
   UPSTAGE_API_KEY=your-upstage-api-key
   GOOGLE_API_KEY=your-google-api-key

3. **Run the Project:**
   - To launch your Flutter application, use the following command:

   ```bash
   flutter run

 4. **Clone the Backend Server**
    - [Jejom Backend](https://github.com/PIEthonista/Jejom)
    - Follow the instruction in the backend to set up the server

 5. **Clone the Murder Mystery Game Script Generator Model**
    - This model is trained solely for generating the game script that is presented in the app.
    - Go to [Jejom Backend](https://github.com/PIEthonista/Jejom) and switch to *jubensha8 branch.
    - Follow the instruction to set up the server


## Project Setup Guide