# Legit - AI-Powered News Verification App

A Flutter application that uses Google's Gemini AI to verify the authenticity of news articles.

## Features

✨ **URL Analysis** - Paste any news article URL to fetch and analyze its content  
📝 **Headline Check** - Enter a news headline or claim to verify its authenticity  
🤖 **AI-Powered** - Uses Gemini 2.5 Flash Lite to analyze credibility signals  
🎨 **shadcn-like UI** - Clean, modern interface with pastel color scheme  
💬 **Detailed Analysis** - Get comprehensive reasoning and key points for each verification  

## Setup Instructions

### 1. Get a Gemini API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key

### 2. Configure the API Key

You have two options to set your API key:

#### Option A: Using .env file (Recommended for development)

Edit the `.env` file in the project root:

```bash
GEMINI_API_KEY=your_actual_api_key_here
```

Then run the app normally:

```bash
flutter run
```

#### Option B: Using command-line argument

Run the app with the API key as a dart-define:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_actual_api_key_here
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## Usage

1. **Launch the app** - You'll see the home screen with a text input field
2. **Enter news to verify**:
   - Paste a URL: `https://example.com/news-article`
   - Or type a headline: `"Breaking: Major event happens"`
3. **Tap "Verify News"** - The app will analyze the content
4. **View results**:
   - An alert dialog shows the initial verdict
   - Full analysis appears below with detailed reasoning
   - See key points that influenced the decision

## How It Works

1. **Input Detection** - The app detects whether you've entered a URL or text
2. **Content Fetching** (if URL) - Scrapes and parses the article content
3. **AI Analysis** - Sends the content to Gemini AI for verification
4. **Result Display** - Shows:
   - Status: Genuine, Fake, or Uncertain
   - Confidence score (0-100%)
   - Summary of the verdict
   - Detailed reasoning
   - Key points that influenced the decision

## Color Scheme

The app uses a pastel color palette:
- 🟢 **Pastel Green** - Genuine news
- 🔴 **Pastel Red** - Fake news  
- 🟡 **Pastel Yellow** - Uncertain
- 🟣 **Pastel Purple/Blue** - UI accents

## Technologies Used

- **Flutter** - Cross-platform mobile framework
- **Gemini AI** - Google's Generative AI model (gemini-2.5-flash-lite)
- **HTTP** - Web content fetching
- **HTML Parser** - Article content extraction

## Notes

- The AI analysis is not 100% accurate and should be used as a guideline
- Always verify important information from multiple trusted sources
- The app requires an active internet connection
- Some websites may block scraping attempts

## Support

For issues or questions, refer to:
- [Google AI Documentation](https://ai.google.dev/docs)
- [Flutter Documentation](https://flutter.dev/docs)
