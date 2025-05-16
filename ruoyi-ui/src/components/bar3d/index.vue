<!--
 描述: 3D立体柱状图
 作者: Jack Chen
 日期: 2020-04-18
-->

<template>
  <div class="wrap-container trigle">
    <div class="bar bar-img"></div>
    <div class="bar bar-img1"></div>
    <div class="bar bar-img2"></div>
    <div class="chartsdom" id="chart_3d"></div>
  </div>
</template>

<script>
export default {
  name: "bar3d",
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
      let myChart = echarts.init(document.getElementById('chart_3d'));
      
      // 定义数据维度
      let categories = ['流量监控', '威胁检测', '自动防护', '攻防清洗'];
      let timePoints = ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'];
      
      // 生成模拟数据
      let data = [];
      categories.forEach((category, i) => {
        timePoints.forEach((time, j) => {
          data.push([
            j,
            i,
            Math.random() * 5 + 3,
            category,
            time,
            Math.floor(Math.random() * 1000 + 500)
          ]);
        });
      });

      this.option = {
        tooltip: {
          show: true,
          formatter: (params) => {
            return `${params.value[3]}<br/>时间：${params.value[4]}<br/>数量：${params.value[5]}`;
          }
        },
        xAxis3D: {
          type: 'category',
          data: timePoints,
          axisLine: {
            lineStyle: {
              color: '#fff',
              width: 2
            }
          },
          splitLine: {
            show: true,
            lineStyle: {
              color: 'rgba(255,255,255,0.3)',
              width: 1
            }
          },
          axisLabel: {
            color: '#fff',
            fontSize: 12
          }
        },
        yAxis3D: {
          type: 'category',
          data: categories,
          axisLine: {
            lineStyle: {
              color: '#fff',
              width: 2
            }
          },
          splitLine: {
            show: true,
            lineStyle: {
              color: 'rgba(255,255,255,0.3)',
              width: 1
            }
          },
          axisLabel: {
            color: '#fff',
            fontSize: 12
          }
        },
        zAxis3D: {
          type: 'value',
          axisLine: {
            lineStyle: {
              color: '#fff',
              width: 2
            }
          },
          splitLine: {
            show: true,
            lineStyle: {
              color: 'rgba(255,255,255,0.3)',
              width: 1
            }
          },
          axisLabel: {
            color: '#fff',
            fontSize: 12
          }
        },
        grid3D: {
          boxWidth: 180,
          boxHeight: 100,
          boxDepth: 80,
          viewControl: {
            distance: 180,
            alpha: 20,
            beta: 40
          },
          light: {
            main: {
              intensity: 1.2
            },
            ambient: {
              intensity: 0.3
            }
          }
        },
        series: [{
          type: 'bar3D',
          data: data.map(item => ({
            value: item,
            itemStyle: {
              color: '#0084ff',
              opacity: 0.8
            }
          })),
          shading: 'lambert',
          label: {
            show: false
          }
        }]
      }

      myChart.setOption(this.option, true);

      window.addEventListener('resize', () => {
        myChart.resize();
      });
    }
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.chartResize);
  }
};
</script>

<style lang="scss" scoped>
.trigle {
  left: 644px;
  top: 2409px;
  width: 620px;
  height: 400px;
  .chartsdom {
    width: 100%;
    height: 100%;
  }

  .bar {
    width: 100%;
    height: 100%;
    position: absolute;
    &.bar-img {
      bottom: 0;
      background: url(../../assets/img/bk_circle.png) no-repeat center 97%;
      background-size: 100%;
      filter: hue-rotate(180deg);
    }
    &.bar-img1 {
      bottom: 30%;
      background: url(../../assets/img/bk_circle1.png) no-repeat center 97%;
      background-size: 75%;
      filter: hue-rotate(180deg);
    }
    &.bar-img2 {
      bottom: 60%;
      background: url(../../assets/img/bk_circle2.png) no-repeat center 97%;
      background-size: 50%;
      filter: hue-rotate(180deg);
    }
  }
}
</style>
