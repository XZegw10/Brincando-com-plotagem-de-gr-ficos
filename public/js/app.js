document.addEventListener('DOMContentLoaded', () => {
    const PrimeAnalyzerApp = {
        chart: null,
        primeData: {
            ratios: [],
            primes: []
        },
        dom: {},

        // Função Debounce para evitar chamadas excessivas em eventos como 'input'
        debounce(func, delay) {
            let timeout;
            return (...args) => {
                clearTimeout(timeout);
                timeout = setTimeout(() => func.apply(this, args), delay);
            };
        },

        // Inicializa a aplicação
        init() {
            this.cacheDom();
            this.bindEvents();
            this.handleUpdate(); // Carrega os dados iniciais ao carregar a página
        },

        // Mapeia os elementos do DOM para o objeto 'dom' para acesso rápido
        cacheDom() {
            const ids = [
                'primeCount', 'movingAverage', 'maValue', 'updateButton',
                'loader', 'primeChart', 'showPointsToggle', 'pointsColorPicker',
                'maColorPicker', 'theoryColorPicker', 'pointSizeSlider', 'pointSizeValue'
            ];
            ids.forEach(id => this.dom[id] = document.getElementById(id));
            this.dom.ctx = this.dom.primeChart.getContext('2d');
        },

        // Adiciona os event listeners aos elementos interativos
        bindEvents() {
            this.dom.updateButton.addEventListener('click', () => this.handleUpdate());

            // Atualização da média móvel com debounce
            this.dom.movingAverage.addEventListener('input', this.debounce(() => {
                this.dom.maValue.textContent = this.dom.movingAverage.value;
                this.updateMovingAverage();
            }, 100));

            // Listeners para customização do gráfico, com debounce para performance
            const customizationControls = ['showPointsToggle', 'pointsColorPicker', 'maColorPicker', 'theoryColorPicker', 'pointSizeSlider'];
            customizationControls.forEach(id => {
                this.dom[id].addEventListener('input', this.debounce(() => this.updateChartAppearance(), 50));
            });
        },

        // Função principal para buscar os dados e iniciar a atualização do gráfico
        async handleUpdate() {
            const count = parseInt(this.dom.primeCount.value);
            if (count < 10 || count > 100000) {
                alert("Por favor, insira um número entre 10 e 100.000.");
                return;
            }

            // Mostra o loader e esconde o gráfico
            this.dom.loader.classList.remove('hidden');
            this.dom.primeChart.style.display = 'none';
            this.dom.updateButton.disabled = true;
            this.dom.movingAverage.disabled = true;

            try {
                // Busca os dados do endpoint PHP
                const response = await fetch(`index.php?action=getPrimeData&count=${count}`);
                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.error || 'Falha ao buscar dados dos primos.');
                }
                const data = await response.json();

                // Processa os dados recebidos
                this.primeData.primes = data.primes;
                this.primeData.ratios = this.primeData.primes.slice(1).map((p, i) => p / this.primeData.primes[i]);

                // Cria ou atualiza o gráfico com os novos dados
                this.createOrUpdateChart();

            } catch (error) {
                console.error('Erro:', error);
                alert(`Ocorreu um erro: ${error.message}`);
            } finally {
                // Esconde o loader e reabilita os controles
                this.dom.loader.classList.add('hidden');
                this.dom.primeChart.style.display = 'block';
                this.dom.updateButton.disabled = false;
                this.dom.movingAverage.disabled = false;
            }
        },

        // Cria um novo gráfico ou atualiza um existente
        createOrUpdateChart() {
            if (this.chart) {
                this.chart.destroy();
            }
            const windowSize = parseInt(this.dom.movingAverage.value);
            this.chart = new Chart(this.dom.ctx, {
                type: 'line',
                data: {
                    labels: Array.from({ length: this.primeData.ratios.length }, (_, i) => i + 2), // Começa do índice 2 (p2/p1)
                    datasets: [{
                        type: 'scatter', // Pontos individuais
                        label: 'Razão (pn / pn-1)',
                        data: this.primeData.ratios,
                    }, {
                        label: `Média Móvel (${windowSize}p)`,
                        data: this.calculateMovingAverage(this.primeData.ratios, windowSize),
                        tension: 0.3,
                        borderWidth: 2.5,
                        pointRadius: 0,
                    }, {
                        label: 'Curva Teórica (1 + 1/ln(pn))',
                        data: this.primeData.primes.slice(1).map(p => 1 + 1 / Math.log(p)),
                        borderWidth: 2,
                        pointRadius: 0,
                        borderDash: [5, 5],
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: { duration: 500 },
                    scales: {
                        x: { type: 'linear', title: { display: true, text: 'Índice do Primo (n)', color: '#9ca3af' }, ticks: { color: '#9ca3af' }, grid: { color: 'rgba(255,255,255,0.1)' } },
                        y: { title: { display: true, text: 'Razão', color: '#9ca3af' }, ticks: { color: '#9ca3af' }, grid: { color: 'rgba(255,255,255,0.1)' } }
                    },
                    plugins: {
                        legend: { labels: { color: '#d1d5db' } },
                        tooltip: { mode: 'index', intersect: false }
                    }
                }
            });
            this.updateChartAppearance();
        },

        // Atualiza a aparência do gráfico com base nos controles de customização
        updateChartAppearance() {
            if (!this.chart) return;
            const ds = this.chart.data.datasets;
            ds[0].hidden = !this.dom.showPointsToggle.checked;
            ds[0].pointBackgroundColor = this.dom.pointsColorPicker.value + '4D'; // Adiciona transparência
            ds[1].borderColor = this.dom.maColorPicker.value;
            ds[2].borderColor = this.dom.theoryColorPicker.value;

            const size = parseFloat(this.dom.pointSizeSlider.value);
            this.dom.pointSizeValue.textContent = size;
            ds[0].pointRadius = size;

            this.chart.update('none'); // 'none' para evitar re-animação
        },

        // Recalcula e atualiza apenas a linha da média móvel
        updateMovingAverage() {
            if (!this.chart) return;
            const windowSize = parseInt(this.dom.movingAverage.value);
            this.chart.data.datasets[1].data = this.calculateMovingAverage(this.primeData.ratios, windowSize);
            this.chart.data.datasets[1].label = `Média Móvel (${windowSize}p)`;
            this.chart.update('none');
        },

        // Calcula a média móvel simples
        calculateMovingAverage(data, size) {
            if (size > data.length || size < 1) return [];
            const sma = [];
            let sum = 0;
            // Preenche o início com 'null' para alinhar o gráfico corretamente
            const result = Array(size - 1).fill(null);

            for (let i = 0; i < data.length; i++) {
                sum += data[i];
                if (i >= size) {
                    sum -= data[i - size];
                    result.push(sum / size);
                } else if (i === size - 1) {
                    result.push(sum / size);
                }
            }
            return result;
        }
    };

    PrimeAnalyzerApp.init();
});
