const mongoose = require('mongoose');

async function run() {
  await mongoose.connect('mongodb+srv://sivapranay1423_db_user:BPOI7VtrKs5YUf1h@orivox-development.2lpvdfm.mongodb.net/test?retryWrites=true&w=majority');
  const db = mongoose.connection.db;

  console.log('Creating vector index...');
  try {
    const result = await db.collection('knowledgerecords').createSearchIndex({
      name: 'vector_index',
      type: 'vectorSearch',
      definition: {
        fields: [
          {
            type: 'vector',
            numDimensions: 1024,
            path: 'embedding',
            similarity: 'cosine'
          },
          {
            type: 'filter',
            path: 'organizationId'
          },
          {
            type: 'filter',
            path: 'projectId'
          }
        ]
      }
    });
    console.log('Search Index Created:', result);
  } catch (err) {
    console.error('Failed to create search index:', err);
  }

  await mongoose.disconnect();
}

run();
