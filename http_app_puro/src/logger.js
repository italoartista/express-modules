const fs = require('fs');
const os = require('os');
const path = require('path');

const logFilePath = path.join(os.homedir(), 'http_requests.log');

function logRequest(req) {
  const logEntry = `${new Date().toISOString()} - ${req.method} ${req.url}\n`;
  fs.appendFile(logFilePath, logEntry, (err) => {
    if (err) {
      console.error('Failed to log request:', err);
    }
  });
}

module.exports = { logRequest };
