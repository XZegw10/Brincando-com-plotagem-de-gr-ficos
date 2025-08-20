<!-- Este é o contêiner principal da aplicação -->
<div class="app-container">
    <header class="header">
        <h1 class="header__title">Analisador Interativo da Razão entre Primos</h1>
        <p class="header__subtitle">Visualize a tendência da razão $p_n / p_{n-1}$ e suavize-a com uma média móvel.</p>
    </header>

    <!-- Controles Principais -->
    <div class="controls-panel">
        <div class="control-group">
            <label for="primeCount" class="control-group__label">Nº de Primos (máx. 100.000)</label>
            <input type="number" id="primeCount" value="5000" min="10" max="100000" class="input-field">
        </div>
        <div class="control-group">
            <label for="movingAverage" class="control-group__label">Média Móvel: <span id="maValue" class="value-display">200</span></label>
            <input type="range" id="movingAverage" min="2" max="1000" value="200" class="range-slider" disabled>
        </div>
        <div class="control-group">
            <button id="updateButton" class="button">
                Atualizar Gráfico
            </button>
        </div>
    </div>

    <!-- Painel de Customização -->
    <details class="customization-panel">
        <summary>Customização do Gráfico</summary>
        <div class="customization-panel__grid">
            <div class="customization-group">
                <label for="showPointsToggle">Exibir Pontos</label>
                <input type="checkbox" id="showPointsToggle" checked class="checkbox-toggle">
            </div>
            <div class="customization-group">
                <label for="pointsColorPicker">Cor Pontos</label>
                <input type="color" id="pointsColorPicker" value="#3B82F6" class="color-picker">
            </div>
            <div class="customization-group">
                <label for="maColorPicker">Cor Média Móvel</label>
                <input type="color" id="maColorPicker" value="#FFFFFF" class="color-picker">
            </div>
            <div class="customization-group">
                <label for="theoryColorPicker">Cor Curva Teórica</label>
                <input type="color" id="theoryColorPicker" value="#EF4444" class="color-picker">
            </div>
            <div class="customization-group customization-group--wide">
                <label for="pointSizeSlider" class="control-group__label">Tamanho Pontos: <span id="pointSizeValue" class="value-display">1</span></label>
                <input type="range" id="pointSizeSlider" min="0" max="5" step="0.5" value="1" class="range-slider">
            </div>
        </div>
    </details>

    <!-- Contêiner do Gráfico e Loader -->
    <div id="chartContainer" class="chart-container">
        <div id="loader" class="loader hidden">
            <div class="loader__spinner"></div>
            <h2 class="loader__title">Calculando primos no servidor...</h2>
            <p class="loader__subtitle">Isso pode levar alguns segundos.</p>
        </div>
        <canvas id="primeChart"></canvas>
    </div>
</div>
