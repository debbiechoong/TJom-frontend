# Project Setup Guide

## Setting Up the Environment

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