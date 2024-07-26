
<template>
  <div class="about-us">
    <div class="content">
      <h2 class="title">关于我们</h2>
      <p class="description">我们是一个充满激情和创造力的团队，致力于提供高质量的产品和服务，满足用户的需求。我们利用团队中每个成员的专业知识和经验，并结合激情和创造力，不断探索和创新，以确保我们的智能测试验证靶场平台能够提供最优质的产品和服务。我们坚信通过我们团队的努力和专业，我们的智能测试验证靶场平台将继续发展壮大，为用户带来更多的实用和创新的功能。</p>

      <h3 class="team-title">我们的团队</h3>
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
        <div class="member">
          <img src="../../assets/images/member.jpg" alt="Team Member 4">
          <h3>赵六</h3>
          <p>市场营销</p>
          <p>作为市场营销专家，赵六负责制定推广策略，推动产品销售。他善于了解用户需求，将产品呈现在人们面前。</p>
        </div>
        <div class="member">
          <img src="../../assets/images/member.jpg" alt="Team Member 5">
          <h3>钱七</h3>
          <p>前端工程师</p>
          <p>钱七是我们团队的前端开发专家，熟练掌握各种前端技术和框架，致力于优化用户体验。擅长创建交互式的界面，确保用户获得无缝的体验。</p>
        </div>
      </div>
    </div>
  </div>
</template>


<style lang="scss">
.about-us {
  padding: 20px;
  background-color: #f9f9f9;
}

.title {
  color: #333;
  font-size: 2.5em;
  margin-bottom: 30px;
  text-align: center;
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
  text-align: center;
}

.team-members {
  display: flex;
  flex-wrap: wrap;
}

.member {
  flex: 1;
  margin: 20px;
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

.description {
  text-indent: 2em;
}
</style>