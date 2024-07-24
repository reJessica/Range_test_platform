<template>
  <div class="about-us">
    <h1 class="title">关于我们</h1>
    <p class="description">欢迎来到我们团队的世界！我们是一群充满创造力和激情的人，致力于将优质服务和创新产品带给用户。通过不断挑战自我和追求卓越，我们努力满足用户的需求，为他们创造出色体验。</p>
    <h2 class="team-title">Meet Our Team</h2>
    <div class="team-members">
      <div class="member">
        <img src="../../assets/images/member.jpg" alt="Team Member 1">
        <h3>张三</h3>
        <p>产品经理</p>
        <p>拥有丰富的产品开发和管理经验，负责确保我们的产品满足用户需求。</p>
      </div>
      <div class="member">
        <img src="../../assets/images/member.jpg" alt="Team Member 2">
        <h3>李四</h3>
        <p>设计师</p>
        <p>具有创造力和美学眼光，致力于打造独特和优雅的用户界面设计。</p>
      </div>
      <div class="member">
        <img src="../../assets/images/member.jpg" alt="Team Member 3">
        <h3>王五</h3>
        <p>开发工程师</p>
        <p>编程天才，善于解决复杂问题和构建高效的代码结构。</p>
      </div>
    </div>
  </div>
</template>

<style lang="scss">
.about-us {
  text-align: center;
  padding: 20px;
  background-color: #f9f9f9;
}

.title {
  color: #333;
  font-size: 3em;
  margin-bottom: 30px;
}

.description {
  color: #666;
  font-size: 1.6em;
  margin-bottom: 40px;
  line-height: 1.8;
}

.team-title {
  font-size: 2.5em;
  margin-bottom: 30px;
  color: #333;
}

.team-members {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.member {
  margin: 0 30px;
  text-align: center;
  padding: 20px;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.member img {
  border-radius: 50%;
  width: 160px;
  height: 160px;
  object-fit: cover;
  border: 5px solid #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.member h3 {
  margin-top: 15px;
  color: #333;
  font-size: 1.8em;
}

.member p {
  color: #666;
  font-size: 1.4em;
  margin-bottom: 15px;
  line-height: 1.6;
}
</style>