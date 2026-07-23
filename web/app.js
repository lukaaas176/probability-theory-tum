/*
 * Probability Theory — Interactive Lernskript
 * Progressive-enhancement layer over the static Typst HTML export.
 * Vanilla JS, no build step, no ES modules (loaded as a classic <script>,
 * must also work when the final page is opened directly via file://).
 */
(function () {
  'use strict';

  var PROGRESS_KEY = 'dwt-progress';
  var READING_KEY = 'dwt-reading-progress';
  var THEME_KEY = 'dwt-theme';
  var SIDEBAR_BREAKPOINT_QUERY = '(min-width: 1024px)';
  // Same "top quarter of the viewport" reference line the scroll-spy uses
  // (IntersectionObserver rootMargin '-75% bottom'), so "read" and "current
  // chapter" agree on what counts as having reached a point in the text.
  var READ_LINE_VIEWPORT_FRACTION = 0.25;

  var RATING_ORDER = ['again', 'know', 'sure'];
  var RATING_LABELS = {
    again: '✖ again',
    know: '✓ know',
    sure: '★ sure'
  };

  var THEME_ORDER = ['light', 'dark', 'auto'];
  var THEME_NAMES = { light: 'Light', dark: 'Dark', auto: 'Auto' };
  var THEME_ICONS = { light: '☀', dark: '☾', auto: '◐' };

  // Single in-memory mirror of the localStorage progress blob. Populated in
  // init(), mutated by applyRating()/import, and always re-persisted in full.
  var progress = {};

  // Sidebar cross-references built once in buildSidebar(), consumed by the
  // scroll-spy and mastery refresh so those don't have to re-query the DOM.
  var badgesByChapter = Object.create(null);
  var tocItemById = Object.create(null);

  // Reading-progress state: a persisted high-water mark (0..1) per chapter —
  // how far into that chapter's text you have ever scrolled, not how many
  // quiz questions you've answered. Drives the sidebar progress bar; the
  // "3/11" badge text next to it is the separate quiz-mastery count.
  var readingProgress = {};
  var chapterBounds = []; // [{ chapterNumber, top, bottom }], document order

  // ---------------------------------------------------------------------
  // storage helpers (must never throw — private browsing / disabled storage)
  // ---------------------------------------------------------------------

  function safeGetItem(key) {
    try {
      return window.localStorage.getItem(key);
    } catch (err) {
      return null;
    }
  }

  function safeSetItem(key, value) {
    try {
      window.localStorage.setItem(key, value);
      return true;
    } catch (err) {
      return false;
    }
  }

  function loadProgress() {
    var raw = safeGetItem(PROGRESS_KEY);
    if (!raw) return {};
    try {
      var parsed = JSON.parse(raw);
      return (parsed && typeof parsed === 'object') ? parsed : {};
    } catch (err) {
      return {};
    }
  }

  function persistProgress() {
    safeSetItem(PROGRESS_KEY, JSON.stringify(progress));
  }

  function loadReadingProgress() {
    var raw = safeGetItem(READING_KEY);
    if (!raw) return {};
    try {
      var parsed = JSON.parse(raw);
      return (parsed && typeof parsed === 'object') ? parsed : {};
    } catch (err) {
      return {};
    }
  }

  function persistReadingProgress() {
    safeSetItem(READING_KEY, JSON.stringify(readingProgress));
  }

  // ---------------------------------------------------------------------
  // text helpers
  // ---------------------------------------------------------------------

  function slugify(text) {
    var base = text;
    try {
      base = base.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    } catch (err) {
      /* String.normalize unsupported: fall back to the raw string below */
    }
    base = base.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
    return base;
  }

  // "2 Probability spaces" -> "Probability spaces" (drop the leading number token)
  function cleanChapterLabel(text) {
    return text.replace(/^\d+\s+/, '');
  }

  // The leading Typst numbering token doubles as the chapter number that
  // ties an h2 to its <section class="quiz-section" data-chapter="N">.
  function chapterNumberFromHeading(text) {
    var match = /^(\d+)\s/.exec(text);
    return match ? match[1] : null;
  }

  // ---------------------------------------------------------------------
  // outline + sidebar
  // ---------------------------------------------------------------------

  function buildOutline(content) {
    var headings = Array.prototype.slice.call(content.querySelectorAll('h2'));
    var usedIds = Object.create(null);

    return headings.map(function (heading, index) {
      var text = heading.textContent.trim();
      var isTeil = /^Part\s/.test(text);
      var id = slugify(text) || ('abschnitt-' + index);
      if (usedIds[id]) {
        id = id + '-' + index;
      }
      usedIds[id] = true;
      heading.id = id;
      // Focusable via script (for post-navigation focus restoration) without
      // becoming a normal Tab stop.
      heading.tabIndex = -1;

      return {
        el: heading,
        id: id,
        text: text,
        isTeil: isTeil,
        chapterNumber: isTeil ? null : chapterNumberFromHeading(text)
      };
    });
  }

  function buildSidebar(outline) {
    var nav = document.getElementById('sidebar');
    if (!nav) return;

    var list = document.createElement('ul');
    list.className = 'toc';

    outline.forEach(function (entry) {
      var li = document.createElement('li');
      var link = document.createElement('a');
      link.href = '#' + entry.id;

      if (entry.isTeil) {
        li.className = 'toc-teil';
        link.textContent = entry.text;
        li.appendChild(link);
      } else {
        li.className = 'toc-chapter';
        link.textContent = cleanChapterLabel(entry.text);
        li.appendChild(link);

        var badge = document.createElement('span');
        badge.className = 'toc-mastery';
        li.appendChild(badge);

        var progress = document.createElement('div');
        progress.className = 'toc-progress';
        var progressFill = document.createElement('div');
        progressFill.className = 'toc-progress-fill';
        progress.appendChild(progressFill);
        li.appendChild(progress);

        if (entry.chapterNumber) {
          badgesByChapter[entry.chapterNumber] = { badge: badge, fill: progressFill };
        }
      }

      tocItemById[entry.id] = li;
      list.appendChild(li);
    });

    nav.appendChild(list);
  }

  // ---------------------------------------------------------------------
  // scroll-spy
  // ---------------------------------------------------------------------

  function setupScrollSpy(outline) {
    if (!('IntersectionObserver' in window) || outline.length === 0) return;

    var current = null;

    // The CSS active-state rule (.toc-chapter > a.is-current) targets the
    // <a> child, not the <li> itself — style.css owns that contract.
    function linkFor(id) {
      var li = tocItemById[id];
      return li ? li.querySelector('a') : null;
    }

    function setActive(id) {
      if (id === current) return;
      var previousLink = linkFor(current);
      if (previousLink) previousLink.classList.remove('is-current');
      var nextLink = linkFor(id);
      if (nextLink) {
        nextLink.classList.add('is-current');
        // "nearest" only scrolls the sidebar's own scrollable list (its
        // nearest scrolling ancestor) if the newly-active item isn't already
        // visible there — it never touches the main page scroll position.
        var reduceMotion = window.matchMedia &&
          window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        nextLink.scrollIntoView({
          block: 'nearest',
          behavior: reduceMotion ? 'auto' : 'smooth'
        });
      }
      current = id;
    }

    // Headings are treated as "current" once they cross into the top 25% of
    // the viewport, and stay current until the next heading crosses that
    // same band — a standard scroll-spy band, not a scroll-driven animation.
    var observer = new IntersectionObserver(function (entries) {
      var visible = entries
        .filter(function (entry) { return entry.isIntersecting; })
        .map(function (entry) { return entry.target; });

      if (visible.length === 0) return;

      var topMost = visible[0];
      visible.forEach(function (el) {
        if (el.getBoundingClientRect().top < topMost.getBoundingClientRect().top) {
          topMost = el;
        }
      });
      setActive(topMost.id);
    }, { rootMargin: '0px 0px -75% 0px', threshold: 0 });

    outline.forEach(function (entry) { observer.observe(entry.el); });
  }

  // ---------------------------------------------------------------------
  // reading progress (per chapter — how far you've scrolled, not the quiz)
  // ---------------------------------------------------------------------

  // Chapter boundaries in document Y coordinates: each chapter runs from its
  // own heading down to whichever heading (Teil or chapter) comes next —
  // walked over the full outline so a following Teil divider still closes
  // off the previous chapter correctly.
  function computeChapterBounds(outline) {
    var bounds = [];
    outline.forEach(function (entry, index) {
      if (entry.isTeil || !entry.chapterNumber) return;
      var top = entry.el.getBoundingClientRect().top + window.scrollY;
      var next = index + 1 < outline.length ? outline[index + 1] : null;
      var bottom = next
        ? next.el.getBoundingClientRect().top + window.scrollY
        : document.documentElement.scrollHeight;
      bounds.push({ chapterNumber: entry.chapterNumber, top: top, bottom: Math.max(bottom, top + 1) });
    });
    return bounds;
  }

  function applyReadingProgressToBars() {
    Object.keys(badgesByChapter).forEach(function (chapterNumber) {
      var ratio = readingProgress[chapterNumber] || 0;
      badgesByChapter[chapterNumber].fill.style.transform = 'scaleX(' + ratio + ')';
    });
  }

  function updateReadingProgress() {
    var readLine = window.scrollY + window.innerHeight * READ_LINE_VIEWPORT_FRACTION;
    // At the very bottom of the document the read line can no longer advance
    // (max scrollY = scrollHeight - innerHeight), so the final chapter — whose
    // lower bound is the document end — could otherwise never reach 1. Treat
    // "scrolled to the bottom" as having fully read the last chapter.
    var atBottom = (window.scrollY + window.innerHeight) >=
      (document.documentElement.scrollHeight - 2);
    var lastIndex = chapterBounds.length - 1;
    var changed = false;

    chapterBounds.forEach(function (bound, index) {
      var raw = (readLine - bound.top) / (bound.bottom - bound.top);
      var ratio = Math.max(0, Math.min(1, raw));
      if (atBottom && index === lastIndex) ratio = 1;
      var previous = readingProgress[bound.chapterNumber] || 0;
      // High-water mark: reading progress only ever goes up, so scrolling
      // back up to re-read something doesn't erase credit already earned.
      if (ratio > previous) {
        readingProgress[bound.chapterNumber] = ratio;
        changed = true;
      }
    });

    if (changed) applyReadingProgressToBars();
    return changed;
  }

  function setupReadingProgress(outline) {
    if (Object.keys(badgesByChapter).length === 0) return;

    // readingProgress is already loaded (and possibly URL-hash-merged) by
    // init() before this runs — reloading here would discard that merge.
    applyReadingProgressToBars();
    chapterBounds = computeChapterBounds(outline);
    updateReadingProgress();

    var ticking = false;
    function onScroll() {
      if (ticking) return;
      ticking = true;
      window.requestAnimationFrame(function () {
        updateReadingProgress();
        ticking = false;
      });
    }
    window.addEventListener('scroll', onScroll, { passive: true });

    var resizeTimer = null;
    window.addEventListener('resize', function () {
      window.clearTimeout(resizeTimer);
      resizeTimer = window.setTimeout(function () {
        chapterBounds = computeChapterBounds(outline);
        updateReadingProgress();
      }, 200);
    });

    // Persist (localStorage + URL hash) on a trailing debounce while
    // scrolling — not every rAF tick, since both are comparatively expensive
    // — plus on every point where the tab might disappear without another
    // chance to save.
    var persistTimer = null;
    window.addEventListener('scroll', function () {
      window.clearTimeout(persistTimer);
      persistTimer = window.setTimeout(function () {
        persistReadingProgress();
        scheduleSyncUrlHash();
      }, 400);
    }, { passive: true });
    document.addEventListener('visibilitychange', function () {
      if (document.visibilityState === 'hidden') {
        persistReadingProgress();
        syncUrlHash();
      }
    });
    window.addEventListener('pagehide', function () {
      persistReadingProgress();
      syncUrlHash();
    });
  }

  // ---------------------------------------------------------------------
  // quiz: reveal + rating controls
  // ---------------------------------------------------------------------

  function buildQuizControls() {
    var questions = Array.prototype.slice.call(document.querySelectorAll('.quiz-question'));

    questions.forEach(function (question, index) {
      // Pairing is by DOM adjacency (next sibling), never by a data-qid
      // lookup. A question and its answer deliberately share the SAME
      // data-qid (question and answer both derive it from the same counter in
      // vorlage.typ's quizid(), e.g. "ch16-b1-q1"), so a
      // querySelector('[data-qid="…"]') would match the question element, not
      // its paired answer. Chapter 16 (Exam training) is the one chapter with
      // several quizblocks; nextElementSibling always lands on the right .quiz-answer.
      var answer = question.nextElementSibling;
      if (!answer || !answer.classList.contains('quiz-answer')) return;

      var qid = question.getAttribute('data-qid');
      var section = question.closest('.quiz-section');
      var chapterNumber = section ? section.getAttribute('data-chapter') : null;

      // Unique per-element id for aria-controls — index-based, not qid-based,
      // for the same duplicate-qid reason as above.
      if (!answer.id) answer.id = 'quiz-answer-' + index;

      var revealBtn = document.createElement('button');
      revealBtn.type = 'button';
      revealBtn.className = 'reveal-btn';
      revealBtn.setAttribute('aria-expanded', 'false');
      revealBtn.setAttribute('aria-controls', answer.id);
      revealBtn.textContent = 'Show answer';
      question.appendChild(revealBtn);

      var ratingButtons = document.createElement('div');
      ratingButtons.className = 'rating-buttons';

      RATING_ORDER.forEach(function (ratingValue) {
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'rating-btn';
        btn.setAttribute('data-rating', ratingValue);
        btn.setAttribute('aria-pressed', 'false');
        btn.textContent = RATING_LABELS[ratingValue];
        btn.addEventListener('click', function () {
          applyRating(qid, ratingValue, chapterNumber);
        });
        ratingButtons.appendChild(btn);
      });

      // Appended inside .quiz-answer: since .quiz-answer is display:none
      // until .revealed is toggled on, the rating buttons are naturally
      // hidden pre-reveal with no extra visibility bookkeeping needed.
      answer.appendChild(ratingButtons);

      revealBtn.addEventListener('click', function () {
        var revealed = answer.classList.toggle('revealed');
        revealBtn.setAttribute('aria-expanded', String(revealed));
        revealBtn.textContent = revealed ? 'Hide answer' : 'Show answer';
      });
    });
  }

  function applyRating(qid, ratingValue, chapterNumber) {
    if (!qid) return;
    var wasComplete = chapterNumber ? isChapterComplete(chapterNumber) : false;

    progress[qid] = { rating: ratingValue, ts: new Date().toISOString() };
    persistProgress();
    scheduleSyncUrlHash();
    applyRatedIndicator(qid, ratingValue);
    refreshMastery();

    // Only fires on the transition into "fully answered" — not on every
    // subsequent rating change within an already-complete chapter.
    if (chapterNumber && !wasComplete && isChapterComplete(chapterNumber)) {
      celebrateChapterComplete();
    }
  }

  // Reuses computeChapterStats(), so this automatically folds chapter 16's
  // three <section> blocks into one combined "complete" check, same as the
  // sidebar mastery badge does.
  function isChapterComplete(chapterNumber) {
    var stats = computeChapterStats()[chapterNumber];
    return !!stats && stats.total > 0 && stats.done === stats.total;
  }

  var CONFETTI_COLORS = ['var(--color-blue)', 'var(--color-green)', 'var(--color-orange)'];
  var CONFETTI_PIECE_COUNT = 70;

  // The one deliberate exception to "not a gamified quiz app" (see
  // PRODUCT.md's 2026-07-18 revision): a single brief burst restricted to
  // the app's own three functional accent colors, skipped entirely — not
  // just shortened — under prefers-reduced-motion.
  function celebrateChapterComplete() {
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      return;
    }

    var layer = document.createElement('div');
    layer.className = 'confetti-layer';
    layer.setAttribute('aria-hidden', 'true');

    for (var i = 0; i < CONFETTI_PIECE_COUNT; i++) {
      var piece = document.createElement('span');
      piece.className = 'confetti-piece';
      piece.style.left = (Math.random() * 100) + 'vw';
      piece.style.backgroundColor = CONFETTI_COLORS[i % CONFETTI_COLORS.length];
      piece.style.setProperty('--drift', (Math.random() * 2 - 1).toFixed(2));
      piece.style.animationDelay = (Math.random() * 0.35) + 's';
      piece.style.animationDuration = (1.8 + Math.random() * 1.1) + 's';
      layer.appendChild(piece);
    }

    document.body.appendChild(layer);
    window.setTimeout(function () {
      if (layer.parentNode) layer.parentNode.removeChild(layer);
    }, 3500);
  }

  // Updates every .quiz-question sharing this qid (a qid is unique per
  // question, so normally exactly one) so any duplicates stay visually in sync.
  function applyRatedIndicator(qid, ratingValue) {
    var questions = document.querySelectorAll('.quiz-question');
    questions.forEach(function (question) {
      if (question.getAttribute('data-qid') !== qid) return;

      question.classList.add('rated');
      question.setAttribute('data-rating', ratingValue);

      var answer = question.nextElementSibling;
      if (!answer || !answer.classList.contains('quiz-answer')) return;
      var ratingButtons = answer.querySelector('.rating-buttons');
      if (!ratingButtons) return;

      ratingButtons.querySelectorAll('.rating-btn').forEach(function (btn) {
        var isActive = btn.getAttribute('data-rating') === ratingValue;
        btn.classList.toggle('rating-btn--active', isActive);
        btn.setAttribute('aria-pressed', String(isActive));
      });
    });
  }

  // Restores the "rated" indicator for previously-rated questions on load
  // (and after an import) WITHOUT touching .revealed — answers stay hidden.
  function restoreRatedIndicators() {
    Object.keys(progress).forEach(function (qid) {
      var entry = progress[qid];
      if (entry && typeof entry.rating === 'string') {
        applyRatedIndicator(qid, entry.rating);
      }
    });
  }

  // ---------------------------------------------------------------------
  // mastery counts
  // ---------------------------------------------------------------------

  // Grouping is by each .quiz-section's own data-chapter attribute, walked
  // via DOM traversal — never by matching/prefix-parsing the qid string.
  // This is what naturally folds chapter 16's three <section> blocks (all
  // data-chapter="16") into one combined bucket.
  function computeChapterStats() {
    var stats = Object.create(null);
    var sections = document.querySelectorAll('.quiz-section');
    sections.forEach(function (section) {
      var chapter = section.getAttribute('data-chapter');
      if (!chapter) return;
      if (!stats[chapter]) stats[chapter] = { total: 0, done: 0 };

      section.querySelectorAll('.quiz-question').forEach(function (question) {
        stats[chapter].total += 1;
        var qid = question.getAttribute('data-qid');
        if (qid && progress[qid]) stats[chapter].done += 1;
      });
    });
    return stats;
  }

  function refreshMastery() {
    var chapterStats = computeChapterStats();
    Object.keys(badgesByChapter).forEach(function (chapterNumber) {
      var refs = badgesByChapter[chapterNumber];
      var stat = chapterStats[chapterNumber] || { total: 0, done: 0 };
      // Just the "N/M questions" count — the bar itself tracks reading
      // progress (see setupReadingProgress()), a deliberately separate signal.
      refs.badge.textContent = stat.done + '/' + stat.total;
    });
  }

  // ---------------------------------------------------------------------
  // URL progress sync (replaces file-based export/import)
  //
  // The URL hash always mirrors current progress. Bookmarking the page or
  // copying its address at any moment captures a full snapshot; opening a
  // URL that carries a hash restores it on load. This is the mitigation for
  // localStorage's fragility on file:// pages (see PRODUCT.md) — a native
  // browser mechanism (bookmarks, pasted links) rather than a downloaded
  // file the user has to manage. Note the hash is only portable between
  // copies of this exact HTML file at the exact same file:// path (or when
  // shared as a plain "swap in this hash" string) — a classmate's own copy
  // of the file lives at a different path, so a full URL can't be pasted
  // and opened directly on their machine.
  // ---------------------------------------------------------------------

  var URL_HASH_PARAM = 'p';

  function encodeProgressForUrl() {
    var payload = { p: progress, r: readingProgress };
    var json = JSON.stringify(payload);
    var bytes = new TextEncoder().encode(json);
    var binary = '';
    bytes.forEach(function (byte) { binary += String.fromCharCode(byte); });
    var base64 = window.btoa(binary);
    // URL-safe variant: no "+", "/", or "=" that would need percent-encoding
    // inside a hash fragment.
    return base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
  }

  function decodeProgressFromUrl(encoded) {
    var base64 = encoded.replace(/-/g, '+').replace(/_/g, '/');
    while (base64.length % 4 !== 0) base64 += '=';
    var binary = window.atob(base64);
    var bytes = new Uint8Array(binary.length);
    for (var i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
    var json = new TextDecoder().decode(bytes);
    var parsed = JSON.parse(json);
    if (!parsed || typeof parsed !== 'object') throw new Error('Invalid format.');
    return parsed;
  }

  function readHashParam(name) {
    var hash = window.location.hash.replace(/^#/, '');
    var params = new URLSearchParams(hash);
    return params.get(name);
  }

  // Merge semantics match the old JSON import: incoming entries win per-qid,
  // existing entries absent from the hash are kept — opening an older saved
  // link can't silently wipe newer progress made since.
  function importProgressFromUrlIfPresent() {
    var encoded = readHashParam(URL_HASH_PARAM);
    if (!encoded) return false;

    try {
      var parsed = decodeProgressFromUrl(encoded);
      var incomingProgress = parsed.p || {};
      var incomingReading = parsed.r || {};

      Object.keys(incomingProgress).forEach(function (qid) {
        if (qid === '__proto__') return; // never let a crafted key reach the prototype
        var entry = incomingProgress[qid];
        // Only accept a rating from the known set, and store a reduced
        // {rating, ts} shape rather than the raw (attacker-controlled) object —
        // a shared link can't inject arbitrary data-rating attribute values.
        if (entry && typeof entry === 'object' && RATING_ORDER.indexOf(entry.rating) !== -1) {
          progress[qid] = {
            rating: entry.rating,
            ts: typeof entry.ts === 'string' ? entry.ts : new Date().toISOString()
          };
        }
      });
      Object.keys(incomingReading).forEach(function (chapterNumber) {
        if (chapterNumber === '__proto__') return;
        var ratio = incomingReading[chapterNumber];
        // Must be a finite number; clamp to [0,1] so a crafted link can't set
        // an out-of-range scaleX transform on the sidebar progress bar.
        if (typeof ratio === 'number' && isFinite(ratio)) {
          var clamped = Math.max(0, Math.min(1, ratio));
          readingProgress[chapterNumber] = Math.max(readingProgress[chapterNumber] || 0, clamped);
        }
      });

      persistProgress();
      persistReadingProgress();
      return true;
    } catch (err) {
      window.alert('The progress in this link could not be read.');
      return false;
    }
  }

  function syncUrlHash() {
    try {
      var encoded = encodeProgressForUrl();
      var url = window.location.pathname + window.location.search + '#' + URL_HASH_PARAM + '=' + encoded;
      window.history.replaceState(null, '', url);
    } catch (err) {
      /* URL sync is a convenience layer over localStorage, not the source
         of truth — a failure here (e.g. no History API) must not break the
         app, so it's silently skipped. */
    }
  }

  var syncUrlHashTimer = null;
  function scheduleSyncUrlHash() {
    window.clearTimeout(syncUrlHashTimer);
    syncUrlHashTimer = window.setTimeout(syncUrlHash, 300);
  }

  function clearUrlHash() {
    window.clearTimeout(syncUrlHashTimer);
    window.history.replaceState(null, '', window.location.pathname + window.location.search);
  }

  function setupCopyLink() {
    var copyBtn = document.getElementById('copy-link-btn');
    if (!copyBtn) return;

    copyBtn.addEventListener('click', function () {
      syncUrlHash(); // flush any pending debounced update before copying
      var href = window.location.href;
      var label = copyBtn.textContent;

      function showCopied() {
        copyBtn.textContent = 'Link copied ✓';
        window.setTimeout(function () { copyBtn.textContent = label; }, 2000);
      }

      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(href).then(showCopied, function () {
          window.prompt('Link to copy:', href);
        });
      } else {
        window.prompt('Link to copy:', href);
      }
    });
  }

  // ---------------------------------------------------------------------
  // reset
  // ---------------------------------------------------------------------

  function setupResetProgress() {
    var resetBtn = document.getElementById('reset-btn');
    if (!resetBtn) return;

    resetBtn.addEventListener('click', function () {
      var confirmed = window.confirm(
        'Really reset all progress?\n\n' +
        'All quiz ratings and the reading progress in every chapter will be ' +
        'permanently deleted. This action cannot be undone.'
      );
      if (!confirmed) return;

      progress = {};
      readingProgress = {};
      persistProgress();
      persistReadingProgress();
      clearUrlHash();

      document.querySelectorAll('.quiz-question').forEach(function (question) {
        question.classList.remove('rated');
        question.removeAttribute('data-rating');
      });
      document.querySelectorAll('.quiz-answer').forEach(function (answer) {
        answer.classList.remove('revealed');
      });
      document.querySelectorAll('.reveal-btn').forEach(function (btn) {
        btn.setAttribute('aria-expanded', 'false');
        btn.textContent = 'Show answer';
      });
      document.querySelectorAll('.rating-btn').forEach(function (btn) {
        btn.classList.remove('rating-btn--active');
        btn.setAttribute('aria-pressed', 'false');
      });

      applyReadingProgressToBars();
      refreshMastery();
    });
  }

  // ---------------------------------------------------------------------
  // theme
  // ---------------------------------------------------------------------

  function getStoredThemePreference() {
    var value = safeGetItem(THEME_KEY);
    return (value === 'light' || value === 'dark' || value === 'auto') ? value : 'auto';
  }

  function resolveTheme(preference) {
    if (preference === 'auto') {
      var prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
      return prefersDark ? 'dark' : 'light';
    }
    return preference;
  }

  function applyTheme(preference) {
    var resolved = resolveTheme(preference);
    document.documentElement.setAttribute('data-theme', resolved);

    var toggle = document.getElementById('theme-toggle');
    if (toggle) {
      toggle.textContent = THEME_ICONS[preference] || THEME_ICONS.auto;
      toggle.setAttribute('aria-label', 'Theme: ' + THEME_NAMES[preference] + ' (click to cycle)');
    }
  }

  function setupThemeToggle() {
    var preference = getStoredThemePreference();
    applyTheme(preference);

    if (window.matchMedia) {
      var mql = window.matchMedia('(prefers-color-scheme: dark)');
      var handleSystemChange = function () {
        if (getStoredThemePreference() === 'auto') applyTheme('auto');
      };
      if (mql.addEventListener) mql.addEventListener('change', handleSystemChange);
      else if (mql.addListener) mql.addListener(handleSystemChange); // older Safari
    }

    var toggle = document.getElementById('theme-toggle');
    if (!toggle) return;
    toggle.addEventListener('click', function () {
      var currentPreference = getStoredThemePreference();
      var nextPreference = THEME_ORDER[(THEME_ORDER.indexOf(currentPreference) + 1) % THEME_ORDER.length];
      safeSetItem(THEME_KEY, nextPreference);
      applyTheme(nextPreference);
    });
  }

  // ---------------------------------------------------------------------
  // more-actions menu (PDF download, copy link, reset — consolidated out of
  // the topbar itself so it doesn't crowd/wrap on narrow screens)
  // ---------------------------------------------------------------------

  function setupMoreMenu() {
    var toggle = document.getElementById('more-menu-toggle');
    var menu = document.getElementById('more-menu');
    if (!toggle || !menu) return;

    function isOpen() {
      return !menu.hidden;
    }

    function onDocumentClick(event) {
      if (menu.contains(event.target) || toggle.contains(event.target)) return;
      closeMenu();
    }

    function onKeydown(event) {
      if (event.key === 'Escape' || event.key === 'Esc') closeMenu({ restoreFocus: true });
    }

    function openMenu() {
      menu.hidden = false;
      toggle.setAttribute('aria-expanded', 'true');
      document.addEventListener('click', onDocumentClick);
      document.addEventListener('keydown', onKeydown);
    }

    function closeMenu(options) {
      if (!isOpen()) return;
      menu.hidden = true;
      toggle.setAttribute('aria-expanded', 'false');
      document.removeEventListener('click', onDocumentClick);
      document.removeEventListener('keydown', onKeydown);
      if (options && options.restoreFocus) toggle.focus();
    }

    toggle.addEventListener('click', function (event) {
      event.stopPropagation();
      if (isOpen()) {
        closeMenu();
      } else {
        openMenu();
      }
    });

    // Any actual action inside the menu (download, reset) closes it afterwards
    // — a stale open menu over the page would be clutter — and restores focus
    // to the toggle so keyboard focus never drops to <body>. Exception: the
    // copy-link action shows its "Link kopiert ✓" confirmation on its own
    // button inside this menu, so closing here would hide the feedback in the
    // same tick; that one item leaves the menu open (it still closes on an
    // outside click or Escape).
    menu.addEventListener('click', function (event) {
      var item = event.target.closest('.more-menu-item');
      if (!item) return;
      if (item.id === 'copy-link-btn') return;
      closeMenu({ restoreFocus: true });
    });
  }

  // ---------------------------------------------------------------------
  // mobile sidebar drawer
  // ---------------------------------------------------------------------

  function setupSidebarDrawer() {
    var toggle = document.getElementById('sidebar-toggle');
    var sidebar = document.getElementById('sidebar');
    var backdrop = document.getElementById('sidebar-backdrop');
    if (!toggle || !sidebar) return;

    var mql = window.matchMedia ? window.matchMedia(SIDEBAR_BREAKPOINT_QUERY) : null;
    function isWide() {
      return !!(mql && mql.matches);
    }

    function isOpen() {
      return sidebar.classList.contains('is-open');
    }

    // Below the breakpoint, the sidebar is an off-canvas drawer: while closed
    // it must not be a tab stop (inert removes its links from the tab order
    // and from the accessibility tree). At/above the breakpoint it's a
    // permanently-visible column and must never be inert.
    function syncInert() {
      sidebar.inert = !isWide() && !isOpen();
    }

    function onKeydown(event) {
      if (event.key === 'Escape' || event.key === 'Esc') {
        closeDrawer();
      }
    }

    function openDrawer() {
      sidebar.classList.add('is-open');
      if (backdrop) backdrop.classList.add('is-visible');
      toggle.setAttribute('aria-expanded', 'true');
      syncInert();
      document.addEventListener('keydown', onKeydown);
      var focusable = sidebar.querySelector('a, button');
      if (focusable) focusable.focus();
    }

    function closeDrawer(options) {
      if (!isOpen()) return;
      sidebar.classList.remove('is-open');
      if (backdrop) backdrop.classList.remove('is-visible');
      toggle.setAttribute('aria-expanded', 'false');
      syncInert();
      document.removeEventListener('keydown', onKeydown);
      if (!options || options.restoreFocus !== false) toggle.focus();
    }

    toggle.addEventListener('click', function () {
      if (isOpen()) {
        closeDrawer();
      } else {
        openDrawer();
      }
    });

    if (backdrop) {
      backdrop.addEventListener('click', function () { closeDrawer(); });
    }

    // Selecting a chapter link on mobile should close the drawer and move
    // focus to the destination heading (rather than leaving it on the now
    // off-canvas, inert link, or on an unrelated default location).
    sidebar.addEventListener('click', function (event) {
      var link = event.target.closest ? event.target.closest('a') : null;
      if (!link) return;
      closeDrawer({ restoreFocus: false });
      var targetId = (link.getAttribute('href') || '').replace(/^#/, '');
      var target = targetId ? document.getElementById(targetId) : null;
      if (target) {
        window.setTimeout(function () { target.focus(); }, 0);
      }
    });

    if (mql) {
      var handleBreakpointChange = function () {
        if (mql.matches) closeDrawer({ restoreFocus: false });
        syncInert();
      };
      if (mql.addEventListener) mql.addEventListener('change', handleBreakpointChange);
      else if (mql.addListener) mql.addListener(handleBreakpointChange);
    }

    syncInert();
  }

  // ---------------------------------------------------------------------
  // init
  // ---------------------------------------------------------------------

  function init() {
    var content = document.getElementById('content');
    if (!content) return;

    progress = loadProgress();
    readingProgress = loadReadingProgress();
    // Merge in any progress carried by the URL hash before anything renders,
    // so a bookmarked/pasted link shows its state on the very first paint.
    importProgressFromUrlIfPresent();

    var outline = buildOutline(content);
    buildSidebar(outline);
    setupScrollSpy(outline);
    setupReadingProgress(outline);

    buildQuizControls();
    restoreRatedIndicators();
    refreshMastery();

    setupCopyLink();
    setupResetProgress();
    setupThemeToggle();
    setupMoreMenu();
    setupSidebarDrawer();

    scheduleSyncUrlHash();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
