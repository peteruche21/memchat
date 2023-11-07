export async function handle(state, action) {
  const input = action.input;

  if (input.function === "register") {
    const { caller, message, signature } = input;
    const data = JSON.parse(input.data);
    await _register(caller, message, signature, data);
    return { state };
  }

  if (input.function === "updateProfile") {
    const { caller, message, signature } = input;
    const data = JSON.parse(input.data);
    await _update(caller, message, signature, data);
    return { state };
  }

  if (input.function === "deleteProfile") {
    const { caller, message, signature } = input;
    ContractAssert(caller && signature, "missing required arguments");
    ContractAssert(state.user_profiles[caller], "user registered");
    await _authenticate(caller, message, signature);
    delete state.user_profiles[caller];
    return { state };
  }

  if (input.function === "addStatusUpdate") {
    const { caller, type, src } = input;
    await _addStatusUpdate(caller, type, src);
    return { state };
  }

  if (input.function === "blockUser") {
    const { caller, uid } = input;
    await _blockUser(caller, uid);
    return { state };
  }

  if (input.function === "unblockUser") {
    const { caller, uid } = input;
    await _unblockUser(caller, uid);
    return { state };
  }

  if (input.function === "excludeStatusUpdate") {
    const { caller, uid } = input;
    await _excludeFromStatusUpdates(caller, uid);
    return { state };
  }

  if (input.function === "undoStatusUpdateExclude") {
    const { caller, uid } = input;
    await _undoStatusUpdateExclude(caller, uid);
    return { state };
  }

  if (input.function === "createGroup") {
    const { caller, gid, name } = input;
    await _createGroup(caller, gid, name);
    return { state };
  }

  if (input.function === "joinGroup") {
    const { caller, gid } = input;
    await _joinGroup(caller, gid);
    return { state };
  }

  if (input.function === "deleteGroup") {
    const { caller, gid } = input;
    await _deleteGroup(caller, gid);
    return { state };
  }

  if (input.function === "deleteGroupMember") {
    const { caller, gid, member } = input;
    await _deleteGroupMember(caller, gid, member);
    return { state };
  }

  if (input.function === "transferGroupOwnership") {
    const { caller, gid, newOwner } = input;
    await _transferGroupOwnership(caller, gid, newOwner);
    return { state };
  }

  if (input.function === "addFriend") {
    const { caller, friend } = input;
    await _addFriend(caller, friend);
    return { state };
  }

  if (input.function === "removeFriend") {
    const { caller, friend } = input;
    await _removeFriend(caller, friend);
    return { state };
  }

  if (input.function === "sendMessage") {
    const { caller, recipient, chatId } = input;
    const message = JSON.parse(input.message);
    if (recipient) {
      await _sendMessage(caller, recipient, chatId, message);
    } else {
      await _sendMessageToGroup(caller, chatId, message);
    }
    return { state };
  }

  if (input.function === "deleteMessage") {
    const { caller, chatId, mid } = input;
    await _deleteMessage(caller, chatId, mid);
    return { state };
  }

  if (input.function === "acceptChat") {
    const { caller, chatId } = input;
    await _acceptChat(caller, chatId);
    return { state };
  }

  if (input.function === "declineChat") {
    const { caller, chatId } = input;
    await _declineChat(caller, chatId);
    return { state };
  }

  if (input.function === "readChat") {
    const { caller, chatId } = input;
    await _readChat(caller, chatId);
    return { state };
  }

  if (input.function === "leaveChat") {
    const { caller, chatId } = input;
    await _leaveChat(caller, chatId);
    return { state };
  }

  /// register a new user
  async function _register(caller, message, signature, data) {
    ContractAssert(caller && signature, "missing required arguments");
    ContractAssert(!state.user_profiles[caller], "user registered");
    await _authenticate(caller, message, signature);
    state.user_profiles[caller] = {
      address: caller,
      alias: data?.alias || "",
      fcm_token: data?.fcmToken || "",
      registered_at: Date.now(),
      chats: [],
      friends: [],
      requests: [],
      blocked: [],
      status_exclude_list: [],
      settings: {
        status: 0,
        message_preferences: {
          accept_messages: true,
          read_reciepts: true,
          push_notifications: true,
        },
        account_info_json: data?.accountInfo || "",
        profile_picture_url: "",
        profile_bio: "",
      },
    };
  }

  /// updates user profile
  async function _update(caller, message, signature, data) {
    ContractAssert(caller && signature, "missing required arguments");
    ContractAssert(state.user_profiles[caller], "user not registered");

    await _authenticate(caller, message, signature);
    const _prevState = state.user_profiles[caller];
    state.user_profiles[caller] = {
      ..._prevState,
      alias: data?.alias || _prevState.alias,
      fcm_token: data?.fcmToken || _prevState.fcm_token,
      settings: {
        status: data?.status || _prevState.settings.status,
        message_preferences: {
          accept_messages:
            data?.acceptMessages ||
            _prevState.settings.message_preferences.accept_messages,
          read_reciepts:
            data?.readReciepts ||
            _prevState.settings.message_preferences.read_reciepts,
          push_notifications:
            data?.pushNotifications ||
            _prevState.settings.message_preferences.push_notifications,
        },
        account_info_json: _prevState.settings.account_info_json,
        profile_picture_url:
          data?.profilePictureUrl || _prevState.settings.profile_picture_url,
        profile_bio: data?.profileBio || _prevState.settings.profile_bio,
      },
    };
  }

  /// add a status update
  async function _addStatusUpdate(caller, type, src) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    if (state.status_updates[caller]?.length > 0) {
      state.status_updates[caller].push({
        type: type,
        src: src,
        created_at: Date.now(),
        expires_at: Date.now() + 24 * 60 * 60 * 1000,
      });
    } else {
      state.status_updates[caller] = [
        {
          type: type,
          src: src,
          created_at: Date.now(),
          expires_at: Date.now() + 24 * 60 * 60 * 1000,
        },
      ];
    }
  }

  /// block a user
  async function _blockUser(caller, userToBlock) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(
      state.user_profiles[userToBlock],
      "user to block not registered"
    );
    ContractAssert(
      !state.user_profiles[caller].blocked.includes(userToBlock),
      "user already blocked"
    );
    ContractAssert(caller !== userToBlock, "user cannot block themselves");
    state.user_profiles[caller].blocked.push(userToBlock);
  }

  /// unblock a user
  async function _unblockUser(caller, userToUnblock) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(
      state.user_profiles[userToUnblock],
      "user to unblock not registered"
    );
    state.user_profiles[caller].blocked = state.user_profiles[
      caller
    ].blocked.filter((user) => user !== userToUnblock);
  }
  /// exclude from status updates
  async function _excludeFromStatusUpdates(caller, userToExclude) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(
      state.user_profiles[userToExclude],
      "user to exclude not registered"
    );
    ContractAssert(
      !state.user_profiles[caller].status_exclude_list.includes(userToExclude),
      "user already excluded"
    );
    ContractAssert(caller !== userToExclude, "user cannot exclude themselves");
    state.user_profiles[caller].status_exclude_list.push(userToExclude);
  }

  /// undo status update exclude
  async function _undoStatusUpdateExclude(caller, userToUndo) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(
      state.user_profiles[userToUndo],
      "user to undo not registered"
    );
    state.user_profiles[caller].status_exclude_list = state.user_profiles[
      caller
    ].status_exclude_list.filter((user) => user !== userToUndo);
  }

  /// create a new group
  async function _createGroup(caller, gid, name) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(!state.chats[gid], "group already created");
    state.chats[gid] = {
      id: gid,
      name: name,
      type: "group",
      owner: caller,
      members: [caller],
      messages: [],
      created_at: Date.now(),
    };
    state.user_profiles[caller].chats.push(gid);
  }

  /// join a group
  async function _joinGroup(caller, gid) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(state.chats[gid], "group not registered");
    ContractAssert(
      !state.user_profiles[caller].chats.includes(gid),
      "group already joined"
    );
    ContractAssert(state.chats[gid].type === "group", "chat is not a group");
    state.user_profiles[caller].chats.push(gid);
    state.chats[gid].members.push(caller);
  }

  /// send a message to a group
  async function _sendMessageToGroup(caller, chatId, message) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(state.chats[chatId], "group not registered");
    ContractAssert(
      state.user_profiles[caller].chats.includes(chatId),
      "group not joined"
    );
    ContractAssert(
      state.chats[chatId].type === "group",
      "chat is not a group chat"
    );
    ContractAssert(message, "missing required arguments");
    state.chats[chatId].messages.push({
      id: message.id,
      ref: message.ref,
      type: message.type,
      src: message.src,
      sender: caller,
      created_at: Date.now(),
    });
  }

  /// delete a group
  async function _deleteGroup(caller, gid) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(
      state.chats[gid].owner === caller,
      "user is not the owner of the group"
    );
    for (const member of state.chats[gid].members) {
      state.user_profiles[member].chats = state.user_profiles[
        member
      ].chats.filter((chat) => chat !== gid);
    }
    delete state.chats[gid];
  }

  /// delete a group member
  async function _deleteGroupMember(caller, gid, member) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(state.chats[gid], "group not registered");
    ContractAssert(
      state.chats[gid].owner === caller,
      "user is not the owner of the group"
    );
    ContractAssert(
      state.chats[gid].members.includes(member),
      "member not found in the group"
    );
    ContractAssert(caller !== member, "owner cannot delete self");
    state.chats[gid].members = state.chats[gid].members.filter(
      (m) => m !== member
    );
    state.user_profiles[member].chats = state.user_profiles[
      member
    ].chats.filter((g) => g !== gid);
  }

  /// transfer group ownership
  async function _transferGroupOwnership(caller, gid, newOwner) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(state.chats[gid], "group not registered");
    ContractAssert(
      state.chats[gid].owner === caller,
      "user is not the owner of the group"
    );
    ContractAssert(
      state.chats[gid].members.includes(newOwner),
      "new owner not found in the group"
    );
    ContractAssert(state.user_profiles[newOwner], "new owner not registered");
    ContractAssert(
      caller !== newOwner,
      "user cannot transfer ownership to themselves"
    );
    state.chats[gid].owner = newOwner;
  }

  /// adds a friend
  async function _addFriend(caller, friend) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(state.user_profiles[friend], "friend not registered");
    ContractAssert(
      !state.user_profiles[caller].friends.includes(friend),
      "already friends"
    );
    ContractAssert(friend !== caller, "cannot add yourself as a friend");
    state.user_profiles[caller].friends.push(friend);
  }

  /// removes a friend
  async function _removeFriend(caller, friend) {
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(state.user_profiles[friend], "friend not registered");
    ContractAssert(
      state.user_profiles[caller].friends.includes(friend),
      "friend not found in the user's list of friends"
    );
    state.user_profiles[caller].friends = state.user_profiles[
      caller
    ].friends.filter((f) => f !== friend);
  }

  /// send a message to a user
  async function _sendMessage(caller, recipient, chatId, message) {
    ContractAssert(caller, "caller does not exist");
    ContractAssert(recipient, "recipient does not exist");
    ContractAssert(message && chatId, "chatId or message not provided");
    ContractAssert(
      !state.user_profiles[recipient].blocked.includes(caller),
      "recipient has blocked you"
    );
    if (state.chats[chatId]) {
      ContractAssert(
        state.user_profiles[caller].chats.includes(chatId),
        "caller not in chat"
      );
      state.chats[chatId].messages.push({
        id: message.id,
        ref: message.ref,
        type: message.type,
        src: message.src,
        sender: caller,
        created_at: Date.now(),
      });
      state.chats[chatId].unread[recipient] += 1;
    } else {
      state.chats[chatId] = {
        id: chatId,
        type: "one-to-one",
        members: [caller, recipient],
        messages: [
          {
            id: message.id,
            ref: message.ref,
            type: message.type,
            src: message.src,
            sender: caller,
            created_at: Date.now(),
          },
        ],
        unread: {
          [caller]: 0,
          [recipient]: 1,
        },
      };
      state.user_profiles[caller].chats.push(chatId);
      if (
        state.user_profiles[recipient].settings.message_preferences
          .accept_messages
      ) {
        state.user_profiles[recipient].chats.push(chatId);
      } else {
        state.user_profiles[recipient].requests.push(chatId);
      }
    }
  }

  /// deletes a message in a chat
  function _deleteMessage(caller, chatId, mid) {
    const chat = state.chats[chatId];
    const message = chat.messages.find((message) => message.id === mid);
    ContractAssert(
      message && message.sender === caller,
      "message not sent by caller"
    );
    const messageIndex = chat.messages.findIndex(
      (message) => message.id === mid
    );
    if (messageIndex !== -1) {
      state.chats[chatId].messages.splice(messageIndex, 1);
    }
  }

  /// accepts a chat request
  function _acceptChat(caller, chatId) {
    const chat = state.chats[chatId];
    ContractAssert(chat, "chat does not exist");
    ContractAssert(
      chat.members.includes(caller),
      "caller not a member of the chat"
    );
    ContractAssert(chat.type === "one-to-one", "chat is not one-to-one");
    state.user_profiles[caller].requests = state.user_profiles[
      caller
    ].requests.filter((r) => r !== chatId);
    state.user_profiles[caller].chats.push(chatId);
  }

  /// declines a chat request
  function _declineChat(caller, chatId) {
    const chat = state.chats[chatId];
    ContractAssert(chat, "chat does not exist");
    ContractAssert(
      chat.members.includes(caller),
      "caller not a member of the chat"
    );
    ContractAssert(chat.type === "one-to-one", "chat is not one-to-one");
    state.user_profiles[caller].requests = state.user_profiles[
      caller
    ].requests.filter((r) => r !== chatId);
    state.chats[chatId].members = state.chats[chatId].members.filter(
      (m) => m !== caller
    );
  }

  /// clears the unread count for a chat
  function _readChat(caller, chatId) {
    const chat = state.chats[chatId];
    ContractAssert(chat, "chat does not exist");
    ContractAssert(
      chat.members.includes(caller),
      "caller not a member of the chat"
    );
    ContractAssert(chat.type === "one-to-one", "chat is not one-to-one");
    state.chats[chatId].unread[caller] = 0;
  }

  /// exit chat
  async function _leaveChat(caller, chatId) {
    const chat = state.chats[chatId];
    ContractAssert(state.user_profiles[caller], "user not registered");
    ContractAssert(chat, "chat does not exist");
    ContractAssert(
      state.user_profiles[caller].chats.includes(chatId),
      "no chat session"
    );
    if (chat.type === "group" && chat.members.length > 1) {
      const owner = chat.owner;
      ContractAssert(caller !== owner, "owner cannot leave the group chat");
    }
    state.user_profiles[caller].chats = state.user_profiles[
      caller
    ].chats.filter((id) => id !== chatId);

    if (chat.members.length === 1) {
      delete state.chats[chatId];
    } else {
      state.chats[chatId].members = state.chats[chatId].members.filter(
        (m) => m !== caller
      );
    }
  }

  /// authenticate the caller.
  async function _authenticate(caller, message, signature) {
    try {
      const res = await EXM.deterministicFetch(
        "https://api.mem.tech/api/transactions",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            functionId: "DKI-7iVBGhAfsX8vbOQtMnlyZjwPZQX9coGe8PsKv_8",
            inputs: [
              {
                input: {
                  function: "sign",
                  caller,
                  message,
                  signature,
                },
              },
            ],
          }),
        }
      );
      ContractAssert(
        Object.keys(res.asJSON()?.data.execution.errors).length === 0,
        "Authentication failed"
      );
    } catch (e) {
      throw new ContractError("Authentication error");
    }
  }
}
