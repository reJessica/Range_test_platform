<template>
  <div class="container-div">
    <div id="app-security-report">
      <div class="header-stats">
        <div class="stat-item" v-for="(item, index) in summary" :key="index">
          <div class="stat-value">{{ item.value }}</div>
          <div class="stat-label">{{ item.title }}</div>
        </div>
      </div>

      <div class="security-section">
        <div class="group-header">
          <h2>安全测试报告</h2>
        </div>

        <div class="report-content">
          <!-- 测试流程 -->
          <div class="process-group">
            <h3>测试流程</h3>
            <div class="timeline-wrapper">
              <div class="timeline-item" v-for="(step, index) in reportData.projectSteps" :key="index">
                <div class="step-time">{{ step.time }}</div>
                <div class="step-status {{ step.status === 'completed' ? 'success' : 'warning' }}">{{ step.status }}
                </div>
                <div class="step-desc">
                  <p class="step-title">{{ step.step }}</p>
                  <p class="step-detail">{{ step.details }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- 攻击详情 -->
          <div class="attack-group">
            <h3>攻击详情分析</h3>
            <div class="data-table">
              <table>
                <thead>
                  <tr>
                    <th>时间</th>
                    <th>攻击类型</th>
                    <th>来源IP</th>
                    <th>目标资产</th>
                    <th>处理状态</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(attack, index) in attackDetails" :key="index">
                    <td>{{ attack.time }}</td>
                    <td>{{ attack.type }}</td>
                    <td>{{ attack.source }}</td>
                    <td>{{ attack.target }}</td>
                    <td><span class="status-tag {{ attack.status === '已拦截' ? 'success' : 'danger' }}">{{ attack.status
                        }}</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 系统状态 -->
          <div class="system-group">
            <h3>系统状态</h3>
            <div class="status-list">
              <div class="status-item" v-for="(value, key) in reportData.systemStatus" :key="key">
                <span class="item-label">{{ key }}</span>
                <span class="item-value {{ value === '正常' ? 'success' : 'warning' }}">{{ value }}</span>
              </div>
            </div>
          </div>

          <!-- 安全建议 -->
          <div class="advice-group">
            <h3>安全建议</h3>
            <div class="advice-list">
              <div class="advice-item" v-for="(advice, index) in securityAdvice" :key="index">
                <div class="advice-header">
                  <span class="advice-title">{{ advice.title }}</span>
                  <span class="priority-tag {{ getPriorityClass(advice.priority) }}">{{ advice.priority }}优先级</span>
                </div>
                <div class="advice-desc">{{ advice.content }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="footer-actions">
        <button class="button--close" @click="visible = false">关闭</button>
        <button class="button--export" @click="handleExport">导出报告</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SecurityReport',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    reportData: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      currentTime: new Date().toLocaleString(),
      summary: [
        { title: '检测资产', value: '12个' },
        { title: '发现漏洞', value: '8个' },
        { title: '攻击次数', value: '2次' },
        { title: '防御成功率', value: '100%' }
      ],
      attackDetails: [
        {
          time: '2025-05-15 10:30:22',
          type: 'DoS攻击',
          source: '192.168.1.100',
          target: 'Web服务器',
          status: '已记录'
        },
        {
          time: '2025-05-15 11:45:33',
          type: 'DoS攻击',
          source: '192.168.1.100',
          target: 'Web服务器',
          status: '已拦截'
        }
      ],
      securityAdvice: [
        {
          title: '加强入侵检测模型',
          priority: '高',
          content: '建议持续优化深度学习模型，提高异常流量识别准确率。'
        },
        {
          title: '完善自动响应机制',
          priority: '中',
          content: '建议进一步完善规则驱动的自动防护机制，提高响应速度。'
        },
        {
          title: '优化日志管理',
          priority: '低',
          content: '建议建立更完善的日志分析体系，提高可疑行为识别效率。'
        }
      ]
    }
  },
  methods: {
    handleExport() {
      this.$message.success('报告已导出为PDF文件')
    },
    getPriorityClass(priority) {
      return {
        '高': 'danger',
        '中': 'warning',
        '低': 'info'
      }[priority] || 'info'
    }
  }
}
</script>

