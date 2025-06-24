const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
require("dotenv").config();

const sendEmail = require("./utils/sendEmail");

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json());

function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

// Email-only OTP route (works for both login/signup)
app.post("/send-email-otp", async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ error: "Email is required." });
  }

  const otp = generateOTP();

  try {
    await sendEmail(email, otp);
    res.status(200).json({ message: "OTP sent successfully", emailOtp: otp });
  } catch (error) {
    console.error("Email OTP Error:", error);
    res.status(500).json({ error: "Failed to send email OTP" });
  }
});

app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});
