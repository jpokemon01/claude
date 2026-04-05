const STORAGE_KEY = 'weekly_reports';

// --- State ---
let reports = loadReports();

// --- DOM refs ---
const listView = document.getElementById('list-view');
const formView = document.getElementById('form-view');
const reportList = document.getElementById('report-list');
const reportForm = document.getElementById('report-form');
const formTitle = document.getElementById('form-title');
const deleteBtn = document.getElementById('delete-btn');
const exportBtn = document.getElementById('export-btn');

// --- Init ---
renderList();
setupFormDefaults();

// --- Event listeners ---
document.getElementById('new-report-btn').addEventListener('click', () => openForm());
document.getElementById('back-btn').addEventListener('click', () => showView('list'));
reportForm.addEventListener('submit', saveReport);
deleteBtn.addEventListener('click', deleteReport);
exportBtn.addEventListener('click', exportReport);

// --- Storage ---
function loadReports() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY)) || [];
  } catch {
    return [];
  }
}

function persistReports() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(reports));
}

// --- Views ---
function showView(view) {
  listView.classList.toggle('hidden', view !== 'list');
  formView.classList.toggle('hidden', view !== 'form');
  if (view === 'list') renderList();
}

// --- List ---
function renderList() {
  if (reports.length === 0) {
    reportList.innerHTML = '<p class="empty-state">No reports yet. Create your first weekly report.</p>';
    return;
  }

  const sorted = [...reports].sort((a, b) => b.weekStart.localeCompare(a.weekStart));
  reportList.innerHTML = sorted.map(r => {
    const preview = r.completed ? r.completed.split('\n')[0].replace(/^[-*]\s*/, '') : 'No entries';
    return `
      <div class="report-card" data-id="${r.id}">
        <div class="report-card-info">
          <h3>${formatDateRange(r.weekStart, r.weekEnd)}</h3>
          <p>${preview}</p>
        </div>
        <div class="report-card-meta">${formatDate(r.updatedAt)}</div>
      </div>
    `;
  }).join('');

  reportList.querySelectorAll('.report-card').forEach(card => {
    card.addEventListener('click', () => openForm(card.dataset.id));
  });
}

// --- Form ---
function setupFormDefaults() {
  const today = new Date();
  const day = today.getDay();
  const monday = new Date(today);
  monday.setDate(today.getDate() - (day === 0 ? 6 : day - 1));
  const friday = new Date(monday);
  friday.setDate(monday.getDate() + 4);

  document.getElementById('week-start').value = toISODate(monday);
  document.getElementById('week-end').value = toISODate(friday);
}

function openForm(id) {
  if (id) {
    const report = reports.find(r => r.id === id);
    if (!report) return;
    formTitle.textContent = formatDateRange(report.weekStart, report.weekEnd);
    document.getElementById('report-id').value = report.id;
    document.getElementById('week-start').value = report.weekStart;
    document.getElementById('week-end').value = report.weekEnd;
    document.getElementById('completed').value = report.completed || '';
    document.getElementById('planned').value = report.planned || '';
    document.getElementById('blockers').value = report.blockers || '';
    document.getElementById('notes').value = report.notes || '';
    deleteBtn.classList.remove('hidden');
    exportBtn.classList.remove('hidden');
  } else {
    formTitle.textContent = 'New Weekly Report';
    document.getElementById('report-id').value = '';
    document.getElementById('completed').value = '';
    document.getElementById('planned').value = '';
    document.getElementById('blockers').value = '';
    document.getElementById('notes').value = '';
    setupFormDefaults();
    deleteBtn.classList.add('hidden');
    exportBtn.classList.add('hidden');
  }
  showView('form');
}

function saveReport(e) {
  e.preventDefault();
  const id = document.getElementById('report-id').value;
  const now = new Date().toISOString();

  const data = {
    id: id || crypto.randomUUID(),
    weekStart: document.getElementById('week-start').value,
    weekEnd: document.getElementById('week-end').value,
    completed: document.getElementById('completed').value.trim(),
    planned: document.getElementById('planned').value.trim(),
    blockers: document.getElementById('blockers').value.trim(),
    notes: document.getElementById('notes').value.trim(),
    updatedAt: now,
    createdAt: id ? (reports.find(r => r.id === id)?.createdAt || now) : now,
  };

  if (id) {
    const idx = reports.findIndex(r => r.id === id);
    reports[idx] = data;
  } else {
    reports.push(data);
  }

  persistReports();
  showToast('Report saved');
  showView('list');
}

function deleteReport() {
  const id = document.getElementById('report-id').value;
  if (!id) return;
  if (!confirm('Delete this report?')) return;
  reports = reports.filter(r => r.id !== id);
  persistReports();
  showToast('Report deleted');
  showView('list');
}

function exportReport() {
  const id = document.getElementById('report-id').value;
  const report = reports.find(r => r.id === id);
  if (!report) return;

  const lines = [
    `# Weekly Report: ${formatDateRange(report.weekStart, report.weekEnd)}`,
    '',
    '## Completed This Week',
    report.completed || '(none)',
    '',
    '## Planned for Next Week',
    report.planned || '(none)',
    '',
  ];

  if (report.blockers) {
    lines.push('## Blockers / Issues', report.blockers, '');
  }
  if (report.notes) {
    lines.push('## Notes', report.notes, '');
  }

  const blob = new Blob([lines.join('\n')], { type: 'text/plain' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `weekly-report-${report.weekStart}.txt`;
  a.click();
  URL.revokeObjectURL(url);
  showToast('Report exported');
}

// --- Helpers ---
function toISODate(date) {
  return date.toISOString().split('T')[0];
}

function formatDate(iso) {
  return new Date(iso).toLocaleDateString(undefined, { month: 'short', day: 'numeric' });
}

function formatDateRange(start, end) {
  const s = new Date(start + 'T00:00:00');
  const e = new Date(end + 'T00:00:00');
  const opts = { year: 'numeric', month: 'short', day: 'numeric' };
  return `${s.toLocaleDateString(undefined, opts)} – ${e.toLocaleDateString(undefined, opts)}`;
}

let toastTimer;
function showToast(message) {
  const toast = document.getElementById('toast');
  toast.textContent = message;
  toast.classList.remove('hidden');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toast.classList.add('hidden'), 2500);
}
