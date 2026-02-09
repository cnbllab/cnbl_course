
// Logic for Slideshow/Carousel
let currentSlide = 0;
let autoPlayInterval;

const track = document.getElementById('galleryTrack');
const dotsContainer = document.getElementById('carouselDots');

function initCarousel() {
    if (!galleryImages || galleryImages.length === 0) {
        if (track) track.innerHTML = '<p class="no-results" style="padding:20px; color:white; text-align:center;">Photos coming soon!</p>';
        return;
    }

    // Generate Slides
    const slidesHtml = galleryImages.map((img, index) => `
        <div class="carousel-slide">
            <img src="${img.src}" alt="${img.caption}">
            <div class="slide-caption">${img.caption}</div>
        </div>
    `).join('');
    if (track) track.innerHTML = slidesHtml;

    // Generate Dots
    const dotsHtml = galleryImages.map((_, index) => `
        <span class="dot" onclick="setSlide(${index})"></span>
    `).join('');
    if (dotsContainer) dotsContainer.innerHTML = dotsHtml;

    // Show first slide
    showSlide(currentSlide);

    // Start Auto-play
    startAutoPlay();
}

function showSlide(index) {
    if (index >= galleryImages.length) currentSlide = 0;
    if (index < 0) currentSlide = galleryImages.length - 1;

    // Move track
    const offset = -currentSlide * 100;
    if (track) track.style.transform = `translateX(${offset}%)`;

    // Update Dots
    const dots = document.getElementsByClassName('dot');
    for (let i = 0; i < dots.length; i++) {
        dots[i].className = dots[i].className.replace(" active", "");
    }
    if (dots[currentSlide]) dots[currentSlide].className += " active";
}

function changeSlide(n) {
    currentSlide += n;
    showSlide(currentSlide);
    resetAutoPlay();
}

function setSlide(index) {
    currentSlide = index;
    showSlide(currentSlide);
    resetAutoPlay();
}

function startAutoPlay() {
    stopAutoPlay();
    autoPlayInterval = setInterval(() => {
        currentSlide++;
        showSlide(currentSlide);
    }, 4000); // Change slide every 4 seconds
}

function stopAutoPlay() {
    if (autoPlayInterval) clearInterval(autoPlayInterval);
}

function resetAutoPlay() {
    stopAutoPlay();
    startAutoPlay();
}

// Pause on hover
const container = document.querySelector('.carousel-container');
if (container) {
    container.addEventListener('mouseenter', stopAutoPlay);
    container.addEventListener('mouseleave', startAutoPlay);
}

// Initialize
document.addEventListener('DOMContentLoaded', initCarousel);
