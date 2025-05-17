<template>
  <div class="container-div">
    <div id="app1">
      <div class="chat-container">
        <ChatBoxe />
      </div>
    </div>
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

<style lang="scss" scoped>
.container-div {
  height: calc(100vh - 84px);
  overflow-y: auto;
  padding: 0;
  background: transparent;
}

#app1 {
  min-height: 100%;
  width: 100%;
  background: linear-gradient(135deg, #0a192f 0%, #0d1b2a 100%);
  position: relative;
  padding: 20px;
  box-sizing: border-box;

  &::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background:
      linear-gradient(90deg, rgba(24, 144, 255, 0.1) 1px, transparent 1px),
      linear-gradient(rgba(24, 144, 255, 0.1) 1px, transparent 1px);
    background-size: 30px 30px;
    mask-image: radial-gradient(circle at 50% 50%, black, transparent 80%);
    z-index: 1;
    animation: grid-animation 20s linear infinite;
    pointer-events: none;
  }

  &::after {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: radial-gradient(circle at 50% 50%, rgba(24, 144, 255, 0.1), transparent 80%);
    z-index: 2;
    pointer-events: none;
  }
}

.chat-container {
  position: relative;
  z-index: 3;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

@keyframes grid-animation {
  0% {
    transform: translateY(0);
  }

  100% {
    transform: translateY(30px);
  }
}

@media screen and (max-width: 768px) {
  #app1 {
    padding: 10px;
  }
}
</style>
