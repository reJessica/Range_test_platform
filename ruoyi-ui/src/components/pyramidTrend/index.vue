<!--
 描述: 安全防护层级
 作者: Jack Chen
 日期: 2024-03-21
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">安全防护层级</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_ptrend"></div>
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>

export default {
  name: "pyramidTrend",
  data() {
    return {
      option: null,
      dataMap: {}
    }
  },
  mounted() {
    this.getEchart();
  },
  methods: {
    dataFormatter(obj) {
      let pList = ['应急响应','威胁检测','入侵防御','访问控制','基础防护'];
      let temp;
      for (let x = 0; x < 3; x++) {
          let max = 0;
          let sum = 0;
          temp = obj[x];
          for (let i = 0, l = temp.length; i < l; i++) {
              max = Math.max(max, temp[i]);
              sum += temp[i];
              obj[x][i] = {
                name: pList[i],
                value: temp[i]
              };
          }
          obj[x + 'max'] = Math.floor(max / 100) * 100;
          obj[x + 'sum'] = sum;
      }
      return obj;
    },
    getEchart() {
      let myChart = echarts.init(document.getElementById('chart_ptrend'));
      let itemStyle = {
        barBorderRadius: [15, 0],
        color: {
          type: 'linear',
          x: 0,
          y: 0,
          x2: 1,
          y2: 0,
          colorStops: [{
            offset: 0,
            color: '#1890ff'
          }, {
            offset: 1,
            color: '#40a9ff'
          }]
        }
      }

      this.dataMap.dataType = this.dataFormatter({
        2:[95, 88, 92, 85, 78],  // 当前状态
        1:[90, 85, 88, 80, 75],  // 上周状态
        0:[85, 80, 83, 75, 70],  // 上月状态
      });

      this.option = {
        baseOption: {
          timeline: {
            axisType: 'category',
            autoPlay: true,
            playInterval: 1000,
            data: ['本月', '上月', '上上月'],
            left: 80,
            right: 80,
            bottom: 10,
            lineStyle: {
              color: '#179bf1'
            },
            label: {
              color: '#fff'
            },
            checkpointStyle: {
              color: '#01d8ff',
              symbolSize: 10,
              borderColor: 'rgba(1, 216, 255, 0.5)',
              borderWidth: 5,
            },
            controlStyle: {
              show: false,
            }, 
            itemStyle: {
              borderColor: '#004b85',
              borderWidth: 1,
              shadowColor: 'rgba(1, 216, 225, 0.5)',
              shadowBlur: 5
            },
            emphasis: {
              label: {
                color: '#01d8ff',
                show: false
              },
              checkpointStyle: {
                color: '#01d8ff',
                borderColor: 'rgba(1, 216, 255, 0.5)',
                borderWidth: 5,
              },
              itemStyle: {
                color: '#01d8ff',
                borderColor: 'rgba(1, 216, 225, 0.5)',
                borderWidth: 5
              } 
            }
          },
          calculable: true,
          grid: {
            top: '10%',
            bottom: '25%'
          },
          xAxis: [{
            type: 'category',
            axisLabel: {
              interval: 0
            },
            data: ['应急响应','威胁检测','入侵防御','访问控制','基础防护'],
            splitLine: { 
              show: false 
            },
            axisTick: {
              show: false
            }, 
            axisLine: {
              show: true,
              lineStyle: {
                color: '#2867a8',
              }
            },
          }],
          yAxis: [{
            type: 'value',
            name: '%',
            splitLine: {
              show: false
            },
            axisTick: {
              show: false
            }, 
            axisLine: {
              show: true,
              lineStyle: {
                color: '#2867a8'
              }
            }
          }],
          series: [{
            name: '防护等级', 
            type: 'bar',
            barWidth: 15,
            legendHoverLink: true,
            label: {
              show: true,
              position: 'top',
              color: '#fff'
            },
          }]
        },
        options: [{
          series: [{
            data: this.dataMap.dataType['0'],
            itemStyle: itemStyle
          }]
        },{
          series: [{
            data: this.dataMap.dataType['1'],
            itemStyle: itemStyle
          }]
        },{
          series: [{
            data: this.dataMap.dataType['2'],
            itemStyle: itemStyle
          }]
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
  left: 666px;
  top: 1548px;
  width: 586px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 100%;
  }
}

</style>
