const { Router } = require("express");
const userController = require("../controllers/users.controller");

const router = Router();

router.get("/read-users", userController.read);

module.exports = router;
