<template>
  <div class="home-container">
  	<div class="wrap" ref="editor">
      <div class="top">
        <el-button
          class="report-btn"
          type="primary"
          @click="generateReport"
        >
          生成安全报告
        </el-button>
      </div>

      <sinan />
      <seamless />
      <pyramid />

      <scrollArc />
      <szBar />

      <ringPin />
      <rotateColorful />
      <circleRunway />
      <scanRadius />

      <pyramidTrend />
      <dynamicLine />

      <staffMix />
      <flashCloud />
      <ringPie />
      <colorfulRadar />

      <dynamicList />
      <bar3d />
      <colorfulArea />

      <rainbow />

      <div class="divider"></div>

      <security-report
        :visible.sync="reportVisible"
        :report-data="reportData"
      />
    </div>

  </div>
</template>

<script>
import { screenSize } from '@/assets/js/utils.js'
import SecurityReport from './components/SecurityReport.vue'

export default {
  name: 'Home',
  components: {
    SecurityReport
  },
  data() {
  	return {
      reportVisible: false,
      reportData: {
        projectSteps: [
          { 
            step: '启动靶场',
            status: 'completed',
            time: '2024-03-15 10:00:00',
            details: '成功启动docker容器，网络拓扑图已生成'
          },
          {
            step: '监控系统启动',
            status: 'completed',
            time: '2024-03-15 10:05:00',
            details: '流量监控、流量分析（基于静态规则开启）、日志记录已启动'
          },
          {
            step: '漏洞处理',
            status: 'completed',
            time: '2024-03-15 10:15:00',
            details: '完成漏洞扫描、自动修复及验证，修复8个中危漏洞'
          },
          {
            step: '第一次攻击',
            status: 'completed',
            time: '2024-03-15 10:30:00',
            details: 'DoS攻击已记录，入侵检测模型未开启状态下'
          },
          {
            step: '防护升级',
            status: 'completed',
            time: '2024-03-15 11:00:00',
            details: '开启用户自定义流量分析（IP: 192.168.1.100:8080）、入侵检测和自动响应'
          },
          {
            step: '第二次攻击',
            status: 'completed',
            time: '2024-03-15 11:45:00',
            details: '攻击已被检测并成功防御，自动响应机制生效'
          }
        ],
        systemStatus: {
          '流量监控': '正常',
          '流量分析': '已优化',
          '日志记录': '已完善',
          '可疑日志': '已记录',
          '入侵检测': '已开启',
          '自动响应': '已激活'
        }
      }
  	}
  },
  computed: {

  },
  created() {
  },
  mounted() {
    screenSize(this.$refs.editor);
  },
  methods: {
    generateReport() {
      this.$confirm('是否生成并发送安全报告给检测人员？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.reportVisible = true;
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消生成报告'
        });
      });
    }
  }
}
</script>

<style lang="scss" scoped>
.home-container {
	position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  margin-left:-1.7%;
  // padding-bottom:10px;
  height: 100%;
  .wrap {
    transform-origin: 0px 0px 0px;
    background: url(../assets/img/bj.jpg) no-repeat;
    background-size: contain;
    background-position: 50% 0;
    background-color: rgb(0, 0, 0);
    min-width: auto;
    width: 1920px;
    min-height: auto;
    height: 1080px;
    overflow: auto;
    .top {
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      height: 80px;
      background-color: transparent;
      background: url(../assets/img/top_nav_new.png) no-repeat;
      background-position: 65% 0;
      border: none;
      overflow: hidden;
      .report-btn {
        position: absolute;
        right: 50px;
        top: 20px;
        background: linear-gradient(45deg, #0a2e5c, #1890ff);
        border: none;
        padding: 10px 20px;
        font-size: 14px;
        border-radius: 4px;
        color: #fff;
        cursor: pointer;
        transition: all 0.3s;
        &:hover {
          opacity: 0.9;
          transform: translateY(-2px);
          box-shadow: 0 2px 8px rgba(24, 144, 255, 0.3);
        }
      }
    }
    .divider {
      position: absolute;
      left: 50px;
      top: 3253px;
      width: 90%;
      height: 50px;
      width: 300px;
      border: none;
      background: transparent;
    }

  }
}
</style>
