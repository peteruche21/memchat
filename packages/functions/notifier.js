export async function handle(state, action) {
  const input = action.input;

  const _cloud_fcm_endpoint = state.google_cloud_fcm_endpoint;
  const _cloud_messaging_token = state.firebase_cloud_messaging_token;

  if (input.function === "notify") {
    const { recipient, message } = input;

    ContractAssert(recipient && message, "missing required arguments");

    await _sendNotification(recipient, message);

    return { state };
  }

  // todo: access controlled update of the firebase_cloud_messaging_token
  // todo: #2 encrypt the firebase_cloud_messaging_token before storage
  // todo: #3 decrypt the firebase_cloud_messaging_token before notification

  async function _sendNotification(recipient, message) {
    const body = {
      notification: {
        title: message.sender,
        body: message.src,
      },
      token: recipient,
    };

    if (message.type === "image") {
      body.android = {
        notification: {
          imageUrl: message.src,
        },
      };
      body.apns = {
        payload: {
          aps: {
            "mutable-content": 1,
          },
        },
        fcm_options: {
          image: message.src,
        },
      };
    }

    await EXM.deterministicFetch(_cloud_fcm_endpoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${_cloud_messaging_token}`,
      },
      body: JSON.stringify(body),
    });
  }
}
