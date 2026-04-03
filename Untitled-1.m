<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mehdi Piano XL - Toutes Musiques</title>
    <style>
        body, html { margin: 0; padding: 0; height: 100%; font-family: 'Segoe UI', sans-serif; background: #1a1a2e; color: white; overflow: hidden; }
        
        /* PAGE DE GARDE */
        #welcome-screen {
            position: fixed; width: 100%; height: 100%; background: radial-gradient(circle, #1a1a2e, #0f0f1a);
            display: flex; flex-direction: column; align-items: center; justify-content: center; z-index: 100;
        }
        .start-btn { padding: 20px 40px; font-size: 1.5rem; background: #2ecc71; color: white; border: none; border-radius: 50px; cursor: pointer; box-shadow: 0 0 20px #2ecc71; }

        /* INTERFACE */
        #piano-interface { display: none; height: 100vh; flex-direction: column; align-items: center; justify-content: center; }
        .piano-container { background: #333; padding: 20px; border-radius: 15px; border: 2px solid #2ecc71; }
        .piano { display: flex; }
        .key { cursor: pointer; transition: 0.1s; position: relative; }
        .white { width: 60px; height: 250px; background: white; border: 1px solid #ddd; border-radius: 0 0 8px 8px; display: flex; align-items: flex-end; justify-content: center; padding-bottom: 15px; color: #333; font-weight: bold; text-align: center; line-height: 1.2; }
        .black { width: 40px; height: 150px; background: #222; margin: 0 -20px; z-index: 2; border-radius: 0 0 5px 5px; }
        
        /* Animation quand la musique joue */
        .playing { background: #ff4d94 !important; color: white !important; transform: translateY(5px); box-shadow: 0 5px 15px #ff4d94; }
    </style>
</head>
<body>

    <div id="welcome-screen">
        <h1 style="font-size: 4rem; color: #2ecc71;">MEHDI PIANO XL</h1>
        <button class="start-btn" onclick="enterPiano()">DÉMARRER L'ORCHESTRE 🎼</button>
    </div>

    <div id="piano-interface">
        <h1 style="color:#2ecc71; margin-bottom: 30px;">Clique sur une touche pour la musique !</h1>
        <div class="piano-container">
            <div class="piano" id="keyboard">
                </div>
        </div>
    </div>

    <script>
        let audioCtx;
        
        // Liste des musiques pour CHAQUE touche blanche
        const playlist = [
            {f: 261, n: "DO", m: "Hymne à la Joie", s: [329, 329, 349, 392, 392, 349, 329, 293]},
            {f: 277, n: ""}, // Noire
            {f: 293, n: "RE", m: "Star Wars", s: [440, 440, 440, 349, 523, 440]},
            {f: 311, n: ""}, // Noire
            {f: 329, n: "MI", m: "Lettre à Élise", s: [659, 622, 659, 622, 659, 494, 587, 523, 440]},
            {f: 349, n: "FA", m: "Pirates", s: [293, 349, 440, 440, 440, 494, 523]},
            {f: 370, n: ""}, // Noire
            {f: 392, n: "SOL", m: "Harry Potter", s: [494, 659, 784, 740, 659, 988]},
            {f: 415, n: ""}, // Noire
            {f: 440, n: "LA", m: "Mission Impossible", s: [440, 440, 523, 587, 440, 440]},
            {f: 466, n: ""}, // Noire
            {f: 494, n: "SI", m: "Bella Ciao", s: [440, 494, 523, 440, 440, 494, 523]},
            {f: 523, n: "DO", m: "Mario Bros", s: [659, 659, 659, 523, 659, 784, 392]}
        ];

        function enterPiano() {
            audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            document.getElementById('welcome-screen').style.display = 'none';
            document.getElementById('piano-interface').style.display = 'flex';
            build();
        }

        function build() {
            const kb = document.getElementById('keyboard');
            playlist.forEach((k) => {
                const div = document.createElement('div');
                div.className = `key ${k.n ? 'white' : 'black'}`;
                div.id = "k-" + k.f;
                if(k.n) div.innerHTML = `<span>${k.n}<br><small style="font-size:0.6rem; color:#f72585;">${k.m}</small></span>`;
                div.onclick = () => k.s ? playMusic(k.s) : playNote(k.f);
                kb.appendChild(div);
            });
        }

        function playNote(f, d = 0.4) {
            const o = audioCtx.createOscillator();
            const g = audioCtx.createGain();
            o.type = 'triangle'; o.frequency.value = f;
            g.gain.setValueAtTime(0.1, audioCtx.currentTime);
            g.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + d);
            o.connect(g); g.connect(audioCtx.destination);
            o.start(); o.stop(audioCtx.currentTime + d);
        }

        async function playMusic(notes) {
            for(let f of notes) {
                const key = document.getElementById("k-" + f);
                if(key) key.classList.add('playing');
                playNote(f, 0.3);
                await new Promise(r => setTimeout(r, 250));
                if(key) key.classList.remove('playing');
            }
        }
    </script>
</body>
</html>
