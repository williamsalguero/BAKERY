const User = require("../models/users.model");

const userController = {
  read: async (req, res) => {
    try {
      const result = await User.read();
      res.status(200).json(result);
    } catch (error) {
      console.error("Error al obtener usuarios:", error);
      res.status(500).json({ error: "Error al obtener usuarios" });
    }
  },
};

module.exports = userController;
