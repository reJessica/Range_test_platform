<!--
 描述: 双轴柱状图
 作者: Jack Chen
 日期: 2020-04-27
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">攻击类型分布</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_bar"></div>
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
export default {
  name: "szBar",
  data() {
    return {
      option: null,
      xAxisData: ['SQL注入', 'XSS攻击', '命令执行', '文件包含', '暴力破解', '敏感信息泄露'],
      yData1: [92, 88, 95, 85, 78, 90],
      yData2: [85, 80, 88, 75, 70, 82],
    }
  },
  mounted() {
    this.getEchart();
  },
  methods: {
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_bar'));
      let barWidth = '30%';
      
      this.option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {
          data: ['检出率', '防护率'],
          textStyle: {
            color: '#fff'
          },
          top: 10
        },
        grid: {
          top: '15%',
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: [{
          type: 'category',
          data: this.xAxisData,
          axisLine: {
            lineStyle: {
              color: '#fff'
            }
          },
          axisLabel: {
            interval: 0,
            rotate: 30
          }
        }],
        yAxis: [{
          type: 'value',
          name: '百分比',
          min: 0,
          max: 100,
          interval: 20,
          axisLine: {
            lineStyle: {
              color: '#fff'
            }
          },
          splitLine: {
            show: false
          }
        }],
        series: [{
          name: '检出率',
          type: 'bar',
          barWidth: barWidth,
          data: this.yData1,
          itemStyle: {
            normal: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: '#83bff6'
              }, {
                offset: 0.5,
                color: '#188df0'
              }, {
                offset: 1,
                color: '#188df0'
              }])
            }
          }
        }, {
          name: '防护率',
          type: 'bar',
          barWidth: barWidth,
          data: this.yData2,
          itemStyle: {
            normal: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: '#25f3e6'
              }, {
                offset: 0.5,
                color: '#4aff93'
              }, {
                offset: 1,
                color: '#4aff93'
              }])
            }
          }
        }]
      };

      myChart.setOption(this.option, true);

      window.addEventListener('resize', () => {
        myChart.resize();
      });
    }
  },
  beforeDestroy() {
    
  }
};
</script>

<style lang="scss" scoped>
.sn-container {
  left: 974px;
  top: 690px;
  width: 895px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 100%;
  }
}
</style>
