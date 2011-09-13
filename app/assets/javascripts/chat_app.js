var ChatApp = SC.Application.create();
var PusherI = new Pusher('4402605531700a27f57d');

ChatApp.Message = SC.Object.extend({
  from_user: null,
  message: null,
  gravatar: null
});

ChatApp.User = SC.Object.extend({
  name: null,
  email: null,
  gravatar: null
});

ChatApp.userController = SC.ArrayProxy.create({
  content: [],

  addUser: function(userName, userEmail, gravatarUrl) {
    var usr = ChatApp.User.create({
      name: userName,
      email: userEmail,
      gravatar: gravatarUrl
    });
    this.pushObject(usr);
  },

  removeUser: function(userName, userEmail, gravatarUrl) {
    var idx = ChatApp.userController.content.indexOf({name: userName,
      email: userEmail, gravatar: gravatarUrl});
    var tmp = this.content;
    var tmp2 = ChatApp.userController.content
    if(idx!=-1) visibleIds.splice(idx, 1);
  }

});

ChatApp.chatController = SC.ArrayProxy.create({
  content: [],

  sendMessage: function(userName, text, gravatarUrl) {
    $.post('chat/send_message',
      {user: userName, message: text, gravatar: gravatarUrl},
      function(data, textStatus, jqXHR){
        //displayMessage(data.user, data.message);
        //ChatApp.chatController.displayMessage(data.user, data.message);
      }
    );
  },

  displayMessage: function(user, text, gravatarUrl) {
    var msg = ChatApp.Message.create({
      fromName: user,
      message: text,
      gravatar: gravatarUrl
    });
    this.pushObject(msg);
  },

  login: function(){
    $.post('chat/login', 
        {email: ChatApp.chatController.userEmail,
         name: ChatApp.chatController.userName
        },
      function(data, textStatus, jqXHR) {
        ChatApp.chatController.gravatarUrl = data.gravatarUrl;
        ChatApp.chatController.myChat = PusherI.subscribe('presence-chat-room');
        ChatApp.chatController.myChat.bind('message-recieved', function(message){
          ChatApp.chatController.displayMessage(message.user, message.message,
            message.gravatar);
        });
        ChatApp.chatController.myChat.bind('pusher:subscription_succeeded', function(members) {
          members.each(function(member) {
            ChatApp.userController.addUser(member.info.name, 
              member.info.email, member.info.gravatar);
          });
        });
        ChatApp.chatController.myChat.bind('pusher:member_added', function(user){
          ChatApp.userController.addUser(user.info.name, user.info.email, user.info.gravatar);
        });
        ChatApp.chatController.myChat.bind('pusher:member_removed', function(user){
          ChatApp.userController.removeUser(user.info.name, user.info.email, user.info.gravatar);
        });
        //ChatApp.userController.addUser(
          //ChatApp.chatController.userName,
          //ChatApp.chatController.userEmail,
          //ChatApp.chatController.gravatarUrl
        //);
        ChatApp.chatController.set('loggedIn', true);
    });
  },

  myChat: null,

  loggedIn: false,

  gravatarUrl: null,

  userName: null,

  userEmail: null

});


ChatApp.CreateMessageView = SC.TextField.extend({
  insertNewline: function() {
    var value = this.get('value');
    if (value) {
      ChatApp.chatController.sendMessage(ChatApp.chatController.userName,
        value, ChatApp.chatController.gravatarUrl);
      this.set('value', '');
    }
  }
});

ChatApp.Name = SC.TextField.extend({
  insertNewline: function() {
    var value = this.get('value');
    if (value) {
      this.set('value', '');
    }
  }
});

ChatApp.Email = SC.TextField.extend({
  insertNewline: function() {
    var value = this.get('value');
    if (value) {
      ChatApp.chatController.login();
      this.set('value', '');
    }
  }
});
