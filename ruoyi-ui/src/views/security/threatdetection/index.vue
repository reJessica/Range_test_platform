<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!-- 威胁检测方法卡片 -->
      <el-col :span="24">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>威胁检测方法</span>
          </div>
          <el-row :gutter="20">
            <el-col :span="12">
              <el-card class="method-card" shadow="hover">
                <div class="method-icon">
                  <i class="el-icon-data-analysis"></i>
                </div>
                <div class="method-title">基于威胁情报</div>
                <div class="method-desc">
                  利用已知威胁情报库进行匹配，快速识别已知威胁
                </div>
                <el-progress :percentage="70" color="#409EFF"></el-progress>
              </el-card>
            </el-col>
            <el-col :span="12">
              <el-card class="method-card" shadow="hover">
                <div class="method-icon">
                  <i class="el-icon-cpu"></i>
                </div>
                <div class="method-title">基于深度学习</div>
                <div class="method-desc">
                  通过深度学习模型分析，识别未知威胁模式
                </div>
                <el-progress :percentage="85" color="#67C23A"></el-progress>
              </el-card>
            </el-col>
          </el-row>
        </el-card>
      </el-col>
    </el-row>

    <!-- 实时检测结果 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="24">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>实时检测结果</span>
            <el-button
              style="float: right; padding: 3px 0"
              type="text"
              @click="refreshData"
            >刷新</el-button>
          </div>
          <el-table :data="detectionResults" style="width: 100%">
            <el-table-column prop="timestamp" label="时间" width="180">
            </el-table-column>
            <el-table-column prop="type" label="检测类型" width="180">
              <template slot-scope="scope">
                <el-tag :type="scope.row.type === '威胁情报' ? 'primary' : 'success'">
                  {{ scope.row.type }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="threat" label="威胁描述">
            </el-table-column>
            <el-table-column prop="confidence" label="置信度" width="180">
              <template slot-scope="scope">
                <el-progress
                  :percentage="scope.row.confidence"
                  :color="getConfidenceColor(scope.row.confidence)"
                ></el-progress>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="180">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleDetail(scope.row)"
                >详情</el-button>
                <el-button
                  size="mini"
                  type="danger"
                  @click="handleBlock(scope.row)"
                >拦截</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <!-- 威胁分布统计 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>威胁类型分布</span>
          </div>
          <div id="threatTypeChart" style="height: 300px"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>检测方法效果对比</span>
          </div>
          <div id="detectionMethodChart" style="height: 300px"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'ThreatDetection',
  data() {
    return {
      detectionResults: [
        {
          timestamp: '2024-03-26 10:30:45',
          type: '威胁情报',
          threat: '发现可疑的DNS查询行为',
          confidence: 85
        },
        {
          timestamp: '2024-03-26 10:29:30',
          type: '深度学习',
          threat: '检测到异常的网络连接模式',
          confidence: 92
        },
        {
          timestamp: '2024-03-26 10:28:15',
          type: '威胁情报',
          threat: '检测到已知恶意IP地址访问',
          confidence: 95
        }
      ],
      threatTypeChart: null,
      detectionMethodChart: null
    }
  },
  mounted() {
    this.initCharts()
  },
  methods: {
    refreshData() {
      // 实现数据刷新逻辑
      this.$message.success('数据已刷新')
    },
    handleDetail(row) {
      this.$message.info('查看详情：' + row.threat)
    },
    handleBlock(row) {
      this.$confirm('确认拦截该威胁？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$message.success('已成功拦截威胁')
      }).catch(() => {})
    },
    getConfidenceColor(confidence) {
      if (confidence >= 90) return '#67C23A'
      if (confidence >= 70) return '#409EFF'
      if (confidence >= 50) return '#E6A23C'
      return '#F56C6C'
    },
    initCharts() {
      // 初始化威胁类型分布图表
      this.threatTypeChart = echarts.init(document.getElementById('threatTypeChart'))
      this.threatTypeChart.setOption({
        title: {
          text: '威胁类型分布',
          left: 'center'
        },
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '威胁类型',
            type: 'pie',
            radius: '50%',
            data: [
              { value: 35, name: 'DNS攻击' },
              { value: 25, name: 'DDoS攻击' },
              { value: 20, name: '恶意扫描' },
              { value: 15, name: '数据泄露' },
              { value: 5, name: '其他' }
            ],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      })

      // 初始化检测方法效果对比图表
      this.detectionMethodChart = echarts.init(document.getElementById('detectionMethodChart'))
      this.detectionMethodChart.setOption({
        title: {
          text: '检测方法效果对比',
          left: 'center'
        },
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: ['威胁情报', '深度学习'],
          bottom: 0
        },
        xAxis: {
          type: 'category',
          data: ['准确率', '召回率', '检测速度', '误报率']
        },
        yAxis: {
          type: 'value',
          max: 100
        },
        series: [
          {
            name: '威胁情报',
            type: 'bar',
            data: [85, 78, 90, 15]
          },
          {
            name: '深度学习',
            type: 'bar',
            data: [92, 88, 75, 8]
          }
        ]
      })
    }
  }
}
</script>

<style scoped>
.method-card {
  text-align: center;
  padding: 20px;
}
.method-icon {
  font-size: 48px;
  color: #409EFF;
  margin-bottom: 20px;
}
.method-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 10px;
}
.method-desc {
  color: #666;
  margin-bottom: 20px;
}
</style>