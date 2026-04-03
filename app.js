// ─── Sprite parser ───────────────────────────────────────────────────────────
function spr(rows) {
    return rows.map(row => [...row].map(c => c !== '.'));
}

// ─── 12×12 Pet sprites ───────────────────────────────────────────────────────
// Baby
const BABY_H = spr([
    '....XXXX....',
    '..XX....XX..',
    '.X.XX..XX.X.',
    '.X........X.',
    '.X..XXXX..X.',
    '..XX....XX..',
    '....XXXX....',
    '............',
    '............',
    '............',
    '............',
    '............',
]);

const BABY_S = spr([
    '....XXXX....',
    '..XX....XX..',
    '.X.XX..XX.X.',
    '.X........X.',
    '.XX.XXXX.XX.',
    '..XX....XX..',
    '....XXXX....',
    '............',
    '............',
    '............',
    '............',
    '............',
]);

const BABY_K = spr([
    '....XXXX....',
    '..XX....XX..',
    '.X.X.XX.X.X.',
    '.X........X.',
    '.XX.X..X.XX.',
    '..XX.XX.XX..',
    '....XXXX....',
    '............',
    '............',
    '............',
    '............',
    '............',
]);

const BABY_Z = spr([
    '....XXXX....',
    '..XX....XX..',
    '.XXXXXXXXXX.',
    '.X..XX....X.',
    '.X..XX....X.',
    '..XX....XX..',
    '....XXXX....',
    '............',
    '............',
    '............',
    '............',
    '............',
]);

const BABY_D = spr([
    '....XXXX....',
    '..XX....XX..',
    '.X.X.XX.X.X.',
    '.X........X.',
    '.X........X.',
    '..XX....XX..',
    '....XXXX....',
    '............',
    '............',
    '............',
    '............',
    '............',
]);

// Child
const CHILD_H = spr([
    '....XXXX....',
    '..XXXXXXXX..',
    '.X.XX..XX.X.',
    '.XXXXXXXXXX.',
    '.X..XXXX..X.',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '...XX..XX...',
    '............',
    '............',
    '............',
]);

const CHILD_S = spr([
    '....XXXX....',
    '..XXXXXXXX..',
    '.X.XX..XX.X.',
    '.XXXXXXXXXX.',
    '.XX.XXXX.XX.',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '...XX..XX...',
    '............',
    '............',
    '............',
]);

const CHILD_K = spr([
    '....XXXX....',
    '..XXXXXXXX..',
    '.X.X.XX.X.X.',
    '.XXXXXXXXXX.',
    '.XX.X..X.XX.',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '...XX..XX...',
    '............',
    '............',
    '............',
]);

const CHILD_Z = spr([
    '....XXXX....',
    '..XXXXXXXX..',
    '.XXXXXXXXXX.',
    '.XXXXXXXXXX.',
    '.X..XXXX..X.',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '............',
    '............',
    '............',
    '............',
]);

const CHILD_D = spr([
    '....XXXX....',
    '..XXXXXXXX..',
    '.X.X.XX.X.X.',
    '.XXXXXXXXXX.',
    '.X........X.',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '...XX..XX...',
    '............',
    '............',
    '............',
]);

// Teen
const TEEN_H = spr([
    '..XXXXXXXX..',
    '.XXXXXXXXXX.',
    'XX.XX..XX.XX',
    'XXXXXXXXXXXX',
    'XX.XXXXXX.XX',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
    '............',
]);

const TEEN_S = spr([
    '..XXXXXXXX..',
    '.XXXXXXXXXX.',
    'XX.XX..XX.XX',
    'XXXXXXXXXXXX',
    'XXX.XXXX.XXX',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
    '............',
]);

const TEEN_K = spr([
    '..XXXXXXXX..',
    '.XXXXXXXXXX.',
    'XX.X.XX.X.XX',
    'XXXXXXXXXXXX',
    'XX.X..X..XX.',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
    '............',
]);

const TEEN_Z = spr([
    '..XXXXXXXX..',
    '.XXXXXXXXXX.',
    'XXXXXXXXXXXX',
    'XXXXXXXXXXXX',
    'XX.XXXXXX.XX',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '............',
    '............',
    '............',
    '............',
]);

