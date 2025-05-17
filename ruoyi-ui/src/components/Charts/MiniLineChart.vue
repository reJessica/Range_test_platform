<template>
  <div class="mini-line-chart" ref="chart"></div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'MiniLineChart',
  props: {
    data: {
      type: Array,
      required: true
    },
    color: {
      type: String,
      default: '#1890ff'
    }
  },
  data() {
    return {
      chart: null
    }
  },
  mounted() {
    this.initChart()
    window.addEventListener('resize', this.resizeHandler)
  },
  beforeDestroy() {
    if (this.chart) {
      this.chart.dispose()
      this.chart = null
    }
    window.removeEventListener('resize', this.resizeHandler)
  },
  methods: {
    initChart() {
      this.chart = echarts.init(this.$refs.chart)
      this.setOptions()
    },
    setOptions() {
      this.chart.setOption({
        grid: {
          top: 2,
          bottom: 2,
          left: 2,
          right: 2
        },
        xAxis: {
          type: 'category',
          show: false,
          boundaryGap: false
        },
        yAxis: {
          type: 'value',
          show: false,
          min: 'dataMin',
          max: 'dataMax'
        },
        series: [{
          type: 'line',
          data: this.data,
          smooth: true,
          symbol: 'none',
          lineStyle: {
            color: this.color,
            width: 2
          },
          areaStyle: {
            color: {
              type: 'linear',
              x: 0,
              y: 0,
              x2: 0,
              y2: 1,
              colorStops: [{
                offset: 0,
                color: this.color // 渐变开始颜色
              }, {
                offset: 1,
                color: 'rgba(255, 255, 255, 0)' // 渐变结束颜色
              }]
            }
          }
        }]
      })
    },
    resizeHandler() {
      if (this.chart) {
        this.chart.resize()
      }
    }
  },
  watch: {
    data: {
      handler(val) {
        if (this.chart) {
          this.setOptions()
        }
      },
      deep: true
    }
  }
}
</script>

<style lang="scss" scoped>
.mini-line-chart {
  width: 100%;
  height: 100%;
}
</style> 