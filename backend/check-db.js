const mongoose = require('mongoose');

async function check() {
  await mongoose.connect('mongodb+srv://sivapranay1423_db_user:BPOI7VtrKs5YUf1h@orivox-development.2lpvdfm.mongodb.net/');
  const db = mongoose.connection.db;
    const repos = await db.collection('repositories').find().toArray();
    console.log('\n--- Repositories ---');
    console.log(repos);

    const documents = await db.collection('documents').find().toArray();
    console.log('\n--- Documents (' + documents.length + ') ---');
    console.log(documents.slice(0, 2));

    const knowledgeRecords = await db.collection('knowledgerecords').find().toArray();
    console.log('\n--- Knowledge Records (' + knowledgeRecords.length + ') ---');
    if (knowledgeRecords.length > 0) {
      console.log('Sample Record:', JSON.stringify(knowledgeRecords[0], null, 2));
      console.log('Embedding vector length:', knowledgeRecords[0].embedding?.length);
    }
    
    const outboxEvents = await db.collection('outboxevents').find().toArray();
    console.log('\n--- Outbox Events ---');
    console.log(outboxEvents);
  await mongoose.disconnect();
}
check();
