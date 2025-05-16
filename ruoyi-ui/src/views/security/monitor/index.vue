<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>网络流量监控</span>
      </div>
      
      <!-- 搜索和过滤区域 -->
      <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch">
        <el-form-item label="IP地址" prop="ipAddress">
          <el-input
            v-model="queryParams.ipAddress"
            placeholder="请输入IP地址"
            clearable
            size="small"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="时间范围" prop="timeRange">
          <el-date-picker
            v-model="queryParams.timeRange"
            type="datetimerange"
            size="small"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 操作按钮区域 -->
      <el-row :gutter="10" class="mb8">
        <el-col :span="1.5">
          <el-button
            type="warning"
            plain
            icon="el-icon-download"
            size="mini"
            @click="handleExport"
            v-hasPermi="['security:monitor:export']"
          >导出</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-row>

      <!-- 流量监控图表 -->
      <div class="chart-container">
        <div ref="trafficChart" style="height: 300px;"></div>
      </div>

      <!-- 数据列表 -->
      <el-table
        v-loading="loading"
        :data="trafficList"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="序号" align="center" prop="id" />
        <el-table-column label="IP地址" align="center" prop="ipAddress" />
        <el-table-column label="流量大小" align="center" prop="trafficSize" />
        <el-table-column label="协议类型" align="center" prop="protocol" />
        <el-table-column label="时间" align="center" prop="time" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.time) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === '正常' ? 'success' : 'danger'">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
      
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: "NetworkMonitor",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 流量数据表格
      trafficList: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ipAddress: undefined,
        timeRange: []
      },
      // 图表实例
      chart: null
    };
  },
  created() {
    this.getList();
  },
  mounted() {
    this.initChart();
    // 监听窗口大小变化，调整图表大小
    window.addEventListener('resize', this.resizeChart);
  },
  beforeDestroy() {
    if (this.chart) {
      this.chart.dispose();
      this.chart = null;
    }
    window.removeEventListener('resize', this.resizeChart);
  },
  methods: {
    /** 查询流量监控列表 */
    getList() {
      this.loading = true;
      // 这里添加获取数据的API调用
      // listTraffic(this.queryParams).then(response => {
      //   this.trafficList = response.rows;
      //   this.total = response.total;
      //   this.loading = false;
      // });
      
      // 模拟数据
      setTimeout(() => {
        this.trafficList = [
          {
            id: 1,
            ipAddress: '192.168.1.1',
            trafficSize: '1.5MB',
            protocol: 'HTTP',
            time: new Date(),
            status: '正常'
          }
        ];
        this.total = 1;
        this.loading = false;
      }, 1000);
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 导出按钮操作 */
    handleExport() {
      // 实现导出功能
    },
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 初始化图表 */
    initChart() {
      this.chart = echarts.init(this.$refs.trafficChart);
      const option = {
        title: {
          text: '网络流量趋势'
        },
        tooltip: {
          trigger: 'axis'
        },
        xAxis: {
          type: 'category',
          data: ['00:00', '02:00', '04:00', '06:00', '08:00', '10:00', '12:00']
        },
        yAxis: {
          type: 'value',
          name: '流量(MB)'
        },
        series: [{
          data: [820, 932, 901, 934, 1290, 1330, 1320],
          type: 'line',
          smooth: true
        }]
      };
      this.chart.setOption(option);
    },
    /** 调整图表大小 */
    resizeChart() {
      if (this.chart) {
        this.chart.resize();
      }
    }
  }
};
</script>

<style scoped>
.chart-container {
  margin: 20px 0;
  border: 1px solid #eee;
  padding: 20px;
  border-radius: 4px;
}
</style> 