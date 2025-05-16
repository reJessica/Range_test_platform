<template>
  <div class="app-container">
    <!-- 添加工具栏 -->
    <div class="toolbar">
      <el-button-group>
        <el-button type="primary" size="small" icon="el-icon-refresh" @click="refreshData">刷新数据</el-button>
        <el-button type="success" size="small" icon="el-icon-download" @click="exportData">导出报表</el-button>
        <el-button type="warning" size="small" icon="el-icon-setting" @click="showSettings">监控设置</el-button>
      </el-button-group>
      
      <div class="time-range">
        <el-date-picker
          v-model="timeRange"
          type="datetimerange"
          size="small"
          range-separator="至"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          :picker-options="pickerOptions"
          @change="handleTimeRangeChange">
        </el-date-picker>
      </div>
    </div>

    <!-- 顶部统计卡片 -->
    <div class="stat-cards">
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-document"></i></div>
        <div class="stat-value">0</div>
        <div class="stat-label">监控事件总数</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-warning"></i></div>
        <div class="stat-value">17</div>
        <div class="stat-label">已处理告警</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-bell"></i></div>
        <div class="stat-value">7</div>
        <div class="stat-label">待处理告警</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-s-data"></i></div>
        <div class="stat-value">8</div>
        <div class="stat-label">流量异常</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-warning-outline"></i></div>
        <div class="stat-value">6</div>
        <div class="stat-label">DNS异常</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-message"></i></div>
        <div class="stat-value">0</div>
        <div class="stat-label">DNS反向查询</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-warning"></i></div>
        <div class="stat-value">0</div>
        <div class="stat-label">运营商检测</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-s-platform"></i></div>
        <div class="stat-value">8</div>
        <div class="stat-label">ICMP检测</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-s-help"></i></div>
        <div class="stat-value">3</div>
        <div class="stat-label">IP归属地</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon"><i class="el-icon-s-marketing"></i></div>
        <div class="stat-value">3</div>
        <div class="stat-label">端口扫描</div>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 左侧面板 -->
      <div class="left-panel">
        <div class="panel-header">
          <div class="title">Top10流量目标IP分布</div>
          <div class="actions">
            <el-button-group>
              <el-button 
                size="mini" 
                :type="activeTab === 'events' ? 'primary' : 'text'"
                @click="switchTab('events')">
                监控事件 ({{ stats.totalEvents }})
              </el-button>
              <el-button 
                size="mini" 
                :type="activeTab === 'threats' ? 'primary' : 'text'"
                @click="switchTab('threats')">
                威胁 ({{ stats.pendingAlerts }})
              </el-button>
              <el-button 
                size="mini" 
                :type="activeTab === 'security' ? 'primary' : 'text'"
                @click="switchTab('security')">
                安全检查 ({{ stats.icmpDetections }})
              </el-button>
              <el-button 
                size="mini" 
                :type="activeTab === 'analysis' ? 'primary' : 'text'"
                @click="switchTab('analysis')">
                安全性 ({{ stats.portScans }})
              </el-button>
            </el-button-group>
            <div class="refresh-btn" :class="{ rotating: isRefreshing }" @click="refreshData">
              <i class="el-icon-refresh"></i>
            </div>
          </div>
        </div>
        
        <!-- 桑基图 -->
        <div class="chart-container">
          <div class="sankey-chart" ref="sankeyChart"></div>
        </div>
        
        <!-- 趋势图 -->
        <div class="trend-chart-container">
          <div class="chart-title">事件时间趋势</div>
          <div class="trend-chart" ref="trendChart"></div>
        </div>
      </div>

      <!-- 右侧面板 -->
      <div class="right-panel">
        <div class="gauge-container">
          <div class="gauge-title">1分钟</div>
          <div class="gauge-chart" ref="gaugeChart"></div>
        </div>

        <div class="events-list">
          <div class="list-header">
            <span>待处理事件 (59)</span>
          </div>
          <div class="list-content">
            <div v-for="event in events" :key="event.id" class="event-item">
              <div class="source">
                <span class="ip">{{ event.sourceIp }}</span>
                <el-tag :type="event.type" size="mini">{{ event.status }}</el-tag>
              </div>
              <div class="target">
                <i class="el-icon-arrow-right"></i>
                <span class="ip">{{ event.targetIp }}</span>
              </div>
              <div class="event-id" @click="goToDetail(event.id)" style="cursor: pointer;">
                <el-link type="primary">#{{ event.id }}</el-link>
              </div>
            </div>
          </div>
          <div class="pagination">
            <el-pagination
              small
              layout="prev, pager, next"
              :total="50"
              :page-size="10">
            </el-pagination>
          </div>
        </div>
      </div>
    </div>

    <!-- 流量报文监控区域 -->
    <div class="packet-monitor">
      <!-- ... existing packet monitor content ... -->
    </div>

    <!-- 添加流量异常警告组件 -->
    <transition name="fade">
      <div v-if="showWarning" class="traffic-warning">
        <i class="el-icon-warning warning-icon"></i>
        <span>检测到异常流量！</span>
      </div>
    </transition>

    <!-- 添加数据更新提示 -->
    <div class="data-update-indicator" :class="{ visible: isUpdating }">
      <span>正在更新数据</span>
      <div class="loading-dot"></div>
      <div class="loading-dot"></div>
      <div class="loading-dot"></div>
    </div>

    <!-- 设置对话框 -->
    <el-dialog title="监控设置" :visible.sync="settingsVisible" width="500px">
      <el-form :model="monitorSettings" label-width="120px">
        <el-form-item label="更新频率(秒)">
          <el-input-number v-model="monitorSettings.updateInterval" :min="1" :max="60"></el-input-number>
        </el-form-item>
        <el-form-item label="流量告警阈值">
          <el-input-number v-model="monitorSettings.trafficThreshold" :min="100" :max="10000" label="Mbps"></el-input-number>
        </el-form-item>
        <el-form-item label="告警等级">
          <el-select v-model="monitorSettings.alertLevel" placeholder="请选择告警等级">
            <el-option label="低" value="low"></el-option>
            <el-option label="中" value="medium"></el-option>
            <el-option label="高" value="high"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="监控项">
          <el-checkbox-group v-model="monitorSettings.enabledMonitors">
            <el-checkbox label="traffic">流量监控</el-checkbox>
            <el-checkbox label="dns">DNS监控</el-checkbox>
            <el-checkbox label="port">端口监控</el-checkbox>
            <el-checkbox label="ip">IP监控</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="settingsVisible = false">取消</el-button>
        <el-button type="primary" @click="saveSettings">保存</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'NetTraffic',
  data() {
    return {
      events: [
        { id: '7249', sourceIp: '192.168.1.178', targetIp: '47.98.148.7', type: 'danger', status: '异常流量' },
        { id: '7203', sourceIp: '192.168.1.178', targetIp: '47.98.148.7', type: 'danger', status: '异常连接' },
        { id: '7273', sourceIp: '192.168.1.198', targetIp: '10.10.10.21', type: 'warning', status: '可疑行为' },
        { id: '7283', sourceIp: '192.168.1.198', targetIp: '10.10.10.21', type: 'danger', status: '异常流量' },
        { id: '7293', sourceIp: '192.168.1.224', targetIp: '192.168.1.225', type: 'warning', status: '可疑扫描' }
      ],
      charts: {
        sankey: null,
        trend: null,
        gauge: null
      },
      stats: {
        totalEvents: 0,
        handledAlerts: 17,
        pendingAlerts: 7,
        trafficAnomalies: 8,
        dnsAnomalies: 6,
        dnsReverseLookups: 0,
        ispDetections: 0,
        icmpDetections: 8,
        ipGeolocation: 3,
        portScans: 3
      },
      trafficData: {
        inbound: [],
        outbound: [],
        anomalies: []
      },
      updateInterval: null,
      alertThresholds: {
        trafficSpike: 1000, // Mbps
        connectionRate: 100, // 连接/秒
        errorRate: 5 // 错误率百分比
      },
      showWarning: false,
      isUpdating: false,
      activeTab: 'events',
      isRefreshing: false,
      settingsVisible: false,
      timeRange: [],
      monitorSettings: {
        updateInterval: 5,
        trafficThreshold: 1000,
        alertLevel: 'medium',
        enabledMonitors: ['traffic', 'dns', 'port', 'ip']
      },
      pickerOptions: {
        shortcuts: [{
          text: '最近1小时',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近6小时',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 6);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近24小时',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24);
            picker.$emit('pick', [start, end]);
          }
        }]
      },
      sankeyData: {
        events: {
          nodes: [
            { name: 'hadoop.top' },
            { name: '异常连接' },
            { name: 'DNS查询' },
            { name: '10.6.5.101' },
            { name: '10.10.10.21' },
            { name: '192.168.1.105' }
          ],
          links: [
            { source: 'hadoop.top', target: '异常连接', value: 5 },
            { source: '异常连接', target: '10.6.5.101', value: 3 },
            { source: 'DNS查询', target: '10.10.10.21', value: 4 },
            { source: 'DNS查询', target: '192.168.1.105', value: 2 }
          ]
        },
        threats: {
          nodes: [
            { name: 'SQL注入' },
            { name: 'XSS攻击' },
            { name: '恶意IP' },
            { name: '192.168.1.100' },
            { name: '10.10.10.50' }
          ],
          links: [
            { source: 'SQL注入', target: '192.168.1.100', value: 3 },
            { source: 'XSS攻击', target: '10.10.10.50', value: 4 },
            { source: '恶意IP', target: '192.168.1.100', value: 2 }
          ]
        },
        security: {
          nodes: [
            { name: '端口扫描' },
            { name: '漏洞探测' },
            { name: '配置错误' },
            { name: '172.16.1.100' },
            { name: '192.168.2.200' }
          ],
          links: [
            { source: '端口扫描', target: '172.16.1.100', value: 6 },
            { source: '漏洞探测', target: '192.168.2.200', value: 3 },
            { source: '配置错误', target: '172.16.1.100', value: 2 }
          ]
        },
        analysis: {
          nodes: [
            { name: '异常流量' },
            { name: '可疑行为' },
            { name: '未知协议' },
            { name: '10.0.0.100' },
            { name: '192.168.3.300' }
          ],
          links: [
            { source: '异常流量', target: '10.0.0.100', value: 5 },
            { source: '可疑行为', target: '192.168.3.300', value: 4 },
            { source: '未知协议', target: '10.0.0.100', value: 3 }
          ]
        }
      }
    }
  },
  mounted() {
    this.initCharts()
    this.startRealTimeUpdates()
  },
  methods: {
    startRealTimeUpdates() {
      this.updateInterval = setInterval(() => {
        this.updateTrafficData()
        this.updateStats()
        this.detectAnomalies()
        this.updateCharts()
      }, 5000)
    },
    
    updateTrafficData() {
      this.isUpdating = true
      
      const now = new Date()
      const inTraffic = this.generateTrafficData()
      const outTraffic = this.generateTrafficData()
      
      this.trafficData.inbound.push({
        time: now,
        value: inTraffic
      })
      this.trafficData.outbound.push({
        time: now,
        value: outTraffic
      })
      
      if (this.trafficData.inbound.length > 360) {
        this.trafficData.inbound.shift()
        this.trafficData.outbound.shift()
      }
      
      if (inTraffic > this.alertThresholds.trafficSpike || 
          outTraffic > this.alertThresholds.trafficSpike) {
        this.showWarning = true
        setTimeout(() => {
          this.showWarning = false
        }, 3000)
      }
      
      setTimeout(() => {
        this.isUpdating = false
      }, 1000)
    },
    
    generateTrafficData() {
      const baseTraffic = 500
      const variation = Math.random() * 200 - 100
      return Math.max(0, baseTraffic + variation)
    },
    
    detectAnomalies() {
      const latestInbound = this.trafficData.inbound[this.trafficData.inbound.length - 1]
      const latestOutbound = this.trafficData.outbound[this.trafficData.outbound.length - 1]
      
      if (latestInbound.value > this.alertThresholds.trafficSpike) {
        this.addAnomaly('入站流量异常', latestInbound.value, 'danger')
      }
      if (latestOutbound.value > this.alertThresholds.trafficSpike) {
        this.addAnomaly('出站流量异常', latestOutbound.value, 'danger')
      }
      
      this.stats.trafficAnomalies = this.trafficData.anomalies.length
    },
    
    addAnomaly(type, value, severity) {
      const anomaly = {
        id: Date.now().toString(),
        time: new Date(),
        type,
        value,
        severity,
        sourceIp: this.generateRandomIp(),
        targetIp: this.generateRandomIp()
      }
      
      this.trafficData.anomalies.push(anomaly)
      this.events.unshift({
        id: anomaly.id,
        sourceIp: anomaly.sourceIp,
        targetIp: anomaly.targetIp,
        type: severity,
        status: type
      })
      
      if (this.events.length > 5) {
        this.events.pop()
      }
    },
    
    generateRandomIp() {
      return Array(4).fill(0).map(() => Math.floor(Math.random() * 256)).join('.')
    },
    
    updateStats() {
      this.stats.totalEvents++
      this.stats.handledAlerts = Math.min(this.stats.handledAlerts + Math.floor(Math.random() * 2), 100)
      this.stats.pendingAlerts = Math.max(0, this.stats.pendingAlerts + Math.floor(Math.random() * 3) - 1)
      
      document.querySelectorAll('.stat-card').forEach((card, index) => {
        const value = card.querySelector('.stat-value')
        if (value) {
          switch (index) {
            case 0: value.textContent = this.stats.totalEvents; break
            case 1: value.textContent = this.stats.handledAlerts; break
            case 2: value.textContent = this.stats.pendingAlerts; break
            case 3: value.textContent = this.stats.trafficAnomalies; break
            case 4: value.textContent = this.stats.dnsAnomalies; break
            case 5: value.textContent = this.stats.dnsReverseLookups; break
            case 6: value.textContent = this.stats.ispDetections; break
            case 7: value.textContent = this.stats.icmpDetections; break
            case 8: value.textContent = this.stats.ipGeolocation; break
            case 9: value.textContent = this.stats.portScans; break
          }
        }
      })
    },
    
    initCharts() {
      this.$nextTick(() => {
        this.initSankeyChart()
        this.initTrendChart()
        this.initGaugeChart()
      })
    },
    initSankeyChart() {
      this.charts.sankey = echarts.init(this.$refs.sankeyChart)
      const option = {
        tooltip: {
          trigger: 'item',
          triggerOn: 'mousemove'
        },
        series: {
          type: 'sankey',
          layout: 'none',
          emphasis: {
            focus: 'adjacency'
          },
          data: this.sankeyData.events.nodes,
          links: this.sankeyData.events.links,
          lineStyle: {
            color: 'gradient',
            curveness: 0.5
          },
          itemStyle: {
            color: '#1890ff',
            borderColor: '#1890ff'
          },
          label: {
            color: '#fff',
            fontWeight: 'bold'
          }
        }
      }
      this.charts.sankey.setOption(option)
    },
    initTrendChart() {
      this.charts.trend = echarts.init(this.$refs.trendChart)
      const option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross',
            label: {
              backgroundColor: '#6a7985'
            }
          }
        },
        legend: {
          data: ['入站流量', '出站流量'],
          textStyle: {
            color: '#fff'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'time',
          boundaryGap: false,
          axisLine: {
            lineStyle: {
              color: '#eee'
            }
          }
        },
        yAxis: {
          type: 'value',
          name: '流量 (Mbps)',
          nameTextStyle: {
            color: '#fff'
          },
          axisLine: {
            lineStyle: {
              color: '#eee'
            }
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(255,255,255,0.1)'
            }
          }
        },
        series: [
          {
            name: '入站流量',
            type: 'line',
            stack: 'Total',
            areaStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: 'rgba(64,158,255,0.5)' },
                { offset: 1, color: 'rgba(64,158,255,0.1)' }
              ])
            },
            emphasis: {
              focus: 'series'
            },
            data: []
          },
          {
            name: '出站流量',
            type: 'line',
            stack: 'Total',
            areaStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: 'rgba(255,158,64,0.5)' },
                { offset: 1, color: 'rgba(255,158,64,0.1)' }
              ])
            },
            emphasis: {
              focus: 'series'
            },
            data: []
          }
        ]
      }
      this.charts.trend.setOption(option)
    },
    initGaugeChart() {
      this.charts.gauge = echarts.init(this.$refs.gaugeChart)
      const option = {
        series: [{
          type: 'gauge',
          startAngle: 180,
          endAngle: 0,
          min: 0,
          max: 100,
          splitNumber: 10,
          axisLine: {
            lineStyle: {
              width: 30,
              color: [
                [0.3, '#67e0e3'],
                [0.7, '#37a2da'],
                [1, '#fd666d']
              ]
            }
          },
          pointer: {
            itemStyle: {
              color: 'auto'
            }
          },
          axisTick: {
            distance: -30,
            length: 8,
            lineStyle: {
              color: '#fff',
              width: 2
            }
          },
          splitLine: {
            distance: -30,
            length: 30,
            lineStyle: {
              color: '#fff',
              width: 2
            }
          },
          axisLabel: {
            color: '#fff',
            distance: -40,
            fontSize: 12
          },
          detail: {
            valueAnimation: true,
            formatter: '{value}%',
            color: '#fff',
            fontSize: 30,
            offsetCenter: [0, '-15%']
          },
          data: [{
            value: 0,
            name: '处理速度'
          }]
        }]
      }
      this.charts.gauge.setOption(option)
    },
    updateCharts() {
      const trendOption = {
        series: [
          {
            data: this.trafficData.inbound.map(item => [item.time, item.value])
          },
          {
            data: this.trafficData.outbound.map(item => [item.time, item.value])
          }
        ]
      }
      this.charts.trend.setOption(trendOption)
      
      const gaugeValue = Math.floor(Math.random() * 100)
      const gaugeOption = {
        series: [{
          data: [{
            value: gaugeValue,
            name: '处理速度'
          }]
        }]
      }
      this.charts.gauge.setOption(gaugeOption)
    },
    goToDetail(id) {
      this.$router.push(`/monitor/nettraffic/detail/${id}`);
    },
    switchTab(tab) {
      this.activeTab = tab;
      // 根据不同tab加载相应数据
      switch(tab) {
        case 'events':
          this.loadEventData();
          break;
        case 'threats':
          this.loadThreatData();
          break;
        case 'security':
          this.loadSecurityData();
          break;
        case 'analysis':
          this.loadAnalysisData();
          break;
      }
    },

    refreshData() {
      this.isRefreshing = true;
      // 更新所有数据
      this.updateTrafficData();
      this.updateStats();
      this.detectAnomalies();
      this.updateCharts();
      
      setTimeout(() => {
        this.isRefreshing = false;
        this.$message.success('数据已更新');
      }, 1000);
    },

    exportData() {
      // 导出当前数据为Excel
      const data = {
        stats: this.stats,
        events: this.events,
        trafficData: this.trafficData
      };
      
      // 这里应该调用后端API进行导出
      this.$message.success('报表导出中，请稍候...');
    },

    showSettings() {
      this.settingsVisible = true;
    },

    saveSettings() {
      // 保存设置
      if (this.updateInterval) {
        clearInterval(this.updateInterval);
      }
      
      // 使用新的更新频率
      this.updateInterval = setInterval(() => {
        this.updateTrafficData();
        this.updateStats();
        this.detectAnomalies();
        this.updateCharts();
      }, this.monitorSettings.updateInterval * 1000);

      // 更新告警阈值
      this.alertThresholds.trafficSpike = this.monitorSettings.trafficThreshold;

      this.settingsVisible = false;
      this.$message.success('设置已保存');
    },

    handleTimeRangeChange(range) {
      if (!range) return;
      
      const [start, end] = range;
      // 根据时间范围加载历史数据
      this.loadHistoricalData(start, end);
    },

    loadEventData() {
      // 加载监控事件数据
      this.$message.info('正在加载监控事件数据...');
    },

    loadThreatData() {
      // 加载威胁数据
      this.$message.info('正在加载威胁数据...');
    },

    loadSecurityData() {
      // 加载安全检查数据
      this.$message.info('正在加载安全检查数据...');
    },

    loadAnalysisData() {
      // 加载安全性分析数据
      this.$message.info('正在加载安全性分析数据...');
    },

    loadHistoricalData(start, end) {
      // 加载指定时间范围的历史数据
      this.$message.info('正在加载历史数据...');
    }
  },
  beforeDestroy() {
    if (this.updateInterval) {
      clearInterval(this.updateInterval)
    }
    Object.values(this.charts).forEach(chart => {
      chart && chart.dispose()
    })
  }
}
</script>

