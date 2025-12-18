import { ObjectId } from "mongodb";
import "dotenv/config";
import connectToDatabase from "../config/db_config.js";

const conection = await connectToDatabase(process.env.STRING_CONEXAO);

export async function getAllDeliveries(deliveryMan = null) {
  const db = conection.db("delivery-hub");
  const dbCollection = db.collection("deliveries");

  if (deliveryMan) {
    return dbCollection.find({ deliveryMan }).toArray();
  }

  return dbCollection.find().toArray();
}

export async function createDelivery(newDelivery) {
    const db = conection.db("delivery-hub");
    const dbCollection = db.collection("deliveries");

    const deliveryWithTimestamps = {
        ...newDelivery,
        createdAt: new Date(),
        updatedAt: new Date()
    };

    return dbCollection.insertOne(deliveryWithTimestamps);
}
export async function updateDelivery(id, newDelivery) {
    const db = conection.db("delivery-hub");
    const dbCollection = db.collection("deliveries");
    const objID = ObjectId.createFromHexString(id);

    const deliveryWithTimestamp = {
        ...newDelivery,
        updatedAt: new Date()
    };

    return dbCollection.updateOne({_id: new ObjectId(objID)}, {$set: deliveryWithTimestamp});
}

export async function deleteDelivery(id) {
    const db = conection.db("delivery-hub");
    const dbCollection = db.collection("deliveries");
    const objID = ObjectId.createFromHexString(id);
    return dbCollection.deleteOne({_id: new ObjectId(objID)});
}

export async function deleteAllDeliveriesByDeliveryMan(deliveryMan) {
    const db = conection.db("delivery-hub");
    const dbCollection = db.collection("deliveries");
    return dbCollection.deleteMany({ deliveryMan });
}
