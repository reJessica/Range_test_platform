<template>
    <div id="app">
      <ChatBoxe />
    </div>
  </template>

  <script>
  import ChatBoxe from './ChatBoxe.vue'

  export default {
    name: 'App',
    components: {
      ChatBoxe
    }
  }
  </script>

  <style>
  * {
    margin: 0;
    padding: 0;
  }

  #app {
    width: 100%;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: url(D:/1/Range_test_platform/ruoyi-ui/src/assets/ai/backround1.jpg) no-repeat;
    background-size: 100% 100%;
  }

  @media screen and (max-width: 600px) {
    #app {
      background: url(D:/1/Range_test_platform/ruoyi-ui/src/assets/ai/backround2.jpeg) no-repeat;
    background-size: 100% 100%;

    }
  }
  </style>
