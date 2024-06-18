const db = require('../models/index');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const registerUser = async (req, res) => {
    try {
        const { username, email, password } = req.body;
        const userExists = await db.Users.findOne({
            where: { email }
        });
        if (userExists) {
            return res.status(400).send('Username is already associated with an account');
        }


        await db.Users.create({
            username,
            email,
            password: await bcrypt.hash(password, 15),
        });
        return res.status(200).send('Registration successful');
    } catch (err) {
        return res.status(500).send('Error in registering user');
    }
}

const signInUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log(req.body);

        const user = await db.Users.findOne({ where: { email } });
        if (!user) {
            return res.status(401).json({ error: 'Incorrect Users or password' });
        }

        const passwordValid = await bcrypt.compare(password, user.password);
        if (!passwordValid) {
            return res.status(401).json({ error: 'Incorrect email or password' });
        }

        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET);

        res.status(200).json({
            id: user.id,
            email: user.email,
            accessToken: token,
        });
    } catch (err) {
        console.log(err)
    }
};

module.exports = { registerUser, signInUser }