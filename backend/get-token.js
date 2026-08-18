const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
async function run() {
  await mongoose.connect('mongodb+srv://sivapranay1423_db_user:BPOI7VtrKs5YUf1h@orivox-development.2lpvdfm.mongodb.net/test?retryWrites=true&w=majority');
  const db = mongoose.connection.db;
  const records = await db.collection('knowledgerecords').find().limit(1).toArray();
  const rec = records[0];
  const proj = await db.collection('projects').findOne({_id: new mongoose.Types.ObjectId(rec.projectId)});
  const org = await db.collection('organizations').findOne({_id: new mongoose.Types.ObjectId(proj.organizationId)});
  const user = await db.collection('users').findOne();
  const token = jwt.sign({userId: user._id, organizationId: org._id, sessionId: '123'}, 'development_secret');
  console.log('Token:', token);
  console.log('ProjectId:', proj._id.toString());
  await mongoose.disconnect();
}
run();
