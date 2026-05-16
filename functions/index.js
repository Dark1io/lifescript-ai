const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.demoDailyChapter = functions.pubsub
  .schedule("every 24 hours")
  .onRun(async () => {
    const db = admin.firestore();
    const users = await db.collection("users").get();

    for (const user of users.docs) {
      await db.collection("users").doc(user.id).collection("chapters").add({
        text: "Today’s chapter: choose one small action that proves your future identity.",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });
