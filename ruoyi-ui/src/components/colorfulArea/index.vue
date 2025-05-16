<!--
 描述: 多彩轮播面积
 作者: Jack Chen
 日期: 2020-05-03
-->

<template>
  <div class="wrap-container sn-container"> 
    <div class="sn-content"> 
      <div class="sn-title">安全事件</div> 
      <div class="sn-body"> 
        <div class="wrap-container"> 
          <div class="chartsdom" id="chart_cra"></div>
        </div> 
      </div> 
    </div>   
  </div>
</template>

<script>

export default {
  name: "colorfulArea",
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
      let pList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
      let temp;
      for (let x = 1; x <= 5; x++) {
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
      let myChart = echarts.init(document.getElementById('chart_cra'));
      
      // 定义渐变色
      const gradients = {
        high: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          offset: 0,
          color: '#ff3d7f'
        },{
          offset: 1,
          color: '#ff1493'
        }]),
        medium: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          offset: 0,
          color: '#ffcf00'
        },{
          offset: 1,
          color: '#ff9a00'
        }]),
        low: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          offset: 0,
          color: '#00ffd8'
        },{
          offset: 1,
          color: '#007a88'
        }]),
        warning: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          offset: 0,
          color: '#00e5ff'
        },{
          offset: 1,
          color: '#0076c6'
        }]),
        normal: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
          offset: 0,
          color: '#b4ff00'
        },{
          offset: 1,
          color: '#00ff9d'
        }])
      };

      this.dataMap.dataType = this.dataFormatter({
        5:[45,52,78,85,65,55,42,48,58,62,48,42,48,58,62,48,55,65,72,58,52,48,42,38], // 高危事件
        4:[85,92,78,95,85,75,82,78,88,92,78,72,78,88,92,88,85,95,102,88,82,78,72,68], // 中危事件
        3:[125,132,128,145,135,125,122,128,138,142,128,122,128,138,142,138,135,145,152,138,132,128,122,118], // 低危事件
        2:[65,72,68,85,75,65,62,68,78,82,68,62,68,78,82,78,75,85,92,78,72,68,62,58], // 告警事件
        1:[35,42,38,45,35,25,32,38,48,52,38,32,38,48,52,48,45,55,62,48,42,38,32,28], // 普通事件
      });

      this.option = {
        backgroundColor: 'transparent',
        baseOption: {
          timeline: {
            axisType: 'category',
            autoPlay: true,
            playInterval: 3000,
            data: ['高危事件', '中危事件', '低危事件', '告警事件', '普通事件'],
            left: '5%',
            right: '5%',
            bottom: '0%',
            lineStyle: {
              color: 'rgba(29,122,248,0.5)'
            },
            label: {
              color: '#00c2ff',
              fontSize: 12,
              textShadow: '0 0 5px rgba(0,194,255,0.5)'
            },
            checkpointStyle: {
              color: '#ff3d7f',
              borderColor: 'rgba(255,61,127,0.3)',
              borderWidth: 2,
              shadowColor: 'rgba(255,61,127,0.5)',
              shadowBlur: 10
            },
            controlStyle: {
              showPlayBtn: true,
              showPrevBtn: true,
              showNextBtn: true,
              itemSize: 22,
              itemGap: 12,
              position: 'left',
              color: '#00c2ff',
              borderColor: '#00c2ff',
              borderWidth: 1
            },
            emphasis: {
              label: {
                color: '#fff',
                textShadow: '0 0 8px rgba(255,255,255,0.8)'
              },
              checkpointStyle: {
                color: '#ff3d7f',
                borderColor: 'rgba(255,61,127,0.5)',
                borderWidth: 2,
                shadowColor: 'rgba(255,61,127,0.8)',
                shadowBlur: 15
              }
            }
          },
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              type: 'shadow',
              shadowStyle: {
                color: 'rgba(0,194,255,0.1)'
              }
            },
            backgroundColor: 'rgba(0,10,30,0.9)',
            borderColor: 'rgba(0,194,255,0.3)',
            borderWidth: 1,
            padding: [8, 12],
            textStyle: {
              color: '#fff',
              fontSize: 12
            }
          },
          grid: {
            top: '15%',
            bottom: '20%',
            left: '5%',
            right: '5%'
          },
          xAxis: [{
            type: 'category',
            data: ['00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'],
            axisLabel: {
              interval: 2,
              color: '#00c2ff',
              fontSize: 12,
              textShadow: '0 0 5px rgba(0,194,255,0.5)'
            },
            axisLine: {
              lineStyle: {
                color: 'rgba(29,122,248,0.3)'
              }
            },
            splitLine: {
              show: true,
              lineStyle: {
                color: 'rgba(29,122,248,0.1)',
                type: 'dashed'
              }
            }
          }],
          yAxis: [{
            type: 'value',
            name: '事件数',
            nameTextStyle: {
              color: '#00c2ff',
              fontSize: 12,
              textShadow: '0 0 5px rgba(0,194,255,0.5)'
            },
            axisLabel: {
              color: '#00c2ff',
              fontSize: 12,
              textShadow: '0 0 5px rgba(0,194,255,0.5)'
            },
            splitLine: {
              show: true,
              lineStyle: {
                color: 'rgba(29,122,248,0.1)',
                type: 'dashed'
              }
            },
            axisLine: {
              lineStyle: {
                color: 'rgba(29,122,248,0.3)'
              }
            }
          }],
          series: [{
            name: '安全事件',
            type: 'line',
            smooth: true,
            symbol: 'circle',
            symbolSize: 8,
            showSymbol: false,
            lineStyle: {
              width: 2,
              shadowColor: 'rgba(0,194,255,0.3)',
              shadowBlur: 10
            },
            areaStyle: {
              opacity: 0.8,
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                offset: 0,
                color: 'rgba(0,194,255,0.3)'
              },{
                offset: 1,
                color: 'rgba(0,194,255,0.1)'
              }])
            },
            emphasis: {
              itemStyle: {
                color: '#fff',
                borderColor: '#00c2ff',
                borderWidth: 2,
                shadowColor: 'rgba(0,194,255,0.5)',
                shadowBlur: 10
              }
            }
          }]
        },
        options: [{
          series: [{
            name: '高危事件',
            itemStyle: { color: gradients.high },
            lineStyle: { color: gradients.high },
            data: this.dataMap.dataType['5']
          }]
        },{
          series: [{
            name: '中危事件',
            itemStyle: { color: gradients.medium },
            lineStyle: { color: gradients.medium },
            data: this.dataMap.dataType['4']
          }]
        },{
          series: [{
            name: '低危事件',
            itemStyle: { color: gradients.low },
            lineStyle: { color: gradients.low },
            data: this.dataMap.dataType['3']
          }]
        },{
          series: [{
            name: '告警事件',
            itemStyle: { color: gradients.warning },
            lineStyle: { color: gradients.warning },
            data: this.dataMap.dataType['2']
          }]
        },{
          series: [{
            name: '普通事件',
            itemStyle: { color: gradients.normal },
            lineStyle: { color: gradients.normal },
            data: this.dataMap.dataType['1']
          }]
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
  left: 1436px;
  top: 1120px;
  width: 432px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 100%;
    filter: drop-shadow(0 0 15px rgba(0,194,255,0.2));
  }
}


</style>
