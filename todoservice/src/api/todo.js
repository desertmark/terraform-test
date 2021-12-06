// Express
const { Router } = require("express");
const todoRouter = Router();
// Cosmos
const { CosmosClient } = require("@azure/cosmos");

const config = {
  endpoint: "https://cosmos-westeuorpe-dev-todo-001.documents.azure.com:443/",
  key: "sBx2sgjraEF0iRrGot8BFugPuZWwAhy0IAWLDcofBa2ByFSDvQYJAT5mgVHOd8GMLWO61pHa8pC2feySvoveqg==",
  databaseId: "tododb",
  containerId: "todo",
  partitionKey: { kind: "Hash", paths: ["/pk"] },
};

todoRouter.get("/", async (req, res) => {
  try {
    const client = new CosmosClient({
      endpoint: config.endpoint,
      key: config.key,
    });
    const tododb = client.database(config.databaseId);
    const todoContainer = tododb.container(config.containerId);
  
    // query to return all items
    const querySpec = {
      query: "SELECT * from c",
    };
  
    // read all items in the Items container
    const { resources: items } = await todoContainer.items
      .query(querySpec)
      .fetchAll();
    res.send(items);
  } catch(error) {
    console.error('Failed to get todo list:', error);
  }
});

module.exports = {
  todoRouter,
};
