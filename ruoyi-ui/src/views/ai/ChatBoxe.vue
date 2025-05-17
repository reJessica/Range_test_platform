<template>
  <div class="ChatBoxe">
    <div class="content">
      <div :class="displayStyle(index)" v-for="(item, index) in msgList" :key="index">
        <img src="@/assets/ai/ai-header.jpeg" alt="">
        <div class="con">
          {{ item.msg }}
        </div>
      </div>
    </div>
    <div class="question">
      <input v-model="msg" type="text" @keyup.enter="sendMsg" @confirm="sendMsg" confirm-type="search"
        placeholder-class="my-neirong-sm" placeholder="用一句简短的话描述您的问题" />
      <button class="send-btn" @click="sendMsg" :disabled="msgLoad">{{ sentext }}</button>
      <button class="clear-btn" @click="clearMsg">清除对话</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChatBoxe',
  mounted() {
    if (document.cookie != "") {
      this.msgList = JSON.parse(document.cookie);
    }
  },
  data() {
    return {
      // 输入自己的key
      api: 'cc7f514058514df198bb84bb04e32097.MnDkWJUVSvJuryME',
      msgLoad: false,
      anData: {},
      sentext: '发送消息',
      animationData: {},
      showTow: false,
      msgList: [{
        my: false,
        msg: "你好我是网盾探隅的AI机器人,请问有什么问题可以帮助您?"
      }],
      msgContent: "",
      msg: "",
      msgForPost: [{
        role: "system",
        content: "你是一个致力于网络安全以及网络攻防的网络安全工程师"
      }, {
        role: "user",
        content: ""
      }]
    }
  },
  methods: {
    // 判断输入方
    displayStyle(index) {
      if (index % 2 == 0) {
        return 'show';
      } else {
        return 'onshow'
      }
    },
    sendMsg() {
      // 消息为空不做任何操作
      if (this.msg == "") {
        alert("请输入内容");
        return 0;
      }
      this.sentext = '等待..'
      this.msgList.push({
        "msg": this.msg,
        "my": true
      })
      console.log(this.msg);
      this.msgContent += ('YOU:' + this.msg + "\n")
      this.msgForPost[1].content = "请在网络安全工程师的角度回答以下问题，并且不要在回答中出现chatglm的字样：\n" + this.msg
      this.msgLoad = true
      // 清除消息
      this.msg = "";
      this.$axios.post('https://open.bigmodel.cn/api/paas/v4/chat/completions', JSON.stringify({
        messages: this.msgForPost, model: "glm-3-turbo"
      }), {
        headers: { 'content-type': 'application/json', 'Authorization': 'Bearer ' + this.api }
      }).then(res => {
        console.log(res);
        let text = res.data.choices[0].message.content;
        console.log(text);
        this.msgList.push({
          "msg": text,
          "my": false
        })
        this.msgContent += (text + "\n")
        this.msgLoad = false
        this.sentext = '发送消息'
        document.cookie = JSON.stringify(this.msgList);
      })
    },
    clearMsg() {
      this.msgList = [{
        my: false,
        msg: '你好我是网盾探隅的AI机器人,请问有什么问题可以帮助您?'
      }];
      this.msgForPost = [{
        role: "system",
        content: "你是一个致力于网络安全以及网络攻防的网络安全工程师"
      }, {
        role: "user",
        content: ""
      }];
      this.msg = "";
      this.msgContent = "";
    }
  }
}
</script>

<style lang="scss" scoped>
.ChatBoxe {
  width: 90vw;
  max-width: 1200px;
  height: 88vh;
  background: rgba(16, 36, 64, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(24, 144, 255, 0.2);
  border-radius: 12px;
  overflow: hidden;
  padding: 20px;
  display: flex;
  flex-direction: column;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.content {
  flex: 1;
  font-size: 1.1rem;
  overflow: auto;
  padding: 10px;
  margin-bottom: 20px;

  &::-webkit-scrollbar {
    width: 6px;
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(24, 144, 255, 0.3);
    border-radius: 3px;
  }

  &::-webkit-scrollbar-track {
    background: rgba(0, 0, 0, 0.1);
  }
}

.question {
  width: 100%;
  background: rgba(13, 27, 42, 0.6);
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  padding: 10px;
  gap: 10px;
  border: 1px solid rgba(24, 144, 255, 0.2);

  input {
    flex: 1;
    height: 50px;
    border: none;
    background: rgba(16, 36, 64, 0.5);
    font-size: 1rem;
    outline: none;
    color: #fff;
    padding: 0 15px;
    border-radius: 6px;

    &::placeholder {
      color: rgba(255, 255, 255, 0.5);
    }
  }

  button {
    height: 50px;
    border: none;
    font-size: 1rem;
    font-weight: 500;
    padding: 0 20px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;

    &.send-btn {
      background: #1890ff;
      color: #fff;

      &:hover:not(:disabled) {
        background: #40a9ff;
        transform: translateY(-2px);
      }

      &:disabled {
        opacity: 0.7;
        cursor: not-allowed;
      }
    }

    &.clear-btn {
      background: rgba(255, 77, 79, 0.2);
      color: #ff4d4f;

      &:hover {
        background: rgba(255, 77, 79, 0.3);
        transform: translateY(-2px);
      }
    }
  }
}

.show,
.onshow {
  display: flex;
  margin-bottom: 1rem;
  align-items: flex-start;

  img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 2px solid rgba(24, 144, 255, 0.3);
  }

  .con {
    background: rgba(13, 27, 42, 0.6);
    padding: 1rem;
    margin: 0 1rem;
    border-radius: 12px;
    color: rgba(255, 255, 255, 0.9);
    max-width: 80%;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(24, 144, 255, 0.2);
  }
}

.show {
  .con {
    border-radius: 0 12px 12px 12px;
  }
}

.onshow {
  flex-direction: row-reverse;

  .con {
    border-radius: 12px 0 12px 12px;
    background: rgba(24, 144, 255, 0.2);
    border-color: rgba(24, 144, 255, 0.3);
  }
}

@media screen and (max-width: 768px) {
  .ChatBoxe {
    width: 95vw;
    height: 85vh;
    padding: 10px;
  }

  .question {
    flex-wrap: wrap;

    input {
      width: 100%;
    }

    button {
      flex: 1;
      min-width: 120px;
    }
  }
}
</style>