<style lang="scss" scoped>
.app-container {
  min-height: 100vh;
  padding: 20px;
  background: #0d1b2a;
  display: flex;
  flex-direction: column;
  gap: 20px;
  
  .main-content {
    display: flex;
    gap: 20px;
    min-height: 600px;
    
    .left-panel {
      flex: 2;
      display: flex;
      flex-direction: column;
      gap: 20px;
      
      .chart-container {
        flex: 1;
        min-height: 300px;
        background: rgba(16, 36, 64, 0.8);
        border-radius: 4px;
        padding: 20px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        
        .sankey-chart {
          height: 100%;
          min-height: 300px;
        }
      }
      
      .trend-chart-container {
        height: 300px;
        background: rgba(16, 36, 64, 0.8);
        border-radius: 4px;
        padding: 20px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        
        .trend-chart {
          height: 100%;
        }
      }
    }
    
    .right-panel {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
  }
}

.stat-cards {
  display: grid;
  grid-template-columns: repeat(10, 1fr);
  gap: 20px;
  margin-bottom: 20px;
  background: transparent;

  .stat-card {
    background: rgba(16, 36, 64, 0.8);
    border-radius: 4px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
    border: 1px solid rgba(255, 255, 255, 0.1);
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 5px 15px rgba(0,0,0,0.3);
      border-color: #409EFF;
    }

    .stat-icon {
      font-size: 24px;
      color: #409EFF;
      margin-bottom: 10px;
      transition: transform 0.3s ease;
    }

    &:hover .stat-icon {
      transform: scale(1.2);
    }

    .stat-value {
      font-size: 24px;
      font-weight: bold;
      color: #fff;
      margin-bottom: 5px;
      transition: all 0.3s ease;
      
      &.increasing {
        color: #52c41a;
        transform: scale(1.1);
      }
      
      &.decreasing {
        color: #ff4d4f;
        transform: scale(0.9);
      }
    }

    .stat-label {
      font-size: 14px;
      color: rgba(255, 255, 255, 0.7);
    }

    &.alert {
      animation: alert-pulse 2s infinite;
    }

    @keyframes alert-pulse {
      0% {
        box-shadow: 0 0 0 0 rgba(255, 77, 79, 0.4);
      }
      70% {
        box-shadow: 0 0 0 10px rgba(255, 77, 79, 0);
      }
      100% {
        box-shadow: 0 0 0 0 rgba(255, 77, 79, 0);
      }
    }
  }
}

