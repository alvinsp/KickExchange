const { where } = require('sequelize');
const db = require('../models/index');
const path = require('path');
const fs = require('fs');

const getProfile = async (req, res) => {
    try {
        console.log(`Fetching profile for user ID: ${req.id}`);
        const user = await db.Users.findByPk(req.id, {
            attributes: ['id', 'username', 'email', 'image'],
        });

        if (!user) {
            console.log('User not found');
            return res.status(404).json({ error: 'User not found' });
        }

        res.json(user);
    } catch (err) {
        console.error('Failed to fetch profile', err);
        res.status(500).json({ error: 'Failed to fetch profile' });
    }
};

const uploadImage = async (req, res) => {
    try {
        const user = await db.Users.findByPk(req.id);
        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        const image = req.file;
        const imagePath = image ? image.filename : null;

        if (!imagePath) {
            return res.status(400).json({ error: "No image uploaded" });
        }

        const oldImagePath = user.image;
        if (oldImagePath) {
            const oldImageFullPath = path.join(__dirname, `../uploads/${oldImagePath}`);
            if (fs.existsSync(oldImageFullPath)) {
                fs.unlinkSync(oldImageFullPath);
            }
        }

        user.image = imagePath;
        await user.save();

        res.status(200).json({
            message: "Image uploaded successfully",
            data: user
        });
    } catch (err) {
        console.error('Failed to upload image:', err);
        res.status(500).json({ error: "Failed to upload image" });
    }
};

module.exports = { getProfile, uploadImage };
