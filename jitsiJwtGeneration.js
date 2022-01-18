const jwt = require("jsonwebtoken");
require('dotenv').config();

exports.generateJitsiJwt = function(roomId, user) {
  const expiry = DateTime.now().plus({"days": 7});
  return jwt.sign({
    iss: "appName",
    aud: "appName",
    sub: process.env.JITSI_URL,
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
  }, process.env.JITSI_SECRET);
}