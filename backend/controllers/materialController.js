const Material = require('../models/Material');

const materialController = {
  uploadMaterial: async (req, res) => {
    try {
      const { title, type, subject, fileUrl, description } = req.body;

      const material = new Material({
        title,
        type,
        subject,
        fileUrl,
        description,
        uploadedBy: req.user.userId
      });
      await material.save();

      res.status(201).json({ message: 'Material uploaded', material });
    } catch (error) {
      res.status(500).json({ message: 'Failed to upload material', error: error.message });
    }
  },

  getMaterials: async (req, res) => {
    try {
      const { subject, type } = req.query;
      const query = {};
      if (subject) query.subject = subject;
      if (type) query.type = type;

      const materials = await Material.find(query)
        .populate('uploadedBy', 'name')
        .sort({ createdAt: -1 });
      res.json(materials);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get materials', error: error.message });
    }
  },

  getMaterialsBySubject: async (req, res) => {
    try {
      const { subject } = req.params;
      const materials = await Material.find({ subject })
        .populate('uploadedBy', 'name')
        .sort({ createdAt: -1 });
      res.json(materials);
    } catch (error) {
      res.status(500).json({ message: 'Failed to get materials', error: error.message });
    }
  }
};

module.exports = materialController;