const TEEN_D = spr([
    '..XXXXXXXX..',
    '.XXXXXXXXXX.',
    'XX.X.XX.X.XX',
    'XXXXXXXXXXXX',
    'XX........XX',
    '.XXXXXXXXXX.',
    '..XXXXXXXX..',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
    '............',
]);

// Adult
const ADULT_H = spr([
    '.XXXXXXXXXX.',
    'X.XXXXXXXX.X',
    'X.XX....XX.X',
    'XXXXXXXXXXXX',
    'X..XXXXXX..X',
    'XXXXXXXXXXXX',
    'X.XXXXXXXX.X',
    '.XXXXXXXXXX.',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
]);

const ADULT_S = spr([
    '.XXXXXXXXXX.',
    'X.XXXXXXXX.X',
    'X.XX....XX.X',
    'XXXXXXXXXXXX',
    'X.XXXXXXXX.X',
    'XXXXXXXXXXXX',
    'X.XXXXXXXX.X',
    '.XXXXXXXXXX.',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
]);

const ADULT_K = spr([
    '.XXXXXXXXXX.',
    'X.XXXXXXXX.X',
    'X.X.XXXX.X.X',
    'XXXXXXXXXXXX',
    'X.XX....XX.X',
    'XXXXXXXXXXXX',
    'X.XXXXXXXX.X',
    '.XXXXXXXXXX.',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
]);

const ADULT_Z = spr([
    '.XXXXXXXXXX.',
    'X.XXXXXXXX.X',
    'XXXXXXXXXXXX',
    'XXXXXXXXXXXX',
    'X..XXXXXX..X',
    'XXXXXXXXXXXX',
    'X.XXXXXXXX.X',
    '.XXXXXXXXXX.',
    '...XX..XX...',
    '............',
    '............',
    '............',
]);

const ADULT_D = spr([
    '.XXXXXXXXXX.',
    'X.XXXXXXXX.X',
    'X.X.XXXX.X.X',
    'XXXXXXXXXXXX',
    'X..........X',
    'XXXXXXXXXXXX',
    'X.XXXXXXXX.X',
    '.XXXXXXXXXX.',
    '...XX..XX...',
    '..XXX..XXX..',
    '............',
    '............',
]);

// ─── Effect sprites ───────────────────────────────────────────────────────────
const Z_BIG = spr([
    'XXXXX',
    '....X',
    '..X..',
    'X....',
    'XXXXX',
]);

const Z_SML = spr([
    'XXX',
    '..X',
    '.X.',
    'X..',
    'XXX',
]);

const HEART = spr([
    '.X.X.',
    'XXXXX',
    'XXXXX',
    '.XXX.',
    '..X..',
]);

const NOTE_MUS = spr([
    '.XX..',
    'XXX..',
    'X....',
    'X..XX',
    'X.XXX',
    '.XXXX',
    '..XXX',
]);

// ─── Sprite lookup ───────────────────────────────────────────────────────────
const PIXEL_SPRITES = {
    baby:  { happy: BABY_H,  sad: BABY_S,  sick: BABY_K,  hungry: BABY_H,  sleeping: BABY_Z,  dead: BABY_D  },
    child: { happy: CHILD_H, sad: CHILD_S, sick: CHILD_K, hungry: CHILD_S, sleeping: CHILD_Z, dead: CHILD_D },
    teen:  { happy: TEEN_H,  sad: TEEN_S,  sick: TEEN_K,  hungry: TEEN_S,  sleeping: TEEN_Z,  dead: TEEN_D  },
    adult: { happy: ADULT_H, sad: ADULT_S, sick: ADULT_K, hungry: ADULT_S, sleeping: ADULT_Z, dead: ADULT_D },
};

// ─── Stage labels ─────────────────────────────────────────────────────────────
const STAGE_LABEL = { baby: 'EGG', child: 'CHILD', teen: 'TEEN', adult: 'ADULT' };

