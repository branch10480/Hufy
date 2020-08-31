const admin = require('firebase-admin');
const { firestore } = require('firebase-admin');
const myRegion = "asia-northeast1";
admin.initializeApp();
const functions = require('firebase-functions').region(myRegion);
const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

// // Add Message
// exports.addMessage = functions.https.onRequest(async (req, res) => {
//     const original = req.query.text;
//     const writeResult = await admin.firestore().collection('messages').add({
//         original: original
//     });
//     res.json({result: `Message with ID: ${writeResult.id} added.`});
// });

// // Make Uppercase
// exports.makeUppercase = functions.firestore.document('/messages/{documentId}').onCreate((snap, context) => {
//     const original = snap.data().original;

//     functions.logger.log('Uppercasing', context.params.documentId, original);

//     const uppercase = original.toUpperCase();
//     return snap.ref.set({uppercase}, {merge: true});
// });

// // Create User (For Debug)
// exports.addUser = functions.https.onRequest(async (req, res) => {
//     const writeResult = await admin.firestore()
//         .collection('users')
//         .add({
//             name: 'for debug',
//             iconURL: 'https://cdn.profile-image.st-hatena.com/users/branch10480/profile.png?1597508290'
//         });
//     res.json({result: `User ID: ${writeResult.id} added.`});
// });

// Create Todo Group
exports.createTodoGroup = functions.firestore
    .document('users/{userId}')
    .onCreate((snap, context) => {
        // Todoドキュメントを作成する
        const userId = snap.id;
        const todoGroupRef = db.collection('todoGroups').doc();
        const res = todoGroupRef.set({
            name: "チュートリアル",
            craetedAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        });
        console.log('documentID is', userId);
        // Todoドキュメントに所属ユーザーを登録する
        const res2 = todoGroupRef
            .collection('groupUsers')
            .doc(userId)
            .set({
                id: userId
            }, {merge: true});

        // Userドキュメントに所属グループを登録する
        return snap.ref.update({belongingGroupId: todoGroupRef.id})
    });