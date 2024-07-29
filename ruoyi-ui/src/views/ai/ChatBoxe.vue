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
        <input v-model="msg" type="text" @keyup.enter="sendMsg" @confirm="sendMsg" confirm-type="search" placeholder-class="my-neirong-sm"
          placeholder="用一句简短的话描述您的问题" />
        <button @click="sendMsg" :disabled="msgLoad">{{ sentext }}</button>
        <button @click="clearMsg">清除对话</button>
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
        api: '9c9f6f4329233d6660f0b58f6e9df891.nqdR96fNVwmQeNvx',
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
          role : "system",
          content : "你是一个致力于网络安全以及网络攻防的网络安全工程师"
        },{
          role : "user",
          content : ""
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
        this.msgForPost[1].content = "请在网络安全工程师的角度回答以下问题，并且不要在回答中出现chatglm的字样：\n"+this.msg
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
          role : "system",
          content : "你是一个致力于网络安全以及网络攻防的网络安全工程师"
        },{
          role : "user",
          content : ""
        }];
        this.msg = "";
        this.msgContent = "";
      }
    }
  }
  </script>

  <style scoped>
  .ChatBoxe {
    width: 90vw;
    height: 90vh;
    background: #ffffffa9;
    border-radius: 1%;
    overflow: hidden;
    padding: 1%;
  }

  .question {
    width: 100%;
    background: #ffffffd8;
    border-radius: 1rem;
    overflow: hidden;
  }

  .question input {
    width: 80%;
    margin-left: 15px;
    height: 60px;
    border: none;
    background: none;
    font-size: 1.2rem;
    outline: none;
  }

  .question button {
    width: 8%;
    height: 60px;
    background-color: #f0f0f0;
    border: none;
    font-size: 1.5rem;
    font-weight: 600;
    color: #cd22eb;
  }

  .content {
    height: 90%;
    font-size: 1.2rem;
    overflow: auto;
  }

  .content img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
  }

  .show {
    color: #000;
    display: flex;
    margin-bottom: 1rem;
    /* align-items: center; */
  }

  .onshow {
    display: flex;
    color: #cd22eb;
    flex-direction: row-reverse;
    margin-bottom: 1rem;
    /* align-items: center; */
  }

  .con {
    background: #fff;
    padding: 1rem;
    margin: 1rem;
    border-radius: 0px 30px 30px 30px;
  }

  .show>.con {
    border-radius: 0px 30px 30px 30px;
  }

  .onshow>.con {
    border-radius: 30px 0px 30px 30px;
  }
  </style>