// ─── Game Boy palette ─────────────────────────────────────────────────────────
const GB0 = '#9bbc0f'; // light (off pixel)
const GB3 = '#0f380f'; // dark  (on pixel)

// ─── Canvas animation state ───────────────────────────────────────────────────
let rafId       = null;
let frameCount  = 0;
let animState   = { cls: '', until: 0 }; // brief action animation flag

// ─── Default state ───────────────────────────────────────────────────────────
function defaultPet() {
    return {
        stage:      'baby',
        mood:       'happy',
        hunger:     100,
        happiness:  100,
        health:     100,
        energy:     100,
        age:        0,
        isSleeping: false,
        isDead:     false,
        lastSaved:  Date.now(),
    };
}

// ─── Game state ───────────────────────────────────────────────────────────────
let pet        = defaultPet();
let gameLoopId = null;
let msgTimerId = null;

// ─── Constants ───────────────────────────────────────────────────────────────
const TICK_MS           = 5000;
const HUNGER_DECAY      = 3;
const HAPPY_DECAY       = 2;
const HEALTH_DMG        = 2;
const HEALTH_REGEN      = 1;
const SLEEP_ENERGY      = 6;
const SLEEP_HUNGER      = 1;
const MAX_OFFLINE_TICKS = 120;

// ─── Web Audio ────────────────────────────────────────────────────────────────
let audioCtx = null;
function getAudio() {
    if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    return audioCtx;
}
function beep(freq, dur, type = 'square') {
    try {
        const ctx  = getAudio();
        const osc  = ctx.createOscillator();
        const gain = ctx.createGain();
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.type            = type;
        osc.frequency.value = freq;
        gain.gain.setValueAtTime(0.07, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + dur);
        osc.start();
        osc.stop(ctx.currentTime + dur);
    } catch (e) {}
}

// ─── Init ─────────────────────────────────────────────────────────────────────
window.addEventListener('load', () => {
    setupBars();
    load();
    startLoop();
    startAnim();
    renderAll();
    updateClock();
    setInterval(updateClock, 30000);
});

window.addEventListener('beforeunload', save);

// ─── Block bar setup ─────────────────────────────────────────────────────────
function setupBars() {
    ['hunger', 'happiness', 'health', 'energy'].forEach(name => {
        const bar = document.getElementById(`bar-${name}`);
        if (!bar) return;
        bar.innerHTML = '';
        for (let i = 0; i < 10; i++) {
            const blk = document.createElement('div');
            blk.className = 'blk';
            bar.appendChild(blk);
        }
    });
}

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

        const elapsed = Date.now() - pet.lastSaved;
        const ticks   = Math.min(Math.floor(elapsed / TICK_MS), MAX_OFFLINE_TICKS);
        if (!pet.isDead && ticks > 0) {
            applyDecay(ticks);
            if (ticks > 6) showMsg(`Away for ${Math.round(elapsed / 1000)}s! Check your pet.`);
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
            showMsg('Rested up! Time to play! ☀️');
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
    if      (pet.age <  2) pet.stage = 'baby';
    else if (pet.age < 10) pet.stage = 'child';
    else if (pet.age < 30) pet.stage = 'teen';
    else                   pet.stage = 'adult';

    if (pet.stage !== prev) {
        showMsg(`Your pet grew up! Now: ${STAGE_LABEL[pet.stage]}!`);
        playLevelUp();
    }
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
    showMsg('Your pet has passed away... 😢 Tap the screen to start over!');
    const canvas = document.getElementById('pet-canvas');
    if (canvas) canvas.addEventListener('click', promptReset, { once: true });
}

// ─── Render ───────────────────────────────────────────────────────────────────
function renderAll() {
    renderPet();
    renderStats();
}

function renderPet() {
    const ageEl  = document.getElementById('age-display');
    const screen = document.getElementById('screen');

    if (ageEl) ageEl.textContent = STAGE_LABEL[pet.stage];

    // Danger flash on screen border
    if (!pet.isDead && pet.health < 30) screen && screen.classList.add('danger');
    else                                screen && screen.classList.remove('danger');
}