.main-content {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;

  .left-panel {
    flex: 2;
    background: rgba(16, 36, 64, 0.8);
    border-radius: 4px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.1);

    .panel-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;

      .title {
        font-size: 16px;
        font-weight: bold;
        color: #fff;
      }

      .actions {
        display: flex;
        align-items: center;
        gap: 10px;

        .el-button-group {
          background: rgba(0, 0, 0, 0.2);
          padding: 4px;
          border-radius: 8px;
          
          .el-button {
            position: relative;
            margin: 0 4px;
            border: none;
            background: transparent;
            color: #909399;
            transition: all 0.3s ease;
            
            &.el-button--primary {
              background: rgba(64, 158, 255, 0.1);
              color: #409EFF;
              
              &::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 50%;
                transform: translateX(-50%);
                width: 20px;
                height: 2px;
                background: #409EFF;
                border-radius: 1px;
              }
            }
            
            &:hover {
              background: rgba(64, 158, 255, 0.05);
            }
          }
        }
        
        .refresh-btn {
          cursor: pointer;
          width: 32px;
          height: 32px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          background: rgba(64, 158, 255, 0.1);
          transition: all 0.3s ease;
          
          &:hover {
            background: rgba(64, 158, 255, 0.2);
          }
          
          &.rotating {
            animation: rotate 1s linear infinite;
          }
        }
      }
    }

    .sankey-chart {
      height: 300px;
      margin-bottom: 20px;
    }

    .trend-chart-container {
      .chart-title {
        font-size: 16px;
        font-weight: bold;
        color: #fff;
        margin-bottom: 20px;
      }

      .trend-chart {
        height: 200px;
      }
    }
  }

  .right-panel {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 20px;

    .gauge-container {
      background: rgba(16, 36, 64, 0.8);
      border-radius: 4px;
      padding: 20px;
      border: 1px solid rgba(255, 255, 255, 0.1);

      .gauge-title {
        font-size: 16px;
        font-weight: bold;
        color: #fff;
        margin-bottom: 20px;
      }

      .gauge-chart {
        height: 200px;
      }
    }

    .events-list {
      background: rgba(16, 36, 64, 0.8);
      border-radius: 4px;
      padding: 20px;
      border: 1px solid rgba(255, 255, 255, 0.1);

      .list-header {
        font-size: 16px;
        font-weight: bold;
        color: #fff;
        margin-bottom: 20px;
      }

      .list-content {
        .event-item {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 10px 0;
          border-bottom: 1px solid rgba(255, 255, 255, 0.1);

          &:last-child {
            border-bottom: none;
          }

          .source, .target {
            display: flex;
            align-items: center;
            gap: 10px;

            .ip {
              color: #fff;
              font-family: monospace;
            }
          }

          .event-id {
            color: rgba(255, 255, 255, 0.5);
            font-size: 12px;
          }

          &.new-event {
            animation: slide-in 0.5s ease-out;
          }

          @keyframes slide-in {
            from {
              transform: translateX(-100%);
              opacity: 0;
            }
            to {
              transform: translateX(0);
              opacity: 1;
            }
          }
        }
      }

      .pagination {
        margin-top: 20px;
        text-align: center;
      }
    }
  }
}

