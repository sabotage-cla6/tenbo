const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// クライアント(Android)から呼ばれるアクション処理 API
exports.processPlayerAction = functions.https.onCall(async (data, context) => {
  const { gameId, actionPlayerId, actionType, targetPlayerIds } = data;

  // 1. ゲームロジックの計算・判定処理
  // (例: ダメージ計算、ターン変更など)
  const resultData = {
    actionType: actionType,
    fromPlayer: actionPlayerId,
    payload: { /* 変更内容の詳細データ */ },
    timestamp: Date.now().toString()
  };

  // 2. 変更結果を反映させたい「関係するプレイヤー(targetPlayerIds)」の FCMトークン をDBから取得
  const tokens = [];
  for (const playerId of targetPlayerIds) {
    const userDoc = await admin.firestore().collection("users").doc(playerId).get();
    if (userDoc.exists && userDoc.data().fcmToken) {
      tokens.push(userDoc.data().fcmToken);
    }
  }

  if (tokens.length === 0) return { success: true };

  // 3. 関係するプレイヤーのみに「画面更新用のデータ」を Push 送信 (Silent Notification)
  const message = {
    data: {
      type: "GAME_STATE_UPDATE", // メッセージ種別
      gameData: JSON.stringify(resultData) // 変更内容
    },
    tokens: tokens // 関係するプレイヤーのトークン一覧
  };

  // 一括送信
  const response = await admin.messaging().sendMulticast(message);
  return { success: true, failureCount: response.failureCount };
});