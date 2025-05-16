<!--
 描述: 多彩雷达
 作者: Jack Chen
 日期: 2020-05-02
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">安全能力评估</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_radar"></div> 
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>
export default {
  name: "colorfulRadar",
  data() {
    return {
      option: null
    }
  },
  mounted() {
    this.getEchart();
  },
  methods: {
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_radar'));
      this.option = {
        tooltip: {
          trigger: 'item'
        },
        legend: {
          data: ['当前水平', '行业标准'],
          textStyle: {
            color: '#fff'
          },
          right: '4%',
          top: '4%'
        },
        radar: [{
          indicator: [
            {text: '威胁检测', max: 100},
            {text: '攻击防护', max: 100},
            {text: '数据安全', max: 100},
            {text: '访问控制', max: 100},
            {text: '安全审计', max: 100},
            {text: '应急响应', max: 100}
          ],
          radius: '65%',
          center: ['50%', '55%'],
          name: {
            textStyle: {
              color: '#fff',
              fontSize: 14
            }
          },
          splitLine: {
            lineStyle: {
              color: 'rgba(255,255,255,0.2)'
            }
          },
          splitArea: {
            show: true,
            areaStyle: {
              color: ['rgba(255,255,255,0.05)', 'rgba(255,255,255,0.02)']
            }
          },
          axisLine: {
            lineStyle: {
              color: 'rgba(255,255,255,0.2)'
            }
          }
        }],
        series: [{
          name: '安全能力评估',
          type: 'radar',
          data: [
            {
              value: [85, 90, 78, 93, 83, 80],
              name: '当前水平',
              symbol: 'none',
              itemStyle: {
                normal: {
                  color: '#ff4757',
                  lineStyle: {
                    color: 'rgba(255,71,87,0.8)',
                    width: 2
                  },
                  areaStyle: {
                    type: 'default',
                    opacity: 0.5
                  }
                }
              }
            },
            {
              value: [75, 65, 85, 82, 88, 75],
              name: '行业标准',
              symbol: 'none',
              itemStyle: {
                normal: {
                  color: '#2ed573',
                  lineStyle: {
                    color: 'rgba(46,213,115,0.8)',
                    width: 2
                  },
                  areaStyle: {
                    type: 'default',
                    opacity: 0.5
                  }
                }
              }
            }
          ]
        }]
      }

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
  left: 1436px;
  top: 1978px;
  width: 432px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 100%;
  }
}
</style>
