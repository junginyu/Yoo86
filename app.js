// ─── Pet sprites ────────────────────────────────────────────────────────────
const SPRITES = {
    baby:  { happy:'🐣', hungry:'🐣', sad:'🐣', sick:'🤕', sleeping:'💤', dead:'💀' },
    child: { happy:'🐥', hungry:'🐥', sad:'🐥', sick:'🤕', sleeping:'💤', dead:'💀' },
    teen:  { happy:'🦆', hungry:'🦆', sad:'🦆', sick:'🤕', sleeping:'💤', dead:'💀' },
    adult: { happy:'🦅', hungry:'🦅', sad:'🦅', sick:'🤕', sleeping:'💤', dead:'💀' },
};

const MOOD_ICON = {
    happy:'😊', hungry:'😋', sad:'😢', sick:'🤢', sleeping:'💤', dead:''
};

const STAGE_LABEL = {
    baby:'🥚 아기', child:'🐥 어린이', teen:'🐦 청소년', adult:'🦅 어른'
};

// ─── Default state ───────────────────────────────────────────────────────────
function defaultPet() {
    return {
        stage:      'baby',
        mood:       'happy',
        hunger:     100,
        happiness:  100,
        health:     100,
        energy:     100,
        age:        0,       // minutes of game-time
        isSleeping: false,
        isDead:     false,
        lastSaved:  Date.now(),
    };
}

// ─── Game state ───────────────────────────────────────────────────────────────
let pet = defaultPet();
let gameLoopId = null;
let msgTimerId = null;

// ─── Constants ───────────────────────────────────────────────────────────────
const TICK_MS          = 5000;  // game tick every 5 s
const HUNGER_DECAY     = 3;
const HAPPY_DECAY      = 2;
const HEALTH_DMG       = 2;     // per tick when stats critical
const HEALTH_REGEN     = 1;     // per tick when stats good
const SLEEP_ENERGY     = 6;     // energy gain per tick while sleeping
const SLEEP_HUNGER     = 1;     // slow hunger decay while sleeping
const MAX_OFFLINE_TICKS = 120;  // cap offline punishment (~10 min)

// ─── Init ─────────────────────────────────────────────────────────────────────
window.addEventListener('load', () => {
    load();
    startLoop();
    renderAll();
    updateClock();
    setInterval(updateClock, 30000);
});

window.addEventListener('beforeunload', save);

// ─── Persistence ─────────────────────────────────────────────────────────────
function save() {
    pet.lastSaved = Date.now();
    localStorage.setItem('tama_pet', JSON.stringify(pet));
}

function load() {
    const raw = localStorage.getItem('tama_pet');
    if (!raw) return;
    try {
        const saved = JSON.parse(raw);
        pet = { ...defaultPet(), ...saved };

        // Apply offline decay
        const elapsed = Date.now() - pet.lastSaved;
        const ticks   = Math.min(Math.floor(elapsed / TICK_MS), MAX_OFFLINE_TICKS);
        if (!pet.isDead && ticks > 0) {
            applyDecay(ticks);
            if (ticks > 6) showMsg(`${Math.round(elapsed / 1000)}초 동안 자리를 비웠네요!\n펫 상태를 확인해주세요 🔍`);
        }
    } catch (_) {
        pet = defaultPet();
    }
}

// ─── Game loop ────────────────────────────────────────────────────────────────
function startLoop() {
    if (gameLoopId) clearInterval(gameLoopId);
    gameLoopId = setInterval(tick, TICK_MS);
}

function tick() {
    if (pet.isDead) return;

    pet.age += TICK_MS / 60000;
    checkStageUp();

    if (pet.isSleeping) {
        pet.energy = Math.min(100, pet.energy + SLEEP_ENERGY);
        pet.hunger = Math.max(0,   pet.hunger - SLEEP_HUNGER);
        if (pet.energy >= 100) {
            pet.isSleeping = false;
            showMsg('잘 잤어요! 이제 놀아요! ☀️');
        }
    } else {
        applyDecay(1);
    }

    calcMood();
    checkDeath();
    renderAll();
    save();
}

// ─── Decay logic ─────────────────────────────────────────────────────────────
function applyDecay(n) {
    for (let i = 0; i < n; i++) {
        if (pet.isDead) break;
        pet.hunger    = Math.max(0, pet.hunger    - HUNGER_DECAY);
        pet.happiness = Math.max(0, pet.happiness - HAPPY_DECAY);

        if (pet.hunger < 20 || pet.happiness < 20) {
            pet.health = Math.max(0, pet.health - HEALTH_DMG);
        } else if (pet.hunger > 60 && pet.happiness > 60) {
            pet.health = Math.min(100, pet.health + HEALTH_REGEN);
        }
    }
}

// ─── Stage progression ───────────────────────────────────────────────────────
function checkStageUp() {
    const prev = pet.stage;
    if      (pet.age <  2)  pet.stage = 'baby';
    else if (pet.age < 10)  pet.stage = 'child';
    else if (pet.age < 30)  pet.stage = 'teen';
    else                    pet.stage = 'adult';

    if (pet.stage !== prev) showMsg(`펫이 성장했어요!\n${STAGE_LABEL[pet.stage]} 🎉`);
}

// ─── Mood calculation ─────────────────────────────────────────────────────────
function calcMood() {
    if (pet.isDead)     { pet.mood = 'dead';     return; }
    if (pet.isSleeping) { pet.mood = 'sleeping'; return; }

    const { hunger, happiness, health } = pet;
    if (health    < 30) pet.mood = 'sick';
    else if (hunger    < 25) pet.mood = 'hungry';
    else if (happiness < 25) pet.mood = 'sad';
    else                     pet.mood = 'happy';
}

