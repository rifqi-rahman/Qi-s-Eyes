(function () {
  const header = document.querySelector('[data-header]');
  const navToggle = document.querySelector('[data-nav-toggle]');
  const navList = document.querySelector('[data-nav-list]');
  const yearEl = document.querySelector('[data-year]');
  const form = document.querySelector('[data-contact-form]');

  // Header shadow on scroll
  let lastKnownY = 0;
  let ticking = false;
  function onScroll() {
    lastKnownY = window.scrollY || window.pageYOffset;
    if (!ticking) {
      window.requestAnimationFrame(() => {
        header && header.classList.toggle('is-scrolled', lastKnownY > 10);
        ticking = false;
      });
      ticking = true;
    }
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  // Mobile nav
  function setNav(open) {
    if (!navList || !navToggle) return;
    navList.classList.toggle('is-open', open);
    navToggle.setAttribute('aria-expanded', String(open));
  }
  navToggle && navToggle.addEventListener('click', () => {
    const isOpen = navList.classList.contains('is-open');
    setNav(!isOpen);
  });
  // Close on link click
  navList && navList.addEventListener('click', (e) => {
    const target = e.target;
    if (target && target.closest('a')) setNav(false);
  });

  // Current year
  if (yearEl) yearEl.textContent = String(new Date().getFullYear());

  // Lightweight form handler
  form && form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const formEl = e.currentTarget;
    const submitBtn = formEl.querySelector('button[type="submit"]');
    const original = submitBtn.textContent;
    submitBtn.disabled = true;
    submitBtn.textContent = 'Sending…';

    try {
      const data = Object.fromEntries(new FormData(formEl).entries());
      // TODO: Replace with your backend endpoint or email service
      await new Promise((r) => setTimeout(r, 800));
      alert('Thanks! We\'ll be in touch within one business day.');
      formEl.reset();
    } catch (err) {
      console.error(err);
      alert('Something went wrong. Please email hello@yourcompany.com.');
    } finally {
      submitBtn.disabled = false;
      submitBtn.textContent = original;
    }
  });
})();