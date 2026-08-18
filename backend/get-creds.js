const { MongoClient } = require('mongodb');
async function run() {
  const client = new MongoClient('mongodb+srv://admin:admin@orivox-dev.6uukd.mongodb.net/test?retryWrites=true&w=majority');
  await client.connect();
  const db = client.db('test');
  const user = await db.collection('users').find().sort({createdAt:-1}).limit(1).toArray();
  console.log('User:', user[0].email);
  const proj = await db.collection('projects').find({organizationId: user[0].organizationId}).sort({createdAt:-1}).limit(1).toArray();
  console.log('Project:', proj[0]._id.toString());
  await client.close();
}
run();