// ─── Death check ──────────────────────────────────────────────────────────────
function checkDeath() {
    if (pet.health > 0) return;
    pet.isDead = true;
    pet.mood   = 'dead';
    showMsg('펫이 무지개 다리를 건넜어요... 😢\n화면을 탭하면 새로운 펫이 태어나요!');
    document.getElementById('pet').addEventListener('click', promptReset, { once: true });
}

// ─── Render ───────────────────────────────────────────────────────────────────
function renderAll() {
    renderPet();
    renderStats();
}

function renderPet() {
    const petEl  = document.getElementById('pet');
    const moodEl = document.getElementById('pet-mood');
    const screen = document.getElementById('screen');
    const ageEl  = document.getElementById('age-display');

    petEl.textContent  = SPRITES[pet.stage]?.[pet.mood] ?? '🐣';
    moodEl.textContent = MOOD_ICON[pet.mood] ?? '';
    ageEl.textContent  = STAGE_LABEL[pet.stage];

    // Animation class
    petEl.className = 'pet';
    if (pet.isDead)          petEl.classList.add('dead');
    else if (pet.isSleeping) petEl.classList.add('sleeping');
    else if (pet.mood === 'sick') petEl.classList.add('sick');

    // Danger flash
    if (!pet.isDead && pet.health < 30) screen.classList.add('danger');
    else                                 screen.classList.remove('danger');
}

function renderStats() {
    setBar('hunger',    pet.hunger);
    setBar('happiness', pet.happiness);
    setBar('health',    pet.health);
    setBar('energy',    pet.energy);
}

function setBar(name, value) {
    const v = Math.round(Math.max(0, Math.min(100, value)));
    document.getElementById(`${name}-bar`).style.width = `${v}%`;
    document.getElementById(`${name}-val`).textContent = v;
}

function updateClock() {
    const d = new Date();
    const h = String(d.getHours()).padStart(2, '0');
    const m = String(d.getMinutes()).padStart(2, '0');
    document.getElementById('time-display').textContent = `${h}:${m}`;
}

// ─── Actions ─────────────────────────────────────────────────────────────────
function feed() {
    if (guardDead()) return;
    if (guardSleep()) return;
    if (pet.hunger >= 100) { showMsg('배가 너무 불러요! 🤭'); return; }

    pet.hunger    = Math.min(100, pet.hunger    + 25);
    pet.happiness = Math.min(100, pet.happiness + 5);
    animatePet('eating', 1400);
    showMsg('냠냠! 맛있다! 🍎');
    finishAction();
}

function play() {
    if (guardDead()) return;
    if (guardSleep()) return;
    if (pet.energy < 15)      { showMsg('너무 피곤해요! 먼저 재워주세요! 😴'); return; }
    if (pet.happiness >= 100) { showMsg('이미 너무 행복해요! 🥳'); return; }

    pet.happiness = Math.min(100, pet.happiness + 20);
    pet.energy    = Math.max(0,   pet.energy    - 15);
    pet.hunger    = Math.max(0,   pet.hunger    - 5);
    animatePet('playing', 1400);
    const msgs = ['신난다! 같이 놀아요! 🎮', '야호! 재밌어요! ⭐', '더 놀고 싶어요! 🎉'];
    showMsg(msgs[Math.floor(Math.random() * msgs.length)]);
    finishAction();
}

function toggleSleep() {
    if (guardDead()) return;
    if (pet.isSleeping) {
        pet.isSleeping = false;
        showMsg('일어났어요! 좋은 아침이에요! ☀️');
    } else {
        if (pet.energy >= 95) { showMsg('아직 안 피곤해요! 🙅'); return; }
        pet.isSleeping = true;
        showMsg('쿨쿨... 자는 중이에요 💤');
    }
    finishAction();
}

function heal() {
    if (guardDead()) return;
    if (guardSleep()) return;
    if (pet.health >= 100) { showMsg('이미 건강해요! 💪'); return; }

    pet.health = Math.min(100, pet.health + 30);
    animatePet('eating', 1400);
    showMsg('약을 먹었어요! 건강해져요! 💊');
    finishAction();
}

function finishAction() {
    calcMood();
    renderAll();
    save();
}

// ─── Guards ───────────────────────────────────────────────────────────────────
function guardDead() {
    if (pet.isDead) { showMsg('펫이 없어요...\n화면을 탭해서 새 펫을 키워요!'); return true; }
    return false;
}
function guardSleep() {
    if (pet.isSleeping) { showMsg('펫이 자고 있어요! 💤'); return true; }
    return false;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
function animatePet(cls, durationMs) {
    const el = document.getElementById('pet');
    el.classList.add(cls);
    setTimeout(() => el.classList.remove(cls), durationMs);
}

function showMsg(text) {
    const popup = document.getElementById('message-popup');
    popup.textContent = text;
    popup.classList.add('show');
    if (msgTimerId) clearTimeout(msgTimerId);
    msgTimerId = setTimeout(() => popup.classList.remove('show'), 2800);
}

function promptReset() {
    if (confirm('새로운 펫을 키우시겠어요? 🥚')) resetGame();
}

function resetGame() {
    localStorage.removeItem('tama_pet');
    pet = defaultPet();
    document.getElementById('screen').classList.remove('danger');
    calcMood();
    renderAll();
    showMsg('새로운 펫이 태어났어요! 🎉\n잘 부탁드려요!');
}
