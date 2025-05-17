<template>
  <el-dialog
    title="安全测试报告"
    :visible.sync="visible"
    width="80%"
    class="security-report-dialog"
  >
    <div class="report-header">
      <h2>安全测试综合报告</h2>
      <p class="report-time">生成时间：{{ currentTime }}</p>
    </div>

    <div class="report-content">
      <!-- 总体概况 -->
      <div class="section">
        <h3>总体概况</h3>
        <el-row :gutter="20">
          <el-col :span="6" v-for="(item, index) in summary" :key="index">
            <div class="summary-card" :class="item.type">
              <div class="card-title">{{ item.title }}</div>
              <div class="card-value">{{ item.value }}</div>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 测试流程 -->
      <div class="section">
        <h3>测试流程</h3>
        <el-timeline>
          <el-timeline-item
            v-for="(step, index) in reportData.projectSteps"
            :key="index"
            :type="step.status === 'completed' ? 'success' : 'warning'"
            :timestamp="step.time"
          >
            <h4>{{ step.step }}</h4>
            <p>{{ step.details }}</p>
          </el-timeline-item>
        </el-timeline>
      </div>

      <!-- 攻击详情 -->
      <div class="section">
        <h3>攻击详情分析</h3>
        <el-table :data="attackDetails" border style="width: 100%">
          <el-table-column prop="time" label="时间" width="180"></el-table-column>
          <el-table-column prop="type" label="攻击类型" width="150"></el-table-column>
          <el-table-column prop="source" label="来源IP" width="150"></el-table-column>
          <el-table-column prop="target" label="目标资产" width="150"></el-table-column>
          <el-table-column prop="status" label="处理状态">
            <template slot-scope="scope">
              <el-tag :type="scope.row.status === '已拦截' ? 'success' : 'danger'">
                {{ scope.row.status }}
              </el-tag>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 系统状态 -->
      <div class="section">
        <h3>系统状态</h3>
        <el-descriptions border>
          <el-descriptions-item v-for="(value, key) in reportData.systemStatus" :key="key" :label="key">
            <el-tag :type="value === '正常' ? 'success' : 'warning'">{{ value }}</el-tag>
          </el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- 安全建议 -->
      <div class="section">
        <h3>安全建议</h3>
        <el-card v-for="(advice, index) in securityAdvice" :key="index" class="advice-card">
          <div slot="header">
            <span>{{ advice.title }}</span>
            <el-tag size="small" :type="advice.priority === '高' ? 'danger' : advice.priority === '中' ? 'warning' : 'info'">
              {{ advice.priority }}优先级
            </el-tag>
          </div>
          <div class="advice-content">{{ advice.content }}</div>
        </el-card>
      </div>
    </div>

    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">关闭</el-button>
      <el-button type="primary" @click="handleExport">导出报告</el-button>
    </span>
  </el-dialog>
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
        { title: '检测资产', value: '12个', type: 'assets' },
        { title: '发现漏洞', value: '8个', type: 'vulnerabilities' },
        { title: '攻击次数', value: '2次', type: 'attacks' },
        { title: '防御成功率', value: '100%', type: 'success-rate' }
      ],
      attackDetails: [
        {
          time: '2024-03-15 10:30:22',
          type: 'DoS攻击',
          source: '192.168.1.100',
          target: 'Web服务器',
          status: '已记录'
        },
        {
          time: '2024-03-15 11:45:33',
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
    }
  }
}
</script>

<style lang="scss" scoped>
.security-report-dialog {
  .report-header {
    text-align: center;
    margin-bottom: 30px;
    h2 {
      color: #303133;
      margin-bottom: 10px;
    }
    .report-time {
      color: #909399;
      font-size: 14px;
    }
  }

  .section {
    margin-bottom: 30px;
    h3 {
      margin-bottom: 20px;
      padding-left: 10px;
      border-left: 4px solid #409EFF;
    }
  }

  .summary-card {
    padding: 20px;
    border-radius: 8px;
    text-align: center;
    color: white;
    margin-bottom: 20px;

    &.assets { background: linear-gradient(135deg, #36D1DC, #5B86E5); }
    &.vulnerabilities { background: linear-gradient(135deg, #FF9966, #FF5E62); }
    &.attacks { background: linear-gradient(135deg, #859398, #283048); }
    &.success-rate { background: linear-gradient(135deg, #11998e, #38ef7d); }

    .card-title {
      font-size: 14px;
      margin-bottom: 10px;
    }
    .card-value {
      font-size: 24px;
      font-weight: bold;
    }
  }

  .advice-card {
    margin-bottom: 15px;
    .el-card__header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .advice-content {
      color: #606266;
      line-height: 1.6;
    }
  }
}
</style> 