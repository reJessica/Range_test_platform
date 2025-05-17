<template>
  <div class="app-container cyber-theme">
    <el-row :gutter="20">
      <!-- 威胁检测方法卡片 -->
      <el-col :span="24">
        <div class="cyber-card detection-methods">
          <div class="cyber-card-header">
            <div class="header-title">
              <i class="el-icon-warning-outline"></i>
              <span>威胁检测方法</span>
            </div>
            <div class="cyber-line"></div>
          </div>
          <el-row :gutter="20">
            <el-col :span="12">
              <div class="method-card">
                <div class="method-content">
                  <div class="method-icon">
                    <i class="el-icon-data-analysis"></i>
                  </div>
                  <div class="method-info">
                    <div class="method-title">
                      <span class="title-text">基于威胁情报</span>
                      <div class="cyber-tag">实时检测</div>
                    </div>
                    <div class="method-desc">
                      利用已知威胁情报库进行匹配，快速识别已知威胁
                    </div>
                    <div class="progress-wrapper">
                      <el-progress :percentage="70" :show-text="false" class="cyber-progress"></el-progress>
                      <span class="progress-value">准确率: 70%</span>
                    </div>
                  </div>
                </div>
              </div>
            </el-col>
            <el-col :span="12">
              <div class="method-card">
                <div class="method-content">
                  <div class="method-icon">
                    <i class="el-icon-cpu"></i>
                  </div>
                  <div class="method-info">
                    <div class="method-title">
                      <span class="title-text">基于深度学习</span>
                      <div class="cyber-tag">AI驱动</div>
                    </div>
                    <div class="method-desc">
                      通过深度学习模型分析，识别未知威胁模式
                    </div>
                    <div class="progress-wrapper">
                      <el-progress :percentage="85" :show-text="false" class="cyber-progress"></el-progress>
                      <span class="progress-value">准确率: 85%</span>
                    </div>
                  </div>
                </div>
              </div>
            </el-col>
          </el-row>
        </div>
      </el-col>
    </el-row>

    <!-- 实时检测结果 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="24">
        <div class="cyber-card detection-results">
          <div class="cyber-card-header">
            <div class="header-title">
              <i class="el-icon-view"></i>
              <span>实时检测结果</span>
            </div>
            <div class="header-operations">
              <span class="refresh-time">最后更新: {{ lastUpdateTime }}</span>
              <i class="el-icon-refresh refresh-icon" @click="refreshData"></i>
            </div>
            <div class="cyber-line"></div>
          </div>
          <el-table 
            :data="pagedDetectionResults" 
            style="width: 100%"
            class="cyber-table">
            <el-table-column prop="timestamp" label="时间" width="180">
              <template slot-scope="scope">
                <div class="cyber-cell">
                  <i class="el-icon-time"></i>
                  <span>{{ scope.row.timestamp }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="type" label="检测类型" width="180">
              <template slot-scope="scope">
                <div class="cyber-tag" :class="scope.row.type === '威胁情报' ? 'info' : 'success'">
                  {{ scope.row.type }}
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="threat" label="威胁描述">
              <template slot-scope="scope">
                <div class="cyber-cell threat-cell">
                  <i class="el-icon-warning" style="color: #E6A23C"></i>
                  <span>{{ scope.row.threat }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="confidence" label="置信度" width="220">
              <template slot-scope="scope">
                <div class="confidence-wrapper">
                  <el-progress
                    :percentage="scope.row.confidence"
                    :color="getConfidenceColor(scope.row.confidence)"
                    :show-text="false"
                    class="cyber-progress"
                  ></el-progress>
                  <span class="confidence-value">{{ scope.row.confidence }}%</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="180">
              <template slot-scope="scope">
                <div class="cyber-buttons">
                  <el-button
                    size="mini"
                    type="primary"
                    class="cyber-button"
                    @click="handleDetail(scope.row)"
                  >详情</el-button>
                  <el-button
                    size="mini"
                    type="danger"
                    class="cyber-button"
                    @click="handleBlock(scope.row)"
                  >拦截</el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
          <div class="pagination-container">
            <el-pagination
              background
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
              :current-page="currentPage"
              :page-sizes="[10, 20, 30, 50]"
              :page-size="pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="detectionResults.length">
            </el-pagination>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 威胁分布统计 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <div class="cyber-card chart-card">
          <div class="cyber-card-header">
            <div class="header-title">
              <i class="el-icon-pie-chart"></i>
              <span>威胁类型分布</span>
            </div>
            <div class="cyber-line"></div>
          </div>
          <div id="threatTypeChart" style="height: 300px"></div>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="cyber-card chart-card">
          <div class="cyber-card-header">
            <div class="header-title">
              <i class="el-icon-data-analysis"></i>
              <span>检测方法效果对比</span>
            </div>
            <div class="cyber-line"></div>
          </div>
          <div id="detectionMethodChart" style="height: 300px"></div>
        </div>
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
      detectionResults: [],
      threatTypeChart: null,
      detectionMethodChart: null,
      timer: null,
      lastUpdateTime: new Date().toLocaleString(),
      // 分页相关
      currentPage: 1,
      pageSize: 10
    }
  },
  computed: {
    pagedDetectionResults() {
      const start = (this.currentPage - 1) * this.pageSize;
      const end = start + this.pageSize;
      return this.detectionResults.slice(start, end);
    }
  },
  mounted() {
    this.initCharts()
    this.generateInitialData()
    this.startAutoRefresh()
  },
  beforeDestroy() {
    this.clearAutoRefresh()
  },
  methods: {
    generateInitialData() {
      // 生成初始的30条数据
      for(let i = 0; i < 30; i++) {
        this.detectionResults.push({
          timestamp: new Date(Date.now() - i * 60000).toLocaleString(),
          type: Math.random() > 0.5 ? '威胁情报' : '深度学习',
          threat: this.getRandomThreat(),
          confidence: Math.floor(Math.random() * 30) + 70
        });
      }
    },
    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1;
    },
    handleCurrentChange(val) {
      this.currentPage = val;
    },
    startAutoRefresh() {
      this.timer = setInterval(() => {
        this.refreshData()
      }, 30000)
    },
    clearAutoRefresh() {
      if (this.timer) {
        clearInterval(this.timer)
        this.timer = null
      }
    },
    async refreshData() {
      const newDetection = {
        timestamp: new Date().toLocaleString(),
        type: Math.random() > 0.5 ? '威胁情报' : '深度学习',
        threat: this.getRandomThreat(),
        confidence: Math.floor(Math.random() * 30) + 70
      }
      
      this.detectionResults.unshift(newDetection)
      
      // 保持最多显示100条记录
      if (this.detectionResults.length > 100) {
        this.detectionResults = this.detectionResults.slice(0, 100)
      }
      
      this.lastUpdateTime = new Date().toLocaleString()
      this.updateCharts()
      
      this.$notify({
        title: '检测更新',
        message: `发现新的威胁: ${newDetection.threat}`,
        type: 'warning',
        duration: 3000,
        customClass: 'cyber-notification'
      })
    },
    getRandomThreat() {
      const threats = [
        '检测到可疑的DNS隧道通信',
        '发现未知来源的扫描行为',
        '检测到异常的数据外传行为',
        '发现可疑的命令控制通信',
        '检测到暴力破解尝试',
        '发现未授权的API访问',
        '检测到异常的加密流量',
        '发现可疑的文件下载行为'
      ]
      return threats[Math.floor(Math.random() * threats.length)]
    },
    getConfidenceColor(confidence) {
      if (confidence >= 90) return {
        '100%': '#67C23A',
        '0%': '#95de64'
      }
      if (confidence >= 70) return {
        '100%': '#409EFF',
        '0%': '#69b1ff'
      }
      if (confidence >= 50) return {
        '100%': '#E6A23C',
        '0%': '#f3d19e'
      }
      return {
        '100%': '#F56C6C',
        '0%': '#fab6b6'
      }
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
        // 从列表中移除该威胁
        const index = this.detectionResults.indexOf(row)
        if (index > -1) {
          this.detectionResults.splice(index, 1)
        }
        this.$message.success('已成功拦截威胁')
      }).catch(() => {})
    },
    initCharts() {
      // 初始化威胁类型分布图表
      this.threatTypeChart = echarts.init(document.getElementById('threatTypeChart'))
      this.threatTypeChart.setOption({
        backgroundColor: 'transparent',
        title: {
          text: '威胁类型分布',
          left: 'center',
          textStyle: {
            color: '#fff'
          }
        },
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          left: 'left',
          textStyle: {
            color: '#8f9bb3'
          }
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
            },
            itemStyle: {
              normal: {
                color: function(params) {
                  const colorList = ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C', '#909399']
                  return colorList[params.dataIndex]
                }
              }
            }
          }
        ]
      })

      // 初始化检测方法效果对比图表
      this.detectionMethodChart = echarts.init(document.getElementById('detectionMethodChart'))
      this.detectionMethodChart.setOption({
        backgroundColor: 'transparent',
        title: {
          text: '检测方法效果对比',
          left: 'center',
          textStyle: {
            color: '#fff'
          }
        },
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: ['威胁情报', '深度学习'],
          bottom: 0,
          textStyle: {
            color: '#8f9bb3'
          }
        },
        xAxis: {
          type: 'category',
          data: ['准确率', '召回率', '检测速度', '误报率'],
          axisLine: {
            lineStyle: {
              color: '#8f9bb3'
            }
          },
          axisLabel: {
            color: '#8f9bb3'
          }
        },
        yAxis: {
          type: 'value',
          max: 100,
          axisLine: {
            lineStyle: {
              color: '#8f9bb3'
            }
          },
          axisLabel: {
            color: '#8f9bb3'
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(255, 255, 255, 0.1)'
            }
          }
        },
        series: [
          {
            name: '威胁情报',
            type: 'bar',
            data: [85, 78, 90, 15],
            itemStyle: {
              color: '#409EFF'
            }
          },
          {
            name: '深度学习',
            type: 'bar',
            data: [92, 88, 75, 8],
            itemStyle: {
              color: '#67C23A'
            }
          }
        ]
      })

      // 监听窗口大小变化，调整图表大小
      window.addEventListener('resize', () => {
        this.threatTypeChart && this.threatTypeChart.resize()
        this.detectionMethodChart && this.detectionMethodChart.resize()
      })
    },
    updateCharts() {
      // 更新图表数据（这里可以根据实际需求更新图表数据）
      if (this.threatTypeChart && this.detectionMethodChart) {
        this.threatTypeChart.setOption({
          series: [{
            data: [
              { value: Math.floor(Math.random() * 20) + 30, name: 'DNS攻击' },
              { value: Math.floor(Math.random() * 20) + 20, name: 'DDoS攻击' },
              { value: Math.floor(Math.random() * 20) + 15, name: '恶意扫描' },
              { value: Math.floor(Math.random() * 15) + 10, name: '数据泄露' },
              { value: Math.floor(Math.random() * 5) + 5, name: '其他' }
            ]
          }]
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.cyber-theme {
  background: linear-gradient(135deg, #1a1f3c 0%, #0a0f1f 100%);
  min-height: 100vh;
  padding: 20px;
  color: #e4e9f2;
  position: relative;
  overflow-y: auto;
  height: calc(100vh - 50px);

  // 添加科技感网格背景
  &::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image: 
      linear-gradient(rgba(64, 158, 255, 0.05) 1px, transparent 1px),
      linear-gradient(90deg, rgba(64, 158, 255, 0.05) 1px, transparent 1px);
    background-size: 20px 20px;
    pointer-events: none;
    animation: gridMove 15s linear infinite;
  }

  // 添加浮动粒子效果
  &::after {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: radial-gradient(circle at 50% 50%, rgba(64, 158, 255, 0.1) 0%, transparent 50%);
    animation: pulseBackground 4s ease-in-out infinite;
    pointer-events: none;
  }

  .cyber-card {
    background: rgba(16, 22, 36, 0.85);
    border: 1px solid rgba(64, 158, 255, 0.3);
    border-radius: 12px;
    box-shadow: 
      0 0 20px rgba(64, 158, 255, 0.1),
      inset 0 0 15px rgba(64, 158, 255, 0.05);
    backdrop-filter: blur(10px);
    position: relative;
    overflow: hidden;
    padding: 20px;
    margin-bottom: 20px;
    transition: all 0.3s ease;

    // 添加霓虹边框效果
    &::before {
      content: '';
      position: absolute;
      top: -2px;
      left: -2px;
      right: -2px;
      bottom: -2px;
      background: linear-gradient(45deg, 
        rgba(64, 158, 255, 0.5),
        rgba(103, 194, 58, 0.5),
        rgba(64, 158, 255, 0.5));
      border-radius: 12px;
      z-index: -1;
      animation: borderGlow 3s linear infinite;
    }

    // 添加扫描线效果
    &::after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: linear-gradient(90deg, 
        transparent,
        rgba(64, 158, 255, 0.8),
        transparent);
      animation: scanLine 2s linear infinite;
    }

    &:hover {
      transform: translateY(-2px);
      box-shadow: 
        0 5px 30px rgba(64, 158, 255, 0.2),
        inset 0 0 20px rgba(64, 158, 255, 0.1);
    }

    .cyber-card-header {
      .header-title {
        i {
          animation: pulseIcon 2s infinite;
        }
      }
    }
  }

  .method-card {
    background: rgba(25, 35, 55, 0.7);
    border: 1px solid rgba(64, 158, 255, 0.3);
    border-radius: 12px;
    transition: all 0.3s;
    height: 100%;
    position: relative;
    overflow: hidden;

    // 添加高光效果
    &::before {
      content: '';
      position: absolute;
      top: -50%;
      left: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(
        circle at center,
        rgba(64, 158, 255, 0.1) 0%,
        transparent 70%
      );
      animation: rotateHighlight 10s linear infinite;
    }

    .method-icon {
      position: relative;
      &::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: radial-gradient(circle at center, rgba(64, 158, 255, 0.2), transparent);
        animation: pulseIconBg 2s infinite;
      }
    }
  }

  .cyber-table {
    .el-table__body-wrapper tr {
      transition: all 0.3s ease;
      
      &:hover > td {
        background: rgba(64, 158, 255, 0.15) !important;
        transform: scale(1.01);
      }
    }
  }

  .cyber-button {
    &::after {
      content: '';
      position: absolute;
      top: -50%;
      left: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(
        circle at center,
        rgba(255, 255, 255, 0.2) 0%,
        transparent 70%
      );
      opacity: 0;
      transition: opacity 0.3s;
    }

    &:hover::after {
      opacity: 1;
    }
  }
}

// 添加动画关键帧
@keyframes gridMove {
  from { background-position: 0 0; }
  to { background-position: 20px 20px; }
}

@keyframes pulseBackground {
  0%, 100% { opacity: 0.5; }
  50% { opacity: 1; }
}

@keyframes borderGlow {
  0%, 100% { opacity: 0.5; }
  50% { opacity: 1; }
}

@keyframes scanLine {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}

@keyframes pulseIcon {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

@keyframes rotateHighlight {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes pulseIconBg {
  0%, 100% { opacity: 0.5; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.1); }
}

.cyber-theme {
  .cyber-card {
    background: rgba(16, 22, 36, 0.8);
    border: 1px solid rgba(64, 158, 255, 0.2);
    border-radius: 8px;
    box-shadow: 0 0 20px rgba(64, 158, 255, 0.1);
    backdrop-filter: blur(10px);
    position: relative;
    overflow: hidden;
    padding: 20px;
    margin-bottom: 20px;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 2px;
      background: linear-gradient(90deg, transparent, rgba(64, 158, 255, 0.5), transparent);
    }

    .cyber-card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      position: relative;

      .header-title {
        display: flex;
        align-items: center;
        gap: 10px;
        color: #fff;
        font-size: 18px;
        font-weight: 500;

        i {
          color: #409EFF;
          font-size: 20px;
        }
      }

      .cyber-line {
        position: absolute;
        bottom: -10px;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, #409EFF 0%, transparent 100%);
      }
    }
  }

  .method-card {
    background: rgba(25, 35, 55, 0.5);
    border: 1px solid rgba(64, 158, 255, 0.2);
    border-radius: 8px;
    transition: all 0.3s;
    height: 100%;
    position: relative;
    overflow: hidden;

    &:hover {
      transform: translateY(-5px);
      border-color: #409EFF;
      box-shadow: 0 5px 15px rgba(64, 158, 255, 0.2);

      &::after {
        transform: translateX(100%);
      }
    }

    &::after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(
        90deg,
        transparent,
        rgba(64, 158, 255, 0.2),
        transparent
      );
      transform: translateX(-100%);
      transition: transform 0.5s ease;
    }

    .method-content {
      display: flex;
      align-items: flex-start;
      gap: 20px;
      padding: 20px;
      position: relative;
      z-index: 1;
    }

    .method-icon {
      font-size: 48px;
      color: #409EFF;
      padding: 20px;
      background: rgba(64, 158, 255, 0.1);
      border-radius: 12px;
      border: 1px solid rgba(64, 158, 255, 0.3);
    }

    .method-info {
      flex: 1;
    }

    .method-title {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 10px;

      .title-text {
        font-size: 18px;
        font-weight: bold;
        color: #fff;
        text-shadow: 0 0 10px rgba(64, 158, 255, 0.3);
      }
    }

    .cyber-tag {
      background: rgba(64, 158, 255, 0.1);
      border: 1px solid rgba(64, 158, 255, 0.3);
      color: #409EFF;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 12px;

      &.success {
        background: rgba(103, 194, 58, 0.1);
        border-color: rgba(103, 194, 58, 0.3);
        color: #67C23A;
      }

      &.info {
        background: rgba(64, 158, 255, 0.1);
        border-color: rgba(64, 158, 255, 0.3);
        color: #409EFF;
      }
    }
  }

  .cyber-table {
    background: transparent;
    
    &::before {
      display: none;
    }

    .el-table__header-wrapper {
      th {
        background: rgba(25, 35, 55, 0.5);
        border-bottom: 1px solid rgba(64, 158, 255, 0.2);
        color: #8f9bb3;
      }
    }

    .el-table__body-wrapper {
      tr {
        background: transparent;
        
        &:hover > td {
          background: rgba(64, 158, 255, 0.1) !important;
        }
      }

      td {
        border-bottom: 1px solid rgba(64, 158, 255, 0.1);
        color: #e4e9f2;
      }
    }
  }

  .cyber-cell {
    display: flex;
    align-items: center;
    gap: 8px;

    i {
      color: #409EFF;
    }
  }

  .threat-cell {
    i {
      color: #E6A23C;
    }
  }

  .confidence-wrapper {
    display: flex;
    align-items: center;
    gap: 10px;

    .cyber-progress {
      flex: 1;
    }

    .confidence-value {
      min-width: 45px;
      color: #8f9bb3;
    }
  }

  .cyber-button {
    background: transparent;
    border: 1px solid;
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(
        90deg,
        transparent,
        rgba(255, 255, 255, 0.1),
        transparent
      );
      transform: translateX(-100%);
      transition: transform 0.3s ease;
    }

    &:hover::before {
      transform: translateX(100%);
    }

    &.el-button--primary {
      border-color: #409EFF;
      color: #409EFF;

      &:hover {
        background: rgba(64, 158, 255, 0.1);
      }
    }

    &.el-button--danger {
      border-color: #F56C6C;
      color: #F56C6C;

      &:hover {
        background: rgba(245, 108, 108, 0.1);
      }
    }
  }

  .pagination-container {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;

    .el-pagination {
      background: transparent;
      
      .btn-prev,
      .btn-next,
      .el-pager li {
        background: rgba(25, 35, 55, 0.5);
        border: 1px solid rgba(64, 158, 255, 0.2);
        color: #8f9bb3;

        &:hover {
          color: #409EFF;
        }

        &.active {
          background: rgba(64, 158, 255, 0.1);
          color: #409EFF;
          border-color: #409EFF;
        }
      }
    }
  }
}

// 添加全局样式
:deep(.el-progress-bar__outer) {
  background-color: rgba(255, 255, 255, 0.1) !important;
  border-radius: 4px;
}

:deep(.el-progress-bar__inner) {
  border-radius: 4px;
  transition: all 0.3s ease;
}

:deep(.cyber-notification) {
  background: rgba(16, 22, 36, 0.9);
  border: 1px solid rgba(64, 158, 255, 0.2);
  backdrop-filter: blur(10px);
  color: #e4e9f2;

  .el-notification__title {
    color: #fff;
  }

  .el-notification__content {
    color: #8f9bb3;
  }
}

// 添加全局滚动条样式
:deep(::-webkit-scrollbar) {
  width: 6px;
  height: 6px;
}

:deep(::-webkit-scrollbar-track) {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 3px;
}

:deep(::-webkit-scrollbar-thumb) {
  background: rgba(64, 158, 255, 0.3);
  border-radius: 3px;
  
  &:hover {
    background: rgba(64, 158, 255, 0.5);
  }
}

// 确保表格内容可以滚动
.cyber-table {
  .el-table__body-wrapper {
    max-height: 500px;
    overflow-y: auto;
  }
}
</style>