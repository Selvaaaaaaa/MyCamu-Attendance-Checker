// State initialization
let totalPeriods = 0;
let periodsPresent = 0;
let historyStack = [];

// Remove local storage references - logic is now session-only

// Update UI inputs from state
function updateDisplay() {
    document.getElementById('total-periods').value = totalPeriods;
    document.getElementById('periods-present').value = periodsPresent;
}

// Update state from UI inputs (Manual Typing)
function updateStateFromInput() {
    const totalInput = parseFloat(document.getElementById('total-periods').value);
    const presentInput = parseFloat(document.getElementById('periods-present').value);

    // Update state if valid numbers, otherwise default to 0 for internal calculations
    totalPeriods = isNaN(totalInput) ? 0 : totalInput;
    periodsPresent = isNaN(presentInput) ? 0 : presentInput;

    // Clear history because manual typing breaks the linear undo chain
    if (historyStack.length > 0) {
        historyStack = [];
        // We could notify user that history is cleared, but let's keep it silent/implicit for now as per minimal requests
    }

    calculatePercentage();
}

// Calculate percentage logic
function calculatePercentage() {
    const resultDiv = document.getElementById('result');

    if (totalPeriods === 0) {
        resultDiv.style.display = 'none';
        return;
    }

    const result = (periodsPresent / totalPeriods) * 100;
    const roundedResult = Math.round(result);

    // Determine status and emoji based on percentage
    let status = '';
    let statusEmoji = '';
    let statusClass = '';

    if (roundedResult >= 75) {
        status = '✓ Great! You\'re safe';
        statusEmoji = '🎉';
        statusClass = 'safe';
    } else if (roundedResult >= 60) {
        status = '⚠ Warning: Attendance is low';
        statusEmoji = '⚠️';
        statusClass = 'warning';
    } else {
        status = '✗ Critical: At risk of being debarred';
        statusEmoji = '🚨';
        statusClass = 'danger';
    }

    resultDiv.className = `result ${statusClass}`;
    resultDiv.innerHTML = `<div style="font-size: 2.5rem; margin-bottom: 0.5rem;">${statusEmoji}</div><div style="font-size: 1.1rem; margin-bottom: 0.5rem;">Overall Attendance</div><div style="font-size: 2.2rem; font-weight: 700;">${roundedResult}%</div><div style="font-size: 0.9rem; margin-top: 0.5rem; opacity: 0.9;">${status}</div>`;
    resultDiv.style.display = 'block';
}

// Button Actions
document.getElementById('btn-present').addEventListener('click', function () {
    // Ensure we start from current input values if they were just typed
    const totalInput = parseFloat(document.getElementById('total-periods').value);
    if (!isNaN(totalInput)) totalPeriods = totalInput;

    const presentInput = parseFloat(document.getElementById('periods-present').value);
    if (!isNaN(presentInput)) periodsPresent = presentInput;

    totalPeriods += 8;
    periodsPresent += 8;
    historyStack.push('P');
    updateDisplay();
    calculatePercentage();
});

document.getElementById('btn-absent').addEventListener('click', function () {
    // Sync first
    const totalInput = parseFloat(document.getElementById('total-periods').value);
    if (!isNaN(totalInput)) totalPeriods = totalInput;

    const presentInput = parseFloat(document.getElementById('periods-present').value);
    if (!isNaN(presentInput)) periodsPresent = presentInput;

    totalPeriods += 8;
    periodsPresent += 0;
    historyStack.push('A');
    updateDisplay();
    calculatePercentage();
});

document.getElementById('btn-undo').addEventListener('click', function () {
    if (historyStack.length === 0) {
        alert("Nothing to undo! (History is cleared if you edit manually)");
        return;
    }

    const lastAction = historyStack.pop();

    if (lastAction === 'P') {
        totalPeriods -= 8;
        periodsPresent -= 8;
    } else if (lastAction === 'A') {
        totalPeriods -= 8;
        // periodsPresent -= 0; 
    }

    // Safety check
    if (totalPeriods < 0) totalPeriods = 0;
    if (periodsPresent < 0) periodsPresent = 0;

    updateDisplay();
    calculatePercentage();
});

document.getElementById('btn-reset').addEventListener('click', function () {
    if (confirm("Are you sure you want to reset all data?")) {
        totalPeriods = 0;
        periodsPresent = 0;
        historyStack = [];
        updateDisplay();
        document.getElementById('result').style.display = 'none';
    }
});

// Manual Input Listeners
document.getElementById('total-periods').addEventListener('input', updateStateFromInput);
document.getElementById('periods-present').addEventListener('input', updateStateFromInput);

// Initialize (just start fresh)
updateDisplay();