.trend-chart-container {
  position: relative;
  
  .chart-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 77, 79, 0.1);
    pointer-events: none;
    opacity: 0;
    transition: opacity 0.3s ease;
    
    &.visible {
      opacity: 1;
    }
  }
}

.gauge-chart {
  position: relative;
  
  &::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 10px;
    height: 10px;
    background: #fff;
    border-radius: 50%;
    transform: translate(-50%, -50%);
    box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
  }
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

:deep(.el-button--text) {
  color: rgba(255, 255, 255, 0.7);
  
  &:hover {
    color: #409EFF;
  }
}

:deep(.el-tag--mini) {
  height: 20px;
  line-height: 18px;
  padding: 0 6px;
  background: transparent;
  border: 1px solid;

  &.el-tag--danger {
    color: #ff4d4f;
    border-color: #ff4d4f;
  }

  &.el-tag--warning {
    color: #faad14;
    border-color: #faad14;
  }
}

:deep(.el-pagination) {
  text-align: center;
  
  .btn-prev,
  .btn-next,
  .el-pager li {
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: #fff;
    
    &:hover {
      color: #409EFF;
      border-color: #409EFF;
    }
    
    &.active {
      background: #409EFF;
      color: #fff;
      border-color: #409EFF;
    }
  }
}

::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 3px;
}

