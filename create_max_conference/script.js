/**
 * CREATE MAX — Creative Technology Conference
 * Interactive UI/UX Scripts
 */

document.addEventListener('DOMContentLoaded', () => {
  // 1. Sticky Navigation on Scroll
  const header = document.querySelector('.site-header');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 40) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  });

  // 2. Mobile Navigation Toggle
  const navToggle = document.querySelector('.nav-toggle');
  const navMenu = document.querySelector('.nav-menu');
  const navLinks = document.querySelectorAll('.nav-link');

  if (navToggle && navMenu) {
    navToggle.addEventListener('click', () => {
      navToggle.classList.toggle('open');
      navMenu.classList.toggle('open');
      document.body.style.overflow = navMenu.classList.contains('open') ? 'hidden' : '';
    });

    navLinks.forEach(link => {
      link.addEventListener('click', () => {
        navToggle.classList.remove('open');
        navMenu.classList.remove('open');
        document.body.style.overflow = '';
      });
    });
  }

  // 3. Countdown Timer (Target: Nov 10, 2026)
  const daysEl = document.getElementById('cd-days');
  const hoursEl = document.getElementById('cd-hours');
  const minsEl = document.getElementById('cd-mins');
  const secsEl = document.getElementById('cd-secs');

  if (daysEl && hoursEl && minsEl && secsEl) {
    // 10 days from now for lively live countdown demo
    const targetDate = new Date();
    targetDate.setDate(targetDate.getDate() + 9);
    targetDate.setHours(9, 0, 0, 0);

    function updateCountdown() {
      const now = new Date().getTime();
      const distance = targetDate.getTime() - now;

      if (distance < 0) {
        daysEl.textContent = '00';
        hoursEl.textContent = '00';
        minsEl.textContent = '00';
        secsEl.textContent = '00';
        return;
      }

      const days = Math.floor(distance / (1000 * 60 * 60 * 24));
      const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((distance % (1000 * 60)) / 1000);

      daysEl.textContent = String(days).padStart(2, '0');
      hoursEl.textContent = String(hours).padStart(2, '0');
      minsEl.textContent = String(minutes).padStart(2, '0');
      secsEl.textContent = String(seconds).padStart(2, '0');
    }

    updateCountdown();
    setInterval(updateCountdown, 1000);
  }

  // 4. Speakers Filter
  const filterBtns = document.querySelectorAll('.filter-btn');
  const speakerCards = document.querySelectorAll('.speaker-card');

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const filter = btn.getAttribute('data-filter');

      speakerCards.forEach(card => {
        if (filter === 'all' || card.getAttribute('data-category') === filter) {
          card.style.display = 'block';
          card.style.animation = 'fadeInUp 0.4s ease-out';
        } else {
          card.style.display = 'none';
        }
      });
    });
  });

  // 5. Registration Modal
  const modal = document.getElementById('reg-modal');
  const openModalBtns = document.querySelectorAll('.open-reg-modal');
  const closeModalBtn = document.querySelector('.modal-close');
  const ticketTiers = document.querySelectorAll('.ticket-tier');

  function openModal() {
    if (modal) {
      modal.classList.add('active');
      document.body.style.overflow = 'hidden';
    }
  }

  function closeModal() {
    if (modal) {
      modal.classList.remove('active');
      document.body.style.overflow = '';
    }
  }

  openModalBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      openModal();
    });
  });

  if (closeModalBtn) {
    closeModalBtn.addEventListener('click', closeModal);
  }

  if (modal) {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        closeModal();
      }
    });

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && modal.classList.contains('active')) {
        closeModal();
      }
    });
  }

  ticketTiers.forEach(tier => {
    tier.addEventListener('click', () => {
      ticketTiers.forEach(t => t.classList.remove('selected'));
      tier.classList.add('selected');
    });
  });

  // 6. Session Bookmark Interaction
  const sessionActionBtns = document.querySelectorAll('.session-action-btn');
  sessionActionBtns.forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      const isBookmarked = this.classList.contains('bookmarked');
      if (isBookmarked) {
        this.classList.remove('bookmarked');
        this.textContent = 'Reserve Seat';
        this.style.background = '';
        this.style.color = '';
      } else {
        this.classList.add('bookmarked');
        this.textContent = '✓ Reserved';
        this.style.background = '#FF2A3A';
        this.style.color = '#FFFFFF';
        this.style.borderColor = '#FF2A3A';
      }
    });
  });

  // 7. Newsletter Form Simulation
  const newsletterForm = document.querySelector('.newsletter-form');
  if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const input = newsletterForm.querySelector('.newsletter-input');
      if (input && input.value.trim()) {
        const btn = newsletterForm.querySelector('.newsletter-btn');
        const origText = btn.textContent;
        btn.textContent = 'Joined ✓';
        btn.style.background = '#FF2A3A';
        input.value = '';
        setTimeout(() => {
          btn.textContent = origText;
          btn.style.background = '';
        }, 3000);
      }
    });
  }
});
