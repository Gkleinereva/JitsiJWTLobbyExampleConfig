const jwt = require("jsonwebtoken");
const { DateTime } = require("luxon");
require('dotenv').config();

exports.generateJitsiJwt = function(roomId, user) {
  const expiry = DateTime.now().plus({"days": 7});
  return jwt.sign({
    iss: "appName",
    aud: "appName",
    sub: "meet.example.com",
    room: roomId,
    exp: expiry.valueOf(),
    context: {
      user: {
        id: user._id,
        name: user.firstName + " " + user.lastName,
        email: user.email,
        affiliation: user.moderator === true ? "owner" : "member",
      }
    },

  // The value of the secret below should match the one in your Prosody configuration file
  }, process.env.JITSI_SECRET);
}