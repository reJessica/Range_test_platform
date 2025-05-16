<template>
  <div class="dashboard-editor-container">

    <panel-group @handleSetLineChartData="handleSetLineChartData" />

    <el-row style="background:#fff;padding:16px 16px 0;margin-bottom:32px;">
      <line-chart :chart-data="lineChartData" />
    </el-row>

    <el-row :gutter="32">
      <el-col :xs="24" :sm="24" :lg="8">
        <div class="chart-wrapper">
          <raddar-chart />
        </div>
      </el-col>
      <el-col :xs="24" :sm="24" :lg="8">
        <div class="chart-wrapper">
          <pie-chart />
        </div>
      </el-col>
      <el-col :xs="24" :sm="24" :lg="8">
        <div class="chart-wrapper">
          <bar-chart />
        </div>
      </el-col>
    </el-row>

    
  </div>
</template>

<script>
import PanelGroup from './dashboard/PanelGroup'
import LineChart from './dashboard/LineChart'
import RaddarChart from './dashboard/RaddarChart'
import PieChart from './dashboard/PieChart'
import BarChart from './dashboard/BarChart'

const lineChartData = {
  attackEvents: {
    expectedData: [120, 140, 161, 134, 105, 160, 165],
    actualData: [150, 182, 191, 154, 162, 140, 145],
    title: '攻击事件趋势'
  },
  vulnerabilities: {
    expectedData: [20, 25, 31, 24, 15, 30, 35],
    actualData: [28, 32, 41, 34, 22, 40, 45],
    title: '漏洞发现趋势'
  },
  protection: {
    expectedData: [95, 93, 92, 94, 95, 96, 97],
    actualData: [92, 90, 91, 93, 94, 95, 96],
    title: '防护成功率趋势'
  },
  scenarios: {
    expectedData: [30, 32, 35, 38, 40, 42, 45],
    actualData: [28, 30, 33, 36, 38, 40, 42],
    title: '演练场景数量'
  }
}

export default {
  name: 'Index',
  components: {
    PanelGroup,
    LineChart,
    RaddarChart,
    PieChart,
    BarChart
  },
  data() {
    return {
      lineChartData: lineChartData.attackEvents
    }
  },
  methods: {
    handleSetLineChartData(type) {
      this.lineChartData = lineChartData[type]
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-editor-container {
  padding: 32px;
  background-color: rgb(240, 242, 245);
  position: relative;

  .chart-wrapper {
    background: #fff;
    padding: 16px 16px 0;
    margin-bottom: 32px;
  }
}

@media (max-width:1024px) {
  .chart-wrapper {
    padding: 8px;
  }
}
</style>
