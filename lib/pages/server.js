const express = require('express');
const bodyParser = require('body-parser');
const fetch = require('node-fetch'); // Install using: npm install node-fetch@2
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Parse JSON bodies.
app.use(bodyParser.json());

// Telegram Bot credentials (set these in your .env file)
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID;

// POST endpoint for contact form submissions.
app.post('/submit', async (req, res) => {
  const { name, email, phone, message } = req.body;
  console.log('New contact submission:', req.body);

  // Prepare message for Telegram.
  const telegramMessage = `
New Contact Submission:
Name: ${name}
Email: ${email}
Phone: ${phone}
Message: ${message}
  `;

  // Construct Telegram API URL.
  const telegramUrl = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;

  try {
    // Send notification to Telegram.
    const response = await fetch(telegramUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chat_id: TELEGRAM_CHAT_ID,
        text: telegramMessage,
      }),
    });

    const telegramResult = await response.json();
    console.log('Telegram response:', telegramResult);

    // You can add code here to store data in a database if needed.
    res.status(200).json({ message: 'Submission received.' });
  } catch (error) {
    console.error('Error sending Telegram message:', error);
    res.status(500).json({ error: 'Internal server error.' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