::-webkit-scrollbar-thumb {
  background: rgba(24, 144, 255, 0.3);
  border-radius: 3px;
  
  &:hover {
    background: rgba(24, 144, 255, 0.5);
  }
}

// 添加流量异常警告动画
.traffic-warning {
  position: fixed;
  top: 20px;
  right: 20px;
  background: rgba(255, 77, 79, 0.9);
  color: #fff;
  padding: 15px 20px;
  border-radius: 4px;
  z-index: 1000;
  display: flex;
  align-items: center;
  gap: 10px;
  animation: slide-in-right 0.5s ease-out;
  
  .warning-icon {
    font-size: 20px;
    animation: pulse 1s infinite;
  }
  
  @keyframes slide-in-right {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
  
  @keyframes pulse {
    0% {
      transform: scale(1);
    }
    50% {
      transform: scale(1.2);
    }
    100% {
      transform: scale(1);
    }
  }
}

// 添加数据更新提示动画
.data-update-indicator {
  position: fixed;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(24, 144, 255, 0.9);
  color: #fff;
  padding: 8px 15px;
  border-radius: 20px;
  font-size: 12px;
  display: flex;
  align-items: center;
  gap: 5px;
  opacity: 0;
  transition: opacity 0.3s ease;
  
  &.visible {
    opacity: 1;
  }
  
  .loading-dot {
    width: 4px;
    height: 4px;
    background: #fff;
    border-radius: 50%;
    animation: loading-dot 1s infinite;
    
    &:nth-child(2) {
      animation-delay: 0.2s;
    }
    
    &:nth-child(3) {
      animation-delay: 0.4s;
    }
  }
  
  @keyframes loading-dot {
    0%, 100% {
      transform: translateY(0);
    }
    50% {
      transform: translateY(-4px);
    }
  }
}

.panel-header {
  .actions {
    .el-button-group {
      .el-button {
        &.el-button--text {
          color: rgba(255, 255, 255, 0.7);
          
          &:hover {
            color: #409EFF;
          }
        }
        
        &.el-button--primary {
          background: #409EFF;
          border-color: #409EFF;
          color: #fff;
        }
      }
    }
    
    .refresh-btn {
      &.rotating {
        animation: rotate 1s linear infinite;
      }
    }
  }
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 10px;
  background: rgba(16, 36, 64, 0.8);
  border-radius: 4px;
  border: 1px solid rgba(255, 255, 255, 0.1);

  .el-button-group {
    .el-button {
      background: transparent;
      border-color: rgba(255, 255, 255, 0.2);
      
      &:hover {
        background: rgba(255, 255, 255, 0.1);
      }
      
      &.el-button--primary {
        background: #409EFF;
        border-color: #409EFF;
      }
    }
  }

  .time-range {
    .el-date-editor {
      background: transparent;
      border-color: rgba(255, 255, 255, 0.2);
      
      .el-range-input {
        background: transparent;
        color: #fff;
      }
      
      .el-range-separator {
        color: rgba(255, 255, 255, 0.7);
      }
    }
  }
}

:deep(.el-dialog) {
  background: #0d1b2a;
  border: 1px solid rgba(255, 255, 255, 0.1);
  
  .el-dialog__title {
    color: #fff;
  }
  
  .el-dialog__body {
    color: #fff;
  }
  
  .el-form-item__label {
    color: rgba(255, 255, 255, 0.7);
  }
  
  .el-input-number,
  .el-select {
    width: 100%;
  }
}
</style>