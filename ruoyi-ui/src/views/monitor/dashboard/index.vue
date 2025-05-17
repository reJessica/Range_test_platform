<template>
  <div class="monitor-dashboard dark-theme">
    <!-- 顶部统计卡片 -->
    <el-row :gutter="20" class="mb-4">
      <el-col :span="6" v-for="(stat, index) in statistics" :key="index">
        <el-card class="data-card glow-effect">
          <div class="card-title">{{ stat.title }}</div>
          <div class="card-value">{{ stat.value }}</div>
          <div class="card-trend">
            <span :class="stat.trend >= 0 ? 'success' : 'danger'">
              {{ Math.abs(stat.trend) }}% 
              <i :class="stat.trend >= 0 ? 'el-icon-top' : 'el-icon-bottom'"></i>
            </span>
            较上周
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 时间范围选择器 -->
    <div class="filter-container mb-4">
      <el-date-picker
        v-model="timeRange"
        type="daterange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        :picker-options="pickerOptions"
        @change="handleTimeRangeChange"
      />
    </div>

    <!-- 主要监控图表 -->
    <el-row :gutter="20" class="mb-4">
      <el-col :span="16">
        <el-card class="chart-card gradient-bg">
          <div slot="header" class="clearfix">
            <span>系统资源使用趋势</span>
          </div>
          <div class="echarts-container" ref="resourceChart" style="height: 400px"></div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card class="chart-card gradient-bg">
          <div slot="header" class="clearfix">
            <span>告警分布</span>
          </div>
          <div class="echarts-container" ref="alertChart" style="height: 400px"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 实时事件时间轴 -->
    <el-card class="timeline-card gradient-bg">
      <div slot="header" class="clearfix">
        <span>实时事件</span>
      </div>
      <el-timeline>
        <el-timeline-item
          v-for="(event, index) in events"
          :key="index"
          :type="event.type"
          :timestamp="event.timestamp"
        >
          <el-card class="event-card">
            <h4>{{ event.title }}</h4>
            <p>{{ event.description }}</p>
            <div class="event-footer">
              <el-tag :type="event.status" size="small">{{ event.statusText }}</el-tag>
              <el-button type="text" @click="handleEventDetail(event)">查看详情</el-button>
            </div>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </el-card>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'MonitorDashboard',
  data() {
    return {
      statistics: [
        { title: '在线设备', value: '128', trend: 5.2 },
        { title: '告警总数', value: '24', trend: -2.8 },
        { title: 'CPU使用率', value: '65%', trend: 1.5 },
        { title: '内存使用率', value: '78%', trend: 3.2 }
      ],
      timeRange: [],
      pickerOptions: {
        shortcuts: [{
          text: '最近一周',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
            picker.$emit('pick', [start, end])
          }
        }, {
          text: '最近一个月',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
            picker.$emit('pick', [start, end])
          }
        }]
      },
      events: [
        {
          title: '检测到异常流量',
          description: 'IP 192.168.1.100 产生异常流量峰值',
          timestamp: '2024-01-20 14:30:00',
          type: 'warning',
          status: 'warning',
          statusText: '待处理'
        },
        {
          title: '系统更新完成',
          description: '安全补丁更新已完成',
          timestamp: '2024-01-20 13:15:00',
          type: 'success',
          status: 'success',
          statusText: '已完成'
        }
      ]
    }
  },
  mounted() {
    this.initResourceChart()
    this.initAlertChart()
  },
  methods: {
    initResourceChart() {
      const chart = echarts.init(this.$refs.resourceChart)
      const option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {
          data: ['CPU', '内存', '磁盘'],
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
          type: 'category',
          data: ['00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00'],
          axisLine: {
            lineStyle: {
              color: '#fff'
            }
          }
        },
        yAxis: {
          type: 'value',
          axisLine: {
            lineStyle: {
              color: '#fff'
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
            name: 'CPU',
            type: 'line',
            smooth: true,
            data: [30, 40, 35, 50, 65, 45, 55, 40],
            itemStyle: {
              color: '#409EFF'
            }
          },
          {
            name: '内存',
            type: 'line',
            smooth: true,
            data: [50, 55, 45, 60, 75, 65, 70, 60],
            itemStyle: {
              color: '#67C23A'
            }
          },
          {
            name: '磁盘',
            type: 'line',
            smooth: true,
            data: [20, 25, 30, 35, 40, 35, 45, 40],
            itemStyle: {
              color: '#E6A23C'
            }
          }
        ]
      }
      chart.setOption(option)
      window.addEventListener('resize', () => chart.resize())
    },
    initAlertChart() {
      const chart = echarts.init(this.$refs.alertChart)
      const option = {
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          left: 'left',
          textStyle: {
            color: '#fff'
          }
        },
        series: [
          {
            name: '告警类型',
            type: 'pie',
            radius: '50%',
            data: [
              { value: 35, name: '网络异常' },
              { value: 25, name: '系统告警' },
              { value: 20, name: '安全事件' },
              { value: 15, name: '性能告警' },
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
      }
      chart.setOption(option)
      window.addEventListener('resize', () => chart.resize())
    },
    handleTimeRangeChange(val) {
      // 处理时间范围变化
      console.log('时间范围变化:', val)
      // TODO: 根据新的时间范围更新数据
    },
    handleEventDetail(event) {
      // 处理事件详情查看
      console.log('查看事件详情:', event)
      // TODO: 跳转到事件详情页或显示详情弹窗
    }
  }
}
</script>

<style lang="scss" scoped>
.monitor-dashboard {
  padding: 20px;

  .mb-4 {
    margin-bottom: 20px;
  }

  .filter-container {
    display: flex;
    justify-content: flex-end;
  }

  .event-card {
    background: rgba(36, 36, 36, 0.8);
    border: none;
    
    h4 {
      margin: 0 0 10px 0;
      color: #fff;
    }
    
    p {
      color: rgba(255, 255, 255, 0.7);
      margin: 0 0 10px 0;
    }
    
    .event-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }

  .chart-card {
    .clearfix {
      color: #fff;
    }
  }
}
</style> 