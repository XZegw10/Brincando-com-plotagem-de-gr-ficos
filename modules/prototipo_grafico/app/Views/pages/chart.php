<!-- Este é o contêiner principal da aplicação, que será inserido no layout 'main.php' -->
<div class="w-full max-w-6xl bg-gray-800 rounded-2xl shadow-2xl p-6 md:p-8 space-y-6">
    <div class="text-center">
        <h1 class="text-2xl md:text-3xl font-bold text-white">Analisador Interativo da Razão entre Primos</h1>
        <p class="text-gray-400 mt-2">Visualize a tendência da razão $p_n / p_{n-1}$ e suavize-a com uma média móvel.</p>
    </div>

    <!-- Controles Principais -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 bg-gray-900/50 p-6 rounded-xl items-end">
        <div class="md:col-span-2">
            <label for="primeCount" class="block text-sm font-medium text-gray-300 mb-2">Nº de Primos (máx. 100.000)</label>
            <input type="number" id="primeCount" value="5000" min="10" max="100000" class="w-full bg-gray-700 border border-gray-600 text-white rounded-lg p-2.5 focus:ring-blue-500 focus:border-blue-500 transition">
        </div>
        <div class="md:col-span-1">
            <label for="movingAverage" class="block text-sm font-medium text-gray-300 mb-2">Média Móvel: <span id="maValue" class="font-bold text-blue-400">200</span></label>
            <input type="range" id="movingAverage" min="2" max="1000" value="200" class="w-full h-2 bg-gray-700 rounded-lg appearance-none cursor-pointer" disabled>
        </div>
        <div class="md:col-span-1">
            <button id="updateButton" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 px-4 rounded-lg transition-colors">
                Atualizar Gráfico
            </button>
        </div>
    </div>

    <!-- Painel de Customização -->
    <details class="bg-gray-900/50 p-6 rounded-xl transition-all duration-300">
        <summary class="text-lg font-semibold text-white cursor-pointer hover:text-blue-400">Customização do Gráfico</summary>
        <div class="mt-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="flex flex-col items-center justify-center bg-gray-700/50 p-4 rounded-lg">
                <label for="showPointsToggle" class="text-sm font-medium text-gray-300 mb-2">Exibir Pontos</label>
                <input type="checkbox" id="showPointsToggle" checked class="w-6 h-6 text-blue-600 bg-gray-600 border-gray-500 rounded focus:ring-blue-500">
            </div>
            <div class="flex flex-col items-center justify-center bg-gray-700/50 p-4 rounded-lg">
                <label class="text-sm font-medium text-gray-300 mb-2">Cor Pontos</label>
                <input type="color" id="pointsColorPicker" value="#3B82F6">
            </div>
            <div class="flex flex-col items-center justify-center bg-gray-700/50 p-4 rounded-lg">
                <label class="text-sm font-medium text-gray-300 mb-2">Cor Média Móvel</label>
                <input type="color" id="maColorPicker" value="#FFFFFF">
            </div>
            <div class="flex flex-col items-center justify-center bg-gray-700/50 p-4 rounded-lg">
                <label class="text-sm font-medium text-gray-300 mb-2">Cor Curva Teórica</label>
                <input type="color" id="theoryColorPicker" value="#EF4444">
            </div>
            <div class="sm:col-span-2 lg:col-span-4 bg-gray-700/50 p-4 rounded-lg">
                <label for="pointSizeSlider" class="block text-sm font-medium text-gray-300 mb-2">Tamanho Pontos: <span id="pointSizeValue" class="font-bold text-blue-400">1</span></label>
                <input type="range" id="pointSizeSlider" min="0" max="5" step="0.5" value="1" class="w-full h-2 bg-gray-600 rounded-lg appearance-none cursor-pointer">
            </div>
        </div>
    </details>

    <!-- Contêiner do Gráfico e Loader -->
    <div id="chartContainer" class="bg-gray-900/50 p-4 rounded-xl min-h-[50vh] flex items-center justify-center">
        <div id="loader" class="hidden flex-col items-center justify-center text-center">
            <div class="loader ease-linear rounded-full border-8 border-t-8 border-gray-600 h-24 w-24 mb-4"></div>
            <h2 class="text-xl font-semibold text-white">Calculando primos no servidor...</h2>
            <p class="text-gray-400">Isso pode levar alguns segundos.</p>
        </div>
        <canvas id="primeChart"></canvas>
    </div>
</div>