function renderStats() {
    ['hunger', 'happiness', 'health', 'energy'].forEach(name => {
        const val    = Math.round(pet[name]);
        const filled = Math.round(val / 10);
        document.querySelectorAll(`#bar-${name} .blk`).forEach((b, i) => {
            b.className = 'blk' + (i < filled ? ' on' : '');
        });
    });
}

function updateClock() {
    const d = new Date();
    const h = String(d.getHours()).padStart(2, '0');
    const m = String(d.getMinutes()).padStart(2, '0');
    const el = document.getElementById('time-display');
    if (el) el.textContent = `${h}:${m}`;
}

// ─── Canvas rendering ─────────────────────────────────────────────────────────
function startAnim() {
    if (rafId) cancelAnimationFrame(rafId);
    function loop() {
        frameCount++;
        renderCanvas();
        rafId = requestAnimationFrame(loop);
    }
    rafId = requestAnimationFrame(loop);
}

function renderCanvas() {
    const canvas = document.getElementById('pet-canvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const W   = canvas.width;   // 128
    const H   = canvas.height;  // 72

    // Background fill
    ctx.fillStyle = GB0;
    ctx.fillRect(0, 0, W, H);

    // Ground dots at y=68, every 4px (alternate positions: 0, 8, 16 ...)
    ctx.fillStyle = GB3;
    for (let x = 0; x < W; x += 8) {
        ctx.fillRect(x, 68, 2, 2);
    }

    // Bob animation (flat when dead)
    const bobY = pet.isDead ? 0 : Math.sin(frameCount * 0.05) * 3;

    // Sprite scale and center
    const SCALE    = 4;
    const SPR_SIZE = 12 * SCALE; // 48
    const sx       = Math.floor((W - SPR_SIZE) / 2);          // 40
    const sy       = Math.floor((H - SPR_SIZE) / 2 + bobY);   // ~12

    // Extra bounce during action animation
    let extraBob = 0;
    if (animState.until > Date.now()) {
        extraBob = Math.sin(frameCount * 0.3) * 4;
    }

    // Pick sprite
    const stage  = pet.stage in PIXEL_SPRITES ? pet.stage : 'baby';
    const mood   = pet.mood  in PIXEL_SPRITES[stage] ? pet.mood : 'happy';
    const sprite = PIXEL_SPRITES[stage][mood];

    // Draw main sprite
    ctx.fillStyle = GB3;
    sprite.forEach((row, ry) => {
        row.forEach((on, rx) => {
            if (on) {
                ctx.fillRect(
                    sx + rx * SCALE,
                    sy + ry * SCALE + extraBob,
                    SCALE,
                    SCALE
                );
            }
        });
    });

    // ── Sleeping Zs ──
    if (pet.mood === 'sleeping') {
        const alpha = Math.abs(Math.sin(frameCount * 0.03));
        ctx.globalAlpha = alpha;
        ctx.fillStyle   = GB3;
        // Z_BIG at (sx+50, sy+2) scale 2
        drawEffect(ctx, Z_BIG, sx + 50, sy + 2, 2);
        // Z_SML at (sx+60, sy-4) scale 2
        drawEffect(ctx, Z_SML, sx + 60, sy - 4, 2);
        ctx.globalAlpha = 1;
    }

    // ── Happy hearts ──
    if (pet.mood === 'happy') {
        const phase  = Math.floor(frameCount / 60) % 2;
        const alpha2 = phase === 0
            ? Math.min(1, (frameCount % 60) / 20)
            : Math.max(0, 1 - (frameCount % 60) / 20);
        ctx.globalAlpha = alpha2;
        ctx.fillStyle   = GB3;
        drawEffect(ctx, HEART, sx - 10, sy, 2);
        ctx.globalAlpha = 1;
    }

    // ── Sick wavy dots ──
    if (pet.mood === 'sick') {
        ctx.fillStyle = GB3;
        for (let i = 0; i < 6; i++) {
            const wx = sx - 8 + i * 4;
            const wy = sy + 30 + Math.sin(frameCount * 0.1 + i) * 3;
            ctx.fillRect(Math.round(wx), Math.round(wy), 1, 1);
        }
    }
}

function drawEffect(ctx, sprite, ox, oy, scale) {
    sprite.forEach((row, ry) => {
        row.forEach((on, rx) => {
            if (on) {
                ctx.fillRect(ox + rx * scale, oy + ry * scale, scale, scale);
            }
        });
    });
}

// ─── Actions ─────────────────────────────────────────────────────────────────
function feed() {
    if (guardDead()) return;
    if (guardSleep()) return;
    if (pet.hunger >= 100) { showMsg('Too full! 🤭'); return; }

    pet.hunger    = Math.min(100, pet.hunger    + 25);
    pet.happiness = Math.min(100, pet.happiness + 5);
    animatePet('eating', 1400);
    showMsg('Yum yum! Delicious! 🍎');
    beep(523, 0.08);
    setTimeout(() => beep(659, 0.12), 100);
    finishAction();
}

function play() {
    if (guardDead()) return;
    if (guardSleep()) return;
    if (pet.energy < 15)      { showMsg('Too tired! Let me sleep first! 😴'); return; }
    if (pet.happiness >= 100) { showMsg('Already super happy! 🥳'); return; }

    pet.happiness = Math.min(100, pet.happiness + 20);
    pet.energy    = Math.max(0,   pet.energy    - 15);
    pet.hunger    = Math.max(0,   pet.hunger    - 5);
    animatePet('playing', 1400);
    const msgs = ['Wheee! Let\'s play! 🎮', 'Yay! So fun! ⭐', 'More! More! 🎉'];
    showMsg(msgs[Math.floor(Math.random() * msgs.length)]);
    beep(659, 0.06);
    setTimeout(() => beep(784, 0.06), 80);
    setTimeout(() => beep(880, 0.1),  160);
    finishAction();
}

function toggleSleep() {
    if (guardDead()) return;
    if (pet.isSleeping) {
        pet.isSleeping = false;
        showMsg('Good morning! ☀️');
        beep(330, 0.25);
    } else {
        if (pet.energy >= 95) { showMsg('Not tired yet! 🙅'); return; }
        pet.isSleeping = true;
        showMsg('Zzz... Sleeping... 💤');
        beep(330, 0.25);
    }
    finishAction();
}

function heal() {
    if (guardDead()) return;
    if (guardSleep()) return;
    if (pet.health >= 100) { showMsg('Already healthy! 💪'); return; }

    pet.health = Math.min(100, pet.health + 30);
    animatePet('healing', 1400);
    showMsg('Took medicine! Feeling better! 💊');
    beep(440, 0.08);
    setTimeout(() => beep(554, 0.12), 110);
    finishAction();
}

function finishAction() {
    calcMood();
    renderAll();
    save();
}

// ─── Guards ───────────────────────────────────────────────────────────────────
function guardDead() {
    if (pet.isDead) { showMsg('No pet... Tap screen for a new one!'); return true; }
    return false;
}
function guardSleep() {
    if (pet.isSleeping) { showMsg('Pet is sleeping! 💤'); return true; }
    return false;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
function animatePet(cls, durationMs) {
    animState = { cls, until: Date.now() + durationMs };
}

function showMsg(text) {
    const toast = document.getElementById('toast');
    if (!toast) return;
    toast.textContent = text;
    toast.classList.add('show');
    if (msgTimerId) clearTimeout(msgTimerId);
    msgTimerId = setTimeout(() => toast.classList.remove('show'), 2800);
}

function playLevelUp() {
    const notes = [523, 659, 784, 1047];
    notes.forEach((freq, i) => {
        setTimeout(() => beep(freq, 0.15), i * 100);
    });
}

function promptReset() {
    if (confirm('Start a new pet? 🥚')) resetGame();
}

function resetGame() {
    const canvas = document.getElementById('pet-canvas');
    if (canvas) canvas.removeEventListener('click', promptReset);

    localStorage.removeItem('tama_pet');
    pet = defaultPet();
    const screen = document.getElementById('screen');
    if (screen) screen.classList.remove('danger');
    calcMood();
    renderAll();
    showMsg('A new pet was born! 🎉 Nice to meet you!');
}