<style lang="scss" scoped>
:root {
  --dark-bg: #121212;
  --darker-bg: #1e1e1e;
  --light-text: #ffffff;
  --primary-color: #4f5aff;
  --success-color: #4caf50;
  --warning-color: #ff9800;
  --danger-color: #f44336;
  --info-color: #2196f3;
  --border-color: #333333;
}

.container-div {
  background-color: var(--dark-bg);
  color: var(--light-text);
  height: 100vh;
  overflow-y: auto;
}

#app-security-report {
  background-color: var(--darker-bg);
  min-height: 100vh;
  padding: 20px;
  border-radius: 8px;
  color: var(--light-text);
}

.header-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
  margin-bottom: 30px;

  .stat-item {
    background-color: rgba(28, 28, 28, 0.7);
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    border: 1px solid var(--border-color);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  .stat-value {
    font-size: 32px;
    font-weight: bold;
    margin-bottom: 8px;
    color: var(--primary-color);
  }

  .stat-label {
    font-size: 14px;
    color: #aaa;
  }
}

.security-section {
  background-color: rgba(28, 28, 28, 0.7);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 30px;
  border: 1px solid var(--border-color);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.group-header h2 {
  color: var(--light-text);
  font-size: 24px;
  margin-bottom: 20px;
}

.timeline-wrapper {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 30px;

  .timeline-item {
    flex: 1 0 calc(50% - 10px);
    min-width: 300px;
    background-color: rgba(21, 21, 21, 0.7);
    border-radius: 8px;
    padding: 20px;
    border: 1px solid var(--border-color);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .step-time {
    color: #00ff9d;
    font-size: 12px;
    margin-bottom: 8px;
  }

  .step-status {
    display: inline-block;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    margin-bottom: 10px;
  }

  .step-title {
    color: var(--light-text);
    font-size: 16px;
    margin-bottom: 8px;
  }
}

.data-table {
  width: 100%;
  overflow-x: auto;
  margin-bottom: 30px;

  table {
    width: 100%;
    min-width: 800px;
    border-collapse: collapse;

    th,
    td {
      padding: 12px 15px;
      border-bottom: 1px solid var(--border-color);
    }

    th {
      color: var(--primary-color);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .status-tag {
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 12px;
    }
  }
}

.system-group {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 30px;

  .status-item {
    background-color: rgba(21, 21, 21, 0.7);
    border-radius: 8px;
    padding: 15px 20px;
    border: 1px solid var(--border-color);
  }

  .item-label {
    color: var(--light-text);
    font-size: 14px;
    margin-bottom: 6px;
  }

  .item-value {
    font-weight: bold;
  }
}

.advice-group .advice-list {
  gap: 20px;
  margin-bottom: 30px;

  .advice-item {
    background-color: rgba(21, 21, 21, 0.7);
    border-radius: 8px;
    padding: 20px;
    border: 1px solid var(--border-color);
  }

  .advice-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
  }

  .advice-title {
    color: var(--light-text);
    font-size: 16px;
  }

  .advice-desc {
    color: #aaa;
    line-height: 1.6;
  }
}

.footer-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 20px;
  border-top: 1px solid var(--border-color);

  .button--close,
  .button--export {
    min-height: 40px;
    padding: 0.5em 2em;
    border: none;
    border-radius: 6px;
    font-size: 15px;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  .button--close {
    background-color: rgba(255, 255, 255, 0.1);
    color: var(--light-text);

    &:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }
  }

  .button--export {
    background-color: var(--primary-color);
    color: #fff;

    &:hover {
      background-color: #3c4dc9;
    }
  }
}

/* 状态标签颜色 */
.success {
  background-color: rgba(76, 175, 80, 0.2);
  color: var(--success-color);
}

.warning {
  background-color: rgba(255, 152, 0, 0.2);
  color: var(--warning-color);
}

.danger {
  background-color: rgba(244, 67, 54, 0.2);
  color: var(--danger-color);
}

.info {
  background-color: rgba(33, 150, 243, 0.2);
  color: var(--info-color);
}

@media screen and (max-width: 1200px) {
  .header-stats {
    grid-template-columns: repeat(2, 1fr);
  }

  .timeline-wrapper .timeline-item {
    flex: 1 0 100%;
  }
}

@media screen and (max-width: 768px) {
  #app-security-report {
    padding: 10px;
  }

  .header-stats {
    grid-template-columns: 1fr;
  }

  .data-table {
    overflow-x: auto;
  }
}
</style>