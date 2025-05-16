<template>
    <div id="app1">
        <div class="cards">
            <div class="card purple">
                <p class="tip">安全措施1</p>
                <p class="second-text">检查和控制网络流量，根据预设的安全规则允许或阻止数据包通过，从而保护内部网络。</p>
                <div class="image-container">
                    <img src="../../assets/img/fanghuoqiang.jpg" alt="Square Image" class="square-image" />
                </div>
                <input class="switch" type="checkbox" checked="false" v-model="safe1" @change="updateChart" />
            </div>
            <div class="card brown">
                <p class="tip">安全措施2</p>
                <p class="second-text">检查和控制网络流量，根据预设的安全规则允许或阻止数据包通过，从而保护内部网络。</p>
                <div class="image-container">
                    <img src="../../assets/img/fanghuoqiang.jpg" alt="Square Image" class="square-image" />
                </div>
                <input class="switch" type="checkbox" checked="false" v-model="safe2" @change="updateChart" />
            </div>
            <div class="card red">
                <p class="tip">防火墙</p>
                <p class="second-text">检查和控制网络流量，根据预设的安全规则允许或阻止数据包通过，从而保护内部网络。</p>
                <div class="image-container">
                    <img src="../../assets/img/fanghuoqiang.jpg" alt="Square Image" class="square-image" />
                </div>
                <input class="switch" type="checkbox" checked="false" v-model="firewallEnabled" @change="updateChart" />
            </div>
            <div class="card blue">
                <p class="tip">ARP绑定技术</p>
                <p class="second-text">通过将 IP 地址与正确的 MAC 地址进行静态绑定，防止ARP欺骗篡改ARP映射表。</p>
                <div class="image-container">
                    <img src="../../assets/img/arp.jpg" alt="Square Image" class="square-image" />
                </div>
                <input class="switch" type="checkbox" checked="false" v-model="arpBindingEnabled"
                    @change="updateChart" />
            </div>
            <div class="card green">
                <p class="tip">安全组策略配置</p>
                <p class="second-text">限制主机之间的通信，减少攻击面，防止恶意通信，通过限制不同主机之间的通信范围，降低网络中的潜在威胁。</p>
                <div class="image-container">
                    <img src="../../assets/img/safe.jpg" alt="Square Image" class="square-image" />
                </div>
                <input class="switch" type="checkbox" checked="false" v-model="securityGroupEnabled"
                    @change="updateChart" />
            </div>
        </div>
        <div class="chart">
            <div id="vulnerabilityChart" style="width: 100%; height:350px;"></div>
        </div>
    </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
    name: "App",
    data() {
        return {
            safe1: false,
            safe2: false,
            firewallEnabled: false,
            arpBindingEnabled: false,
            securityGroupEnabled: false,
            vulnerabilityData: [100], // 初始漏洞数
            chart: null,
            timer: null,
        };
    },
    mounted() {
        this.initChart();
        this.startTimer();
    },
    methods: {
        initChart() {
            this.chart = echarts.init(document.getElementById('vulnerabilityChart'));
            this.updateChart();
        },
        updateChart() {
            const baseVulnerability = 100; 
            const reductionFactor = 0.05 + Math.random() * 0.1; 
            const increaseFactor = 0.05 + Math.random() * 0.1; 

            let totalReduction = 0;
            let totalIncrease = 0;

            if (this.safe1) totalReduction += reductionFactor;
            else totalIncrease += increaseFactor;

            if (this.safe2) totalReduction += reductionFactor;
            else totalIncrease += increaseFactor;

            if (this.firewallEnabled) totalReduction += reductionFactor;
            else totalIncrease += increaseFactor;

            if (this.arpBindingEnabled) totalReduction += reductionFactor;
            else totalIncrease += increaseFactor;

            if (this.securityGroupEnabled) totalReduction += reductionFactor;
            else totalIncrease += increaseFactor;

            const newVulnerability = Math.round(baseVulnerability * (1 - totalReduction + totalIncrease));

            
            this.vulnerabilityData.push(newVulnerability);

            
            this.chart.setOption({
                title: {
                    text: '漏洞数随时间的变化',
                },
                tooltip: {
                    trigger: 'axis',
                },
                xAxis: {
                    type: 'category',
                    data: this.vulnerabilityData.map((_, index) => `${(index + 1)*5}s`),
                },
                yAxis: {
                    type: 'value',
                    min: 0,
                },
                series: [
                    {
                        name: '漏洞数',
                        type: 'line',
                        data: this.vulnerabilityData,
                        smooth: true,
                        areaStyle: {},
                    },
                ],
            });
        },
        startTimer() {
            this.timer = setInterval(() => {
                this.updateChart();
            }, 5000); 
        },
    },
    beforeDestroy() {
        if (this.chart) {
            this.chart.dispose();
        }
        if (this.timer) {
            clearInterval(this.timer);
        }
    },
};
</script>
<style>
* {
    margin: 0;
    padding: 0;
}

