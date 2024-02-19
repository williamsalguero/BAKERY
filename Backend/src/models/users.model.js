const { db } = require("../database/config");

const userModel = {
  read: () => {
    return new Promise((resolve, reject) => {
      db.query("SELECT * FROM users", (error, results) => {
        if (error) {
          reject(error);
        } else {
          resolve(results);
        }
      });
    });
  },
};

module.exports = userModel;