#app1 {
    width: 100%;
    height: 100vh;
    /* display: flex; */
    justify-content: center;
    align-items: center;
    background: url(../../assets/ai/backround1.jpg) no-repeat;
    background-size: 100% 100%;
}

.chart {
    width: 98%;
    margin-left: 1%;
    margin-top: -2%;
    height: 40vh;
    background: #ffffffa9;
    border-radius: 15px;
}

.image-container {
    width: 200px;
    height: 200px;
    margin-top: 3%;
    border: 1px solid #ccc;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
}

.square-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.cards {
    display: flex;
    gap: 15px;
    width: 100%;
    height: 50vh;
    margin-top: 1%;
    /* margin-left: 20%; */
}

.cards .red {
    background-color: #f43f5e;
}

.cards .blue {
    background-color: #3b82f6;
}

.cards .green {
    background-color: #22c55e;
}

.cards .brown {
    background-color: brown;
}

.cards .purple {
    background-color: purple;
}

.cards .card {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    text-align: center;
    height: 350px;
    width: 250px;
    border-radius: 10px;
    color: white;
    cursor: pointer;
    transition: 400ms;
}

.cards .card p.tip {
    font-size: 20px;
    font-weight: 700;
}

.cards .card p.second-text {
    font-size: .7em;
    color: rgb(200, 200, 200);
}

.cards .card:hover {
    transform: scale(1.1, 1.1);
}

.cards:hover>.card:not(:hover) {
    /* filter: blur(10px); */
    transform: scale(0.9, 0.9);
}

.switch {
    margin-top: 3%;
    margin-bottom: -2%;
    position: relative;
    height: 1.5rem;
    width: 3rem;
    cursor: pointer;
    appearance: none;
    -webkit-appearance: none;
    border-radius: 9999px;
    background-color: rgba(100, 116, 139, 0.377);
    transition: all .3s ease;
}

.switch:checked {
    background-color: rgb(72, 254, 72);
}

.switch::before {
    position: absolute;
    content: "";
    left: calc(1.5rem - 1.6rem);
    top: calc(1.5rem - 1.6rem);
    display: block;
    height: 1.6rem;
    width: 1.6rem;
    cursor: pointer;
    border: 1px solid rgba(100, 116, 139, 0.527);
    border-radius: 9999px;
    background-color: rgba(255, 255, 255, 1);
    box-shadow: 0 3px 10px rgba(100, 116, 139, 0.327);
    transition: all .3s ease;
}

.switch:hover::before {
    box-shadow: 0 0 0px 8px rgba(0, 0, 0, .15)
}

.switch:checked:hover::before {
    box-shadow: 0 0 0px 8px rgba(123, 245, 131, 0.15)
}

.switch:checked:before {
    transform: translateX(100%);
    border-color: rgb(72, 254, 72);
}
</style>